// ====================================================================
// RavFen Shadow v7.1 - PUBG Mobile 4.5.0 iOS Tweak
// جميع الأوفستات مؤكدة | Aimbot | ESP | 120 FPS | قائمة هيبة
// Fixed: Build errors, ESP+Aimbot always running, redesigned menu
// ====================================================================

#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <pthread.h>
#import <dlfcn.h>
#import <math.h>
#import <sys/sysctl.h>
#import <sys/types.h>

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
        (vm_address_t)addr, (vm_size_t)sz,
        (vm_address_t)buf, &outsize);
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
    volatile BOOL       fps120Enabled;
} RavConfig;

static RavConfig gConfig = {0};

// ====================================================================
// 🔐 Offsets
// ====================================================================
enum {
    OFF_GW, OFF_GN, OFF_PL, OFF_AA, OFF_AC, OFF_GI, OFF_LP,
    OFF_PC, OFF_AP, OFF_RC, OFF_CTW, OFF_CR, OFF_MS, OFF_BA,
    OFF_HP, OFF_TM, OFF_AD, OFF_VMC, OFF_VM, OFF_COUNT
};
static uint64_t gOffsets[OFF_COUNT] = {0};

static void InitOffsets(void) {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        gOffsets[OFF_GW]  = 0xA68D558;
        gOffsets[OFF_GN]  = 0xA5C1598;
        gOffsets[OFF_VMC] = 0x7F8B000;
        gOffsets[OFF_PL]  = 0xAF0;
        gOffsets[OFF_AA]  = 0x80;
        gOffsets[OFF_AC]  = 0x88;
        gOffsets[OFF_GI]  = 0xC48;
        gOffsets[OFF_LP]  = 0xB48;
        gOffsets[OFF_PC]  = 0x30;
        gOffsets[OFF_AP]  = 0x7A8;
        gOffsets[OFF_RC]  = 0x138;
        gOffsets[OFF_CTW] = 0xAC0;
        gOffsets[OFF_CR]  = 0xB80;
        gOffsets[OFF_MS]  = 0x310;
        gOffsets[OFF_BA]  = 0xB00;
        gOffsets[OFF_HP]  = 0x5C;
        gOffsets[OFF_TM]  = 0xA6C;
        gOffsets[OFF_AD]  = 0x8;
        gOffsets[OFF_VM]  = 0x0;
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
static BOOL WriteInt(uint64_t addr, int32_t val) {
    if (!addr) return NO;
    int32_t c = ReadInt(addr);
    if (c == val) return YES;
    return WriteMem(addr, &val, 4);
}

// ====================================================================
// 👤 IsPlayer
// ====================================================================
static BOOL gDebugBypassPlayerCheck = NO;

static BOOL IsPlayer(uint64_t actor) {
    if (!actor) return NO;
    if (gDebugBypassPlayerCheck) {
        return (ReadFloat(actor + OFF(OFF_HP)) > 0.0f && ReadPtr(actor + OFF(OFF_MS)));
    }
    uint64_t gnBase = ReadPtr(GetBaseAddress() + OFF(OFF_GN));
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
    uint64_t base = GetBaseAddress();
    uint64_t gw = ReadPtr(base + OFF(OFF_GW));
    if (!gw) return arr;
    uint64_t lvl = ReadPtr(gw + OFF(OFF_PL));
    if (!lvl) return arr;
    uint64_t act = ReadPtr(lvl + OFF(OFF_AA));
    int32_t  cnt = ReadInt(lvl + OFF(OFF_AC));
    if (!act || cnt <= 0 || cnt > 1000) return arr;
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

    ReadMem(base + OFF(OFF_VMC), g_ViewMatrix, 64);

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

    uint64_t base = GetBaseAddress();
    uint64_t gw   = ReadPtr(base + OFF(OFF_GW)); if (!gw) return;
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
// ⚡ 120 FPS
// ====================================================================
static void SetFPS120(void) {
    BOOL en = NO;
    pthread_mutex_lock(&g_ConfigMutex); en = gConfig.fps120Enabled; pthread_mutex_unlock(&g_ConfigMutex);
    if (!en) return;
    uint64_t base = GetBaseAddress();
    static uint64_t addr = 0;
    static dispatch_once_t ot;
    dispatch_once(&ot, ^{
        for (uint64_t a = base; a < base + 0x20000000; a += 8) {
            float v = ReadFloat(a);
            if (v == 30.0f || v == 60.0f) {
                float nv = ReadFloat(a + 4);
                if (nv == 0.0f || nv == 1.0f) { addr = a; break; }
            }
        }
    });
    if (addr) { WriteFloat(addr, 120.0f); WriteInt(addr + 0x10, 0); }
    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (arc4random() % 3 + 5) * NSEC_PER_SEC),
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
        ^{ SetFPS120(); }
    );
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
@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation ESPOverlayView

- (instancetype)initWithFrame:(CGRect)f {
    self = [super initWithFrame:f];
    if (!self) return nil;
    self.backgroundColor     = [UIColor clearColor];
    self.userInteractionEnabled = NO;

    // Box layer — cyan outline
    _boxLayer              = [CAShapeLayer layer];
    _boxLayer.strokeColor  = [UIColor colorWithRed:0.0 green:0.95 blue:1.0 alpha:0.9].CGColor;
    _boxLayer.fillColor    = [UIColor colorWithRed:0.0 green:0.95 blue:1.0 alpha:0.05].CGColor;
    _boxLayer.lineWidth    = 1.5f;
    [self.layer addSublayer:_boxLayer];

    // Line layer — yellow dashed
    _lineLayer              = [CAShapeLayer layer];
    _lineLayer.strokeColor  = [UIColor colorWithRed:1.0 green:0.9 blue:0.0 alpha:0.7].CGColor;
    _lineLayer.lineWidth    = 1.0f;
    _lineLayer.lineDashPattern = @[@4, @3];
    [self.layer addSublayer:_lineLayer];

    // Bullet line layer — hot red
    _bulletLineLayer              = [CAShapeLayer layer];
    _bulletLineLayer.strokeColor  = [UIColor colorWithRed:1.0 green:0.15 blue:0.15 alpha:0.85].CGColor;
    _bulletLineLayer.lineWidth    = 2.0f;
    [self.layer addSublayer:_bulletLineLayer];

    // Info label
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, f.size.width, 20)];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.textColor     = [UIColor colorWithRed:0.0 green:1.0 blue:0.85 alpha:1.0];
    _infoLabel.font          = [UIFont boldSystemFontOfSize:12];
    _infoLabel.text          = @"";
    [self addSubview:_infoLabel];

    return self;
}

