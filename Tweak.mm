// ====================================================================
// RavFen Shadow v6.2 - PUBG Mobile 4.4.0 iOS Tweak
// تم إصلاح: X معلق، إيموجيات، خط أسود، حجم القائمة
// ====================================================================

#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <pthread.h>
#import <dlfcn.h>
#import <math.h>

// ====================================================================
// 📍 Base Address
// ====================================================================
static uint64_t gBase = 0;
static inline uint64_t GetBaseAddress(void) {
    if (gBase == 0) gBase = (uint64_t)_dyld_get_image_header(0);
    return gBase;
}

// ====================================================================
// 📡 قراءة/كتابة الذاكرة
// ====================================================================
static BOOL ReadMem(uint64_t addr, void *buf, size_t sz) {
    if (!addr || !buf || sz == 0) return NO;
    if (addr < 0x100000000ULL || addr > 0x7FFFFFFFFFFFULL) return NO;
    memcpy(buf, (const void *)addr, sz);
    return YES;
}

static BOOL WriteMem(uint64_t addr, const void *buf, size_t sz) {
    if (!addr || !buf || sz == 0) return NO;
    if (addr < 0x100000000ULL || addr > 0x7FFFFFFFFFFFULL) return NO;
    memcpy((void *)addr, buf, sz);
    return YES;
}

// ====================================================================
// 🧵 Mutex
// ====================================================================
static pthread_mutex_t g_ConfigMutex = PTHREAD_MUTEX_INITIALIZER;

typedef struct {
    volatile BOOL aimbotEnabled;
    volatile float aimbotSpeed;
    volatile BOOL espEnabled;
    volatile BOOL espLine;
    volatile BOOL espBulletLine;
    volatile float espDistance;
    volatile BOOL menuVisible;
} RavConfig;

static RavConfig gConfig = {0};

// ====================================================================
// 🔐 الأوفستات
// ====================================================================
static const uint8_t kEncryptedOffsets[] = {
    0x8D, 0x06, 0x0E, 0xD7, 0x8D, 0x06, 0x0E, 0xD7,
    0xAD, 0xC3, 0xC3, 0xD3, 0xAD, 0xC3, 0xC3, 0xD3,
    0x87, 0x87, 0x87, 0x87, 0x00, 0x00, 0x00, 0x00,
    0x7D, 0x7D, 0x7D, 0x7D, 0x00, 0x00, 0x00, 0x00,
    0x45, 0x45, 0x45, 0x45, 0x00, 0x00, 0x00, 0x00,
    0x95, 0x95, 0x95, 0x95, 0x00, 0x00, 0x00, 0x00,
    0x9D, 0x9D, 0x9D, 0x9D, 0x00, 0x00, 0x00, 0x00,
    0x95, 0x95, 0x95, 0x95, 0x00, 0x00, 0x00, 0x00,
    0x05, 0x05, 0x05, 0x05, 0x00, 0x00, 0x00, 0x00,
    0x6D, 0x6D, 0x6D, 0x6D, 0x00, 0x00, 0x00, 0x00,
    0xB5, 0xB5, 0xB5, 0xB5, 0x00, 0x00, 0x00, 0x00,
    0xD5, 0xD5, 0xD5, 0xD5, 0x00, 0x00, 0x00, 0x00,
    0xB5, 0xB5, 0xB5, 0xB5, 0x00, 0x00, 0x00, 0x00,
    0x15, 0x15, 0x15, 0x15, 0x00, 0x00, 0x00, 0x00,
    0x0D, 0x0D, 0x0D, 0x0D, 0x00, 0x00, 0x00, 0x00,
    0x15, 0x15, 0x15, 0x15, 0x00, 0x00, 0x00, 0x00,
    0x5D, 0x5D, 0x5D, 0x5D, 0x00, 0x00, 0x00, 0x00,
    0xD5, 0xD5, 0xD5, 0xD5, 0x00, 0x00, 0x00, 0x00,
    0x75, 0x75, 0x75, 0x75, 0x00, 0x00, 0x00, 0x00,
    0x95, 0x95, 0x95, 0x95, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x25, 0x2A, 0x2D, 0x2A, 0x5A, 0x5A, 0x5A, 0x5A,
    0xD5, 0xD5, 0xD5, 0xD5, 0x00, 0x00, 0x00, 0x00,
};

enum {
    OFF_GW, OFF_GN, OFF_PL, OFF_AA, OFF_AC, OFF_GI, OFF_LP,
    OFF_PC, OFF_AP, OFF_RC, OFF_RL, OFF_CM, OFF_CC, OFF_CP,
    OFF_CR, OFF_MS, OFF_BA, OFF_HP, OFF_TM, OFF_AD, OFF_CTW,
    OFF_VMC, OFF_VM,
    OFF_COUNT
};

static uint64_t gOffsets[OFF_COUNT] = {0};

static void InitOffsets(void) {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        memcpy(gOffsets, kEncryptedOffsets, sizeof(gOffsets));
        for (int i = 0; i < OFF_COUNT; i++) {
            gOffsets[i] ^= 0xA5A5A5A5A5A5A5A5ULL;
        }
    });
}

#define OFF(x) gOffsets[x]

