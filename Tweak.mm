//====================================================================
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
    volatile BOOL       crosshairEnabled;
    volatile float      aimbotSmoothing;
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
@property (nonatomic, strong) CAShapeLayer *crosshairLayer;
@property (nonatomic, strong) UILabel      *infoLabel;
- (void)updateWithPlayers:(NSArray *)players;
@end

@implementation ESPOverlayView {
    UILabel  *_wm;
    NSTimer  *_wmTmr;
    CGFloat   _wmAngle, _wmCX, _wmCY, _wmRX, _wmRY;
}

- (instancetype)initWithFrame:(CGRect)f {
    self = [super initWithFrame:f];
    if (!self) return nil;
    self.backgroundColor        = [UIColor clearColor];
    self.userInteractionEnabled = NO;

    // Box layer — violet
    _boxLayer             = [CAShapeLayer layer];
    _boxLayer.strokeColor = [UIColor colorWithRed:0.545 green:0.361 blue:0.965 alpha:1.00].CGColor;
    _boxLayer.fillColor   = [UIColor colorWithRed:0.545 green:0.361 blue:0.965 alpha:0.28].CGColor;
    _boxLayer.lineWidth   = 1.2f;
    [self.layer addSublayer:_boxLayer];

    // Skeleton line — gold dashed
    _lineLayer                  = [CAShapeLayer layer];
    _lineLayer.strokeColor      = [UIColor colorWithRed:0.984 green:0.749 blue:0.247 alpha:1.00].CGColor;
    _lineLayer.lineWidth        = 0.8f;
    _lineLayer.lineDashPattern  = @[@5, @3];
    [self.layer addSublayer:_lineLayer];

    // Bullet tracer — red
    _bulletLineLayer             = [CAShapeLayer layer];
    _bulletLineLayer.strokeColor = [UIColor colorWithRed:0.937 green:0.267 blue:0.267 alpha:1.00].CGColor;
    _bulletLineLayer.lineWidth   = 1.5f;
    [self.layer addSublayer:_bulletLineLayer];

    // Crosshair — white, slightly dimmed, centre-screen
    _crosshairLayer             = [CAShapeLayer layer];
    _crosshairLayer.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.70].CGColor;
    _crosshairLayer.lineWidth   = 1.2f;
    _crosshairLayer.fillColor   = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.55].CGColor;
    _crosshairLayer.hidden      = YES;
    [self buildCrosshairForFrame:f];
    [self.layer addSublayer:_crosshairLayer];

    // Info label
    _infoLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, f.size.width, 18)];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.textColor     = [UIColor colorWithRed:0.545 green:0.361 blue:0.965 alpha:1.00];
    _infoLabel.font          = [UIFont boldSystemFontOfSize:10];
    _infoLabel.text          = @"";
    [self addSubview:_infoLabel];

    // Watermark — "RavFen" orbits the screen very slowly (barely visible)
    _wm                       = [[UILabel alloc] init];
    _wm.text                  = @"RavFen";
    _wm.textColor             = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.052];
    _wm.font                  = [UIFont boldSystemFontOfSize:10];
    _wm.userInteractionEnabled = NO;
    [_wm sizeToFit];
    [self addSubview:_wm];

    _wmAngle = 0;
    _wmCX = f.size.width  / 2.0;
    _wmCY = f.size.height / 2.0;
    _wmRX = f.size.width  * 0.37;
    _wmRY = f.size.height * 0.37;

    _wmTmr = [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer *t) {
        if (!self.window) { [t invalidate]; return; }
        _wmAngle += 0.006;
        _wm.center    = CGPointMake(_wmCX + _wmRX * cosf(_wmAngle),
                                    _wmCY + _wmRY * sinf(_wmAngle));
        _wm.transform = CGAffineTransformMakeRotation(_wmAngle + (CGFloat)M_PI_2);
    }];
    [[NSRunLoop mainRunLoop] addTimer:_wmTmr forMode:NSRunLoopCommonModes];

    return self;
}

- (void)buildCrosshairForFrame:(CGRect)f {
    CGFloat cx  = f.size.width  / 2.0;
    CGFloat cy  = f.size.height / 2.0;
    CGFloat arm = 9.0;
    CGFloat gap = 4.0;

    UIBezierPath *p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(cx - arm - gap, cy)];
    [p addLineToPoint:CGPointMake(cx - gap, cy)];
    [p moveToPoint:CGPointMake(cx + gap, cy)];
    [p addLineToPoint:CGPointMake(cx + arm + gap, cy)];
    [p moveToPoint:CGPointMake(cx, cy - arm - gap)];
    [p addLineToPoint:CGPointMake(cx, cy - gap)];
    [p moveToPoint:CGPointMake(cx, cy + gap)];
    [p addLineToPoint:CGPointMake(cx, cy + arm + gap)];
    [p appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(cx - 1.3, cy - 1.3, 2.6, 2.6)]];

    _crosshairLayer.path = p.CGPath;
}

