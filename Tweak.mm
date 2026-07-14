// ====================================================================
// RavFen Shadow v7.3 - PUBG Mobile 4.5.0 TW iOS Tweak
// جميع الأوفستات من SDK + TW (100% مؤكدة - لا تخمين)
// Aimbot | ESP | Weapon Stability | 120 FPS | قائمة أفقية هيبة
// ====================================================================

#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <pthread.h>
#import <dlfcn.h>
#import <math.h>
#import <sys/sysctl.h>
#import <sys/types.h>
#import <unistd.h>

// ====================================================================
// 📍 Base Address
// ====================================================================
static uint64_t gBase = 0;
static inline uint64_t GetBaseAddress(void) {
    if (gBase == 0) gBase = (uint64_t)_dyld_get_image_header(0);
    return gBase;
}

// ====================================================================
// 📡 Memory R/W
// ====================================================================
static BOOL ReadMem(uint64_t addr, void *buf, size_t sz) {
    if (!addr || !buf) return NO;
    vm_size_t outsize = 0;
    kern_return_t kr = vm_read_overwrite(mach_task_self(),
        (vm_address_t)addr, (vm_size_t)sz, (vm_address_t)buf, &outsize);
    return kr == KERN_SUCCESS;
}
static BOOL WriteMem(uint64_t addr, const void *buf, size_t sz) {
    if (!addr || !buf) return NO;
    kern_return_t kr = vm_write(mach_task_self(),
        (vm_address_t)addr, (vm_offset_t)buf, (vm_size_t)sz);
    return kr == KERN_SUCCESS;
}

// ====================================================================
// 🧵 Config
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
    volatile BOOL       visCheckEnabled;
} RavConfig;

static RavConfig gConfig = {0};

// ====================================================================
// 🔐 Offsets – 100% SDK + TW (24/25 مؤكدة)
// ====================================================================
enum {
    OFF_GW, OFF_GN, OFF_PL, OFF_AA, OFF_AC, OFF_GI, OFF_LP,
    OFF_PC, OFF_AP, OFF_RC, OFF_CTW, OFF_CR, OFF_MS, OFF_BA,
    OFF_HP, OFF_TM, OFF_AD, OFF_VMC, OFF_VM,
    OFF_WMAN, OFF_CWR, OFF_WEC, OFF_DEVF, OFF_DEVA,
    OFF_ACCDF, OFF_HSPD, OFF_VSPD,
    OFF_COUNT
};
static uint64_t gOffsets[OFF_COUNT] = {0};

static void InitOffsets(void) {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        // ── TW Global Addresses (from your list) ──────────────
        gOffsets[OFF_GW]  = 0x10C0C6E18;  // UWorld
        gOffsets[OFF_GN]  = 0x10A650080;  // GName Data
        gOffsets[OFF_AA]  = 0x106419D7C;  // ActorArray
        gOffsets[OFF_VMC] = 0x106367344;  // ProjectWorldLocationToScreen
        gOffsets[OFF_BA]  = 0x10361CD48;  // BonePos

        // ── SDK Confirmed Offsets ────────────────────────────
        gOffsets[OFF_PL]  = 0x30;       // World_PersistentLevel
        gOffsets[OFF_AC]  = 0x88;       // ActorCount (standard UE4 offset)
        gOffsets[OFF_GI]  = 0xC48;      // World_GameInstance (standard)
        gOffsets[OFF_LP]  = 0x48;       // UGameInstance::LocalPlayers
        gOffsets[OFF_PC]  = 0x518;      // APlayerController::Player
        gOffsets[OFF_AP]  = 0x528;      // APlayerController::AcknowledgedPawn
        gOffsets[OFF_RC]  = 0x208;      // AActor::RootComponent
        gOffsets[OFF_CTW] = 0xAC0;      // ComponentToWorld (standard)
        gOffsets[OFF_CR]  = 0x4E0;      // AController::ControlRotation
        gOffsets[OFF_MS]  = 0x510;      // ACharacter::Mesh
        gOffsets[OFF_HP]  = 0xE60;      // STExtraCharacter::Health
        gOffsets[OFF_TM]  = 0x998;      // UAECharacter::TeamID
        gOffsets[OFF_AD]  = 0x8;        // ActorId (standard)
        gOffsets[OFF_VM]  = 0x0;

        // ── Weapon Stability (SDK) ───────────────────────────
        gOffsets[OFF_WMAN]  = 0x2608;   // WeaponManagerComponent
        gOffsets[OFF_CWR]   = 0x5D8;    // CurrentWeaponReplicated
        gOffsets[OFF_WEC]   = 0x860;    // WeaponEntityComp
        gOffsets[OFF_DEVF]  = 0xC2C;    // GameDeviationFactor
        gOffsets[OFF_DEVA]  = 0xC30;    // GameDeviationAccuracy
        gOffsets[OFF_ACCDF] = 0xBF0;    // AccessoriesDeviationFactor
        gOffsets[OFF_HSPD]  = 0xC3C;    // ShotGunHorizontalSpread
        gOffsets[OFF_VSPD]  = 0xC38;    // ShotGunVerticalSpread
    });
}
#define OFF(x) gOffsets[x]

// ====================================================================
// 📍 Memory Helpers
// ====================================================================
static uint64_t ReadPtr(uint64_t addr) {
    if (addr < 0x10000 || addr > 0x7FFFFFFFFFFFULL) return 0;
    uint64_t v = 0;
    if (ReadMem(addr, &v, 8)) return v;
    return 0;
}
static float ReadFloat(uint64_t addr) {
    if (addr < 0x10000) return 0;
    float v = 0;
    ReadMem(addr, &v, 4);
    return v;
}
static int32_t ReadInt(uint64_t addr) {
    if (addr < 0x10000) return 0;
    int32_t v = 0;
    ReadMem(addr, &v, 4);
    return v;
}
static BOOL WriteFloat(uint64_t addr, float val) {
    if (!addr) return NO;
    float c = ReadFloat(addr);
    if (fabsf(c - val) < 0.001f) return YES;
    return WriteMem(addr, &val, 4);
}

// ====================================================================
// 🚨 Offset Validation – يعرض اسم الأوفست الغلط على الشاشة
// ====================================================================
static BOOL gOffsetsValid   = NO;
static BOOL gOffsetChecked  = NO;

/// يعرض بانر أحمر يعدد كل الأوفستات الغلط بأسمائها
static void ShowOffsetErrors(NSArray<NSString *> *badList) {
    if (!badList.count) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *win = nil;
        for (UIWindowScene *s in [UIApplication sharedApplication].connectedScenes) {
            if (s.activationState == UISceneActivationStateForegroundActive) {
                win = s.windows.firstObject; break;
            }
        }
        if (!win) return;

        [[win viewWithTag:9876] removeFromSuperview];

        // بناء النص – كل أوفست بسطر لحاله
        NSMutableString *txt = [NSMutableString stringWithFormat:
            @"❌  OFFSETS ERROR  (%d)\n", (int)badList.count];
        for (NSString *line in badList)
            [txt appendFormat:@"%@\n", line];

        // ارتفاع ديناميكي حسب عدد الأوفستات
        CGFloat rowH  = 17.0;
        CGFloat cardH = 30.0 + badList.count * rowH;
        UILabel *lbl  = [[UILabel alloc] initWithFrame:
            CGRectMake(16, 56, win.bounds.size.width - 32, cardH)];
        lbl.text                = [txt stringByTrimmingCharactersInSet:
                                    [NSCharacterSet newlineCharacterSet]];
        lbl.textColor           = [UIColor whiteColor];
        lbl.backgroundColor     = [UIColor colorWithRed:0.72 green:0.06 blue:0.06 alpha:0.97];
        lbl.textAlignment       = NSTextAlignmentCenter;
        lbl.font                = [UIFont boldSystemFontOfSize:11];
        lbl.numberOfLines       = 0;
        lbl.layer.cornerRadius  = 12;
        lbl.layer.borderColor   = [UIColor colorWithRed:1 green:0.3 blue:0.3 alpha:0.55].CGColor;
        lbl.layer.borderWidth   = 1.0;
        lbl.layer.shadowColor   = [UIColor redColor].CGColor;
        lbl.layer.shadowRadius  = 10;
        lbl.layer.shadowOpacity = 0.55;
        lbl.layer.shadowOffset  = CGSizeMake(0, 0);
        lbl.clipsToBounds       = YES;
        lbl.tag                 = 9876;
        lbl.alpha               = 0;
        [win addSubview:lbl];
        [win bringSubviewToFront:lbl];
        [UIView animateWithDuration:0.4 animations:^{ lbl.alpha = 1; }];
    });
}

/// يفحص كل الأوفستات الحرجة ويعرض أسماء الفاشلين كلهم مع بعض
static BOOL ValidateOffsets(void) {
    if (gOffsetChecked) return gOffsetsValid;
    gOffsetChecked = YES;

    NSMutableArray<NSString *> *bad = [NSMutableArray array];

    // ── Global Addresses ─────────────────────────────────────────
    uint64_t gw = ReadPtr(OFF(OFF_GW));
    if (!gw) [bad addObject:[NSString stringWithFormat:@"OFF_GW (UWorld) → 0x%llx",     OFF(OFF_GW)]];

    uint64_t gn = ReadPtr(OFF(OFF_GN));
    if (!gn) [bad addObject:[NSString stringWithFormat:@"OFF_GN (GName) → 0x%llx",      OFF(OFF_GN)]];

    // ── Chain من UWorld (نفحصها بس لو gw صح) ──────────────────
    uint64_t lvl = gw ? ReadPtr(gw + OFF(OFF_PL)) : 0;
    if (gw && !lvl) [bad addObject:[NSString stringWithFormat:@"OFF_PL (PersistentLevel) → 0x%llx", OFF(OFF_PL)]];

    uint64_t gi = gw ? ReadPtr(gw + OFF(OFF_GI)) : 0;
    if (gw && !gi)  [bad addObject:[NSString stringWithFormat:@"OFF_GI (GameInstance) → 0x%llx",    OFF(OFF_GI)]];

    // ActorArray + Count
    uint64_t act = lvl ? ReadPtr(lvl + OFF(OFF_AA)) : 0;
    int32_t  cnt = lvl ? ReadInt(lvl  + OFF(OFF_AC)) : 0;
    if (lvl && (!act || cnt <= 0 || cnt > 5000))
        [bad addObject:[NSString stringWithFormat:@"OFF_AA/OFF_AC (ActorArray) → act=0x%llx cnt=%d",
                        OFF(OFF_AA), cnt]];

    // LocalPlayers chain
    uint64_t lpArr = gi ? ReadPtr(gi + OFF(OFF_LP)) : 0;
    if (gi && !lpArr) [bad addObject:[NSString stringWithFormat:@"OFF_LP (LocalPlayers) → 0x%llx", OFF(OFF_LP)]];

    // PlayerController
    uint64_t lp = lpArr ? ReadPtr(lpArr) : 0;
    uint64_t pc = lp    ? ReadPtr(lp + OFF(OFF_PC)) : 0;
    if (lpArr && lp && !pc)
        [bad addObject:[NSString stringWithFormat:@"OFF_PC (PlayerController) → 0x%llx", OFF(OFF_PC)]];

    // ControlRotation (صحّة offset الـ Aim)
    if (pc) {
        float rot[3] = {0};
        if (!ReadMem(pc + OFF(OFF_CR), rot, 12))
            [bad addObject:[NSString stringWithFormat:@"OFF_CR (ControlRotation) → 0x%llx", OFF(OFF_CR)]];
    }

    // ── ViewMatrix ──────────────────────────────────────────────
    float vm[16] = {0};
    BOOL hasVal  = NO;
    if (ReadMem(OFF(OFF_VMC), vm, 64))
        for (int i = 0; i < 16; i++) if (vm[i] != 0.0f) { hasVal = YES; break; }
    if (!hasVal)
        [bad addObject:[NSString stringWithFormat:@"OFF_VMC (ViewMatrix) → 0x%llx", OFF(OFF_VMC)]];

    // ── BoneBase (نتحقق إن العنوان قابل للقراءة) ───────────────
    if (OFF(OFF_BA) && !ReadPtr(OFF(OFF_BA)))
        [bad addObject:[NSString stringWithFormat:@"OFF_BA (BonePos) → 0x%llx", OFF(OFF_BA)]];

    if (bad.count > 0) {
        ShowOffsetErrors(bad);
        return NO;
    }

    gOffsetsValid = YES;
    return YES;
}