// ====================================================================
// 📍 دوال القراءة
// ====================================================================
static uint64_t ReadPtr(uint64_t addr) {
    uint64_t val = 0;
    if (!addr) return 0;
    if (!ReadMem(addr, &val, 8)) return 0;
    if (val < 0x100000 || val > 0x7FFFFFFFFFFFULL) return 0;
    return val;
}

static float ReadFloat(uint64_t addr) {
    float val = 0;
    if (!addr) return 0;
    ReadMem(addr, &val, 4);
    return val;
}

static int32_t ReadInt(uint64_t addr) {
    int32_t val = 0;
    if (!addr) return 0;
    ReadMem(addr, &val, 4);
    return val;
}

static BOOL WriteFloat(uint64_t addr, float val) {
    if (!addr) return NO;
    return WriteMem(addr, &val, 4);
}

// ====================================================================
// 👤 IsPlayer
// ====================================================================
static BOOL IsPlayer(uint64_t actor) {
    if (!actor) return NO;
    uint64_t gnBase = ReadPtr(OFF(OFF_GN) + GetBaseAddress());
    if (!gnBase) return NO;
    uint32_t actorId = ReadInt(actor + OFF(OFF_AD));
    if (actorId == 0 || actorId > 10000000) return NO;
    uint32_t chunkIdx = actorId / 0x3FE0;
    uint32_t nameIdx  = actorId % 0x3FE0;
    uint64_t chunk = ReadPtr(gnBase + chunkIdx * 8);
    if (!chunk) return NO;
    uint64_t entry = chunk + nameIdx * 48;
    if (!entry) return NO;
    char name[24] = {0};
    if (!ReadMem(entry + 8, name, 20)) return NO;
    name[20] = '\0';
    if (strstr(name, "PlayerPawn") || strstr(name, "BP_Player") || 
        strstr(name, "PlayerCharacter") || strstr(name, "PlayerMale") ||
        strstr(name, "PlayerFemale")) {
        if (!strstr(name, "Pickup") && !strstr(name, "Dropped") && 
            !strstr(name, "Item") && !strstr(name, "Weapon")) {
            return YES;
        }
    }
    return NO;
}

static float g_LocalX = 0, g_LocalY = 0, g_LocalZ = 0;
static float g_ViewMatrix[16] = {0};

// ====================================================================
// PlayerData
// ====================================================================
@interface PlayerData : NSObject
@property (nonatomic, assign) uint64_t address;
@property (nonatomic, assign) float x, y, z;
@property (nonatomic, assign) float health;
@property (nonatomic, assign) float distance;
@property (nonatomic, assign) BOOL isEnemy;
@property (nonatomic, assign) BOOL isAlive;
@property (nonatomic, assign) uint64_t meshAddr;
@property (nonatomic, assign) uint64_t boneAddr;
@property (nonatomic, assign) int32_t teamId;
@end

@implementation PlayerData
@end

// ====================================================================
// 🌐 World to Screen
// ====================================================================
static BOOL WorldToScreen(float wx, float wy, float wz, float *sx, float *sy) {
    float clipX = g_ViewMatrix[0]*wx + g_ViewMatrix[4]*wy + g_ViewMatrix[8]*wz + g_ViewMatrix[12];
    float clipY = g_ViewMatrix[1]*wx + g_ViewMatrix[5]*wy + g_ViewMatrix[9]*wz + g_ViewMatrix[13];
    float clipW = g_ViewMatrix[3]*wx + g_ViewMatrix[7]*wy + g_ViewMatrix[11]*wz + g_ViewMatrix[15];
    
    if (clipW < 0.1f) return NO;
    
    float ndcX = clipX / clipW;
    float ndcY = clipY / clipW;
    
    UIWindow *key = nil;
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            key = scene.windows.firstObject; break;
        }
    }
    if (!key) return NO;
    
    CGFloat screenW = key.bounds.size.width;
    CGFloat screenH = key.bounds.size.height;
    
    *sx = (screenW / 2.0f) + (ndcX * screenW / 2.0f);
    *sy = (screenH / 2.0f) - (ndcY * screenH / 2.0f);
    
    return YES;
}