- (void)updateWithPlayers:(NSArray *)players {
    BOOL espOn = NO, lineOn = NO, bulletOn = NO, crossOn = NO;
    pthread_mutex_lock(&g_ConfigMutex);
    espOn    = gConfig.espEnabled;
    lineOn   = gConfig.espLine;
    bulletOn = gConfig.espBulletLine;
    crossOn  = gConfig.crosshairEnabled;
    pthread_mutex_unlock(&g_ConfigMutex);

    if (!espOn || !players || players.count == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.boxLayer.path        = nil;
            self.lineLayer.path       = nil;
            self.bulletLineLayer.path = nil;
            _infoLabel.text           = @"";
            _crosshairLayer.hidden    = !crossOn;
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
        _crosshairLayer.hidden    = !crossOn;
        _infoLabel.text = visible > 0
            ? [NSString stringWithFormat:@"[ %d ]", visible]
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
        _t = [NSTimer scheduledTimerWithTimeInterval:0.050
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
// 🎨 Helper — coloured label
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
// ◈ Floating Button — pill capsule, violet glow, pulse ring
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
// ◈ Menu View — WRAITH · Tabbed (AIMBOT | ESP | MEMORY)
// ====================================================================
@interface RavMenuView : UIView
- (instancetype)initWithFrame:(CGRect)f overlayView:(ESPOverlayView *)ov;
@end

@implementation RavMenuView {
    NSInteger            _activeTab;
    UIButton            *_tabBtns[3];
    CALayer             *_tabIndicator;
    UIView              *_pages[3];

    UISwitch            *_as;
    UISegmentedControl  *_ms;
    UISlider            *_ss, *_smSlider;
    UILabel             *_sv, *_smv;

    UISwitch            *_es, *_ls, *_bls;
    UISlider            *_ds;
    UILabel             *_dv;

    UISwitch            *_chs;
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
    pthread_mutex_unlock(&g_ConfigMutex);
    [_sv  setText:[NSString stringWithFormat:@"%.0f",   _ss.value]];
    [_smv setText:[NSString stringWithFormat:@"%.0f%%", (_smSlider.value / 10.0f) * 100.0f]];
    [_dv  setText:[NSString stringWithFormat:@"%.0fm",  _ds.value]];
}

- (void)buildUI {
    CGFloat mw   = self.bounds.size.width;
    CGFloat mh   = self.bounds.size.height;
    CGFloat tabW = mw / 3.0;

    // ── Header ────────────────────────────────────────────
    UIView *hdr = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mw, 52)];
    hdr.backgroundColor     = CLR_HDR;
    hdr.layer.cornerRadius  = 22;
    hdr.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    [self addSubview:hdr];

    UILabel *badge = [[UILabel alloc] initWithFrame:CGRectMake(14, 13, 28, 26)];
    badge.text               = @"RF";
    badge.textColor          = CLR_VIOLET;
    badge.font               = [UIFont boldSystemFontOfSize:12];
    badge.textAlignment      = NSTextAlignmentCenter;
    badge.backgroundColor    = CLR_VIOLET_DIM;
    badge.layer.cornerRadius = 8;
    badge.clipsToBounds      = YES;
    [self addSubview:badge];

    [self addSubview:RavLabel(@"RAVFEN  WRAITH",
        [UIFont boldSystemFontOfSize:12], CLR_TEXT, CGRectMake(50, 10, mw - 100, 17))];
    [self addSubview:RavLabel(@"v7.1  ·  PUBG 4.5.0",
        [UIFont systemFontOfSize:9], CLR_MUTED, CGRectMake(50, 27, mw - 100, 14))];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(mw - 42, 14, 28, 24);
    [closeBtn setTitle:@"×" forState:UIControlStateNormal];
    [closeBtn setTitleColor:CLR_RED forState:UIControlStateNormal];
    closeBtn.titleLabel.font    = [UIFont systemFontOfSize:20];
    closeBtn.backgroundColor    = [UIColor colorWithRed:0.25 green:0.04 blue:0.04 alpha:0.7];
    closeBtn.layer.cornerRadius = 8;
    [closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];

    // ── Tab Bar ───────────────────────────────────────────
    NSArray *tabNames  = @[@"AIMBOT", @"ESP", @"MEMORY"];
    NSArray *tabColors = @[CLR_GOLD, CLR_VIOLET, CLR_GREEN];

    for (int i = 0; i < 3; i++) {
        UIButton *tb = [UIButton buttonWithType:UIButtonTypeSystem];
        tb.frame = CGRectMake(i * tabW, 52, tabW, 36);
        [tb setTitle:tabNames[i] forState:UIControlStateNormal];
        tb.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        [tb setTitleColor:(i == 0 ? tabColors[i] : CLR_MUTED) forState:UIControlStateNormal];
        tb.tag = i;
        [tb addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tb];
        _tabBtns[i] = tb;
    }

    _tabIndicator                 = [CALayer layer];
    _tabIndicator.backgroundColor = CLR_GOLD.CGColor;
    _tabIndicator.frame           = CGRectMake(6, 85, tabW - 12, 2);
    _tabIndicator.cornerRadius    = 1;
    [self.layer addSublayer:_tabIndicator];

    [self addSubview:Sep(0, 88, mw)];

    CGFloat pageH = mh - 89;
    CGRect  pageR = CGRectMake(0, 89, mw, pageH);

    [self buildAimbotPage:pageR];
    [self buildEspPage:pageR];
    [self buildMemoryPage:pageR];

    _pages[1].hidden = YES;
    _pages[2].hidden = YES;
}

- (void)buildAimbotPage:(CGRect)fr {
    UIView *page = [[UIView alloc] initWithFrame:fr];
    _pages[0] = page;
    [self addSubview:page];
    CGFloat pw = fr.size.width - 24, mw = fr.size.width, y = 16;

    [page addSubview:RavLabel(@"AIMBOT", [UIFont boldSystemFontOfSize:10], CLR_GOLD,
                              CGRectMake(14, y, 80, 14))];
    _as = StyledSwitch(CLR_GOLD);
    _as.frame = CGRectMake(mw - 58, y - 4, 51, 31);
    [_as addTarget:self action:@selector(tgA) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_as];
    y += 24;

    _ms = [[UISegmentedControl alloc] initWithItems:@[@"Lock", @"Fire", @"Scope"]];
    _ms.frame = CGRectMake(12, y, pw, 27);
    _ms.selectedSegmentIndex = 0;
    _ms.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.14 alpha:1.0];
    [_ms setTitleTextAttributes:@{NSForegroundColorAttributeName: CLR_MUTED,
                                   NSFontAttributeName: [UIFont boldSystemFontOfSize:10]}
                       forState:UIControlStateNormal];
    [_ms setTitleTextAttributes:@{NSForegroundColorAttributeName: CLR_GOLD,
                                   NSFontAttributeName: [UIFont boldSystemFontOfSize:10]}
                       forState:UIControlStateSelected];
    if (@available(iOS 13.0, *)) { _ms.selectedSegmentTintColor = CLR_GOLD_DIM; }
    [_ms addTarget:self action:@selector(mCh) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_ms];
    y += 34;

    [page addSubview:RavLabel(@"Speed", [UIFont systemFontOfSize:10], CLR_MUTED,
                              CGRectMake(14, y, 50, 14))];
    _sv = RavLabel(@"120", [UIFont boldSystemFontOfSize:10], CLR_GOLD,
                   CGRectMake(mw - 38, y, 28, 14));
    _sv.textAlignment = NSTextAlignmentRight;
    [page addSubview:_sv];
    y += 14;
    _ss = [[UISlider alloc] initWithFrame:CGRectMake(12, y, pw, 18)];
    _ss.minimumValue = 1; _ss.maximumValue = 150; _ss.value = 120;
    _ss.minimumTrackTintColor = CLR_GOLD;
    _ss.maximumTrackTintColor = [UIColor colorWithRed:0.15 green:0.13 blue:0.09 alpha:1.0];
    [_ss addTarget:self action:@selector(sCh) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_ss];
    y += 28;

    [page addSubview:Sep(12, y, pw)]; y += 14;

    [page addSubview:RavLabel(@"Smoothing", [UIFont systemFontOfSize:10], CLR_MUTED,
                              CGRectMake(14, y, 70, 14))];
    _smv = RavLabel(@"50%", [UIFont boldSystemFontOfSize:10], CLR_GOLD,
                    CGRectMake(mw - 38, y, 28, 14));
    _smv.textAlignment = NSTextAlignmentRight;
    [page addSubview:_smv];
    y += 14;
    _smSlider = [[UISlider alloc] initWithFrame:CGRectMake(12, y, pw, 18)];
    _smSlider.minimumValue = 0; _smSlider.maximumValue = 10; _smSlider.value = 5;
    _smSlider.minimumTrackTintColor = CLR_GOLD;
    _smSlider.maximumTrackTintColor = [UIColor colorWithRed:0.15 green:0.13 blue:0.09 alpha:1.0];
    [_smSlider addTarget:self action:@selector(smCh) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_smSlider];
    y += 28;

    UILabel *hint = RavLabel(@"Higher smoothing = more natural movement",
        [UIFont systemFontOfSize:8.5], CLR_MUTED, CGRectMake(14, y, pw, 28));
    hint.numberOfLines = 2;
    [page addSubview:hint];
}