- (void)updateWithPlayers:(NSArray *)players {
    BOOL espOn = NO, lineOn = NO, bulletOn = NO;
    pthread_mutex_lock(&g_ConfigMutex);
    espOn   = gConfig.espEnabled;
    lineOn  = gConfig.espLine;
    bulletOn= gConfig.espBulletLine;
    pthread_mutex_unlock(&g_ConfigMutex);

    if (!espOn || !players || players.count == 0) {
        self.boxLayer.path        = nil;
        self.lineLayer.path       = nil;
        self.bulletLineLayer.path = nil;
        _infoLabel.text           = @"";
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

        // Box proportional to distance
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
            ? [NSString stringWithFormat:@"[ %d ENEMY ]", visible]
            : @"";
    });
}

@end

// ====================================================================
// 🔄 RavEngine — Independent Game Loop (runs always, even menu hidden)
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
        _t = [NSTimer scheduledTimerWithTimeInterval:0.016
                                             repeats:YES
                                               block:^(NSTimer *timer) {
            dispatch_async(_q, ^{
                NSArray *p = GetPlayers();
                DoAimbot(p);
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
// 🎨 Helper — colored label
// ====================================================================
static UILabel *RavLabel(NSString *text, UIFont *font, UIColor *color, CGRect frame) {
    UILabel *l = [[UILabel alloc] initWithFrame:frame];
    l.text          = text;
    l.font          = font;
    l.textColor     = color;
    l.backgroundColor = [UIColor clearColor];
    return l;
}

// Forward declaration — RavFloatingButton defined later
@class RavFloatingButton;

// ====================================================================
// 📋 Menu View — تصميم هيبة جديد كامل
// ====================================================================
@interface RavMenuView : UIView
- (instancetype)initWithFrame:(CGRect)f overlayView:(ESPOverlayView *)ov;
@end

@implementation RavMenuView {
    UISwitch           *_as, *_es, *_ls, *_bls;
    UISegmentedControl *_ms;
    UISlider           *_ss, *_ds;
    UILabel            *_sv, *_dv;
    UIButton           *_fps;
    BOOL                _fc;
    ESPOverlayView     *_ev;
    UIPanGestureRecognizer *_pan;
    CGPoint             _startCenter;
}

- (instancetype)initWithFrame:(CGRect)f overlayView:(ESPOverlayView *)ov {
    self = [super initWithFrame:f];
    if (!self) return nil;
    _ev = ov;

    // Background
    self.backgroundColor = [UIColor colorWithRed:0.03 green:0.03 blue:0.10 alpha:0.96];
    self.layer.cornerRadius  = 16;
    self.layer.borderWidth   = 1.5;
    self.layer.borderColor   = [UIColor colorWithRed:0.0 green:0.9 blue:1.0 alpha:0.45].CGColor;
    self.clipsToBounds       = NO;
    // Outer glow
    self.layer.shadowColor   = [UIColor colorWithRed:0.0 green:0.85 blue:1.0 alpha:1.0].CGColor;
    self.layer.shadowRadius  = 12;
    self.layer.shadowOpacity = 0.35;
    self.layer.shadowOffset  = CGSizeMake(0, 0);

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
    _ms.selectedSegmentIndex = (NSInteger)(gConfig.aimbotMode - 1);
    _es.on  = gConfig.espEnabled;
    _ls.on  = gConfig.espLine;
    _bls.on = gConfig.espBulletLine;
    _ds.value = gConfig.espDistance;
    _fc = gConfig.fps120Enabled;
    pthread_mutex_unlock(&g_ConfigMutex);
    [_sv setText:[NSString stringWithFormat:@"%.0f", _ss.value]];
    [_dv setText:[NSString stringWithFormat:@"%.0fm", _ds.value]];
    [self updateFPSButton];
}

- (void)updateFPSButton {
    if (_fc) {
        [_fps setTitle:@"ON" forState:UIControlStateNormal];
        [_fps setTitleColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.55 alpha:1.0]
                  forState:UIControlStateNormal];
        _fps.backgroundColor        = [UIColor colorWithRed:0.0 green:0.25 blue:0.12 alpha:1.0];
        _fps.layer.borderColor      = [UIColor colorWithRed:0.0 green:1.0 blue:0.55 alpha:0.8].CGColor;
    } else {
        [_fps setTitle:@"OFF" forState:UIControlStateNormal];
        [_fps setTitleColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.6 alpha:1.0]
                  forState:UIControlStateNormal];
        _fps.backgroundColor        = [UIColor colorWithRed:0.08 green:0.08 blue:0.16 alpha:1.0];
        _fps.layer.borderColor      = [UIColor colorWithRed:0.3 green:0.3 blue:0.5 alpha:0.5].CGColor;
    }
}

- (void)buildUI {
    CGFloat mw  = self.bounds.size.width;
    CGFloat y   = 0;
    CGFloat pw  = mw - 20; // padded width

    // ── Header bar ───────────────────────────────────────
    UIView *hdrBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mw, 46)];
    hdrBg.backgroundColor = [UIColor colorWithRed:0.0 green:0.08 blue:0.18 alpha:1.0];
    [self addSubview:hdrBg];

    // R badge
    UILabel *badge = [[UILabel alloc] initWithFrame:CGRectMake(12, 9, 28, 28)];
    badge.text           = @"R";
    badge.textColor      = [UIColor colorWithRed:0.0 green:0.95 blue:1.0 alpha:1.0];
    badge.font           = [UIFont boldSystemFontOfSize:17];
    badge.textAlignment  = NSTextAlignmentCenter;
    badge.backgroundColor= [UIColor colorWithRed:0.0 green:0.25 blue:0.4 alpha:0.9];
    badge.layer.cornerRadius = 8;
    badge.clipsToBounds  = YES;
    badge.layer.borderWidth = 1;
    badge.layer.borderColor = [UIColor colorWithRed:0.0 green:0.9 blue:1.0 alpha:0.6].CGColor;
    [self addSubview:badge];

    // Title
    UILabel *ttl = [[UILabel alloc] initWithFrame:CGRectMake(48, 7, mw - 100, 18)];
    ttl.text      = @"RAVFEN SHADOW";
    ttl.textColor = [UIColor colorWithRed:0.0 green:0.95 blue:1.0 alpha:1.0];
    ttl.font      = [UIFont boldSystemFontOfSize:13];
    [self addSubview:ttl];

    UILabel *ver = [[UILabel alloc] initWithFrame:CGRectMake(48, 25, mw - 100, 13)];
    ver.text      = @"v7.1  •  PUBG 4.5.0";
    ver.textColor = [UIColor colorWithRed:0.35 green:0.55 blue:0.75 alpha:1.0];
    ver.font      = [UIFont systemFontOfSize:9];
    [self addSubview:ver];

    // Close button
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(mw - 38, 11, 26, 24);
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorWithRed:0.8 green:0.3 blue:0.3 alpha:1.0]
                  forState:UIControlStateNormal];
    closeBtn.titleLabel.font     = [UIFont boldSystemFontOfSize:13];
    closeBtn.backgroundColor     = [UIColor colorWithRed:0.35 green:0.05 blue:0.05 alpha:0.7];
    closeBtn.layer.cornerRadius  = 6;
    closeBtn.layer.borderWidth   = 1;
    closeBtn.layer.borderColor   = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:0.4].CGColor;
    [closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];

    y = 54;

    // ── Section helper ────────────────────────────────────
    // AIMBOT section label
    UILabel *aimHdr = RavLabel(@"⬡  AIMBOT",
        [UIFont boldSystemFontOfSize:11],
        [UIColor colorWithRed:1.0 green:0.45 blue:0.1 alpha:1.0],
        CGRectMake(12, y, 110, 18));
    [self addSubview:aimHdr];

    _as = [[UISwitch alloc] init];
    _as.transform   = CGAffineTransformMakeScale(0.72, 0.72);
    _as.onTintColor = [UIColor colorWithRed:1.0 green:0.45 blue:0.1 alpha:1.0];
    _as.frame       = CGRectMake(mw - 62, y - 3, 51, 31);
    [_as addTarget:self action:@selector(tgA) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_as];
    y += 24;

    // Mode segmented
    _ms = [[UISegmentedControl alloc] initWithItems:@[@"Lock", @"Fire", @"Scope"]];
    _ms.frame                    = CGRectMake(10, y, pw, 26);
    _ms.selectedSegmentIndex     = 0;
    _ms.backgroundColor          = [UIColor colorWithRed:0.05 green:0.05 blue:0.15 alpha:1.0];
    [_ms setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.6 green:0.6 blue:0.8 alpha:1.0],
                                   NSFontAttributeName:[UIFont boldSystemFontOfSize:10]}
                       forState:UIControlStateNormal];
    [_ms setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:0.55 blue:0.1 alpha:1.0],
                                   NSFontAttributeName:[UIFont boldSystemFontOfSize:10]}
                       forState:UIControlStateSelected];
    if (@available(iOS 13.0, *)) {
        _ms.selectedSegmentTintColor = [UIColor colorWithRed:0.25 green:0.1 blue:0.0 alpha:1.0];
    }
    [_ms addTarget:self action:@selector(mCh) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_ms];
    y += 32;

    // Speed label + slider
    UILabel *spLbl = RavLabel(@"Speed",
        [UIFont systemFontOfSize:10],
        [UIColor colorWithRed:0.55 green:0.55 blue:0.75 alpha:1.0],
        CGRectMake(12, y, 40, 16));
    [self addSubview:spLbl];
    _sv = RavLabel(@"120", [UIFont boldSystemFontOfSize:10],
        [UIColor colorWithRed:1.0 green:0.75 blue:0.2 alpha:1.0],
        CGRectMake(mw - 36, y, 26, 16));
    _sv.textAlignment = NSTextAlignmentRight;
    [self addSubview:_sv];
    y += 16;

    _ss = [[UISlider alloc] initWithFrame:CGRectMake(10, y, pw, 18)];
    _ss.minimumValue = 1; _ss.maximumValue = 150; _ss.value = 120;
    _ss.minimumTrackTintColor = [UIColor colorWithRed:1.0 green:0.45 blue:0.1 alpha:1.0];
    _ss.maximumTrackTintColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.22 alpha:1.0];
    [_ss addTarget:self action:@selector(sCh) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_ss];
    y += 26;

    // ── Divider ───────────────────────────────────────────
    UIView *div1 = [[UIView alloc] initWithFrame:CGRectMake(10, y, pw, 0.6)];
    div1.backgroundColor = [UIColor colorWithRed:0.0 green:0.7 blue:1.0 alpha:0.18];
    [self addSubview:div1];
    y += 10;

    // ── ESP section ───────────────────────────────────────
    UILabel *espHdr = RavLabel(@"⬡  ESP",
        [UIFont boldSystemFontOfSize:11],
        [UIColor colorWithRed:0.0 green:0.9 blue:1.0 alpha:1.0],
        CGRectMake(12, y, 80, 18));
    [self addSubview:espHdr];

    _es = [[UISwitch alloc] init];
    _es.transform   = CGAffineTransformMakeScale(0.72, 0.72);
    _es.onTintColor = [UIColor colorWithRed:0.0 green:0.85 blue:1.0 alpha:1.0];
    _es.frame       = CGRectMake(mw - 62, y - 3, 51, 31);
    [_es addTarget:self action:@selector(tgE) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_es];
    y += 26;

    // Lines toggle row
    UILabel *lineLbl = RavLabel(@"Lines",
        [UIFont systemFontOfSize:10],
        [UIColor colorWithRed:0.6 green:0.6 blue:0.8 alpha:1.0],
        CGRectMake(12, y, 60, 18));
    [self addSubview:lineLbl];
    _ls = [[UISwitch alloc] init];
    _ls.transform   = CGAffineTransformMakeScale(0.65, 0.65);
    _ls.onTintColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.0 alpha:1.0];
    _ls.frame       = CGRectMake(mw - 62, y - 2, 51, 28);
    [_ls addTarget:self action:@selector(tgL) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_ls];
    y += 22;

    // Bullet line toggle row
    UILabel *bullLbl = RavLabel(@"Bullet",
        [UIFont systemFontOfSize:10],
        [UIColor colorWithRed:0.6 green:0.6 blue:0.8 alpha:1.0],
        CGRectMake(12, y, 60, 18));
    [self addSubview:bullLbl];
    _bls = [[UISwitch alloc] init];
    _bls.transform   = CGAffineTransformMakeScale(0.65, 0.65);
    _bls.onTintColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0];
    _bls.frame       = CGRectMake(mw - 62, y - 2, 51, 28);
    [_bls addTarget:self action:@selector(tgB) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_bls];
    y += 22;

    // Distance label + slider
    UILabel *dLbl = RavLabel(@"Dist",
        [UIFont systemFontOfSize:10],
        [UIColor colorWithRed:0.55 green:0.55 blue:0.75 alpha:1.0],
        CGRectMake(12, y, 36, 16));
    [self addSubview:dLbl];
    _dv = RavLabel(@"200m", [UIFont boldSystemFontOfSize:10],
        [UIColor colorWithRed:0.0 green:1.0 blue:0.6 alpha:1.0],
        CGRectMake(mw - 42, y, 32, 16));
    _dv.textAlignment = NSTextAlignmentRight;
    [self addSubview:_dv];
    y += 16;

    _ds = [[UISlider alloc] initWithFrame:CGRectMake(10, y, pw, 18)];
    _ds.minimumValue = 50; _ds.maximumValue = 350; _ds.value = 200;
    _ds.minimumTrackTintColor = [UIColor colorWithRed:0.0 green:0.85 blue:1.0 alpha:1.0];
    _ds.maximumTrackTintColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.18 alpha:1.0];
    [_ds addTarget:self action:@selector(dCh) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_ds];
    y += 26;

    // ── Divider ───────────────────────────────────────────
    UIView *div2 = [[UIView alloc] initWithFrame:CGRectMake(10, y, pw, 0.6)];
    div2.backgroundColor = [UIColor colorWithRed:0.0 green:0.7 blue:1.0 alpha:0.18];
    [self addSubview:div2];
    y += 10;

    // ── FPS ───────────────────────────────────────────────
    UILabel *fpsLbl = RavLabel(@"⚡  120 FPS",
        [UIFont boldSystemFontOfSize:11],
        [UIColor colorWithRed:0.9 green:0.9 blue:1.0 alpha:1.0],
        CGRectMake(12, y, 100, 20));
    [self addSubview:fpsLbl];

    _fps = [UIButton buttonWithType:UIButtonTypeSystem];
    _fps.frame = CGRectMake(mw - 50, y, 40, 20);
    _fps.titleLabel.font    = [UIFont boldSystemFontOfSize:10];
    _fps.layer.cornerRadius = 5;
    _fps.layer.borderWidth  = 1;
    _fps.clipsToBounds      = YES;
    [_fps addTarget:self action:@selector(tgF) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fps];
    y += 28;

    // ── Divider ───────────────────────────────────────────
    UIView *div3 = [[UIView alloc] initWithFrame:CGRectMake(10, y, pw, 0.6)];
    div3.backgroundColor = [UIColor colorWithRed:0.0 green:0.7 blue:1.0 alpha:0.18];
    [self addSubview:div3];
    y += 8;

    // ── Telegram button ───────────────────────────────────
    UIButton *tgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    tgBtn.frame = CGRectMake(10, y, pw, 28);
    [tgBtn setTitle:@"📢  t.me/RavFenupdate" forState:UIControlStateNormal];
    [tgBtn setTitleColor:[UIColor colorWithRed:0.0 green:0.85 blue:1.0 alpha:1.0]
               forState:UIControlStateNormal];
    tgBtn.titleLabel.font     = [UIFont boldSystemFontOfSize:10];
    tgBtn.backgroundColor     = [UIColor colorWithRed:0.0 green:0.12 blue:0.22 alpha:1.0];
    tgBtn.layer.cornerRadius  = 8;
    tgBtn.layer.borderWidth   = 1;
    tgBtn.layer.borderColor   = [UIColor colorWithRed:0.0 green:0.7 blue:1.0 alpha:0.3].CGColor;
    [tgBtn addTarget:self action:@selector(openTG) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tgBtn];
}