// ====================================================================
// 👥 GetPlayers
// ====================================================================
static NSArray<PlayerData *> *GetPlayers(void) {
    NSMutableArray *result = [NSMutableArray array];
    
    uint64_t base = GetBaseAddress();
    uint64_t gwAddr = base + OFF(OFF_GW);
    uint64_t gw = 0;
    ReadMem(gwAddr, &gw, 8);
    if (!gw) return result;
    
    uint64_t level = ReadPtr(gw + OFF(OFF_PL));
    if (!level) return result;
    
    uint64_t actors = ReadPtr(level + OFF(OFF_AA));
    int32_t count   = ReadInt(level + OFF(OFF_AC));
    if (!actors || count <= 0 || count > 1000) return result;
    
    uint64_t gi     = ReadPtr(gw + OFF(OFF_GI));
    uint64_t lpArr  = ReadPtr(gi + OFF(OFF_LP));
    uint64_t lp     = ReadPtr(lpArr);
    uint64_t pc     = ReadPtr(lp + OFF(OFF_PC));
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
    
    uint64_t vmAddr = ReadPtr(base + OFF(OFF_VMC));
    if (vmAddr) {
        ReadMem(vmAddr + OFF(OFF_VM), g_ViewMatrix, 64);
    }
    
    float maxDist = 0.0f;
    pthread_mutex_lock(&g_ConfigMutex);
    maxDist = gConfig.espDistance;
    pthread_mutex_unlock(&g_ConfigMutex);
    
    for (int i = 0; i < count; i++) {
        @autoreleasepool {
            uint64_t actor = ReadPtr(actors + i * 8);
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
            
            float hp = ReadFloat(actor + OFF(OFF_HP));
            int32_t team = ReadInt(actor + OFF(OFF_TM));
            uint64_t mesh = ReadPtr(actor + OFF(OFF_MS));
            
            PlayerData *p = [[PlayerData alloc] init];
            p.address  = actor;
            p.x = ax; p.y = ay; p.z = az;
            p.health   = hp;
            p.distance = dist;
            p.isAlive  = (hp > 0.1f);
            p.teamId   = team;
            p.isEnemy  = (team != localTeam) || (team == 0);
            p.meshAddr = mesh;
            if (mesh) p.boneAddr = ReadPtr(mesh + OFF(OFF_BA));
            
            [result addObject:p];
        }
    }
    return result;
}

// ====================================================================
// 🎯 Aimbot
// ====================================================================
static void DoAimbot(void) {
    BOOL enabled = NO;
    float speed  = 5.0f;
    
    pthread_mutex_lock(&g_ConfigMutex);
    enabled = gConfig.aimbotEnabled;
    speed   = gConfig.aimbotSpeed;
    pthread_mutex_unlock(&g_ConfigMutex);
    
    if (!enabled) return;
    
    NSArray *players = GetPlayers();
    PlayerData *best = nil;
    float closest = FLT_MAX;
    
    for (PlayerData *p in players) {
        if (!p.isAlive || p.distance > 500.0f) continue;
        if (p.distance < closest) { closest = p.distance; best = p; }
    }
    if (!best) return;
    
    uint64_t base = GetBaseAddress();
    uint64_t gwAddr = base + OFF(OFF_GW);
    uint64_t gw = 0;
    ReadMem(gwAddr, &gw, 8);
    
    uint64_t gi    = ReadPtr(gw + OFF(OFF_GI));
    uint64_t lpArr = ReadPtr(gi + OFF(OFF_LP));
    uint64_t lp    = ReadPtr(lpArr);
    uint64_t pc    = ReadPtr(lp + OFF(OFF_PC));
    
    float camX = g_LocalX, camY = g_LocalY, camZ = g_LocalZ;
    float targetH = 1.75f;
    float tz = best.z + targetH;
    
    float dx = best.x - camX, dy = best.y - camY, dz = tz - camZ;
    float yaw   = atan2f(dy, dx) * (180.0f / M_PI);
    float pitch = -atan2f(dz, sqrtf(dx*dx + dy*dy)) * (180.0f / M_PI);
    if (yaw < 0) yaw += 360.0f;
    if (pitch > 89.0f) pitch = 89.0f;
    if (pitch < -89.0f) pitch = -89.0f;
    
    uint64_t crAddr = pc + OFF(OFF_CR);
    float curPitch = ReadFloat(crAddr);
    float curYaw   = ReadFloat(crAddr + 4);
    
    float factor = speed / 150.0f;
    if (factor > 1.0f) factor = 1.0f;
    if (factor < 0.01f) factor = 0.01f;
    
    float dyaw = yaw - curYaw, dpitch = pitch - curPitch;
    if (dyaw > 180.0f) dyaw -= 360.0f;
    if (dyaw < -180.0f) dyaw += 360.0f;
    
    WriteFloat(crAddr, curPitch + dpitch * factor);
    WriteFloat(crAddr + 4, curYaw + dyaw * factor);
}

// ====================================================================
// 🖥️ Anti-Detach
// ====================================================================
static void *AntiDetachLoop(void *arg) {
    char *ourName = NULL;
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        const char *name = _dyld_get_image_name(i);
        if (name) { ourName = strdup(name); break; }
    }
    if (!ourName) return NULL;
    
    while (YES) {
        uint32_t cnt = _dyld_image_count();
        BOOL found = NO;
        for (uint32_t i = 0; i < cnt; i++) {
            const char *name = _dyld_get_image_name(i);
            if (name && strcmp(name, ourName) == 0) { found = YES; break; }
        }
        usleep(found ? 5000000 : 1000000);
    }
    free(ourName);
    return NULL;
}

// ====================================================================
// 🎨 ESP Overlay View
// ====================================================================
@interface ESPOverlayView : UIView
@property (nonatomic, strong) CAShapeLayer *boxLayer;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) CAShapeLayer *bulletLineLayer;
@property (nonatomic, strong) CATextLayer *playerCountLayer;
@end