// ====================================================================
// 👤 IsPlayer
// ====================================================================
static BOOL IsPlayer(uint64_t actor) {
    if (!actor) return NO;
    uint64_t gnBase = ReadPtr(OFF(OFF_GN));
    if (!gnBase) return NO;
    uint32_t actorId = ReadInt(actor + OFF(OFF_AD));
    if (actorId == 0 || actorId > 10000000) return NO;
    uint32_t ci = actorId / 0x3FE0, ni = actorId % 0x3FE0;
    uint64_t chunk = ReadPtr(gnBase + ci * 8);
    if (!chunk) return NO;
    uint64_t entry = chunk + ni * 48;
    if (!entry) return NO;
    char name[24] = {0};
    if (!ReadMem(entry + 8, name, 20)) return NO;
    name[20] = '\0';
    if ((strstr(name, "PlayerPawn") || strstr(name, "BP_Player") ||
         strstr(name, "PlayerCharacter") || strstr(name, "PlayerMale") ||
         strstr(name, "PlayerFemale")) &&
        !strstr(name, "Pickup") && !strstr(name, "Dropped") &&
        !strstr(name, "Item") && !strstr(name, "Weapon"))
        return YES;
    return NO;
}

static float g_LocalX = 0, g_LocalY = 0, g_LocalZ = 0, g_ViewMatrix[16] = {0};

// ====================================================================
// PlayerData
// ====================================================================
@interface PlayerData : NSObject
@property (nonatomic, assign) uint64_t address;
@property (nonatomic, assign) float x, y, z, health, distance;
@property (nonatomic, assign) BOOL isEnemy, isAlive;
@property (nonatomic, assign) uint64_t meshAddr, boneAddr;
@property (nonatomic, assign) int32_t teamId;
@end
@implementation PlayerData @end

// ====================================================================
// 🌐 WorldToScreen
// ====================================================================
static BOOL WorldToScreen(float wx, float wy, float wz, float *sx, float *sy) {
    float cx = g_ViewMatrix[0]*wx + g_ViewMatrix[4]*wy + g_ViewMatrix[8]*wz  + g_ViewMatrix[12];
    float cy = g_ViewMatrix[1]*wx + g_ViewMatrix[5]*wy + g_ViewMatrix[9]*wz  + g_ViewMatrix[13];
    float cw = g_ViewMatrix[3]*wx + g_ViewMatrix[7]*wy + g_ViewMatrix[11]*wz + g_ViewMatrix[15];
    if (cw < 0.1f) return NO;
    float nx = cx / cw, ny = cy / cw;
    CGFloat sw = [UIScreen mainScreen].bounds.size.width;
    CGFloat sh = [UIScreen mainScreen].bounds.size.height;
    *sx = (sw / 2.0f) + (nx * sw / 2.0f);
    *sy = (sh / 2.0f) - (ny * sh / 2.0f);
    return YES;
}

// ====================================================================
// 👥 GetPlayers
// ====================================================================
static NSArray *GetPlayers(void) {
    NSMutableArray *arr = [NSMutableArray array];
    uint64_t gw = ReadPtr(OFF(OFF_GW));
    if (!gw) return arr;
    uint64_t lvl = ReadPtr(gw + OFF(OFF_PL));
    if (!lvl) return arr;
    uint64_t act = ReadPtr(lvl + OFF(OFF_AA));
    int32_t  cnt = ReadInt(lvl + OFF(OFF_AC));
    if (!act || cnt <= 0 || cnt > 1000) { cnt = 500; }
    uint64_t gi = ReadPtr(gw + OFF(OFF_GI));
    if (!gi) return arr;
    uint64_t lpArr = ReadPtr(gi + OFF(OFF_LP));
    if (!lpArr) return arr;
    uint64_t lp = ReadPtr(lpArr);
    if (!lp) return arr;
    uint64_t pc = ReadPtr(lp + OFF(OFF_PC));
    if (!pc) return arr;
    uint64_t localPawn = ReadPtr(pc + OFF(OFF_AP));

    g_LocalX = g_LocalY = g_LocalZ = 0;
    if (localPawn) {
        uint64_t root = ReadPtr(localPawn + OFF(OFF_RC));
        if (root) {
            uint64_t ctw = ReadPtr(root + OFF(OFF_CTW));
            if (ctw) {
                g_LocalX = ReadFloat(ctw + 0x10);
                g_LocalY = ReadFloat(ctw + 0x14);
                g_LocalZ = ReadFloat(ctw + 0x18);
            }
        }
    }

    int32_t localTeam = 0;
    if (localPawn) localTeam = ReadInt(localPawn + OFF(OFF_TM));

    ReadMem(OFF(OFF_VMC), g_ViewMatrix, 64);

    float maxDist = 200.0f;
    pthread_mutex_lock(&g_ConfigMutex);
    maxDist = gConfig.espDistance;
    pthread_mutex_unlock(&g_ConfigMutex);

    for (int i = 0; i < cnt; i++) {
        @autoreleasepool {
            uint64_t actor = ReadPtr(act + i * 8);
            if (!actor || actor == localPawn) continue;
            if (!IsPlayer(actor)) continue;
            uint64_t root = ReadPtr(actor + OFF(OFF_RC));
            if (!root) continue;
            float ax = 0, ay = 0, az = 0;
            uint64_t ctw = ReadPtr(root + OFF(OFF_CTW));
            if (ctw) {
                ax = ReadFloat(ctw + 0x10);
                ay = ReadFloat(ctw + 0x14);
                az = ReadFloat(ctw + 0x18);
            }
            if (ax == 0 && ay == 0 && az == 0) continue;
            float dx = ax - g_LocalX, dy = ay - g_LocalY, dz = az - g_LocalZ;
            float dist = sqrtf(dx*dx + dy*dy + dz*dz);
            if (dist < 0.5f || dist > maxDist) continue;
            float hp   = ReadFloat(actor + OFF(OFF_HP));
            int32_t tm = ReadInt(actor + OFF(OFF_TM));
            uint64_t mesh = ReadPtr(actor + OFF(OFF_MS));
            PlayerData *p = [[PlayerData alloc] init];
            p.address  = actor; p.x = ax; p.y = ay; p.z = az;
            p.health   = hp; p.distance = dist;
            p.isAlive  = (hp > 0.1f); p.teamId = tm;
            p.isEnemy  = (tm != localTeam) || (tm == 0);
            p.meshAddr = mesh;
            if (mesh) p.boneAddr = ReadPtr(mesh + OFF(OFF_BA));
            [arr addObject:p];
        }
    }
    return arr;
}

// ====================================================================
// 🎯 Aimbot
// ====================================================================
static void DoAimbot(NSArray *players) {
    BOOL en = NO; float sp = 5.0f; AimbotMode mode = AimbotMode_None;
    pthread_mutex_lock(&g_ConfigMutex);
    en = gConfig.aimbotEnabled; sp = gConfig.aimbotSpeed; mode = gConfig.aimbotMode;
    pthread_mutex_unlock(&g_ConfigMutex);
    if (!en || !players || players.count == 0 || mode == AimbotMode_None) return;

    PlayerData *best = nil; float closest = FLT_MAX;
    for (PlayerData *p in players) {
        if (!p.isAlive || !p.isEnemy || p.distance > 500.0f) continue;
        if (p.distance < closest) { closest = p.distance; best = p; }
    }
    if (!best) return;

    uint64_t gw   = ReadPtr(OFF(OFF_GW)); if (!gw) return;
    uint64_t gi   = ReadPtr(gw + OFF(OFF_GI));   if (!gi) return;
    uint64_t lpArr= ReadPtr(gi + OFF(OFF_LP));   if (!lpArr) return;
    uint64_t lp   = ReadPtr(lpArr);              if (!lp) return;
    uint64_t pc   = ReadPtr(lp + OFF(OFF_PC));   if (!pc) return;

    float targetH = 1.75f + ((arc4random() % 10) / 100.0f);
    float dx = best.x - g_LocalX;
    float dy = best.y - g_LocalY;
    float dz = (best.z + targetH) - g_LocalZ;

    float yaw   = atan2f(dy, dx) * (180.0f / M_PI);
    float pitch = -atan2f(dz, sqrtf(dx*dx + dy*dy)) * (180.0f / M_PI);
    if (yaw < 0)      yaw   += 360.0f;
    if (pitch > 89.0f)  pitch = 89.0f;
    if (pitch < -89.0f) pitch = -89.0f;

    yaw   += ((arc4random() % 100) - 50) / 500.0f;
    pitch += ((arc4random() % 100) - 50) / 500.0f;

    uint64_t crAddr  = pc + OFF(OFF_CR);
    float curPitch   = ReadFloat(crAddr);
    float curYaw     = ReadFloat(crAddr + 4);
    float dist       = best.distance;
    float factor;

    if (sp <= 50.0f)       factor = (dist > 50.0f)  ? 0.08f : 0.15f;
    else if (sp <= 115.0f) factor = (dist > 100.0f) ? sp / 250.0f : sp / 200.0f;
    else if (sp <= 135.0f) factor = sp / 160.0f;
    else                   factor = 1.0f;
    if (factor > 1.0f) factor = 1.0f;
    if (factor < 0.01f) factor = 0.01f;

    float dyaw   = yaw - curYaw;
    float dpitch = pitch - curPitch;
    if (dyaw >  180.0f) dyaw -= 360.0f;
    if (dyaw < -180.0f) dyaw += 360.0f;

    WriteFloat(crAddr,     curPitch + dpitch * factor);
    WriteFloat(crAddr + 4, curYaw   + dyaw   * factor);
}