// ── Actions ──────────────────────────────────────────────────────────
- (void)openTG { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/RavFenupdate"] options:@{} completionHandler:nil]; }
- (void)tgA    { pthread_mutex_lock(&g_ConfigMutex); gConfig.aimbotEnabled  = _as.isOn; pthread_mutex_unlock(&g_ConfigMutex); }
- (void)tgE    { pthread_mutex_lock(&g_ConfigMutex); gConfig.espEnabled     = _es.isOn; pthread_mutex_unlock(&g_ConfigMutex); }
- (void)tgL    { pthread_mutex_lock(&g_ConfigMutex); gConfig.espLine        = _ls.isOn; pthread_mutex_unlock(&g_ConfigMutex); }
- (void)tgB    { pthread_mutex_lock(&g_ConfigMutex); gConfig.espBulletLine  = _bls.isOn; pthread_mutex_unlock(&g_ConfigMutex); }
- (void)mCh    { pthread_mutex_lock(&g_ConfigMutex); gConfig.aimbotMode     = (AimbotMode)(_ms.selectedSegmentIndex + 1); pthread_mutex_unlock(&g_ConfigMutex); }
- (void)sCh {
    float v = _ss.value;
    pthread_mutex_lock(&g_ConfigMutex); gConfig.aimbotSpeed = v; pthread_mutex_unlock(&g_ConfigMutex);
    dispatch_async(dispatch_get_main_queue(), ^{ [_sv setText:[NSString stringWithFormat:@"%.0f", v]]; });
}
- (void)dCh {
    float v = _ds.value;
    pthread_mutex_lock(&g_ConfigMutex); gConfig.espDistance = v; pthread_mutex_unlock(&g_ConfigMutex);
    dispatch_async(dispatch_get_main_queue(), ^{ [_dv setText:[NSString stringWithFormat:@"%.0fm", v]]; });
}
- (void)tgF {
    _fc = !_fc;
    pthread_mutex_lock(&g_ConfigMutex); gConfig.fps120Enabled = _fc; pthread_mutex_unlock(&g_ConfigMutex);
    [self updateFPSButton];
    if (_fc) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{ SetFPS120(); });
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
        initWithFrame:CGRectMake(k.bounds.size.width - 56 - 10,
                                 k.bounds.size.height * 0.52, 56, 56)];
    fb.alpha = 0;
    __weak typeof(fb) wfb = fb;
    __weak typeof(self) ws = self;
    fb.onTap = ^{ [wfb removeFromSuperview]; [ws showAgain]; };
    [k addSubview:fb]; [k bringSubviewToFront:fb];
    [UIView animateWithDuration:0.3 animations:^{ fb.alpha = 1; }];
}