@implementation ESPOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        _boxLayer = [CAShapeLayer layer];
        _boxLayer.strokeColor = [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.9] CGColor];
        _boxLayer.fillColor = [[UIColor clearColor] CGColor];
        _boxLayer.lineWidth = 1.5;
        [self.layer addSublayer:_boxLayer];
        
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.strokeColor = [[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.7] CGColor];
        _lineLayer.lineWidth = 1.0;
        _lineLayer.lineDashPattern = @[@3, @3];
        [self.layer addSublayer:_lineLayer];
        
        _bulletLineLayer = [CAShapeLayer layer];
        _bulletLineLayer.strokeColor = [[UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:0.9] CGColor];
        _bulletLineLayer.lineWidth = 2.0;
        [self.layer addSublayer:_bulletLineLayer];
        
        _playerCountLayer = [CATextLayer layer];
        _playerCountLayer.string = @"";
        _playerCountLayer.fontSize = 16;
        _playerCountLayer.foregroundColor = [[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0] CGColor];
        _playerCountLayer.alignmentMode = kCAAlignmentCenter;
        _playerCountLayer.frame = CGRectMake(0, 50, frame.size.width, 30);
        _playerCountLayer.shadowOpacity = 0.5;
        _playerCountLayer.shadowRadius = 2;
        // ✅ لا خلفية سوداء
        _playerCountLayer.backgroundColor = nil;
        [self.layer addSublayer:_playerCountLayer];
    }
    return self;
}

@end

// ====================================================================
// 🖥️ Splash
// ====================================================================
@interface RavSplashView : UIView @end
@implementation RavSplashView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        UILabel *title = [[UILabel alloc] init];
        title.text = @"RavFen";
        title.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0];
        title.font = [UIFont boldSystemFontOfSize:52];
        title.textAlignment = NSTextAlignmentCenter;
        [title sizeToFit];
        title.center = CGPointMake(frame.size.width/2, frame.size.height * 0.40);
        title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y,
                                  frame.size.width - 40, title.frame.size.height);
        title.shadowColor = [UIColor purpleColor];
        title.shadowOffset = CGSizeMake(2, 2);
        [self addSubview:title];
        
        UILabel *sub = [[UILabel alloc] init];
        sub.text = @"Shadow Edition";
        sub.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:1.0 alpha:0.8];
        sub.font = [UIFont systemFontOfSize:16];
        sub.textAlignment = NSTextAlignmentCenter;
        [sub sizeToFit];
        sub.frame = CGRectMake(30, frame.size.height * 0.50, frame.size.width - 60, sub.frame.size.height);
        [self addSubview:sub];
        
        title.alpha = 0; sub.alpha = 0;
        [UIView animateWithDuration:0.6 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{ title.alpha = 1; } completion:nil];
        [UIView animateWithDuration:0.5 delay:0.5 options:0 animations:^{ sub.alpha = 1; } completion:nil];
    }
    return self;
}
@end

// ====================================================================
// Captcha
// ====================================================================
@interface RavCaptchaView : UIView
@property (nonatomic, copy) void (^onDone)(void);
@end
@implementation RavCaptchaView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        UILabel *tap = [[UILabel alloc] init];
        tap.text = @"Tap to Activate";
        tap.textColor = [UIColor whiteColor];
        tap.font = [UIFont boldSystemFontOfSize:26];
        tap.textAlignment = NSTextAlignmentCenter;
        [tap sizeToFit];
        tap.center = CGPointMake(frame.size.width/2, frame.size.height * 0.42);
        tap.frame = CGRectMake(tap.frame.origin.x, tap.frame.origin.y, frame.size.width, tap.frame.size.height);
        [self addSubview:tap];
        
        UILabel *desc = [[UILabel alloc] init];
        desc.text = @"Press anywhere to unlock RavFen";
        desc.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.6 alpha:0.7];
        desc.font = [UIFont systemFontOfSize:13];
        desc.textAlignment = NSTextAlignmentCenter;
        desc.numberOfLines = 0;
        [desc sizeToFit];
        desc.frame = CGRectMake(30, frame.size.height * 0.48, frame.size.width - 60, desc.frame.size.height);
        [self addSubview:desc];
        
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{ tap.alpha = 0.3; } completion:nil];
        
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:t];
    }
    return self;
}
- (void)handleTap {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.onDone) self.onDone();
    }];
}
@end

// ====================================================================
// 🔘 Floating Button
// ====================================================================
@interface RavFloatingButton : UIView {
    UILabel *_label;
    UILabel *_ravfenText;
    UIPanGestureRecognizer *_pan;
    CGFloat _moveAngle;
}
@property (nonatomic, copy) void (^onTap)(void);
@end