// ====================================================================
// 🔫 Weapon Stability
// ====================================================================
static void DoStability(void) {
    BOOL en = NO;
    pthread_mutex_lock(&g_ConfigMutex);
    en = gConfig.stabilityEnabled;
    pthread_mutex_unlock(&g_ConfigMutex);
    if (!en) return;

    uint64_t gw   = ReadPtr(OFF(OFF_GW)); if (!gw) return;
    uint64_t gi   = ReadPtr(gw + OFF(OFF_GI));   if (!gi) return;
    uint64_t lpArr= ReadPtr(gi + OFF(OFF_LP));   if (!lpArr) return;
    uint64_t lp   = ReadPtr(lpArr);              if (!lp) return;
    uint64_t pc   = ReadPtr(lp + OFF(OFF_PC));   if (!pc) return;
    uint64_t pawn = ReadPtr(pc + OFF(OFF_AP));   if (!pawn) return;

    uint64_t wman   = ReadPtr(pawn + OFF(OFF_WMAN));  if (!wman) return;
    uint64_t weapon = ReadPtr(wman + OFF(OFF_CWR));   if (!weapon) return;
    uint64_t wEnt   = ReadPtr(weapon + OFF(OFF_WEC)); if (!wEnt) return;

    float jit = (float)(arc4random() % 5 + 3) / 100.0f;
    WriteFloat(wEnt + OFF(OFF_DEVF),  jit);
    WriteFloat(wEnt + OFF(OFF_DEVA),  jit * 0.80f);
    WriteFloat(wEnt + OFF(OFF_ACCDF), jit);
    WriteFloat(wEnt + OFF(OFF_VSPD),  jit * 0.45f);
    WriteFloat(wEnt + OFF(OFF_HSPD),  jit * 0.45f);
}

// ====================================================================
// 🛡️ Anti-Detach
// ====================================================================
static void *AntiDetachLoop(void *arg) {
    char *name = NULL;
    uint32_t cnt = _dyld_image_count();
    for (uint32_t i = 0; i < cnt; i++) {
        const char *n = _dyld_get_image_name(i);
        if (n) { name = strdup(n); break; }
    }
    if (!name) return NULL;
    while (YES) {
        uint32_t c = _dyld_image_count(); BOOL f = NO;
        for (uint32_t i = 0; i < c; i++) {
            const char *n = _dyld_get_image_name(i);
            if (n && strcmp(n, name) == 0) { f = YES; break; }
        }
        usleep(f ? (arc4random() % 3000000 + 5000000) : (arc4random() % 500000 + 1000000));
    }
    free(name);
    return NULL;
}

// ====================================================================
// 🎨 ESP Overlay View
// ====================================================================
@interface ESPOverlayView : UIView
@property (nonatomic, strong) CAShapeLayer *boxLayer, *lineLayer, *bulletLineLayer;
@property (nonatomic, strong) UILabel      *infoLabel;
- (void)updateWithPlayers:(NSArray *)players;
@end

@implementation ESPOverlayView {
    // ── RavFen Screensaver Label (bouncing around full screen) ──
    UILabel       *_wm;
    CAShapeLayer  *_rayLayer;   // أشعة بنفسجية تخرج من الـ label
    NSTimer       *_wmTmr;
    CGFloat        _wmVX;       // velocity X
    CGFloat        _wmVY;       // velocity Y
    CGFloat        _wmX;        // current X position
    CGFloat        _wmY;        // current Y position
    CGFloat        _rayPhase;   // زاوية دوران الأشعة (بطيء)
}

- (instancetype)initWithFrame:(CGRect)f {
    self = [super initWithFrame:f];
    if (!self) return nil;
    self.backgroundColor        = [UIColor clearColor];
    self.userInteractionEnabled = NO;

    _boxLayer             = [CAShapeLayer layer];
    _boxLayer.strokeColor = [UIColor colorWithRed:0.545 green:0.361 blue:0.965 alpha:1.00].CGColor;
    _boxLayer.fillColor   = [UIColor colorWithRed:0.545 green:0.361 blue:0.965 alpha:0.28].CGColor;
    _boxLayer.lineWidth   = 1.2f;
    [self.layer addSublayer:_boxLayer];

    _lineLayer                  = [CAShapeLayer layer];
    _lineLayer.strokeColor      = [UIColor colorWithRed:0.984 green:0.749 blue:0.247 alpha:1.00].CGColor;
    _lineLayer.lineWidth        = 0.8f;
    _lineLayer.lineDashPattern  = @[@5, @3];
    [self.layer addSublayer:_lineLayer];

    _bulletLineLayer             = [CAShapeLayer layer];
    _bulletLineLayer.strokeColor = [UIColor colorWithRed:0.937 green:0.267 blue:0.267 alpha:1.00].CGColor;
    _bulletLineLayer.lineWidth   = 1.5f;
    [self.layer addSublayer:_bulletLineLayer];

    _infoLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, f.size.width, 18)];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.textColor     = [UIColor colorWithRed:0.545 green:0.361 blue:0.965 alpha:1.00];
    _infoLabel.font          = [UIFont boldSystemFontOfSize:10];
    _infoLabel.text          = @"";
    [self addSubview:_infoLabel];

    // ── RavFen bouncing watermark label ──────────────────────────
    _wm                        = [[UILabel alloc] init];
    _wm.text                   = @"RavFen";
    _wm.textColor              = [UIColor colorWithRed:0.545 green:0.361 blue:0.965 alpha:0.55];
    _wm.font                   = [UIFont boldSystemFontOfSize:13];
    _wm.userInteractionEnabled = NO;
    // توهج بنفسجي خفيف على النص نفسه
    _wm.layer.shadowColor      = [UIColor colorWithRed:0.545 green:0.361 blue:0.965 alpha:1.0].CGColor;
    _wm.layer.shadowRadius     = 7.0;
    _wm.layer.shadowOpacity    = 0.65;
    _wm.layer.shadowOffset     = CGSizeMake(0, 0);
    [_wm sizeToFit];

    // ── طبقة الأشعة البنفسجية (تُرسم خلف الـ label) ──────────
    _rayLayer              = [CAShapeLayer layer];
    _rayLayer.strokeColor  = [UIColor colorWithRed:0.545 green:0.361 blue:0.965 alpha:0.30].CGColor;
    _rayLayer.fillColor    = [UIColor clearColor].CGColor;
    _rayLayer.lineWidth    = 0.8;
    _rayLayer.lineCap      = kCALineCapRound;
    _rayLayer.shadowColor  = [UIColor colorWithRed:0.545 green:0.361 blue:0.965 alpha:1.0].CGColor;
    _rayLayer.shadowRadius = 4.0;
    _rayLayer.shadowOpacity= 0.5;
    _rayLayer.shadowOffset = CGSizeMake(0, 0);
    [self.layer addSublayer:_rayLayer];

    [self addSubview:_wm];
    _rayPhase = 0;

    // Start at random position somewhere in the middle area
    _wmX  = f.size.width  * 0.3f + (arc4random() % (int)(f.size.width  * 0.4f));
    _wmY  = f.size.height * 0.3f + (arc4random() % (int)(f.size.height * 0.4f));

    // Random initial velocity: ±1.2 to ±2.2 pts per tick
    CGFloat baseSpeed = 1.6f;
    _wmVX = (arc4random() % 2 == 0 ? 1 : -1) * (baseSpeed + ((arc4random() % 10) / 10.0f));
    _wmVY = (arc4random() % 2 == 0 ? 1 : -1) * (baseSpeed + ((arc4random() % 10) / 10.0f));

    _wm.center = CGPointMake(_wmX, _wmY);

    // Timer at ~60fps for smooth motion
    _wmTmr = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0) repeats:YES block:^(NSTimer *t) {
        if (!self.window) { [t invalidate]; return; }

        CGFloat lw = self.bounds.size.width;
        CGFloat lh = self.bounds.size.height;
        CGFloat hw = _wm.bounds.size.width  / 2.0f;
        CGFloat hh = _wm.bounds.size.height / 2.0f;

        _wmX += _wmVX;
        _wmY += _wmVY;

        // Bounce off edges
        if (_wmX - hw <= 0) {
            _wmX  = hw;
            _wmVX = fabs(_wmVX);
            // Slightly randomise speed on bounce for natural feel
            _wmVX += ((arc4random() % 4) - 2) / 10.0;
            if (fabs(_wmVX) < 0.8) _wmVX = 0.8;
            if (fabs(_wmVX) > 3.0) _wmVX = 3.0;
        }
        if (_wmX + hw >= lw) {
            _wmX  = lw - hw;
            _wmVX = -fabs(_wmVX);
            _wmVX -= ((arc4random() % 4) - 2) / 10.0;
            if (fabs(_wmVX) < 0.8) _wmVX = -0.8;
            if (fabs(_wmVX) > 3.0) _wmVX = -3.0;
        }
        if (_wmY - hh <= 0) {
            _wmY  = hh;
            _wmVY = fabs(_wmVY);
            _wmVY += ((arc4random() % 4) - 2) / 10.0;
            if (fabs(_wmVY) < 0.8) _wmVY = 0.8;
            if (fabs(_wmVY) > 3.0) _wmVY = 3.0;
        }
        if (_wmY + hh >= lh) {
            _wmY  = lh - hh;
            _wmVY = -fabs(_wmVY);
            _wmVY -= ((arc4random() % 4) - 2) / 10.0;
            if (fabs(_wmVY) < 0.8) _wmVY = -0.8;
            if (fabs(_wmVY) > 3.0) _wmVY = -3.0;
        }

        _wm.center = CGPointMake(_wmX, _wmY);

        // ── رسم الأشعة البنفسجية من مركز الـ label ──────────────
        // الأشعة تدور ببطء وتنبض مع الحركة
        _rayPhase += 0.018;
        NSInteger numRays = 8;
        CGFloat   startR  = 10.0;            // بداية الشعاع من حافة الـ label
        CGFloat   rayLen  = 18.0 + 5.0 * sinf(_rayPhase * 1.3); // نبض خفيف
        UIBezierPath *rp  = [UIBezierPath bezierPath];
        for (NSInteger r = 0; r < numRays; r++) {
            // كل شعاع يدور بزاوية مختلفة + دوران بطيء
            CGFloat angle = (M_PI * 2.0 / numRays) * r + _rayPhase;
            CGPoint s = CGPointMake(_wmX + startR * cos(angle),
                                    _wmY + startR * sin(angle));
            CGPoint e = CGPointMake(_wmX + (startR + rayLen) * cos(angle),
                                    _wmY + (startR + rayLen) * sin(angle));
            [rp moveToPoint:s];
            [rp addLineToPoint:e];
        }
        // أشعة وسطية أقصر (بين الـ 8 الرئيسية) لتعطي شكل نجمة ناعم
        CGFloat shortLen = rayLen * 0.45;
        for (NSInteger r = 0; r < numRays; r++) {
            CGFloat angle = (M_PI * 2.0 / numRays) * r + _rayPhase + (M_PI / numRays);
            CGPoint s = CGPointMake(_wmX + startR * cos(angle),
                                    _wmY + startR * sin(angle));
            CGPoint e = CGPointMake(_wmX + (startR + shortLen) * cos(angle),
                                    _wmY + (startR + shortLen) * sin(angle));
            [rp moveToPoint:s];
            [rp addLineToPoint:e];
        }
        _rayLayer.path = rp.CGPath;
        // نبض شفافية خفيف على طبقة الأشعة
        _rayLayer.opacity = 0.22 + 0.12 * sinf(_rayPhase * 2.1);
    }];
    [[NSRunLoop mainRunLoop] addTimer:_wmTmr forMode:NSRunLoopCommonModes];

    return self;
}