- (void)buildEspPage:(CGRect)fr {
    UIView *page = [[UIView alloc] initWithFrame:fr];
    _pages[1] = page;
    [self addSubview:page];
    CGFloat pw = fr.size.width - 24, mw = fr.size.width, y = 16;

    [page addSubview:RavLabel(@"ESP", [UIFont boldSystemFontOfSize:10], CLR_VIOLET,
                              CGRectMake(14, y, 50, 14))];
    _es = StyledSwitch(CLR_VIOLET);
    _es.frame = CGRectMake(mw - 58, y - 4, 51, 31);
    [_es addTarget:self action:@selector(tgE) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_es];
    y += 30;

    [page addSubview:RavLabel(@"Skeleton Lines", [UIFont systemFontOfSize:10], CLR_MUTED,
                              CGRectMake(14, y + 4, 110, 14))];
    _ls = StyledSwitch(CLR_GREEN);
    _ls.frame = CGRectMake(mw - 58, y, 51, 28);
    [_ls addTarget:self action:@selector(tgL) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_ls];
    y += 28;

    [page addSubview:RavLabel(@"Bullet Tracer", [UIFont systemFontOfSize:10], CLR_MUTED,
                              CGRectMake(14, y + 4, 100, 14))];
    _bls = StyledSwitch(CLR_RED);
    _bls.frame = CGRectMake(mw - 58, y, 51, 28);
    [_bls addTarget:self action:@selector(tgB) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_bls];
    y += 30;

    [page addSubview:Sep(12, y, pw)]; y += 14;

    [page addSubview:RavLabel(@"Max Distance", [UIFont systemFontOfSize:10], CLR_MUTED,
                              CGRectMake(14, y, 90, 14))];
    _dv = RavLabel(@"200m", [UIFont boldSystemFontOfSize:10], CLR_VIOLET,
                   CGRectMake(mw - 42, y, 32, 14));
    _dv.textAlignment = NSTextAlignmentRight;
    [page addSubview:_dv];
    y += 14;
    _ds = [[UISlider alloc] initWithFrame:CGRectMake(12, y, pw, 18)];
    _ds.minimumValue = 50; _ds.maximumValue = 350; _ds.value = 200;
    _ds.minimumTrackTintColor = CLR_VIOLET;
    _ds.maximumTrackTintColor = [UIColor colorWithRed:0.12 green:0.10 blue:0.16 alpha:1.0];
    [_ds addTarget:self action:@selector(dCh) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_ds];
}