- (void)presentMenuIn:(UIWindow *)k {
    RavMenuView *m = [[RavMenuView alloc]
        initWithFrame:CGRectMake((k.bounds.size.width  - 245) / 2.0,
                                 (k.bounds.size.height - 360) / 2.0,
                                 245, 360)
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
// 🔘 Floating Button
// ====================================================================
@interface RavFloatingButton : UIView
@property (nonatomic, copy) void (^onTap)(void);
@end

@implementation RavFloatingButton {
    UILabel                *_lbl;
    UIPanGestureRecognizer *_pan;
    CGFloat                 _angle;
    NSTimer                *_rot;
    UILabel                *_tag;
}

- (instancetype)initWithFrame:(CGRect)f {
    self = [super initWithFrame:f];
    if (!self) return nil;

    self.backgroundColor     = [UIColor colorWithRed:0.0 green:0.1 blue:0.22 alpha:0.88];
    self.layer.cornerRadius  = f.size.width / 2.0;
    self.layer.borderWidth   = 2.0;
    self.layer.borderColor   = [UIColor colorWithRed:0.0 green:0.9 blue:1.0 alpha:0.85].CGColor;
    self.layer.shadowColor   = [UIColor colorWithRed:0.0 green:0.85 blue:1.0 alpha:1.0].CGColor;
    self.layer.shadowRadius  = 10;
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowOffset  = CGSizeMake(0, 0);

    _lbl = [[UILabel alloc] initWithFrame:self.bounds];
    _lbl.text          = @"R";
    _lbl.textColor     = [UIColor colorWithRed:0.0 green:0.95 blue:1.0 alpha:1.0];
    _lbl.font          = [UIFont boldSystemFontOfSize:26];
    _lbl.textAlignment = NSTextAlignmentCenter;
    _lbl.userInteractionEnabled = NO;
    [self addSubview:_lbl];

    _tag = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 11)];
    _tag.text          = @"RavFen";
    _tag.textColor     = [UIColor colorWithRed:0.0 green:0.85 blue:1.0 alpha:0.55];
    _tag.font          = [UIFont boldSystemFontOfSize:8];
    _tag.userInteractionEnabled = NO;
    [self addSubview:_tag];

    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:_pan];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    [_pan requireGestureRecognizerToFail:tap];

    _angle = 0;
    _rot = [NSTimer scheduledTimerWithTimeInterval:0.03
                                           repeats:YES
                                             block:^(NSTimer *t) {
        if (!self.superview) { [t invalidate]; return; }
        _angle += 0.08;
        CGFloat r  = 26, cx = self.bounds.size.width / 2.0, cy = self.bounds.size.height / 2.0;
        _tag.frame = CGRectMake(cx + cosf(_angle) * r - 24, cy + sinf(_angle) * r - 5.5, 48, 11);
    }];
    [[NSRunLoop mainRunLoop] addTimer:_rot forMode:NSRunLoopCommonModes];

    return self;
}