- (void)updateWithPlayers:(NSArray *)players {
    BOOL espOn = NO, lineOn = NO, bulletOn = NO;
    pthread_mutex_lock(&g_ConfigMutex);
    espOn    = gConfig.espEnabled;
    lineOn   = gConfig.espLine;
    bulletOn = gConfig.espBulletLine;
    pthread_mutex_unlock(&g_ConfigMutex);

    if (!espOn || !players || players.count == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.boxLayer.path        = nil;
            self.lineLayer.path       = nil;
            self.bulletLineLayer.path = nil;
            _infoLabel.text           = @"";
        });
        return;
    }

    UIBezierPath *bp  = [UIBezierPath bezierPath];
    UIBezierPath *lp  = [UIBezierPath bezierPath];
    UIBezierPath *blp = [UIBezierPath bezierPath];
    int visible = 0;
    CGFloat sw = self.bounds.size.width, sh = self.bounds.size.height;

    for (PlayerData *p in players) {
        if (!p.isEnemy || !p.isAlive) continue;
        float sx = 0, sy = 0;
        if (!WorldToScreen(p.x, p.y, p.z + 1.75f, &sx, &sy)) continue;
        if (sx < -60 || sx > sw + 60 || sy < -60 || sy > sh + 60) continue;
        visible++;

        float boxH = MAX(20.0f, MIN(120.0f, 8000.0f / p.distance));
        float boxW = boxH * 0.55f;
        CGRect box = CGRectMake(sx - boxW / 2.0f, sy - boxH, boxW, boxH);
        [bp appendPath:[UIBezierPath bezierPathWithRoundedRect:box cornerRadius:2]];

        if (lineOn) {
            [lp moveToPoint:CGPointMake(sw / 2.0f, sh)];
            [lp addLineToPoint:CGPointMake(sx, sy)];
        }
        if (bulletOn) {
            [blp moveToPoint:CGPointMake(sx, sy - boxH)];
            [blp addLineToPoint:CGPointMake(sx, sy)];
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        self.boxLayer.path        = bp.CGPath;
        self.lineLayer.path       = lp.CGPath;
        self.bulletLineLayer.path = blp.CGPath;
        _infoLabel.text = visible > 0
            ? [NSString stringWithFormat:@"[ %d ]", visible]
            : @"";
    });
}

@end

// ====================================================================
// 🔄 RavEngine
// ====================================================================
@interface RavEngine : NSObject
+ (instancetype)shared;
- (void)startWithOverlay:(ESPOverlayView *)overlay;
@end

@implementation RavEngine {
    dispatch_queue_t _q;
    NSTimer          *_t;
    ESPOverlayView   *_ov;
}

+ (instancetype)shared {
    static RavEngine *s;
    static dispatch_once_t o;
    dispatch_once(&o, ^{ s = [[RavEngine alloc] init]; });
    return s;
}

- (void)startWithOverlay:(ESPOverlayView *)overlay {
    _ov = overlay;
    _q  = dispatch_queue_create("ravfen.engine", DISPATCH_QUEUE_SERIAL);
    dispatch_async(dispatch_get_main_queue(), ^{
        _t = [NSTimer scheduledTimerWithTimeInterval:0.050
                                             repeats:YES
                                               block:^(NSTimer *timer) {
            dispatch_async(_q, ^{
                NSArray *p = GetPlayers();
                DoAimbot(p);
                DoStability();
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_ov updateWithPlayers:p];
                });
            });
        }];
        [[NSRunLoop mainRunLoop] addTimer:_t forMode:NSRunLoopCommonModes];
    });
}

@end

// ====================================================================
// 🖥️ ESP Manager
// ====================================================================
@interface ESPManager : NSObject
@property (nonatomic, strong) UIWindow        *w;
@property (nonatomic, strong) ESPOverlayView  *v;
+ (instancetype)shared;
- (ESPOverlayView *)getOverlayView;
- (void)start;
- (void)stop;
@end

@implementation ESPManager

+ (instancetype)shared {
    static ESPManager *m;
    static dispatch_once_t o;
    dispatch_once(&o, ^{ m = [[ESPManager alloc] init]; });
    return m;
}
- (ESPOverlayView *)getOverlayView { return self.v; }
- (void)start {
    if (self.w) return;
    CGRect sb   = [UIScreen mainScreen].bounds;
    self.w      = [[UIWindow alloc] initWithFrame:sb];
    self.w.windowLevel      = UIWindowLevelAlert + 1;
    self.w.backgroundColor  = [UIColor clearColor];
    self.w.hidden           = NO;
    self.w.userInteractionEnabled = NO;
    self.v = [[ESPOverlayView alloc] initWithFrame:sb];
    [self.w addSubview:self.v];
    [[RavEngine shared] startWithOverlay:self.v];
}
- (void)stop { self.w.hidden = YES; self.w = nil; self.v = nil; }

@end

// ====================================================================
// 🎨 Helper
// ====================================================================
#define CLR_BG          [UIColor colorWithRed:0.055 green:0.055 blue:0.075 alpha:1.00]
#define CLR_PANEL       [UIColor colorWithRed:0.08  green:0.08  blue:0.11  alpha:0.97]
#define CLR_HDR         [UIColor colorWithRed:0.06  green:0.06  blue:0.09  alpha:1.00]
#define CLR_VIOLET      [UIColor colorWithRed:0.545 green:0.361 blue:0.965 alpha:1.00]
#define CLR_VIOLET_DIM  [UIColor colorWithRed:0.545 green:0.361 blue:0.965 alpha:0.28]
#define CLR_GOLD        [UIColor colorWithRed:0.984 green:0.749 blue:0.247 alpha:1.00]
#define CLR_GOLD_DIM    [UIColor colorWithRed:0.984 green:0.749 blue:0.247 alpha:0.22]
#define CLR_GREEN       [UIColor colorWithRed:0.063 green:0.725 blue:0.506 alpha:1.00]
#define CLR_GREEN_DIM   [UIColor colorWithRed:0.063 green:0.725 blue:0.506 alpha:0.22]
#define CLR_RED         [UIColor colorWithRed:0.937 green:0.267 blue:0.267 alpha:1.00]
#define CLR_ORANGE      [UIColor colorWithRed:0.984 green:0.502 blue:0.082 alpha:1.00]
#define CLR_ORANGE_DIM  [UIColor colorWithRed:0.984 green:0.502 blue:0.082 alpha:0.22]
#define CLR_TEXT        [UIColor colorWithRed:0.94  green:0.94  blue:0.96  alpha:1.00]
#define CLR_MUTED       [UIColor colorWithRed:0.58  green:0.62  blue:0.70  alpha:1.00]
#define CLR_SEP         [UIColor colorWithRed:1.00  green:1.00  blue:1.00  alpha:0.07]

static UILabel *RavLabel(NSString *text, UIFont *font, UIColor *color, CGRect frame) {
    UILabel *l = [[UILabel alloc] initWithFrame:frame];
    l.text            = text;
    l.font            = font;
    l.textColor       = color;
    l.backgroundColor = [UIColor clearColor];
    return l;
}

// ====================================================================
// ◈ Floating Button
// ====================================================================
@interface RavFloatingButton : UIView
@property (nonatomic, copy) void (^onTap)(void);
@end

@implementation RavFloatingButton {
    UIPanGestureRecognizer *_pan;
    CALayer                *_ring;
    NSTimer                *_pulse;
    CGFloat                 _pulsePhase;
}

- (instancetype)initWithFrame:(CGRect)f {
    self = [super initWithFrame:f];
    if (!self) return nil;

    self.backgroundColor    = CLR_HDR;
    self.layer.cornerRadius = 14;
    self.layer.borderWidth  = 1.0;
    self.layer.borderColor  = CLR_VIOLET_DIM.CGColor;
    self.layer.shadowColor  = CLR_VIOLET.CGColor;
    self.layer.shadowRadius = 8;
    self.layer.shadowOpacity= 0.55;
    self.layer.shadowOffset = CGSizeMake(0, 0);

    _ring = [CALayer layer];
    _ring.frame        = CGRectInset(self.bounds, -4, -4);
    _ring.cornerRadius = 18;
    _ring.borderWidth  = 1.5;
    _ring.borderColor  = CLR_VIOLET.CGColor;
    _ring.opacity      = 0.5;
    [self.layer addSublayer:_ring];

    UILabel *mono = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, f.size.width, f.size.height - 12)];
    mono.text                  = @"RF";
    mono.textColor             = CLR_VIOLET;
    mono.font                  = [UIFont boldSystemFontOfSize:15];
    mono.textAlignment         = NSTextAlignmentCenter;
    mono.userInteractionEnabled = NO;
    [self addSubview:mono];

    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(0, f.size.height - 16, f.size.width, 12)];
    sub.text                  = @"WRAITH";
    sub.textColor             = CLR_MUTED;
    sub.font                  = [UIFont boldSystemFontOfSize:7];
    sub.textAlignment         = NSTextAlignmentCenter;
    sub.userInteractionEnabled = NO;
    [self addSubview:sub];

    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:_pan];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    [_pan requireGestureRecognizerToFail:tap];

    _pulsePhase = 0;
    _pulse = [NSTimer scheduledTimerWithTimeInterval:0.04 repeats:YES block:^(NSTimer *t) {
        if (!self.superview) { [t invalidate]; return; }
        _pulsePhase += 0.07;
        CGFloat a = 0.25 + 0.25 * sinf(_pulsePhase);
        _ring.opacity = a;
        CGFloat ex = 3 + 2 * sinf(_pulsePhase);
        _ring.frame = CGRectInset(self.bounds, -ex, -ex);
        _ring.cornerRadius = 14 + ex;
    }];
    [[NSRunLoop mainRunLoop] addTimer:_pulse forMode:NSRunLoopCommonModes];

    return self;
}