@implementation RavFloatingButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _moveAngle = 0;
        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.0 blue:1.0 alpha:0.35];
        self.layer.cornerRadius = frame.size.width / 2;
        self.layer.borderWidth = 1.5;
        self.layer.borderColor = [UIColor colorWithRed:0.7 green:0.3 blue:1.0 alpha:0.6].CGColor;
        self.layer.shadowColor = [UIColor purpleColor].CGColor;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 6;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        
        // نقطة الدم
        UIImageView *drop = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, frame.size.width - 10, frame.size.height - 10)];
        drop.layer.cornerRadius = (frame.size.width - 10) / 2;
        drop.backgroundColor = [UIColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:0.5];
        drop.clipsToBounds = YES;
        [self addSubview:drop];
        
        _label = [[UILabel alloc] init];
        _label.text = @"R";
        _label.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.95];
        _label.font = [UIFont boldSystemFontOfSize:20];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.frame = self.bounds;
        _label.shadowColor = [UIColor blackColor];
        _label.shadowOffset = CGSizeMake(1, 1);
        [self addSubview:_label];
        
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:_pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];
        
        // RavFen text يتحرك
        _ravfenText = [[UILabel alloc] init];
        _ravfenText.text = @"RavFen";
        _ravfenText.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.35];
        _ravfenText.font = [UIFont boldSystemFontOfSize:10];
        _ravfenText.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_ravfenText];
        
        [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer *t) {
            _moveAngle += 0.08;
            CGFloat radius = 28;
            CGFloat cx = self.bounds.size.width / 2;
            CGFloat cy = self.bounds.size.height / 2;
            _ravfenText.frame = CGRectMake(cx + cos(_moveAngle)*radius - 20,
                                            cy + sin(_moveAngle)*radius - 8,
                                            40, 16);
        }];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    UIView *v = self.superview;
    if (!v) return;
    CGPoint t = [gesture translationInView:v];
    CGPoint c = self.center;
    c.x += t.x; c.y += t.y;
    CGFloat hw = self.bounds.size.width/2 + 30;
    CGFloat hh = self.bounds.size.height/2 + 30;
    c.x = MAX(hw, MIN(v.bounds.size.width - hw, c.x));
    c.y = MAX(hh, MIN(v.bounds.size.height - hh, c.y));
    if (gesture.state == UIGestureRecognizerStateChanged) {
        self.center = c;
        [gesture setTranslation:CGPointZero inView:v];
    }
}

- (void)handleTap { if (self.onTap) self.onTap(); }

@end

// ====================================================================
// 📋 Menu View - مصغرة ومحسنة
// ====================================================================
@interface RavMenuView : UIView {
    dispatch_queue_t _bgQueue;
    NSTimer *_loopTimer;
    UILabel *_playerCountLabel;
    UISlider *_speedSlider, *_distSlider;
    UILabel *_speedValLabel, *_distValLabel;
    UISwitch *_aimbotSwitch, *_espSwitch, *_lineSwitch, *_bulletLineSwitch;
}
@end

@implementation RavMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bgQueue = dispatch_queue_create("com.ravfen.bg", DISPATCH_QUEUE_SERIAL);
        self.backgroundColor = [UIColor colorWithRed:0.06 green:0.06 blue:0.12 alpha:0.95];
        self.layer.cornerRadius = 16;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor colorWithRed:0.5 green:0.2 blue:1.0 alpha:0.7].CGColor;
        self.clipsToBounds = YES;
        self.layer.shadowColor = [UIColor purpleColor].CGColor;
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 12;
        self.layer.shadowOffset = CGSizeMake(0, 4);
        [self buildUI];
        [self startLoop];
    }
    return self;
}

