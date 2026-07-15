// ====================================================================
// RavFen Shadow v8.0 - PUBG Mobile 4.5.0 TW (Full SDK + Direct Memory)
// - Uses Dumper‑7 SDK (namespace SDK, prefix SHANKS_PUBGM_)
// - Completely REMOVED UWorld dependence.
// - Uses GUObject, GNames, and Direct ActorArray.
// ====================================================================

#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <pthread.h>
#import <dlfcn.h>
#import <math.h>
#import <sys/sysctl.h>

// ────────────── تضمين ملفات الـ SDK بالترتيب الصحيح ──────────────
#include "SDK/SHANKS_PUBGM_Basic.hpp"
#include "SDK/SHANKS_PUBGM_CoreUObject_structs.hpp"
#include "SDK/SHANKS_PUBGM_CoreUObject_classes.hpp"
#include "SDK/SHANKS_PUBGM_Engine_structs.hpp"
#include "SDK/SHANKS_PUBGM_Engine_classes.hpp"
#include "SDK/SHANKS_PUBGM_ShadowTrackerExtra_structs.hpp"
#include "SDK/SHANKS_PUBGM_ShadowTrackerExtra_classes.hpp"
// ──────────────────────────────────────────────────────────────────
// ──────────────────────────────────────────────────

// ====================================================================
// 📍 الحصول على عنوان بداية تشغيل اللعبة (ASLR)
// ====================================================================
static uint64_t gBase = 0;
static inline uint64_t GetBaseAddress(void) {
    if (gBase == 0) gBase = (uint64_t)_dyld_get_image_header(0);
    return gBase;
}

// ====================================================================
// 🔑 العناوين الثلاثة الأساسية التي زودتنا بها + الكاميرا
// ====================================================================
#define ADDR_GUOBJECT     0x10A88BA60   // GUObjectArray
#define ADDR_GNAMES       0x1050C4AB4   // GNames (FNamePool)
#define ADDR_ACTORARRAY   0x106419D7C   // Direct Actor Array
#define ADDR_VIEWMATRIX   0x106367344   // الكاميرا (WorldToScreen)

// ====================================================================
// 🧵 الإعدادات (Config)
// ====================================================================
static pthread_mutex_t g_ConfigMutex = PTHREAD_MUTEX_INITIALIZER;

typedef enum {
    AimbotMode_None  = 0,
    AimbotMode_Lock  = 1,
    AimbotMode_Fire  = 2,
    AimbotMode_Scope = 3
} AimbotMode;

typedef struct {
    volatile BOOL       aimbotEnabled;
    volatile float      aimbotSpeed;
    volatile AimbotMode aimbotMode;
    volatile BOOL       espEnabled;
    volatile BOOL       espLine;
    volatile BOOL       espBulletLine;
    volatile float      espDistance;
    volatile BOOL       menuVisible;
    volatile BOOL       crosshairEnabled;
    volatile float      aimbotSmoothing;
    volatile BOOL       stabilityEnabled;
} RavConfig;

static RavConfig gConfig = {0};

// ====================================================================
// 🌐 متغيرات عامة للفريم الحالي
// ====================================================================
static float g_ViewMatrix[16] = {0};
static SDK::FVector g_LocalLocation = {0,0,0};
static int32_t      g_LocalTeam = 0;
static SDK::ASTExtraCharacter* g_LocalPawn = nullptr; // تخزين اللاعب المحلي للوصول السريع

// ====================================================================
// 👤 التحقق من هوية اللاعب (باستخدام GNames المباشر)
// ====================================================================
static BOOL IsPlayer(SDK::AActor* Actor) {
    if (!Actor) return NO;

    uint64_t GNamesBase = *(uint64_t*)(GetBaseAddress() + ADDR_GNAMES);
    if (!GNamesBase) return NO;

    // جلب الـ Actor ID من الكلاس (إزاحة 0x18 الافتراضية)
    int32_t ActorId = *(int32_t*)((uint64_t)Actor + 0x18);
    if (ActorId <= 0 || ActorId > 10000000) return NO;

    uint32_t ChunkIdx = ActorId / 0x3FE0;
    uint32_t NameIdx  = ActorId % 0x3FE0;

    uint64_t Chunk = ((uint64_t*)(GNamesBase))[ChunkIdx];
    if (!Chunk) return NO;

    uint64_t Entry = Chunk + NameIdx * 48; // حجم الـ FNameEntry
    char Name[24] = {0};
    memcpy(Name, (void*)(Entry + 8), 20);
    Name[20] = '\0';

    if ((strstr(Name, "PlayerPawn") || strstr(Name, "BP_Player") ||
         strstr(Name, "PlayerCharacter") || strstr(Name, "PlayerMale") ||
         strstr(Name, "PlayerFemale")) &&
        !strstr(Name, "Pickup") && !strstr(Name, "Dropped") &&
        !strstr(Name, "Item") && !strstr(Name, "Weapon"))
        return YES;

    return NO;
}