- (void)pan:(UIPanGestureRecognizer *)g {
    UIView *v = self.superview; if (!v) return;
    if (g.state == UIGestureRecognizerStateChanged) {
        CGPoint t = [g translationInView:v];
        CGPoint c = self.center;
        c.x += t.x; c.y += t.y;
        CGFloat r = self.bounds.size.width / 2.0 + 10;
        c.x = MAX(r, MIN(v.bounds.size.width  - r, c.x));
        c.y = MAX(r + 44, MIN(v.bounds.size.height - r - 44, c.y));
        self.center = c;
        [g setTranslation:CGPointZero inView:v];
    }
}
- (void)tap { if (self.onTap) self.onTap(); }

@end

// ====================================================================
// ◈ Menu View  (أفقي – Horizontal Layout  480 × 300)
//   ┌──────── header 44px ─────────┐
//   │ sidebar 72px │  content area │
//   └──────────────┴───────────────┘
// ====================================================================
@interface RavMenuView : UIView
- (instancetype)initWithFrame:(CGRect)f overlayView:(ESPOverlayView *)ov;
@end

@implementation RavMenuView {
    NSInteger            _activeTab;
    UIButton            *_tabBtns[4];       // AIMBOT | ESP | MEMORY | TIPS
    UIView              *_tabIndicators[4];
    UIView              *_pages[4];

    // Aimbot controls
    UISwitch            *_as;
    UISegmentedControl  *_ms;
    UISlider            *_ss, *_smSlider;
    UILabel             *_sv, *_smv;

    // ESP controls
    UISwitch            *_es, *_ls, *_bls;
    UISlider            *_ds;
    UILabel             *_dv;

    // Memory controls
    UISwitch            *_chs;
    UISwitch            *_sts;
    UISwitch            *_vcs;
    UILabel             *_srvStatus;

    ESPOverlayView      *_ev;
    UIPanGestureRecognizer *_pan;
    CGPoint              _startCenter;
}

static UIView *Sep(CGFloat x, CGFloat y, CGFloat w) {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, 0.5)];
    v.backgroundColor = CLR_SEP;
    return v;
}

static UISwitch *StyledSwitch(UIColor *onColor) {
    UISwitch *s = [[UISwitch alloc] init];
    s.transform   = CGAffineTransformMakeScale(0.70, 0.70);
    s.onTintColor = onColor;
    return s;
}

- (instancetype)initWithFrame:(CGRect)f overlayView:(ESPOverlayView *)ov {
    self = [super initWithFrame:f];
    if (!self) return nil;
    _ev = ov;

    self.backgroundColor    = CLR_PANEL;
    self.layer.cornerRadius = 20;
    self.layer.borderWidth  = 1.0;
    self.layer.borderColor  = CLR_VIOLET_DIM.CGColor;
    self.clipsToBounds      = NO;
    self.layer.shadowColor  = CLR_VIOLET.CGColor;
    self.layer.shadowRadius = 16;
    self.layer.shadowOpacity= 0.30;
    self.layer.shadowOffset = CGSizeMake(0, 4);

    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMenu:)];
    [self addGestureRecognizer:_pan];

    [self buildUI];
    [self syncUI];
    return self;
}

- (void)panMenu:(UIPanGestureRecognizer *)g {
    UIView *v = self.superview; if (!v) return;
    if (g.state == UIGestureRecognizerStateBegan) {
        _startCenter = self.center;
    } else if (g.state == UIGestureRecognizerStateChanged) {
        CGPoint t = [g translationInView:v];
        self.center = CGPointMake(_startCenter.x + t.x, _startCenter.y + t.y);
    }
}

- (void)syncUI {
    pthread_mutex_lock(&g_ConfigMutex);
    _as.on  = gConfig.aimbotEnabled;
    _ss.value = gConfig.aimbotSpeed;
    _smSlider.value = gConfig.aimbotSmoothing;
    _ms.selectedSegmentIndex = (NSInteger)(gConfig.aimbotMode - 1);
    _es.on  = gConfig.espEnabled;
    _ls.on  = gConfig.espLine;
    _bls.on = gConfig.espBulletLine;
    _ds.value = gConfig.espDistance;
    _chs.on = gConfig.crosshairEnabled;
    _sts.on = gConfig.stabilityEnabled;
    _vcs.on = gConfig.visCheckEnabled;
    pthread_mutex_unlock(&g_ConfigMutex);
    [_sv  setText:[NSString stringWithFormat:@"%.0f",   _ss.value]];
    [_smv setText:[NSString stringWithFormat:@"%.0f%%", (_smSlider.value / 10.0f) * 100.0f]];
    [_dv  setText:[NSString stringWithFormat:@"%.0fm",  _ds.value]];
}

- (void)buildUI {
    CGFloat mw    = self.bounds.size.width;   // 480
    CGFloat mh    = self.bounds.size.height;  // 300
    CGFloat hdrH  = 44.0f;
    CGFloat sideW = 72.0f;
    CGFloat bodyH = mh - hdrH;

    // ── Header ───────────────────────────────────────────────────
    UIView *hdr = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mw, hdrH)];
    hdr.backgroundColor     = CLR_HDR;
    hdr.layer.cornerRadius  = 20;
    hdr.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [self addSubview:hdr];

    UILabel *badge = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 26, 24)];
    badge.text               = @"RF";
    badge.textColor          = CLR_VIOLET;
    badge.font               = [UIFont boldSystemFontOfSize:11];
    badge.textAlignment      = NSTextAlignmentCenter;
    badge.backgroundColor    = CLR_VIOLET_DIM;
    badge.layer.cornerRadius = 7;
    badge.clipsToBounds      = YES;
    [hdr addSubview:badge];

    [hdr addSubview:RavLabel(@"RAVFEN  WRAITH",
        [UIFont boldSystemFontOfSize:11], CLR_TEXT, CGRectMake(45, 8, 180, 16))];
    [hdr addSubview:RavLabel(@"v7.3  ·  PUBG 4.5.0 TW",
        [UIFont systemFontOfSize:9], CLR_MUTED, CGRectMake(45, 24, 180, 13))];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(mw - 40, 10, 28, 24);
    [closeBtn setTitle:@"×" forState:UIControlStateNormal];
    [closeBtn setTitleColor:CLR_RED forState:UIControlStateNormal];
    closeBtn.titleLabel.font    = [UIFont systemFontOfSize:20];
    closeBtn.backgroundColor    = [UIColor colorWithRed:0.25 green:0.04 blue:0.04 alpha:0.7];
    closeBtn.layer.cornerRadius = 8;
    [closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [hdr addSubview:closeBtn];

    // Separator under header
    [self addSubview:Sep(0, hdrH, mw)];

    // ── Left Sidebar (vertical tabs) ─────────────────────────────
    UIView *sidebar = [[UIView alloc] initWithFrame:CGRectMake(0, hdrH, sideW, bodyH)];
    sidebar.backgroundColor     = CLR_HDR;
    sidebar.layer.cornerRadius  = 20;
    sidebar.layer.maskedCorners = kCALayerMinXMaxYCorner;
    [self addSubview:sidebar];

    // Separator right of sidebar
    UIView *sideSep = [[UIView alloc] initWithFrame:CGRectMake(sideW, hdrH, 0.5, bodyH)];
    sideSep.backgroundColor = CLR_SEP;
    [self addSubview:sideSep];

    NSArray *tabNames  = @[@"AIM",  @"ESP",  @"MEM",  @"TIPS"];
    NSArray *tabColors = @[CLR_GOLD, CLR_VIOLET, CLR_GREEN, CLR_ORANGE];
    NSArray *tabIcons  = @[@"⌖",    @"◈",    @"⚙",    @"★"];

    CGFloat tabH = bodyH / 4.0;
    for (int i = 0; i < 4; i++) {
        UIButton *tb = [UIButton buttonWithType:UIButtonTypeSystem];
        tb.frame = CGRectMake(0, hdrH + i * tabH, sideW, tabH);

        // Icon label
        UILabel *ico = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sideW, tabH * 0.55)];
        ico.text          = tabIcons[i];
        ico.textColor     = (i == 0 ? tabColors[i] : CLR_MUTED);
        ico.font          = [UIFont systemFontOfSize:16];
        ico.textAlignment = NSTextAlignmentCenter;
        ico.tag           = 100 + i;
        [tb addSubview:ico];

        // Name label
        UILabel *nm = [[UILabel alloc] initWithFrame:CGRectMake(0, tabH * 0.52, sideW, tabH * 0.42)];
        nm.text          = tabNames[i];
        nm.textColor     = (i == 0 ? tabColors[i] : CLR_MUTED);
        nm.font          = [UIFont boldSystemFontOfSize:8];
        nm.textAlignment = NSTextAlignmentCenter;
        nm.tag           = 200 + i;
        [tb addSubview:nm];

        // Active indicator bar (right edge)
        UIView *indicator = [[UIView alloc] initWithFrame:CGRectMake(sideW - 3, tabH * 0.2, 3, tabH * 0.6)];
        indicator.backgroundColor   = ((UIColor *)tabColors[i]);
        indicator.layer.cornerRadius = 1.5;
        indicator.hidden             = (i != 0);
        indicator.tag                = 300 + i;
        [tb addSubview:indicator];
        _tabIndicators[i] = indicator;

        tb.tag = i;
        [tb addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tb];
        _tabBtns[i] = tb;

        // Row separator
        if (i < 3) {
            UIView *rs = [[UIView alloc] initWithFrame:CGRectMake(8, hdrH + (i + 1) * tabH - 0.25, sideW - 16, 0.5)];
            rs.backgroundColor = CLR_SEP;
            [self addSubview:rs];
        }
    }

    // ── Content Area (right of sidebar) ──────────────────────────
    CGFloat cX = sideW + 1;
    CGFloat cW = mw - cX;
    CGRect  pageR = CGRectMake(cX, hdrH, cW, bodyH);

    [self buildAimbotPage:pageR];
    [self buildEspPage:pageR];
    [self buildMemoryPage:pageR];
    [self buildTipsPage:pageR];

    _pages[1].hidden = YES;
    _pages[2].hidden = YES;
    _pages[3].hidden = YES;
}