- (void)buildUI {
    CGFloat w = self.bounds.size.width - 24, y = 12, mw = self.bounds.size.width;
    
    // Header + X جنب بعض
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, y, mw - 50, 24)];
    title.text = @"RavFen Shadow";
    title.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0];
    title.font = [UIFont boldSystemFontOfSize:18];
    title.shadowColor = [UIColor purpleColor];
    title.shadowOffset = CGSizeMake(1, 1);
    [self addSubview:title];
    
    // ✅ زر X - واضح وجانب العنوان
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(mw - 36, 8, 28, 28);
    closeBtn.backgroundColor = [UIColor colorWithRed:0.3 green:0.0 blue:0.0 alpha:0.7];
    closeBtn.layer.cornerRadius = 14;
    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [closeBtn setTitle:@"X" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    y += 32;
    UIView *ln = [[UIView alloc] initWithFrame:CGRectMake(12, y, w, 0.5)];
    ln.backgroundColor = [UIColor colorWithRed:0.4 green:0.2 blue:0.6 alpha:0.6];
    [self addSubview:ln];
    y += 8;
    
    // Aimbot
    UILabel *sa = [[UILabel alloc] initWithFrame:CGRectMake(12, y, 80, 20)];
    sa.text = @"Aimbot"; sa.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
    sa.font = [UIFont boldSystemFontOfSize:14]; [self addSubview:sa];
    
    _aimbotSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(mw - 62, y-2, 50, 20)];
    _aimbotSwitch.onTintColor = [UIColor orangeColor];
    [_aimbotSwitch addTarget:self action:@selector(toggleAimbot) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_aimbotSwitch];
    y += 24;
    
    UILabel *sl = [[UILabel alloc] initWithFrame:CGRectMake(12, y, 80, 14)];
    sl.text = @"Speed:"; sl.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.7 alpha:1.0];
    sl.font = [UIFont systemFontOfSize:11]; [self addSubview:sl];
    
    _speedValLabel = [[UILabel alloc] initWithFrame:CGRectMake(mw-55, y, 45, 14)];
    _speedValLabel.text = @"120"; _speedValLabel.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0];
    _speedValLabel.font = [UIFont boldSystemFontOfSize:11]; _speedValLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_speedValLabel];
    y += 14;
    
    _speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(12, y, w, 22)];
    _speedSlider.minimumValue = 1; _speedSlider.maximumValue = 150; _speedSlider.value = 120;
    _speedSlider.tintColor = [UIColor orangeColor];
    [_speedSlider addTarget:self action:@selector(speedChanged) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_speedSlider];
    y += 26;
    
    UIView *ln2 = [[UIView alloc] initWithFrame:CGRectMake(12, y, w, 0.5)];
    ln2.backgroundColor = [UIColor colorWithRed:0.4 green:0.2 blue:0.6 alpha:0.4];
    [self addSubview:ln2];
    y += 6;
    
    // ESP
    UILabel *sesp = [[UILabel alloc] initWithFrame:CGRectMake(12, y, 60, 20)];
    sesp.text = @"ESP"; sesp.textColor = [UIColor colorWithRed:0.3 green:0.8 blue:1.0 alpha:1.0];
    sesp.font = [UIFont boldSystemFontOfSize:14]; [self addSubview:sesp];
    
    _espSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(mw - 62, y-2, 50, 20)];
    _espSwitch.onTintColor = [UIColor cyanColor];
    [_espSwitch addTarget:self action:@selector(toggleESP) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_espSwitch];
    y += 24;
    
    UILabel *ll = [[UILabel alloc] initWithFrame:CGRectMake(12, y, 100, 14)];
    ll.text = @"Show Lines:"; ll.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.7 alpha:1.0];
    ll.font = [UIFont systemFontOfSize:11]; [self addSubview:ll];
    
    _lineSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(mw - 62, y-3, 50, 20)];
    _lineSwitch.onTintColor = [UIColor yellowColor];
    [_lineSwitch addTarget:self action:@selector(toggleLine) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_lineSwitch];
    y += 22;
    
    UILabel *bl = [[UILabel alloc] initWithFrame:CGRectMake(12, y, 100, 14)];
    bl.text = @"Bullet Line:"; bl.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.7 alpha:1.0];
    bl.font = [UIFont systemFontOfSize:11]; [self addSubview:bl];
    
    _bulletLineSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(mw - 62, y-3, 50, 20)];
    _bulletLineSwitch.onTintColor = [UIColor redColor];
    [_bulletLineSwitch addTarget:self action:@selector(toggleBulletLine) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_bulletLineSwitch];
    y += 22;
    
    UILabel *dl = [[UILabel alloc] initWithFrame:CGRectMake(12, y, 80, 14)];
    dl.text = @"Distance:"; dl.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.7 alpha:1.0];
    dl.font = [UIFont systemFontOfSize:11]; [self addSubview:dl];
    
    _distValLabel = [[UILabel alloc] initWithFrame:CGRectMake(mw-55, y, 45, 14)];
    _distValLabel.text = @"200m"; _distValLabel.textColor = [UIColor colorWithRed:0.3 green:1.0 blue:0.3 alpha:1.0];
    _distValLabel.font = [UIFont boldSystemFontOfSize:11]; _distValLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_distValLabel];
    y += 14;
    
    _distSlider = [[UISlider alloc] initWithFrame:CGRectMake(12, y, w, 22)];
    _distSlider.minimumValue = 50; _distSlider.maximumValue = 350; _distSlider.value = 200;
    _distSlider.tintColor = [UIColor greenColor];
    [_distSlider addTarget:self action:@selector(distChanged) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_distSlider];
    y += 26;
    
    _playerCountLabel = [[UILabel alloc] init];
    _playerCountLabel.text = @"Players: 0";
    _playerCountLabel.textColor = [UIColor colorWithRed:0.3 green:1.0 blue:0.3 alpha:1.0];
    _playerCountLabel.font = [UIFont boldSystemFontOfSize:13];
    _playerCountLabel.textAlignment = NSTextAlignmentCenter;
    [_playerCountLabel sizeToFit];
    _playerCountLabel.frame = CGRectMake(12, y, w, 20);
    [self addSubview:_playerCountLabel];
}

- (void)hideMenu {
    pthread_mutex_lock(&g_ConfigMutex);
    gConfig.menuVisible = NO;
    pthread_mutex_unlock(&g_ConfigMutex);
    [_loopTimer invalidate]; _loopTimer = nil;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL f) {
        [self removeFromSuperview];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *key = nil;
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    key = scene.windows.firstObject; break;
                }
            }
            if (!key) return;
            for (UIView *v in key.subviews) {
                if ([v isKindOfClass:[RavFloatingButton class]]) return;
            }
            CGFloat bs = 45;
            CGFloat fx = key.bounds.size.width - bs - 15;
            CGFloat fy = key.bounds.size.height * 0.55;
            RavFloatingButton *fb = [[RavFloatingButton alloc] initWithFrame:CGRectMake(fx, fy, bs, bs)];
            fb.alpha = 0;
            __weak typeof(fb) wfb = fb;
            fb.onTap = ^{ [wfb removeFromSuperview]; [self showMenuAgain]; };
            [key addSubview:fb];
            [key bringSubviewToFront:fb];
            [UIView animateWithDuration:0.3 animations:^{ fb.alpha = 1; }];
        });
    }];
}