- (void)pan:(UIPanGestureRecognizer *)g {
    UIView *v = self.superview; if (!v) return;
    if (g.state == UIGestureRecognizerStateChanged) {
        CGPoint t = [g translationInView:v];
        CGPoint c = self.center;
        c.x += t.x; c.y += t.y;
        CGFloat r = self.bounds.size.width / 2.0 + 8;
        c.x = MAX(r, MIN(v.bounds.size.width  - r, c.x));
        c.y = MAX(r + 44, MIN(v.bounds.size.height - r - 44, c.y));
        self.center = c;
        [g setTranslation:CGPointZero inView:v];
    }
}
- (void)tap { if (self.onTap) self.onTap(); }

@end

// ====================================================================
// 🌟 Splash Screen
// ====================================================================
@interface RavSplashView : UIView @end
@implementation RavSplashView

- (instancetype)initWithFrame:(CGRect)f {
    self = [super initWithFrame:f];
    if (!self) return nil;
    self.backgroundColor = [UIColor blackColor];

    // Glowing R
    UILabel *big = [[UILabel alloc] initWithFrame:CGRectMake(0, f.size.height * 0.28, f.size.width, 110)];
    big.text          = @"R";
    big.textColor     = [UIColor colorWithRed:0.0 green:0.95 blue:1.0 alpha:1.0];
    big.font          = [UIFont boldSystemFontOfSize:96];
    big.textAlignment = NSTextAlignmentCenter;
    big.alpha         = 0;
    [self addSubview:big];

    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(0, f.size.height * 0.50, f.size.width, 36)];
    sub.text          = @"RAVFEN SHADOW";
    sub.textColor     = [UIColor colorWithRed:0.0 green:0.85 blue:1.0 alpha:0.9];
    sub.font          = [UIFont boldSystemFontOfSize:20];
    sub.textAlignment = NSTextAlignmentCenter;
    sub.alpha         = 0;
    [self addSubview:sub];

    UILabel *ver = [[UILabel alloc] initWithFrame:CGRectMake(0, f.size.height * 0.57, f.size.width, 22)];
    ver.text          = @"v7.1  •  PUBG Mobile 4.5.0";
    ver.textColor     = [UIColor colorWithRed:0.3 green:0.55 blue:0.75 alpha:1.0];
    ver.font          = [UIFont systemFontOfSize:12];
    ver.textAlignment = NSTextAlignmentCenter;
    ver.alpha         = 0;
    [self addSubview:ver];

    [UIView animateWithDuration:0.5 delay:0.15 options:0 animations:^{ big.alpha = 1; } completion:nil];
    [UIView animateWithDuration:0.5 delay:0.45 options:0 animations:^{ sub.alpha = 1; ver.alpha = 1; } completion:nil];

    return self;
}
@end