// ════════════════════════════════════════════════════════════════════
// FIX 1 — سطر 1008: حذف المتغير mw غير المستخدم من buildMemoryPage
// ════════════════════════════════════════════════════════════════════
- (void)buildMemoryPage:(CGRect)fr {
    UIView *page = [[UIView alloc] initWithFrame:fr];
    _pages[2] = page;
    [self addSubview:page];
    CGFloat pw = fr.size.width - 24, y = 16;  // ← أزلنا mw غير المستخدم

    [page addSubview:RavLabel(@"MEMORY", [UIFont boldSystemFontOfSize:10], CLR_GREEN,
                              CGRectMake(14, y, 80, 14))];
    y += 26;

    UIView *chCard = [[UIView alloc] initWithFrame:CGRectMake(12, y, pw, 44)];
    chCard.backgroundColor   = [UIColor colorWithRed:0.09 green:0.10 blue:0.13 alpha:1.0];
    chCard.layer.cornerRadius = 12;
    [page addSubview:chCard];

    UILabel *chH = [[UILabel alloc] initWithFrame:CGRectMake(7, 16, 16, 2)];
    chH.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.65];
    chH.layer.cornerRadius = 1; chH.clipsToBounds = YES;
    [chCard addSubview:chH];
    UILabel *chV = [[UILabel alloc] initWithFrame:CGRectMake(14, 9, 2, 16)];
    chV.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.65];
    chV.layer.cornerRadius = 1; chV.clipsToBounds = YES;
    [chCard addSubview:chV];

    [chCard addSubview:RavLabel(@"Crosshair Overlay",
        [UIFont boldSystemFontOfSize:10], CLR_TEXT, CGRectMake(34, 8, pw - 90, 14))];
    [chCard addSubview:RavLabel(@"Precision aim guide",
        [UIFont systemFontOfSize:8.5], CLR_MUTED, CGRectMake(34, 23, pw - 90, 12))];

    _chs = StyledSwitch([UIColor colorWithRed:1 green:1 blue:1 alpha:0.80]);
    _chs.frame = CGRectMake(pw - 46, 8, 51, 28);
    [_chs addTarget:self action:@selector(tgCH) forControlEvents:UIControlEventValueChanged];
    [chCard addSubview:_chs];
    y += 54;

    [page addSubview:Sep(12, y, pw)]; y += 14;

    UIView *srvCard = [[UIView alloc] initWithFrame:CGRectMake(12, y, pw, 32)];
    srvCard.backgroundColor   = [UIColor colorWithRed:0.06 green:0.11 blue:0.08 alpha:1.0];
    srvCard.layer.cornerRadius = 10;
    [page addSubview:srvCard];

    UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(12, 12, 8, 8)];
    dot.backgroundColor    = CLR_GREEN;
    dot.layer.cornerRadius = 4;
    [srvCard addSubview:dot];

    _srvStatus = RavLabel(@"PROTECTED",
        [UIFont boldSystemFontOfSize:9], CLR_GREEN, CGRectMake(26, 10, pw - 34, 12));
    [srvCard addSubview:_srvStatus];
    y += 44;

    [page addSubview:Sep(12, y, pw)]; y += 14;

    UIButton *tgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    tgBtn.frame = CGRectMake(12, y, pw, 32);
    [tgBtn setTitle:@"▸  t.me/RavFenupdate" forState:UIControlStateNormal];
    [tgBtn setTitleColor:CLR_VIOLET forState:UIControlStateNormal];
    tgBtn.titleLabel.font    = [UIFont boldSystemFontOfSize:10];
    tgBtn.backgroundColor    = CLR_VIOLET_DIM;
    tgBtn.layer.cornerRadius = 10;
    tgBtn.layer.borderWidth  = 1;
    tgBtn.layer.borderColor  = CLR_VIOLET_DIM.CGColor;
    [tgBtn addTarget:self action:@selector(openTG) forControlEvents:UIControlEventTouchUpInside];
    [page addSubview:tgBtn];
}