// ====================================================================
// 👥 جلب اللاعبين (باستخدام ActorArray مباشرة وبدون UWorld)
// ====================================================================
@interface PlayerData : NSObject
@property (nonatomic) uint64_t address;
@property (nonatomic) float x, y, z, health, distance;
@property (nonatomic) BOOL isEnemy, isAlive;
@property (nonatomic) int32_t teamId;
@end
@implementation PlayerData @end

static NSArray<PlayerData*>* GetPlayers(void) {
    NSMutableArray<PlayerData*>* result = [NSMutableArray array];
    uint64_t base = GetBaseAddress();

    // 1. قراءة مؤشر مصفوفة الممثلين مباشرة وبسرعة فائقة
    SDK::AActor** ActorArray = *(SDK::AActor***)(base + ADDR_ACTORARRAY);
    if (!ActorArray) return result;

    // حد أقصى معقول لعدد العناصر داخل الجيم لتجنب الـ Lag
    int32_t Count = 2000; 

    // 2. البحث عن اللاعب المحلي الحقيقي وتمييزه (بدون تخمين وبدون UWorld)
    g_LocalPawn = nullptr;
    for (int i = 0; i < Count; ++i) {
        SDK::AActor* Actor = ActorArray[i];
        if (!Actor) continue;
        
        if (IsPlayer(Actor)) {
            SDK::ASTExtraCharacter* Char = (SDK::ASTExtraCharacter*)Actor;
            // ميزة الـ SDK: التحقق المباشر والسريع إذا كان هذا هو اللاعب الحقيقي الخاص بنا
            if (Char->IsLocallyControlled()) { 
                g_LocalPawn = Char;
                break;
            }
        }
    }

    // إذا وجدنا اللاعب المحلي، نقرأ موقعه وفريقه الحقيقيين
    if (g_LocalPawn) {
        if (g_LocalPawn->RootComponent) {
            g_LocalLocation = g_LocalPawn->RootComponent->RelativeLocation;
        }
        g_LocalTeam = g_LocalPawn->TeamID;
    }

    // 3. قراءة الكاميرا (ViewMatrix)
    memcpy(g_ViewMatrix, (void*)(base + ADDR_VIEWMATRIX), 64);

    // 4. قراءة المسافة القصوى من الإعدادات
    float maxDist = 500.0f;
    pthread_mutex_lock(&g_ConfigMutex);
    maxDist = gConfig.espDistance;
    pthread_mutex_unlock(&g_ConfigMutex);

    // 5. التكرار على مصفوفة الممثلين لفرز الأعداء
    for (int i = 0; i < Count; ++i) {
        SDK::AActor* Actor = ActorArray[i];
        if (!Actor || Actor == (SDK::AActor*)g_LocalPawn) continue;
        if (!IsPlayer(Actor)) continue;

        SDK::ASTExtraCharacter* Char = (SDK::ASTExtraCharacter*)Actor;

        float Health  = Char->Health;
        int32_t Team  = Char->TeamID;
        bool bDead    = Char->bDead;

        if (Health <= 0.0f || bDead) continue;

        // جلب الإحداثيات للاعب
        SDK::FVector Loc = {0,0,0};
        if (Char->RootComponent) {
            Loc = Char->RootComponent->RelativeLocation;
        }
        
        float dx = Loc.X - g_LocalLocation.X;
        float dy = Loc.Y - g_LocalLocation.Y;
        float dz = Loc.Z - g_LocalLocation.Z;
        float dist = sqrtf(dx*dx + dy*dy + dz*dz);

        if (dist < 0.5f || dist > maxDist) continue;

        PlayerData* data = [[PlayerData alloc] init];
        data.address   = (uint64_t)Actor;
        data.x = Loc.X; data.y = Loc.Y; data.z = Loc.Z;
        data.health    = Health;
        data.distance  = dist;
        data.isAlive   = YES;
        data.teamId    = Team;
        data.isEnemy   = (Team != g_LocalTeam) || (Team == 0);
        [result addObject:data];
    }

    return result;
}

// ====================================================================
// 🌐 تحويل الإحداثيات ثلاثية الأبعاد لشاشة الهاتف الثنائية
// ====================================================================
static BOOL WorldToScreen(float wx, float wy, float wz, float* sx, float* sy) {
    float* vm = g_ViewMatrix;
    float clipX = vm[0]*wx + vm[4]*wy + vm[8]*wz  + vm[12];
    float clipY = vm[1]*wx + vm[5]*wy + vm[9]*wz  + vm[13];
    float clipW = vm[3]*wx + vm[7]*wy + vm[11]*wz + vm[15];
    if (clipW < 0.1f) return NO;

    float ndcX = clipX / clipW;
    float ndcY = clipY / clipW;
    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
    CGFloat sh = [UIScreen mainScreen].bounds.size.height;
    *sx = (sw/2) + (ndcX * sw/2);
    *sy = (sh/2) - (ndcY * sh/2);
    return YES;
}