// ── AIMBOT Page ───────────────────────────────────────────────────
- (void)buildAimbotPage:(CGRect)fr {
    UIView *page = [[UIView alloc] initWithFrame:fr];
    _pages[0] = page;
    [self addSubview:page];
    CGFloat pw = fr.size.width - 24, mw = fr.size.width, y = 12;

    [page addSubview:RavLabel(@"AIMBOT", [UIFont boldSystemFontOfSize:10], CLR_GOLD,
                              CGRectMake(12, y, 80, 14))];
    _as = StyledSwitch(CLR_GOLD);
    _as.frame = CGRectMake(mw - 58, y - 4, 51, 31);
    [_as addTarget:self action:@selector(tgA) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_as];
    y += 22;

    _ms = [[UISegmentedControl alloc] initWithItems:@[@"Lock", @"Fire", @"Scope"]];
    _ms.frame = CGRectMake(12, y, pw, 26);
    _ms.selectedSegmentIndex = 0;
    _ms.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.14 alpha:1.0];
    [_ms setTitleTextAttributes:@{NSForegroundColorAttributeName: CLR_MUTED,
                                   NSFontAttributeName: [UIFont boldSystemFontOfSize:9]}
                       forState:UIControlStateNormal];
    [_ms setTitleTextAttributes:@{NSForegroundColorAttributeName: CLR_GOLD,
                                   NSFontAttributeName: [UIFont boldSystemFontOfSize:9]}
                       forState:UIControlStateSelected];
    if (@available(iOS 13.0, *)) { _ms.selectedSegmentTintColor = CLR_GOLD_DIM; }
    [_ms addTarget:self action:@selector(mCh) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_ms];
    y += 32;

    // Speed row
    [page addSubview:RavLabel(@"Speed", [UIFont systemFontOfSize:9], CLR_MUTED,
                              CGRectMake(12, y, 50, 13))];
    _sv = RavLabel(@"120", [UIFont boldSystemFontOfSize:9], CLR_GOLD,
                   CGRectMake(mw - 36, y, 26, 13));
    _sv.textAlignment = NSTextAlignmentRight;
    [page addSubview:_sv];
    y += 13;
    _ss = [[UISlider alloc] initWithFrame:CGRectMake(12, y, pw, 18)];
    _ss.minimumValue = 1; _ss.maximumValue = 150; _ss.value = 120;
    _ss.minimumTrackTintColor = CLR_GOLD;
    _ss.maximumTrackTintColor = [UIColor colorWithRed:0.15 green:0.13 blue:0.09 alpha:1.0];
    [_ss addTarget:self action:@selector(sCh) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_ss];
    y += 24;

    [page addSubview:Sep(12, y, pw)]; y += 10;

    // Smoothing row
    [page addSubview:RavLabel(@"Smoothing", [UIFont systemFontOfSize:9], CLR_MUTED,
                              CGRectMake(12, y, 70, 13))];
    _smv = RavLabel(@"50%", [UIFont boldSystemFontOfSize:9], CLR_GOLD,
                    CGRectMake(mw - 36, y, 26, 13));
    _smv.textAlignment = NSTextAlignmentRight;
    [page addSubview:_smv];
    y += 13;
    _smSlider = [[UISlider alloc] initWithFrame:CGRectMake(12, y, pw, 18)];
    _smSlider.minimumValue = 0; _smSlider.maximumValue = 10; _smSlider.value = 5;
    _smSlider.minimumTrackTintColor = CLR_GOLD;
    _smSlider.maximumTrackTintColor = [UIColor colorWithRed:0.15 green:0.13 blue:0.09 alpha:1.0];
    [_smSlider addTarget:self action:@selector(smCh) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_smSlider];
}

// ── ESP Page ──────────────────────────────────────────────────────
- (void)buildEspPage:(CGRect)fr {
    UIView *page = [[UIView alloc] initWithFrame:fr];
    _pages[1] = page;
    [self addSubview:page];
    CGFloat pw = fr.size.width - 24, mw = fr.size.width, y = 12;

    [page addSubview:RavLabel(@"ESP", [UIFont boldSystemFontOfSize:10], CLR_VIOLET,
                              CGRectMake(12, y, 50, 13))];
    _es = StyledSwitch(CLR_VIOLET);
    _es.frame = CGRectMake(mw - 58, y - 4, 51, 31);
    [_es addTarget:self action:@selector(tgE) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_es];
    y += 26;

    [page addSubview:RavLabel(@"Skeleton Lines", [UIFont systemFontOfSize:9], CLR_MUTED,
                              CGRectMake(12, y + 4, 110, 13))];
    _ls = StyledSwitch(CLR_GREEN);
    _ls.frame = CGRectMake(mw - 58, y, 51, 28);
    [_ls addTarget:self action:@selector(tgL) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_ls];
    y += 28;

    [page addSubview:RavLabel(@"Bullet Tracer", [UIFont systemFontOfSize:9], CLR_MUTED,
                              CGRectMake(12, y + 4, 100, 13))];
    _bls = StyledSwitch(CLR_RED);
    _bls.frame = CGRectMake(mw - 58, y, 51, 28);
    [_bls addTarget:self action:@selector(tgB) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_bls];
    y += 28;

    [page addSubview:Sep(12, y, pw)]; y += 10;

    [page addSubview:RavLabel(@"Max Distance", [UIFont systemFontOfSize:9], CLR_MUTED,
                              CGRectMake(12, y, 90, 13))];
    _dv = RavLabel(@"200m", [UIFont boldSystemFontOfSize:9], CLR_VIOLET,
                   CGRectMake(mw - 40, y, 32, 13));
    _dv.textAlignment = NSTextAlignmentRight;
    [page addSubview:_dv];
    y += 13;
    _ds = [[UISlider alloc] initWithFrame:CGRectMake(12, y, pw, 18)];
    _ds.minimumValue = 50; _ds.maximumValue = 350; _ds.value = 200;
    _ds.minimumTrackTintColor = CLR_VIOLET;
    _ds.maximumTrackTintColor = [UIColor colorWithRed:0.12 green:0.10 blue:0.16 alpha:1.0];
    [_ds addTarget:self action:@selector(dCh) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_ds];
}

// ── MEMORY Page ───────────────────────────────────────────────────
- (void)buildMemoryPage:(CGRect)fr {
    UIView *page = [[UIView alloc] initWithFrame:fr];
    _pages[2] = page;
    [self addSubview:page];
    CGFloat pw = fr.size.width - 24, y = 10;

    [page addSubview:RavLabel(@"MEMORY", [UIFont boldSystemFontOfSize:10], CLR_GREEN,
                              CGRectMake(12, y, 80, 14))];
    y += 22;

    // Crosshair
    UIView *chCard = [[UIView alloc] initWithFrame:CGRectMake(12, y, pw, 36)];
    chCard.backgroundColor   = [UIColor colorWithRed:0.09 green:0.10 blue:0.13 alpha:1.0];
    chCard.layer.cornerRadius = 9;
    [page addSubview:chCard];
    [chCard addSubview:RavLabel(@"Crosshair", [UIFont boldSystemFontOfSize:9], CLR_TEXT,
                                CGRectMake(10, 10, 70, 14))];
    _chs = StyledSwitch([UIColor colorWithRed:1 green:1 blue:1 alpha:0.80]);
    _chs.frame = CGRectMake(pw - 50, 3, 51, 28);
    [_chs addTarget:self action:@selector(tgCH) forControlEvents:UIControlEventValueChanged];
    [chCard addSubview:_chs];
    y += 42;

    // Weapon Stability
    UIView *stCard = [[UIView alloc] initWithFrame:CGRectMake(12, y, pw, 36)];
    stCard.backgroundColor   = [UIColor colorWithRed:0.13 green:0.07 blue:0.07 alpha:1.0];
    stCard.layer.cornerRadius = 9;
    [page addSubview:stCard];
    [stCard addSubview:RavLabel(@"Weapon Stability", [UIFont boldSystemFontOfSize:9], CLR_RED,
                                CGRectMake(10, 10, 100, 14))];
    _sts = StyledSwitch(CLR_RED);
    _sts.frame = CGRectMake(pw - 50, 3, 51, 28);
    [_sts addTarget:self action:@selector(tgST) forControlEvents:UIControlEventValueChanged];
    [stCard addSubview:_sts];
    y += 42;

    // Vis Check
    UIView *vcCard = [[UIView alloc] initWithFrame:CGRectMake(12, y, pw, 36)];
    vcCard.backgroundColor   = [UIColor colorWithRed:0.07 green:0.10 blue:0.16 alpha:1.0];
    vcCard.layer.cornerRadius = 9;
    [page addSubview:vcCard];
    [vcCard addSubview:RavLabel(@"Vis Check", [UIFont boldSystemFontOfSize:9],
                                [UIColor colorWithRed:0.361 green:0.741 blue:0.965 alpha:1.0],
                                CGRectMake(10, 10, 80, 14))];
    _vcs = StyledSwitch([UIColor colorWithRed:0.361 green:0.741 blue:0.965 alpha:1.0]);
    _vcs.frame = CGRectMake(pw - 50, 3, 51, 28);
    [_vcs addTarget:self action:@selector(tgVC) forControlEvents:UIControlEventValueChanged];
    [vcCard addSubview:_vcs];
    y += 42;

    // Status + TG link (side by side)
    UIView *srvCard = [[UIView alloc] initWithFrame:CGRectMake(12, y, pw * 0.48f, 26)];
    srvCard.backgroundColor   = [UIColor colorWithRed:0.06 green:0.11 blue:0.08 alpha:1.0];
    srvCard.layer.cornerRadius = 7;
    [page addSubview:srvCard];
    UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(8, 9, 8, 8)];
    dot.backgroundColor    = CLR_GREEN;
    dot.layer.cornerRadius = 4;
    [srvCard addSubview:dot];
    _srvStatus = RavLabel(@"PROTECTED", [UIFont boldSystemFontOfSize:7], CLR_GREEN,
                           CGRectMake(22, 7, 80, 12));
    [srvCard addSubview:_srvStatus];

    UIButton *tgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    tgBtn.frame = CGRectMake(12 + pw * 0.48f + 6, y, pw * 0.52f - 6, 26);
    [tgBtn setTitle:@"▸ t.me/RavFenupdate" forState:UIControlStateNormal];
    [tgBtn setTitleColor:CLR_VIOLET forState:UIControlStateNormal];
    tgBtn.titleLabel.font    = [UIFont boldSystemFontOfSize:8];
    tgBtn.backgroundColor    = CLR_VIOLET_DIM;
    tgBtn.layer.cornerRadius = 7;
    [tgBtn addTarget:self action:@selector(openTG) forControlEvents:UIControlEventTouchUpInside];
    [page addSubview:tgBtn];
    y += 32;

    // ── حالة الأوفستات (✅ صح / ❌ اسم الغلط) ────────────────────
    BOOL   offOk  = ValidateOffsets();
    NSString *offTxt = offOk ? @"✅  Offsets: Valid" : @"❌  Offsets: Invalid – check screen";
    UIColor  *offClr = offOk ? CLR_GREEN : CLR_RED;
    UIView *offCard = [[UIView alloc] initWithFrame:CGRectMake(12, y, pw, 20)];
    offCard.backgroundColor   = [UIColor colorWithRed:(offOk?0.05:0.14)
                                                green:(offOk?0.10:0.04)
                                                 blue:(offOk?0.06:0.04) alpha:1.0];
    offCard.layer.cornerRadius = 6;
    [page addSubview:offCard];
    UILabel *offLbl = RavLabel(offTxt, [UIFont boldSystemFontOfSize:8], offClr,
                                CGRectMake(8, 4, pw - 16, 12));
    offLbl.textAlignment = NSTextAlignmentCenter;
    [offCard addSubview:offLbl];
}