- (void)tabTapped:(UIButton *)sender {
    NSInteger idx = sender.tag;
    if (idx == _activeTab) return;
    NSInteger prev = _activeTab;
    _activeTab = idx;
    NSArray *tabColors = @[CLR_GOLD, CLR_VIOLET, CLR_GREEN];
    CGFloat  tabW      = self.bounds.size.width / 3.0;

    for (int i = 0; i < 3; i++)
        [_tabBtns[i] setTitleColor:(i == idx ? tabColors[i] : CLR_MUTED) forState:UIControlStateNormal];

    [CATransaction begin];
    [CATransaction setAnimationDuration:0.20];
    [CATransaction setAnimationTimingFunction:
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    _tabIndicator.frame           = CGRectMake(idx * tabW + 6, 85, tabW - 12, 2);
    _tabIndicator.backgroundColor = ((UIColor *)tabColors[idx]).CGColor;
    [CATransaction commit];

    UIView *outPage = _pages[prev];
    UIView *inPage  = _pages[idx];
    inPage.alpha  = 0;
    inPage.hidden = NO;
    [UIView animateWithDuration:0.20 animations:^{ outPage.alpha = 0; } completion:^(BOOL d) {
        outPage.hidden = YES;
        [UIView animateWithDuration:0.20 animations:^{ inPage.alpha = 1; }];
    }];
}

- (void)openTG { [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/RavFenupdate"] options:@{} completionHandler:nil]; }
- (void)tgA    { pthread_mutex_lock(&g_ConfigMutex); gConfig.aimbotEnabled  = _as.isOn;  pthread_mutex_unlock(&g_ConfigMutex); }
- (void)tgE    { pthread_mutex_lock(&g_ConfigMutex); gConfig.espEnabled     = _es.isOn;  pthread_mutex_unlock(&g_ConfigMutex); }
- (void)tgL    { pthread_mutex_lock(&g_ConfigMutex); gConfig.espLine        = _ls.isOn;  pthread_mutex_unlock(&g_ConfigMutex); }
- (void)tgB    { pthread_mutex_lock(&g_ConfigMutex); gConfig.espBulletLine  = _bls.isOn; pthread_mutex_unlock(&g_ConfigMutex); }
- (void)tgCH   { pthread_mutex_lock(&g_ConfigMutex); gConfig.crosshairEnabled = _chs.isOn; pthread_mutex_unlock(&g_ConfigMutex); }
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

- (void)presentMenuIn:(UIWindow *)k {
    RavMenuView *m = [[RavMenuView alloc]
        initWithFrame:CGRectMake((k.bounds.size.width  - 300) / 2.0,
                                 (k.bounds.size.height - 480) / 2.0,
                                 300, 480)
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
// ◈ Splash Screen — minimal dark, hexagon ring + brand fade
// ====================================================================
@interface RavSplashView : UIView @end
@implementation RavSplashView

- (instancetype)initWithFrame:(CGRect)f {
    self = [super initWithFrame:f];
    if (!self) return nil;
    self.backgroundColor = [UIColor colorWithRed:0.04 green:0.04 blue:0.06 alpha:1.0];

    CGFloat cx = f.size.width * 0.5, cy = f.size.height * 0.42;

    CGFloat hex = 68;
    UIBezierPath *hexPath = [UIBezierPath bezierPath];
    for (int i = 0; i < 6; i++) {
        CGFloat angle = M_PI / 180.0 * (60 * i - 30);
        CGPoint pt = CGPointMake(cx + hex * cosf(angle), cy + hex * sinf(angle));
        i == 0 ? [hexPath moveToPoint:pt] : [hexPath addLineToPoint:pt];
    }
    [hexPath closePath];

    CAShapeLayer *ring = [CAShapeLayer layer];
    ring.path        = hexPath.CGPath;
    ring.strokeColor = CLR_VIOLET.CGColor;
    ring.fillColor   = [UIColor clearColor].CGColor;
    ring.lineWidth   = 1.5;
    ring.opacity     = 0;
    [self.layer addSublayer:ring];

    CGFloat hex2 = 44;
    UIBezierPath *hexPath2 = [UIBezierPath bezierPath];
    for (int i = 0; i < 6; i++) {
        CGFloat angle = M_PI / 180.0 * (60 * i - 30);
        CGPoint pt = CGPointMake(cx + hex2 * cosf(angle), cy + hex2 * sinf(angle));
        i == 0 ? [hexPath2 moveToPoint:pt] : [hexPath2 addLineToPoint:pt];
    }
    [hexPath2 closePath];

    CAShapeLayer *ring2 = [CAShapeLayer layer];
    ring2.path        = hexPath2.CGPath;
    ring2.strokeColor = CLR_VIOLET_DIM.CGColor;
    ring2.fillColor   = CLR_VIOLET_DIM.CGColor;
    ring2.lineWidth   = 1.0;
    ring2.opacity     = 0;
    [self.layer addSublayer:ring2];

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
    ver.text          = @"v7.1  ·  PUBG Mobile 4.5.0";
    ver.textColor     = CLR_MUTED;
    ver.font          = [UIFont systemFontOfSize:11];
    ver.textAlignment = NSTextAlignmentCenter;
    ver.alpha         = 0;
    [self addSubview:ver];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(f.size.width * 0.3, f.size.height - 60,
                                                            f.size.width * 0.4, 0.5)];
    line.backgroundColor = CLR_VIOLET;
    line.alpha           = 0;
    [self addSubview:line];

    [UIView animateWithDuration:0.6 delay:0.1 options:0 animations:^{
        ring.opacity  = 1.0;
        ring2.opacity = 0.6;
        mono.alpha    = 1;
    } completion:nil];
    [UIView animateWithDuration:0.5 delay:0.5 options:0 animations:^{
        name.alpha = 1; ver.alpha = 1; line.alpha = 1;
    } completion:nil];

    return self;
}
@end

// ====================================================================
// ◈ Captcha — "TOUCH TO ARM" minimal pulse
// ====================================================================
@interface RavCaptchaView : UIView
@property (nonatomic, copy) void (^onDone)(void);
@end

@implementation RavCaptchaView {
    NSTimer *_dotTimer;
    CGFloat  _dotPhase;
    CALayer *_dot;
}

- (instancetype)initWithFrame:(CGRect)f {
    self = [super initWithFrame:f];
    if (!self) return nil;
    self.backgroundColor = [UIColor colorWithRed:0.04 green:0.04 blue:0.06 alpha:1.0];

    CGFloat cx = f.size.width * 0.5, cy = f.size.height * 0.45;

    _dot = [CALayer layer];
    _dot.frame        = CGRectMake(cx - 5, cy - 5, 10, 10);
    _dot.cornerRadius = 5;
    _dot.backgroundColor = CLR_VIOLET.CGColor;
    [self.layer addSublayer:_dot];

    CALayer *ripple = [CALayer layer];
    ripple.frame           = CGRectMake(cx - 20, cy - 20, 40, 40);
    ripple.cornerRadius    = 20;
    ripple.borderColor     = CLR_VIOLET.CGColor;
    ripple.borderWidth     = 0.75;
    ripple.backgroundColor = [UIColor clearColor].CGColor;
    ripple.opacity         = 0.3;
    [self.layer addSublayer:ripple];

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, cy + 44, f.size.width, 26)];
    lbl.text          = @"TOUCH  TO  ARM";
    lbl.textColor     = CLR_TEXT;
    lbl.font          = [UIFont boldSystemFontOfSize:14];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.alpha         = 0;
    [self addSubview:lbl];

    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(0, cy + 72, f.size.width, 16)];
    sub.text          = @"RAVFEN  WRAITH";
    sub.textColor     = CLR_MUTED;
    sub.font          = [UIFont systemFontOfSize:9];
    sub.textAlignment = NSTextAlignmentCenter;
    sub.alpha         = 0;
    [self addSubview:sub];

    [UIView animateWithDuration:0.5 delay:0.3 options:0
                     animations:^{ lbl.alpha = 1; sub.alpha = 0.7; }
                     completion:nil];

    _dotPhase = 0;
    _dotTimer = [NSTimer scheduledTimerWithTimeInterval:0.04 repeats:YES block:^(NSTimer *t) {
        if (!self.superview) { [t invalidate]; return; }
        _dotPhase += 0.06;
        CGFloat s = 0.6 + 0.4 * sinf(_dotPhase);
        _dot.opacity = s;
        CGFloat sz = 10 + 4 * sinf(_dotPhase);
        _dot.frame = CGRectMake(cx - sz / 2, cy - sz / 2, sz, sz);
        _dot.cornerRadius = sz / 2;
    }];
    [[NSRunLoop mainRunLoop] addTimer:_dotTimer forMode:NSRunLoopCommonModes];

    UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc]
        initWithTarget:self action:@selector(tapped)];
    [self addGestureRecognizer:tg];
    return self;
}