- (void)showMenuAgain {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *key = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                key = scene.windows.firstObject; break;
            }
        }
        if (!key) return;
        CGFloat mw = 240, mh = 360;
        CGFloat mx = (key.bounds.size.width - mw) / 2;
        CGFloat my = (key.bounds.size.height - mh) / 2;
        RavMenuView *menu = [[RavMenuView alloc] initWithFrame:CGRectMake(mx, my, mw, mh)];
        menu.alpha = 0;
        menu.transform = CGAffineTransformMakeScale(0.85, 0.85);
        [key addSubview:menu];
        [key bringSubviewToFront:menu];
        pthread_mutex_lock(&g_ConfigMutex);
        gConfig.menuVisible = YES;
        pthread_mutex_unlock(&g_ConfigMutex);
        [UIView animateWithDuration:0.3 delay:0
              usingSpringWithDamping:0.7 initialSpringVelocity:0.6
                            options:0 animations:^{ menu.alpha = 1; menu.transform = CGAffineTransformIdentity; }
                        completion:nil];
    });
}

- (void)toggleAimbot { pthread_mutex_lock(&g_ConfigMutex); gConfig.aimbotEnabled = _aimbotSwitch.isOn; pthread_mutex_unlock(&g_ConfigMutex); }
- (void)toggleESP    { pthread_mutex_lock(&g_ConfigMutex); gConfig.espEnabled = _espSwitch.isOn; pthread_mutex_unlock(&g_ConfigMutex); }
- (void)toggleLine   { pthread_mutex_lock(&g_ConfigMutex); gConfig.espLine = _lineSwitch.isOn; pthread_mutex_unlock(&g_ConfigMutex); }
- (void)toggleBulletLine { pthread_mutex_lock(&g_ConfigMutex); gConfig.espBulletLine = _bulletLineSwitch.isOn; pthread_mutex_unlock(&g_ConfigMutex); }

- (void)speedChanged {
    pthread_mutex_lock(&g_ConfigMutex);
    gConfig.aimbotSpeed = _speedSlider.value;
    float val = _speedSlider.value;
    pthread_mutex_unlock(&g_ConfigMutex);
    dispatch_async(dispatch_get_main_queue(), ^{ self->_speedValLabel.text = [NSString stringWithFormat:@"%.0f", val]; });
}

- (void)distChanged {
    pthread_mutex_lock(&g_ConfigMutex);
    gConfig.espDistance = _distSlider.value;
    float val = _distSlider.value;
    pthread_mutex_unlock(&g_ConfigMutex);
    dispatch_async(dispatch_get_main_queue(), ^{ self->_distValLabel.text = [NSString stringWithFormat:@"%.0fm", val]; });
}

- (void)startLoop {
    __weak typeof(self) ws = self;
    _loopTimer = [NSTimer scheduledTimerWithTimeInterval:0.016 repeats:YES block:^(NSTimer *t) {
        typeof(self) ss = ws; if (!ss) { [t invalidate]; return; }
        dispatch_async(ss->_bgQueue, ^{
            DoAimbot();
            BOOL espOn = NO;
            pthread_mutex_lock(&g_ConfigMutex);
            espOn = gConfig.espEnabled;
            pthread_mutex_unlock(&g_ConfigMutex);
            if (espOn) {
                NSArray *players = GetPlayers();
                int cnt = 0;
                for (PlayerData *p in players) if (p.isEnemy && p.isAlive) cnt++;
                dispatch_async(dispatch_get_main_queue(), ^{
                    ss->_playerCountLabel.text = [NSString stringWithFormat:@"Players: %d", cnt];
                });
            }
        });
    }];
    [[NSRunLoop mainRunLoop] addTimer:_loopTimer forMode:NSRunLoopCommonModes];
}

- (void)dealloc { [_loopTimer invalidate]; }
@end

// ====================================================================
// 🎯 ESP Manager
// ====================================================================
@interface ESPManager : NSObject
@property (nonatomic, strong) UIWindow *overlayWindow;
@property (nonatomic, strong) ESPOverlayView *overlayView;
@property (nonatomic, strong) NSTimer *updateTimer;
@end

@implementation ESPManager

+ (instancetype)shared {
    static ESPManager *m = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ m = [[ESPManager alloc] init]; });
    return m;
}

- (void)startOverlay {
    if (self.overlayWindow) return;
    CGRect sb = [UIScreen mainScreen].bounds;
    self.overlayWindow = [[UIWindow alloc] initWithFrame:sb];
    self.overlayWindow.windowLevel = UIWindowLevelAlert + 1;
    self.overlayWindow.backgroundColor = [UIColor clearColor];
    self.overlayWindow.hidden = NO;
    self.overlayWindow.userInteractionEnabled = NO;
    self.overlayView = [[ESPOverlayView alloc] initWithFrame:sb];
    [self.overlayWindow addSubview:self.overlayView];
    [self startUpdateTimer];
}

- (void)startUpdateTimer {
    __weak typeof(self) ws = self;
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.016 repeats:YES block:^(NSTimer *t) {
        [ws updateESP];
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.updateTimer forMode:NSRunLoopCommonModes];
}