// ====================================================================
// 🎯 الأيم بوت الاحترافي (الكتابة المباشرة على زوايا الكاميرا)
// ====================================================================
static void DoAimbot(NSArray<PlayerData*>* players) {
    if (!gConfig.aimbotEnabled || gConfig.aimbotMode == AimbotMode_None) return;
    if (!players.count) return;

    // نجلب متحكم الكاميرا (PlayerController) مباشرة من كلاس اللاعب المحلي المخزن لدينا
    if (!g_LocalPawn || !g_LocalPawn->Controller) return;
    SDK::APlayerController* PC = (SDK::APlayerController*)g_LocalPawn->Controller;
    if (!PC) return;

    // البحث عن أفضل وأقرب هدف
    PlayerData* best = nil;
    float bestDist = FLT_MAX;
    for (PlayerData* p in players) {
        if (!p.isAlive || !p.isEnemy) continue;
        if (p.distance < bestDist) {
            bestDist = p.distance;
            best = p;
        }
    }
    if (!best) return;

    // توجيه الأيم بوت على الرأس (يرتفع بمقدار 1.75 متر تقريباً عن الأقدام)
    float targetZ = best.z + 1.75f;
    float dx = best.x - g_LocalLocation.X;
    float dy = best.y - g_LocalLocation.Y;
    float dz = targetZ - g_LocalLocation.Z;

    float yaw   = atan2f(dy, dx) * (180.0f / M_PI);
    float pitch = -atan2f(dz, sqrtf(dx*dx + dy*dy)) * (180.0f / M_PI);
    if (yaw < 0) yaw += 360.0f;
    pitch = fmaxf(-89.0f, fminf(89.0f, pitch));

    // نسبة التنعيم (Smoothing) للحماية
    float factor = 1.0f;
    if (gConfig.aimbotSpeed <= 50) factor = 0.08f;
    else if (gConfig.aimbotSpeed <= 115) factor = gConfig.aimbotSpeed / 250.0f;
    else if (gConfig.aimbotSpeed <= 135) factor = gConfig.aimbotSpeed / 160.0f;
    factor = fmaxf(0.01f, fminf(1.0f, factor));

    // تطبيق زوايا الكاميرا مباشرة على متحكم اللاعب
    SDK::FRotator curRot = PC->ControlRotation;
    float dYaw   = yaw   - curRot.Yaw;
    float dPitch = pitch - curRot.Pitch;
    if (dYaw > 180) dYaw -= 360;
    if (dYaw < -180) dYaw += 360;

    PC->ControlRotation.Yaw   = curRot.Yaw   + dYaw * factor;
    PC->ControlRotation.Pitch = curRot.Pitch + dPitch * factor;
}

// ====================================================================
// 🔫 ثبات السلاح (تصفير الارتداد والانتشار)
// ====================================================================
static void DoStability(void) {
    if (!gConfig.stabilityEnabled) return;
    // (مكان مخصص لإضافة أكواد تصفير ارتداد السلاح لاحقاً عبر الـ SDK)
}

// ====================================================================
// 🖥️ لوحة الـ ESP والـ Loop الرئيسي للمشروع
// ====================================================================
@interface ESPOverlayView : UIView
- (void)updateWithPlayers:(NSArray<PlayerData*>*)players;
@end

@interface RavEngine : NSObject
+ (instancetype)shared;
- (void)startWithOverlay:(ESPOverlayView*)overlay;
@end

@implementation RavEngine {
    dispatch_queue_t _queue;
    NSTimer*         _timer;
    ESPOverlayView*  _overlay;
}
+ (instancetype)shared { static RavEngine* s; static dispatch_once_t o; dispatch_once(&o,^{ s = [RavEngine new]; }); return s; }

- (void)startWithOverlay:(ESPOverlayView*)overlay {
    _overlay = overlay;
    _queue   = dispatch_queue_create("ravfen.engine", DISPATCH_QUEUE_SERIAL);
    dispatch_async(dispatch_get_main_queue(), ^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer* t){
            dispatch_async(_queue, ^{
                NSArray* players = GetPlayers();
                DoAimbot(players);
                DoStability();
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_overlay updateWithPlayers:players];
                });
            });
        }];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    });
}
@end

// ====================================================================
// 🚀 تفعيل التويك عند تشغيل اللعبة
// ====================================================================
__attribute__((constructor))
static void Init(void) {
    GetBaseAddress();
    [[RavEngine shared] startWithOverlay:[[ESPOverlayView alloc] initWithFrame:[UIScreen mainScreen].bounds]];
}