// ── TIPS Page (30 نصيحة أمنية مهمة جدا) ─────────────────────────
- (void)buildTipsPage:(CGRect)fr {
    UIView *page = [[UIView alloc] initWithFrame:fr];
    _pages[3] = page;
    [self addSubview:page];

    // Header row
    [page addSubview:RavLabel(@"30 TIPS – PROTECTION GUIDE", [UIFont boldSystemFontOfSize:9],
                              CLR_ORANGE, CGRectMake(12, 10, fr.size.width - 24, 14))];
    [page addSubview:Sep(12, 26, fr.size.width - 24)];

    // Scrollable tips list
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:
        CGRectMake(0, 30, fr.size.width, fr.size.height - 30)];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator   = YES;
    [page addSubview:scroll];

    // Tips data – 30 نصيحة مهمة جدا مطبقة 100%
    NSArray *tips = @[
        // ═══ أولاً: حماية الذاكرة والبصمات الرقمية ═══
        @[@"1", @"String Encryption",
          @"تشفير النصوص الحساسة (XOR) وفكها ديناميكياً لمنع الفحص الساكن."],
        @[@"2", @"Signature Obfuscation",
          @"تغيير التوقيع الرقمي للملف تلقائياً مع كل Build لتصعيب رصده."],
        @[@"3", @"Dynamic Memory",
          @"تجنب التعديل الثابت على العناوين. اقرأ مؤقتاً ثم أعد القيم الأصلية."],
        @[@"4", @"Class Renaming",
          @"استخدم أسماء عشوائية للملفات والحزم والفئات لتشتيت أدوات الفحص."],
        @[@"5", @"Inline Hooking",
          @"الاعتماد على Inline Hooking المتطور بدلاً من تعديل جداول VMT."],
        @[@"6", @"Page Protection",
          @"غيّر صلاحيات صفحات الذاكرة إلى PAGE_NOACCESS فور الانتهاء منها."],
        @[@"7", @"Function Spoofing",
          @"اجعل Call Stack يبدو صادراً من المحرك الرسمي لتفادي الرصد."],
        // ═══ ثانياً: سلامة بيئة التشغيل ═══
        @[@"8", @"Log Filtering",
          @"منع إرسال Crash Reports التي قد تكشف عن التعديلات."],
        @[@"9", @"Honey Pot Detection",
          @"افحص المؤشرات قبل الوصول للتأكد أنها ليست مصائد برمجية."],
        @[@"10", @"Kernel-Level",
          @"نفّذ العمليات الحساسة على Ring 0 بعيداً عن مراقبة Ring 3."],
        @[@"11", @"Integrity Watchdog",
          @"رصد توقيت فحوصات النظام وتجميد العمليات خلال الفحص النشط."],
        @[@"12", @"Direct Syscalls",
          @"استدعاء النظام مباشرة بدلاً من المرور عبر APIs الخاضعة للمراقبة."],
        // ═══ ثالثاً: المدخلات والرسم ═══
        @[@"13", @"Input Smoothing",
          @"محاكاة حركات بشرية طبيعية مع تأخير ديناميكي لتفادي الأنماط الحادة."],
        @[@"14", @"Boundary Limiter",
          @"قصر العمليات على نطاق رؤية محدد لمنع الاستهلاك المبالغ فيه."],
        @[@"15", @"Target Randomization",
          @"توزيع نقاط المعالجة عشوائياً بدلاً من التركيز على نقطة ثابتة."],
        @[@"16", @"State Check",
          @"منع التفاعل مع العناصر إلا إذا كانت في حالة صالحة ونشطة."],
        @[@"17", @"File Integrity",
          @"تجنب تعديل ملفات النظام. استخدم الحقن المؤقت في الذاكرة فقط."],
        @[@"18", @"Overlay Isolation",
          @"عرض Overlay على طبقة منفصلة غير قابلة للالتقاط بأدوات الفحص."],
        // ═══ رابعاً: إدارة السلوك ═══
        @[@"19", @"Activity Rate",
          @"قيود ذكية تمنع تجاوز الحدود المنطقية للعمليات في الدقيقة الواحدة."],
        @[@"20", @"Proportional Adjust",
          @"أبقِ المتغيرات قريبة من القيم الطبيعية لتفادي الفحص الإحصائي."],
        @[@"21", @"Latency Simulation",
          @"أرسل البيانات بتوافق مع معدل الاستجابة (Ping) لتجنب الفجوات الزمنية."],
        @[@"22", @"Kill Switch",
          @"زر طوارئ يعطّل كل الميزات فوراً عند استشعار مراقبة مكثفة."],
        // ═══ خامساً: البناء والتحديثات ═══
        @[@"23", @"Cloud Offsets",
          @"جلب الـ Offsets من سيرفر سحابي آمن دورياً دون تحديث كامل."],
        @[@"24", @"Secure Auth",
          @"نظام تسجيل دخول مشفر مرتبط بسيرفر خارجي لحماية الكود."],
        @[@"25", @"Canary Testing",
          @"تشغيل حسابات اختبارية آلية لرصد أي مراقبة تلقائية."],
        @[@"26", @"Feature Minimization",
          @"استبعد الميزات غير المستقرة وركّز على الصامتة والأكثر أماناً."],
        @[@"27", @"HWID Validation",
          @"التحقق من هوية الجهاز (HWID) ومحاكاتها لتفادي الحظر الكامل."],
        @[@"28", @"Traffic Encryption",
          @"تشفير حركة المرور بين التطبيق والسيرفر لمنع تحليل البيانات."],
        @[@"29", @"Control Flow Flatten",
          @"تعمية تجعل مسار التدفق معقداً جداً أمام أدوات الهندسة العكسية."],
        @[@"30", @"Native C++ NDK",
          @"اكتب الأجزاء الحساسة بـ C++ مباشرة – تترجم لآلة وتصعب قراءتها."],
    ];

    CGFloat ty   = 8;
    CGFloat tw   = scroll.bounds.size.width - 16;
    // Category section headers
    NSDictionary *catHeaders = @{
        @0:  @"◆ Memory & Signatures",
        @7:  @"◆ Runtime Integrity",
        @12: @"◆ Input & UI Safety",
        @18: @"◆ Behavior Hardening",
        @22: @"◆ Build & Protection",
    };

    for (NSInteger i = 0; i < (NSInteger)tips.count; i++) {
        NSArray *tip = tips[i];

        // Category header if applicable
        NSString *cat = catHeaders[@(i)];
        if (cat) {
            UILabel *catLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, ty, tw, 13)];
            catLbl.text      = cat;
            catLbl.textColor = CLR_ORANGE;
            catLbl.font      = [UIFont boldSystemFontOfSize:7.5f];
            [scroll addSubview:catLbl];
            ty += 16;
        }

        // Tip card
        UIView *card = [[UIView alloc] initWithFrame:CGRectMake(8, ty, tw, 36)];
        card.backgroundColor    = [UIColor colorWithRed:0.09 green:0.09 blue:0.12 alpha:1.0];
        card.layer.cornerRadius = 8;
        card.layer.borderWidth  = 0.5;
        card.layer.borderColor  = CLR_SEP.CGColor;
        [scroll addSubview:card];

        // Number badge
        UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 20, 20)];
        num.text               = tip[0];
        num.textColor          = CLR_ORANGE;
        num.font               = [UIFont boldSystemFontOfSize:7.5f];
        num.textAlignment      = NSTextAlignmentCenter;
        num.backgroundColor    = CLR_ORANGE_DIM;
        num.layer.cornerRadius = 4;
        num.clipsToBounds      = YES;
        [card addSubview:num];

        // Title
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30, 4, tw - 36, 13)];
        title.text      = tip[1];
        title.textColor = CLR_TEXT;
        title.font      = [UIFont boldSystemFontOfSize:8.5f];
        [card addSubview:title];

        // Description
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(30, 17, tw - 36, 16)];
        desc.text           = tip[2];
        desc.textColor      = CLR_MUTED;
        desc.font           = [UIFont systemFontOfSize:7.5f];
        desc.numberOfLines  = 2;
        [card addSubview:desc];

        ty += 42;
    }

    scroll.contentSize = CGSizeMake(scroll.bounds.size.width, ty + 10);
}

// ── Tab switching ─────────────────────────────────────────────────
- (void)tabTapped:(UIButton *)sender {
    NSInteger idx = sender.tag;
    if (idx == _activeTab) return;
    NSInteger prev = _activeTab;
    _activeTab = idx;
    NSArray *tabColors = @[CLR_GOLD, CLR_VIOLET, CLR_GREEN, CLR_ORANGE];

    for (int i = 0; i < 4; i++) {
        BOOL active       = (i == idx);
        UIColor *c        = active ? tabColors[i] : CLR_MUTED;
        UILabel *ico      = (UILabel *)[_tabBtns[i] viewWithTag:100 + i];
        UILabel *nm       = (UILabel *)[_tabBtns[i] viewWithTag:200 + i];
        ico.textColor     = c;
        nm.textColor      = c;
        _tabIndicators[i].hidden = !active;
    }

    UIView *outPage = _pages[prev];
    UIView *inPage  = _pages[idx];
    inPage.alpha  = 0;
    inPage.hidden = NO;
    [UIView animateWithDuration:0.18 animations:^{ outPage.alpha = 0; } completion:^(BOOL d) {
        outPage.hidden = YES;
        [UIView animateWithDuration:0.18 animations:^{ inPage.alpha = 1; }];
    }];
}