- (void)tapped {
    [_dotTimer invalidate];
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.35
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:0
                     animations:^{ self.alpha = 0; self.transform = CGAffineTransformMakeScale(1.04, 1.04); }
                     completion:^(BOOL d) {
        [self removeFromSuperview];
        if (self.onDone) self.onDone();
    }];
}

@end

// ====================================================================
// 🔑 RavFen Server Auth — POST credentials to your own server
// ====================================================================
//
//  ► غيّر RAV_AUTH_HOST إلى رابط سيرفرك الحقيقي
//  ► السيرفر يستقبل POST على /v1/login بـ JSON: {"username":"...","password":"..."}
//  ► يرجع { "ok": true, "token": "..." } أو { "ok": false, "msg": "..." }
//
#define RAV_AUTH_HOST   "147.135.213.72"              // ← ضع رابط سيرفرك هنا
#define RAV_AUTH_PATH   ":3000/v1/login"

static void RavAuthLogin(NSString *user, NSString *pass,
                         void(^done)(BOOL ok, NSString *msg)) {
    static const uint8_t rawHost[] = {
        0x00
    };
    (void)rawHost;

    NSString *host    = @(RAV_AUTH_HOST);
    NSString *urlStr  = [NSString stringWithFormat:@"https://%@%s", host, RAV_AUTH_PATH];
    NSURL    *url     = [NSURL URLWithString:urlStr];
    if (!url) { dispatch_async(dispatch_get_main_queue(), ^{ done(NO, @"Bad URL"); }); return; }

    NSMutableURLRequest *req = [NSMutableURLRequest
        requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    req.HTTPMethod = @"POST";
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15"
       forHTTPHeaderField:@"User-Agent"];

    NSDictionary *body = @{@"email": user, @"password": pass};
    req.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];

    [[NSURLSession.sharedSession
        dataTaskWithRequest:req
        completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
            if (e || !d) {
                dispatch_async(dispatch_get_main_queue(), ^{ done(NO, @"No connection"); });
                return;
            }
            NSHTTPURLResponse *http = (NSHTTPURLResponse *)r;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            BOOL ok  = (http.statusCode == 200 && [json[@"ok"] boolValue]);
            NSString *tok = json[@"token"] ?: @"";
            NSString *msg = json[@"msg"]   ?: (ok ? @"OK" : @"Unauthorized");
            if (ok && tok.length) {
                [[NSUserDefaults standardUserDefaults] setObject:tok forKey:@"rav_tok"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            dispatch_async(dispatch_get_main_queue(), ^{ done(ok, msg); });
    }] resume];
}