- (void)updateESP {
    BOOL espOn = NO, lineOn = NO, bulletOn = NO;
    pthread_mutex_lock(&g_ConfigMutex);
    espOn = gConfig.espEnabled;
    lineOn = gConfig.espLine;
    bulletOn = gConfig.espBulletLine;
    pthread_mutex_unlock(&g_ConfigMutex);
    
    if (!espOn || !self.overlayView) {
        self.overlayView.boxLayer.path = nil;
        self.overlayView.lineLayer.path = nil;
        self.overlayView.bulletLineLayer.path = nil;
        self.overlayView.playerCountLayer.string = @"";
        return;
    }
    
    NSArray *players = GetPlayers();
    UIBezierPath *boxPath = [UIBezierPath bezierPath];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    UIBezierPath *bulletPath = [UIBezierPath bezierPath];
    
    int count = 0;
    CGFloat sw = self.overlayView.bounds.size.width;
    CGFloat sh = self.overlayView.bounds.size.height;
    
    for (PlayerData *p in players) {
        if (!p.isEnemy || !p.isAlive) continue;
        count++;
        float sx = 0, sy = 0;
        if (!WorldToScreen(p.x, p.y, p.z + 1.75f, &sx, &sy)) continue;
        if (sx < -50 || sx > sw + 50 || sy < -50 || sy > sh + 50) continue;
        CGRect box = CGRectMake(sx - 25, sy - 50, 50, 100);
        [boxPath appendPath:[UIBezierPath bezierPathWithRect:box]];
        if (lineOn) {
            [linePath moveToPoint:CGPointMake(sw/2, sh/2)];
            [linePath addLineToPoint:CGPointMake(sx, sy)];
        }
        if (bulletOn) {
            [bulletPath moveToPoint:CGPointMake(sx, sy - 50)];
            [bulletPath addLineToPoint:CGPointMake(sx, sy + 50)];
        }
    }
    
    self.overlayView.boxLayer.path = boxPath.CGPath;
    self.overlayView.lineLayer.path = linePath.CGPath;
    self.overlayView.bulletLineLayer.path = bulletPath.CGPath;
    self.overlayView.playerCountLayer.string = [NSString stringWithFormat:@"Players: %d", count];
}

- (void)stopOverlay {
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    self.overlayWindow.hidden = YES;
    self.overlayWindow = nil;
    self.overlayView = nil;
}

@end

// ====================================================================
// 🚀 Launch
// ====================================================================
static void LaunchRavFen(void) {
    [[ESPManager shared] startOverlay];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *key = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                key = scene.windows.firstObject; break;
            }
        }
        if (!key) return;
        
        RavSplashView *splash = [[RavSplashView alloc] initWithFrame:key.bounds];
        [key addSubview:splash];
        [key bringSubviewToFront:splash];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.3 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4 animations:^{ splash.alpha = 0; }
            completion:^(BOOL f) {
                [splash removeFromSuperview];
                RavCaptchaView *captcha = [[RavCaptchaView alloc] initWithFrame:key.bounds];
                captcha.onDone = ^{
                    CGFloat bs = 45;
                    CGFloat fx = key.bounds.size.width - bs - 15;
                    CGFloat fy = key.bounds.size.height * 0.55;
                    RavFloatingButton *fb = [[RavFloatingButton alloc] initWithFrame:CGRectMake(fx, fy, bs, bs)];
                    fb.alpha = 0;
                    __weak typeof(fb) wfb = fb;
                    fb.onTap = ^{
                        [wfb removeFromSuperview];
                        CGFloat mw = 240, mh = 360;
                        CGFloat mx = (key.bounds.size.width - mw) / 2;
                        CGFloat my = (key.bounds.size.height - mh) / 2;
                        for (UIView *v in key.subviews) {
                            if ([v isKindOfClass:[RavMenuView class]]) return;
                        }
                        RavMenuView *menu = [[RavMenuView alloc] initWithFrame:CGRectMake(mx, my, mw, mh)];
                        menu.alpha = 0;
                        menu.transform = CGAffineTransformMakeScale(0.85, 0.85);
                        [key addSubview:menu];
                        [key bringSubviewToFront:menu];
                        pthread_mutex_lock(&g_ConfigMutex);
                        gConfig.menuVisible = YES;
                        pthread_mutex_unlock(&g_ConfigMutex);
                        [UIView animateWithDuration:0.3 delay:0
                              usingSpringWithDamping:0.7 initialSpringVelocity:0.6
                                            options:0 animations:^{ menu.alpha = 1; menu.transform = CGAffineTransformIdentity; }
                                        completion:nil];
                    };
                    [key addSubview:fb];
                    [key bringSubviewToFront:fb];
                    [UIView animateWithDuration:0.3 animations:^{ fb.alpha = 1; }];
                };
                [key addSubview:captcha];
                [key bringSubviewToFront:captcha];
            }];
        });
    });
}

// ====================================================================
// 🔌 Constructor
// ====================================================================
__attribute__((constructor))
static void Init(void) {
    GetBaseAddress();
    InitOffsets();
    
    pthread_mutex_lock(&g_ConfigMutex);
    gConfig.aimbotEnabled = NO;
    gConfig.aimbotSpeed = 120.0f;
    gConfig.espEnabled = NO;
    gConfig.espLine = NO;
    gConfig.espBulletLine = NO;
    gConfig.espDistance = 200.0f;
    gConfig.menuVisible = NO;
    pthread_mutex_unlock(&g_ConfigMutex);
    
    pthread_t th;
    pthread_create(&th, NULL, AntiDetachLoop, NULL);
    pthread_detach(th);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{ LaunchRavFen(); });
}