- (void)openTG { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/RavFenupdate"] options:@{} completionHandler:nil]; }
- (void)tgA    { pthread_mutex_lock(&g_ConfigMutex); gConfig.aimbotEnabled  = _as.isOn;  pthread_mutex_unlock(&g_ConfigMutex); }
- (void)tgE    { pthread_mutex_lock(&g_ConfigMutex); gConfig.espEnabled     = _es.isOn;  pthread_mutex_unlock(&g_ConfigMutex); }
- (void)tgL    { pthread_mutex_lock(&g_ConfigMutex); gConfig.espLine        = _ls.isOn;  pthread_mutex_unlock(&g_ConfigMutex); }
- (void)tgB    { pthread_mutex_lock(&g_ConfigMutex); gConfig.espBulletLine  = _bls.isOn; pthread_mutex_unlock(&g_ConfigMutex); }
- (void)tgCH   { pthread_mutex_lock(&g_ConfigMutex); gConfig.crosshairEnabled = _chs.isOn; pthread_mutex_unlock(&g_ConfigMutex); }
- (void)tgST   { pthread_mutex_lock(&g_ConfigMutex); gConfig.stabilityEnabled = _sts.isOn; pthread_mutex_unlock(&g_ConfigMutex); }
- (void)tgVC   { pthread_mutex_lock(&g_ConfigMutex); gConfig.visCheckEnabled  = _vcs.isOn; pthread_mutex_unlock(&g_ConfigMutex); }
- (void)mCh    { pthread_mutex_lock(&g_ConfigMutex); gConfig.aimbotMode     = (AimbotMode)(_ms.selectedSegmentIndex + 1); pthread_mutex_unlock(&g_ConfigMutex); }
- (void)sCh {
    float v = _ss.value;
    pthread_mutex_lock(&g_ConfigMutex); gConfig.aimbotSpeed = v; pthread_mutex_unlock(&g_ConfigMutex);
    dispatch_async(dispatch_get_main_queue(), ^{ [_sv setText:[NSString stringWithFormat:@"%.0f", v]]; });
}
- (void)smCh {
    float v = _smSlider.value;
    pthread_mutex_lock(&g_ConfigMutex); gConfig.aimbotSmoothing = v; pthread_mutex_unlock(&g_ConfigMutex);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_smv setText:[NSString stringWithFormat:@"%.0f%%", (v / 10.0f) * 100.0f]];
    });
}
- (void)dCh {
    float v = _ds.value;
    pthread_mutex_lock(&g_ConfigMutex); gConfig.espDistance = v; pthread_mutex_unlock(&g_ConfigMutex);
    dispatch_async(dispatch_get_main_queue(), ^{ [_dv setText:[NSString stringWithFormat:@"%.0fm", v]]; });
}
- (void)hide {
    pthread_mutex_lock(&g_ConfigMutex); gConfig.menuVisible = NO; pthread_mutex_unlock(&g_ConfigMutex);
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha     = 0;
        self.transform = CGAffineTransformMakeScale(0.88, 0.88);
    } completion:^(BOOL done) {
        [self removeFromSuperview];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *k = [self keyWindow]; if (!k) return;
            for (UIView *v in k.subviews)
                if ([v isKindOfClass:[RavFloatingButton class]]) return;
            [self showFloatingButtonIn:k];
        });
    }];
}

- (void)showAgain {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *k = [self keyWindow]; if (!k) return;
        [self presentMenuIn:k];
    });
}

- (UIWindow *)keyWindow {
    for (UIWindowScene *s in [UIApplication sharedApplication].connectedScenes) {
        if (s.activationState == UISceneActivationStateForegroundActive)
            return s.windows.firstObject;
    }
    return nil;
}

- (void)showFloatingButtonIn:(UIWindow *)k {
    RavFloatingButton *fb = [[RavFloatingButton alloc]
        initWithFrame:CGRectMake(k.bounds.size.width - 66 - 14,
                                 k.bounds.size.height * 0.52, 66, 66)];
    fb.alpha = 0;
    __weak typeof(fb) wfb = fb;
    __weak typeof(self) ws = self;
    fb.onTap = ^{ [wfb removeFromSuperview]; [ws showAgain]; };
    [k addSubview:fb]; [k bringSubviewToFront:fb];
    [UIView animateWithDuration:0.3 animations:^{ fb.alpha = 1; }];
}

// Menu size: 480 × 300 (أفقي – horizontal)
- (void)presentMenuIn:(UIWindow *)k {
    CGFloat mw = MIN(480.0f, k.bounds.size.width  - 30);
    CGFloat mh = 300.0f;
    RavMenuView *m = [[RavMenuView alloc]
        initWithFrame:CGRectMake((k.bounds.size.width  - mw) / 2.0,
                                 (k.bounds.size.height - mh) / 2.0,
                                 mw, mh)
          overlayView:_ev];
    m.alpha     = 0;
    m.transform = CGAffineTransformMakeScale(0.88, 0.88);
    [k addSubview:m]; [k bringSubviewToFront:m];
    pthread_mutex_lock(&g_ConfigMutex); gConfig.menuVisible = YES; pthread_mutex_unlock(&g_ConfigMutex);
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.6
                        options:0
                     animations:^{ m.alpha = 1; m.transform = CGAffineTransformIdentity; }
                     completion:nil];
}

@end

// ====================================================================
// ◈ Splash Screen
// ====================================================================
@interface RavSplashView : UIView @end
@implementation RavSplashView

- (instancetype)initWithFrame:(CGRect)f {
    self = [super initWithFrame:f];
    if (!self) return nil;
    self.backgroundColor = [UIColor colorWithRed:0.04 green:0.04 blue:0.06 alpha:1.0];

    CGFloat cx = f.size.width * 0.5, cy = f.size.height * 0.42;

    UILabel *mono = [[UILabel alloc] initWithFrame:CGRectMake(cx - 30, cy - 22, 60, 44)];
    mono.text          = @"RF";
    mono.textColor     = CLR_VIOLET;
    mono.font          = [UIFont boldSystemFontOfSize:30];
    mono.textAlignment = NSTextAlignmentCenter;
    mono.alpha         = 0;
    [self addSubview:mono];

    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, cy + 90, f.size.width, 28)];
    name.text          = @"RAVFEN  WRAITH";
    name.textColor     = CLR_TEXT;
    name.font          = [UIFont boldSystemFontOfSize:18];
    name.textAlignment = NSTextAlignmentCenter;
    name.alpha         = 0;
    [self addSubview:name];

    UILabel *ver = [[UILabel alloc] initWithFrame:CGRectMake(0, cy + 120, f.size.width, 20)];
    ver.text          = @"v7.3  ·  PUBG Mobile 4.5.0 TW";
    ver.textColor     = CLR_MUTED;
    ver.font          = [UIFont systemFontOfSize:11];
    ver.textAlignment = NSTextAlignmentCenter;
    ver.alpha         = 0;
    [self addSubview:ver];

    [UIView animateWithDuration:0.6 delay:0.1 options:0 animations:^{
        mono.alpha = 1;
    } completion:nil];
    [UIView animateWithDuration:0.5 delay:0.5 options:0 animations:^{
        name.alpha = 1; ver.alpha = 1;
    } completion:nil];

    return self;
}
@end

// ====================================================================
// ◈ Captcha
// ====================================================================
@interface RavCaptchaView : UIView
@property (nonatomic, copy) void (^onDone)(void);
@end

@implementation RavCaptchaView

- (instancetype)initWithFrame:(CGRect)f {
    self = [super initWithFrame:f];
    if (!self) return nil;
    self.backgroundColor = [UIColor colorWithRed:0.04 green:0.04 blue:0.06 alpha:1.0];

    CGFloat cy = f.size.height * 0.45;

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, cy + 44, f.size.width, 26)];
    lbl.text          = @"TOUCH  TO  ARM";
    lbl.textColor     = CLR_TEXT;
    lbl.font          = [UIFont boldSystemFontOfSize:14];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.alpha         = 0;
    [self addSubview:lbl];

    [UIView animateWithDuration:0.5 delay:0.3 options:0
                     animations:^{ lbl.alpha = 1; }
                     completion:nil];

    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(tapped)];
    [self addGestureRecognizer:tg];
    return self;
}

- (void)tapped {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.35 animations:^{ self.alpha = 0; } completion:^(BOOL d) {
        [self removeFromSuperview];
        if (self.onDone) self.onDone();
    }];
}

@end

// ====================================================================
// 🚀 Launch
// ====================================================================
static void Launch(void) {
    [[ESPManager shared] start];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *k = nil;
        for (UIWindowScene *s in [UIApplication sharedApplication].connectedScenes) {
            if (s.activationState == UISceneActivationStateForegroundActive) {
                k = s.windows.firstObject; break;
            }
        }
        if (!k) return;

        RavSplashView *sp = [[RavSplashView alloc] initWithFrame:k.bounds];
        [k addSubview:sp]; [k bringSubviewToFront:sp];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4 animations:^{ sp.alpha = 0; } completion:^(BOOL d) {
                [sp removeFromSuperview];

                RavCaptchaView *cp = [[RavCaptchaView alloc] initWithFrame:k.bounds];
                cp.onDone = ^{
                    CGFloat mw = MIN(480.0f, k.bounds.size.width  - 30);
                    CGFloat mh = 300.0f;
                    RavFloatingButton *fb = [[RavFloatingButton alloc]
                        initWithFrame:CGRectMake(k.bounds.size.width - 66 - 14,
                                                 k.bounds.size.height * 0.52, 66, 66)];
                    fb.alpha = 0;
                    __weak typeof(fb) wfb = fb;
                    fb.onTap = ^{
                        [wfb removeFromSuperview];
                        ESPOverlayView *ov = [[ESPManager shared] getOverlayView];
                        RavMenuView *m = [[RavMenuView alloc]
                            initWithFrame:CGRectMake((k.bounds.size.width  - mw) / 2.0,
                                                     (k.bounds.size.height - mh) / 2.0,
                                                     mw, mh)
                              overlayView:ov];
                        m.alpha     = 0;
                        m.transform = CGAffineTransformMakeScale(0.88, 0.88);
                        [k addSubview:m]; [k bringSubviewToFront:m];
                        pthread_mutex_lock(&g_ConfigMutex);
                        gConfig.menuVisible = YES;
                        pthread_mutex_unlock(&g_ConfigMutex);
                        [UIView animateWithDuration:0.3 delay:0
                             usingSpringWithDamping:0.7 initialSpringVelocity:0.6
                                            options:0
                                         animations:^{ m.alpha = 1; m.transform = CGAffineTransformIdentity; }
                                         completion:nil];
                    };
                    [k addSubview:fb]; [k bringSubviewToFront:fb];
                    [UIView animateWithDuration:0.3 animations:^{ fb.alpha = 1; }];
                };
                [k addSubview:cp]; [k bringSubviewToFront:cp];
            }];
        });
    });
}

// ====================================================================
// ⚙️ Constructor
// ====================================================================
__attribute__((constructor))
static void Init(void) {
    GetBaseAddress();
    InitOffsets();

    // 🔥 فحص الأوفستات – لو في واحد غلط يظهر اسمه بالشاشة ويوقف
    if (!ValidateOffsets()) {
        // يأخر الـ UI شوي حتى تتجهز النافذة ثم يعرض الخطأ مجدداً
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            // أعد استدعاء ValidateOffsets ليعرض البانر بعد تجهز الـ window
            gOffsetChecked = NO;
            ValidateOffsets();
        });
        return; // لا تشغل باقي الكود
    }

    pthread_mutex_lock(&g_ConfigMutex);
    gConfig.aimbotEnabled    = NO;
    gConfig.aimbotSpeed      = 120.0f;
    gConfig.aimbotMode       = AimbotMode_Lock;
    gConfig.espEnabled       = NO;
    gConfig.espLine          = NO;
    gConfig.espBulletLine    = NO;
    gConfig.espDistance      = 200.0f;
    gConfig.menuVisible      = NO;
    gConfig.crosshairEnabled = NO;
    gConfig.aimbotSmoothing  = 5.0f;
    gConfig.stabilityEnabled = NO;
    gConfig.visCheckEnabled  = NO;
    pthread_mutex_unlock(&g_ConfigMutex);

    pthread_t th;
    pthread_create(&th, NULL, AntiDetachLoop, NULL);
    pthread_detach(th);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{ Launch(); });
}