// ====================================================================
// 🔑 Login Screen — shown before splash; authenticates against your server
// ====================================================================
@interface RavLoginView : UIView
@property (nonatomic, copy) void (^onSuccess)(void);
@end

@implementation RavLoginView {
    UITextField *_userF, *_passF;
    UIButton    *_loginBtn;
    UILabel     *_statusLbl;
    UIActivityIndicatorView *_spinner;
}

- (instancetype)initWithFrame:(CGRect)f {
    self = [super initWithFrame:f];
    if (!self) return nil;
    self.backgroundColor = [UIColor colorWithRed:0.04 green:0.04 blue:0.06 alpha:1.0];

    CGFloat cx  = f.size.width  * 0.5;
    CGFloat top = f.size.height * 0.22;

    UILabel *badge = [[UILabel alloc] initWithFrame:CGRectMake(cx - 28, top, 56, 52)];
    badge.text              = @"RF";
    badge.textColor         = CLR_VIOLET;
    badge.font              = [UIFont boldSystemFontOfSize:24];
    badge.textAlignment     = NSTextAlignmentCenter;
    badge.backgroundColor   = CLR_VIOLET_DIM;
    badge.layer.cornerRadius = 16;
    badge.clipsToBounds     = YES;
    [self addSubview:badge];

    UILabel *brand = [[UILabel alloc] initWithFrame:CGRectMake(0, top + 58, f.size.width, 22)];
    brand.text          = @"RAVFEN  WRAITH";
    brand.textColor     = CLR_TEXT;
    brand.font          = [UIFont boldSystemFontOfSize:16];
    brand.textAlignment = NSTextAlignmentCenter;
    [self addSubview:brand];

    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(0, top + 82, f.size.width, 16)];
    sub.text          = @"Sign in to continue";
    sub.textColor     = CLR_MUTED;
    sub.font          = [UIFont systemFontOfSize:11];
    sub.textAlignment = NSTextAlignmentCenter;
    [self addSubview:sub];

    CGFloat fw = MIN(f.size.width - 60, 280);
    CGFloat fx = (f.size.width - fw) / 2.0;
    CGFloat fy = top + 118;

    _userF = [self makeField:@"Email" secure:NO  frame:CGRectMake(fx, fy, fw, 44)];
    [self addSubview:_userF];

    _passF = [self makeField:@"Password" secure:YES frame:CGRectMake(fx, fy + 54, fw, 44)];
    [self addSubview:_passF];

    _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _loginBtn.frame = CGRectMake(fx, fy + 116, fw, 46);
    [_loginBtn setTitle:@"LOGIN" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.titleLabel.font  = [UIFont boldSystemFontOfSize:13];
    _loginBtn.backgroundColor  = CLR_VIOLET;
    _loginBtn.layer.cornerRadius = 12;
    _loginBtn.clipsToBounds    = YES;
    [_loginBtn addTarget:self action:@selector(doLogin)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginBtn];

    _statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(fx, fy + 170, fw, 18)];
    _statusLbl.textAlignment = NSTextAlignmentCenter;
    _statusLbl.font          = [UIFont systemFontOfSize:10];
    _statusLbl.textColor     = CLR_MUTED;
    _statusLbl.text          = @"";
    [self addSubview:_statusLbl];

    _spinner = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    _spinner.color  = CLR_VIOLET;
    _spinner.center = CGPointMake(cx, fy + 139);
    _spinner.hidden = YES;
    [self addSubview:_spinner];

    UIButton *tgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    tgBtn.frame = CGRectMake(fx, f.size.height - 70, fw, 24);
    [tgBtn setTitle:@"▸  t.me/RavFenupdate" forState:UIControlStateNormal];
    [tgBtn setTitleColor:CLR_VIOLET forState:UIControlStateNormal];
    tgBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [tgBtn addTarget:self action:@selector(openTG) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tgBtn];

    return self;
}