// ====================================================================
// 🔒 Captcha / Tap to Start
// ====================================================================
@interface RavCaptchaView : UIView
@property (nonatomic, copy) void (^onDone)(void);
@end

@implementation RavCaptchaView

- (instancetype)initWithFrame:(CGRect)f {
    self = [super initWithFrame:f];
    if (!self) return nil;
    self.backgroundColor = [UIColor colorWithRed:0.02 green:0.02 blue:0.08 alpha:0.95];

    UILabel *tap = [[UILabel alloc] initWithFrame:CGRectMake(0, f.size.height * 0.44, f.size.width, 44)];
    tap.text          = @"TAP TO START";
    tap.textColor     = [UIColor colorWithRed:0.0 green:0.95 blue:1.0 alpha:1.0];
    tap.font          = [UIFont boldSystemFontOfSize:24];
    tap.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tap];

    [UIView animateWithDuration:0.9 delay:0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{ tap.alpha = 0.25; }
                     completion:nil];

    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self addGestureRecognizer:tg];
    return self;
}

- (void)tapped {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{ self.alpha = 0; }
                     completion:^(BOOL d) {
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

        // Splash
        RavSplashView *sp = [[RavSplashView alloc] initWithFrame:k.bounds];
        [k addSubview:sp]; [k bringSubviewToFront:sp];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (arc4random() % 2 + 3) * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4 animations:^{ sp.alpha = 0; }
                             completion:^(BOOL d) {
                [sp removeFromSuperview];

                // Captcha
                RavCaptchaView *cp = [[RavCaptchaView alloc] initWithFrame:k.bounds];
                cp.onDone = ^{
                    // Floating button
                    RavFloatingButton *fb = [[RavFloatingButton alloc]
                        initWithFrame:CGRectMake(k.bounds.size.width - 56 - 10,
                                                 k.bounds.size.height * 0.52, 56, 56)];
                    fb.alpha = 0;
                    __weak typeof(fb) wfb = fb;
                    fb.onTap = ^{
                        [wfb removeFromSuperview];
                        ESPOverlayView *ov = [[ESPManager shared] getOverlayView];
                        RavMenuView *m = [[RavMenuView alloc]
                            initWithFrame:CGRectMake((k.bounds.size.width  - 245) / 2.0,
                                                     (k.bounds.size.height - 360) / 2.0,
                                                     245, 360)
                              overlayView:ov];
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

    pthread_mutex_lock(&g_ConfigMutex);
    gConfig.aimbotEnabled  = NO;
    gConfig.aimbotSpeed    = 120.0f;
    gConfig.aimbotMode     = AimbotMode_Lock;
    gConfig.espEnabled     = NO;
    gConfig.espLine        = NO;
    gConfig.espBulletLine  = NO;
    gConfig.espDistance    = 200.0f;
    gConfig.menuVisible    = NO;
    gConfig.fps120Enabled  = NO;
    pthread_mutex_unlock(&g_ConfigMutex);

    pthread_t th;
    pthread_create(&th, NULL, AntiDetachLoop, NULL);
    pthread_detach(th);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (arc4random() % 2 + 2) * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{ Launch(); });
}