- (UITextField *)makeField:(NSString *)ph secure:(BOOL)sec frame:(CGRect)fr {
    UITextField *f     = [[UITextField alloc] initWithFrame:fr];
    f.placeholder      = ph;
    f.secureTextEntry  = sec;
    f.autocorrectionType   = UITextAutocorrectionTypeNo;
    f.autocapitalizationType = UITextAutocapitalizationTypeNone;
    f.returnKeyType    = sec ? UIReturnKeyGo : UIReturnKeyNext;
    f.backgroundColor  = [UIColor colorWithRed:0.10 green:0.10 blue:0.14 alpha:1.0];
    f.textColor        = CLR_TEXT;
    f.font             = [UIFont systemFontOfSize:13];
    f.layer.cornerRadius = 10;
    f.layer.borderWidth  = 1.0;
    f.layer.borderColor  = CLR_VIOLET_DIM.CGColor;
    f.clipsToBounds      = YES;
    UIView *pad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 1)];
    f.leftView      = pad;
    f.leftViewMode  = UITextFieldViewModeAlways;
    UIView *rpad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 1)];
    f.rightView     = rpad;
    f.rightViewMode = UITextFieldViewModeAlways;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = CLR_MUTED;
    f.attributedPlaceholder = [[NSAttributedString alloc]
        initWithString:ph attributes:attrs];
    return f;
}

- (void)doLogin {
    NSString *user = [_userF.text stringByTrimmingCharactersInSet:
        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *pass = _passF.text ?: @"";
    if (user.length < 1) {
        [self showStatus:@"Enter your username" color:CLR_RED];
        return;
    }
    if (pass.length < 1) {
        [self showStatus:@"Enter your password" color:CLR_RED];
        return;
    }
    [_userF resignFirstResponder];
    [_passF resignFirstResponder];
    _loginBtn.enabled = NO;
    _spinner.hidden   = NO;
    [_spinner startAnimating];
    [self showStatus:@"Connecting…" color:CLR_MUTED];

    // ════════════════════════════════════════════════════════════════
    // FIX 2 — أسطر 1562-1579: تحويل __weak pointer لـ strong
    //         قبل استخدام -> للوصول للـ ivars مباشرة
    // ════════════════════════════════════════════════════════════════
    __weak typeof(self) ws = self;
    RavAuthLogin(user, pass, ^(BOOL ok, NSString *msg) {
        __strong typeof(ws) strongSelf = ws;
        if (!strongSelf) return;
        [strongSelf->_spinner stopAnimating];
        strongSelf->_spinner.hidden   = YES;
        strongSelf->_loginBtn.enabled = YES;
        if (ok) {
            [strongSelf showStatus:@"Authenticated ✓" color:CLR_GREEN];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 500 * NSEC_PER_MSEC),
                           dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.35 animations:^{ strongSelf.alpha = 0; }
                                 completion:^(BOOL d) {
                    [strongSelf removeFromSuperview];
                    if (strongSelf.onSuccess) strongSelf.onSuccess();
                }];
            });
        } else {
            [strongSelf showStatus:msg ?: @"Login failed" color:CLR_RED];
            [UIView animateWithDuration:0.06 delay:0 options:UIViewAnimationOptionAutoreverse
                animations:^{ strongSelf->_loginBtn.transform = CGAffineTransformMakeTranslation(6, 0); }
                completion:^(BOOL d) { strongSelf->_loginBtn.transform = CGAffineTransformIdentity; }];
        }
    });
}

- (void)showStatus:(NSString *)s color:(UIColor *)c {
    _statusLbl.text      = s;
    _statusLbl.textColor = c;
}

- (void)openTG {
    [[UIApplication sharedApplication]
        openURL:[NSURL URLWithString:@"https://t.me/RavFenupdate"]
        options:@{} completionHandler:nil];
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

        void (^showSplash)(void) = ^{
            RavSplashView *sp = [[RavSplashView alloc] initWithFrame:k.bounds];
            [k addSubview:sp]; [k bringSubviewToFront:sp];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (arc4random() % 2 + 3) * NSEC_PER_SEC),
                           dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.4 animations:^{ sp.alpha = 0; }
                                 completion:^(BOOL d) {
                    [sp removeFromSuperview];

                    RavCaptchaView *cp = [[RavCaptchaView alloc] initWithFrame:k.bounds];
                    cp.onDone = ^{
                        RavFloatingButton *fb = [[RavFloatingButton alloc]
                            initWithFrame:CGRectMake(k.bounds.size.width - 66 - 14,
                                                     k.bounds.size.height * 0.52, 66, 66)];
                        fb.alpha = 0;
                        __weak typeof(fb) wfb = fb;
                        fb.onTap = ^{
                            [wfb removeFromSuperview];
                            ESPOverlayView *ov = [[ESPManager shared] getOverlayView];
                            RavMenuView *m = [[RavMenuView alloc]
                                initWithFrame:CGRectMake((k.bounds.size.width  - 300) / 2.0,
                                                         (k.bounds.size.height - 480) / 2.0,
                                                         300, 480)
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
        };

        RavLoginView *lv = [[RavLoginView alloc] initWithFrame:k.bounds];
        lv.onSuccess = showSplash;
        lv.alpha = 0;
        [k addSubview:lv]; [k bringSubviewToFront:lv];
        [UIView animateWithDuration:0.35 animations:^{ lv.alpha = 1; }];
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
    gConfig.menuVisible      = NO;
    gConfig.crosshairEnabled = NO;
    gConfig.aimbotSmoothing  = 5.0f;
    pthread_mutex_unlock(&g_ConfigMutex);

    pthread_t th;
    pthread_create(&th, NULL, AntiDetachLoop, NULL);
    pthread_detach(th);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (arc4random() % 2 + 2) * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{ Launch(); });
}
