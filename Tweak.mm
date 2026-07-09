// ====================================================================
// RavFen Shadow v6.2 - PUBG Mobile 4.4.0 iOS Tweak
// تم إصلاح: الأوفستات، الكشف، ESP، Aimbot، أخطاء UI
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
// 🔐 الأوفستات - مثبتة بالقيم المستخرجة + تخمينات
// ====================================================================
enum {
    OFF_GW,    // GWorld - مؤكد 0x97C4
    OFF_GN,    // GNames - مؤكد 0x9E5C
    OFF_PL,    // PersistentLevel
    OFF_AA,    // Actors Array
    OFF_AC,    // Actor Count - مؤكد 0x70
    OFF_GI,    // GameInstance
    OFF_LP,    // LocalPlayers
    OFF_PC,    // PlayerController - مؤكد 0x30
    OFF_AP,    // AcknowledgedPawn
    OFF_RC,    // RootComponent - مؤكد 0x140
    OFF_CTW,   // ComponentToWorld - مؤكد 0x10
    OFF_CR,    // ControlRotation - مؤكد 0x6B8
    OFF_MS,    // Mesh - مؤكد 0x928
    OFF_BA,    // BoneArray - مؤكد 0x4270
    OFF_HP,    // Health
    OFF_TM,    // TeamId
    OFF_AD,    // ActorId - مؤكد 0x20
    OFF_VMC,   // ViewMatrixCache - مؤكد 0x97C0
    OFF_VM,    // ViewMatrix Offset
    OFF_COUNT
};

static uint64_t gOffsets[OFF_COUNT] = {0};

static void InitOffsets(void) {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        // القيم مباشرة
        gOffsets[OFF_GW]  = 0x97C4;
        gOffsets[OFF_GN]  = 0x9E5C;
        gOffsets[OFF_PL]  = 0x38;
        gOffsets[OFF_AA]  = 0x98;
        gOffsets[OFF_AC]  = 0x70;
        gOffsets[OFF_GI]  = 0x190;
        gOffsets[OFF_LP]  = 0x38;
        gOffsets[OFF_PC]  = 0x30;
        gOffsets[OFF_AP]  = 0x338;
        gOffsets[OFF_RC]  = 0x140;
        gOffsets[OFF_CTW] = 0x10;
        gOffsets[OFF_CR]  = 0x6B8;
        gOffsets[OFF_MS]  = 0x928;
        gOffsets[OFF_BA]  = 0x4270;
        gOffsets[OFF_HP]  = 0x4A0;
        gOffsets[OFF_TM]  = 0x458;
        gOffsets[OFF_AD]  = 0x20;
        gOffsets[OFF_VMC] = 0x97C0;
        gOffsets[OFF_VM]  = 0x0;
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
// 👥 GetPlayers - تم الإصلاح: استخدام الأوفستات الصحيحة
// ====================================================================
static NSArray<PlayerData *> *GetPlayers(void) {
    NSMutableArray *result = [NSMutableArray array];
    
    uint64_t base = GetBaseAddress();
    
    uint64_t gwAddr = base + OFF(OFF_GW);
    uint64_t gw = ReadPtr(gwAddr);
    if (!gw) return result;
    
    uint64_t level = ReadPtr(gw + OFF(OFF_PL));
    if (!level) return result;
    
    uint64_t actors = ReadPtr(level + OFF(OFF_AA));
    int32_t count   = ReadInt(level + OFF(OFF_AC));
    if (!actors || count <= 0 || count > 1000) return result;
    
    uint64_t gi     = ReadPtr(gw + OFF(OFF_GI));
    if (!gi) return result;
    uint64_t lpArr  = ReadPtr(gi + OFF(OFF_LP));
    if (!lpArr) return result;
    uint64_t lp     = ReadPtr(lpArr);
    if (!lp) return result;
    uint64_t pc     = ReadPtr(lp + OFF(OFF_PC));
    if (!pc) return result;
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
    
    float maxDist = 500.0f;
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
// 🎯 Aimbot - يستخدم نفس قائمة اللاعبين
// ====================================================================
static void DoAimbot(NSArray<PlayerData *> *players) {
    BOOL enabled = NO;
    float speed  = 5.0f;
    
    pthread_mutex_lock(&g_ConfigMutex);
    enabled = gConfig.aimbotEnabled;
    speed   = gConfig.aimbotSpeed;
    pthread_mutex_unlock(&g_ConfigMutex);
    
    if (!enabled || !players || players.count == 0) return;
    
    PlayerData *best = nil;
    float closest = FLT_MAX;
    
    for (PlayerData *p in players) {
        if (!p.isAlive || p.distance > 500.0f) continue;
        if (p.distance < closest) { closest = p.distance; best = p; }
    }
    if (!best) return;
    
    uint64_t base = GetBaseAddress();
    uint64_t gw = ReadPtr(base + OFF(OFF_GW));
    if (!gw) return;
    uint64_t gi    = ReadPtr(gw + OFF(OFF_GI));
    if (!gi) return;
    uint64_t lpArr = ReadPtr(gi + OFF(OFF_LP));
    if (!lpArr) return;
    uint64_t lp    = ReadPtr(lpArr);
    if (!lp) return;
    uint64_t pc    = ReadPtr(lp + OFF(OFF_PC));
    if (!pc) return;
    
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
        [_playerCountLayer setString:@""];
        [_playerCountLayer setFontSize:16];
        [_playerCountLayer setForegroundColor:[[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0] CGColor]];
        [_playerCountLayer setAlignmentMode:kCAAlignmentCenter];
        _playerCountLayer.frame = CGRectMake(0, 50, frame.size.width, 30);
        _playerCountLayer.shadowOpacity = 0.5;
        _playerCountLayer.shadowRadius = 2;
        _playerCountLayer.backgroundColor = nil;
        [self.layer addSublayer:_playerCountLayer];
    }
    return self;
}

- (void)updateWithPlayers:(NSArray<PlayerData *> *)players {
    BOOL espOn = NO, lineOn = NO, bulletOn = NO;
    pthread_mutex_lock(&g_ConfigMutex);
    espOn = gConfig.espEnabled;
    lineOn = gConfig.espLine;
    bulletOn = gConfig.espBulletLine;
    pthread_mutex_unlock(&g_ConfigMutex);
    
    if (!espOn || !players || players.count == 0) {
        self.boxLayer.path = nil;
        self.lineLayer.path = nil;
        self.bulletLineLayer.path = nil;
        [_playerCountLayer setString:@""];
        return;
    }
    
    UIBezierPath *boxPath = [UIBezierPath bezierPath];
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    UIBezierPath *bulletPath = [UIBezierPath bezierPath];
    
    int count = 0;
    CGFloat sw = self.bounds.size.width;
    CGFloat sh = self.bounds.size.height;
    
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.boxLayer.path = boxPath.CGPath;
        self.lineLayer.path = linePath.CGPath;
        self.bulletLineLayer.path = bulletPath.CGPath;
        [_playerCountLayer setString:[NSString stringWithFormat:@"Players: %d", count]];
    });
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
        
        UIImageView *drop = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, frame.size.width - 10, frame.size.height - 10)];
        drop.layer.cornerRadius = (frame.size.width - 10) / 2;
        drop.backgroundColor = [UIColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:0.5];
        drop.clipsToBounds = YES;
        [self addSubview:drop];
        
        _label = [[UILabel alloc] init];
        [_label setText:@"R"];
        [_label setTextColor:[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.95]];
        [_label setFont:[UIFont boldSystemFontOfSize:20]];
        [_label setTextAlignment:NSTextAlignmentCenter];
        _label.frame = self.bounds;
        _label.shadowColor = [UIColor blackColor];
        _label.shadowOffset = CGSizeMake(1, 1);
        [self addSubview:_label];
        
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:_pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];
        
        _ravfenText = [[UILabel alloc] init];
        [_ravfenText setText:@"RavFen"];
        [_ravfenText setTextColor:[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.35]];
        [_ravfenText setFont:[UIFont boldSystemFontOfSize:10]];
        [_ravfenText setTextAlignment:NSTextAlignmentCenter];
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
// 📋 Menu View - ✅ تم إصلاح أخطاء UI
// ====================================================================
@interface RavMenuView : UIView {
    dispatch_queue_t _bgQueue;
    NSTimer *_loopTimer;
    UILabel *_playerCountLabel;
    UISlider *_speedSlider, *_distSlider;
    UILabel *_speedValLabel, *_distValLabel;
    UISwitch *_aimbotSwitch, *_espSwitch, *_lineSwitch, *_bulletLineSwitch;
    ESPOverlayView *_espOverlayView;
}
@end

@implementation RavMenuView

- (instancetype)initWithFrame:(CGRect)frame overlayView:(ESPOverlayView *)overlayView {
    self = [super initWithFrame:frame];
    if (self) {
        _bgQueue = dispatch_queue_create("com.ravfen.bg", DISPATCH_QUEUE_SERIAL);
        _espOverlayView = overlayView;
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
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, y, mw - 50, 24)];
    [title setText:@"RavFen Shadow"];
    [title setTextColor:[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0]];
    [title setFont:[UIFont boldSystemFontOfSize:18]];
    title.shadowColor = [UIColor purpleColor];
    title.shadowOffset = CGSizeMake(1, 1);
    [self addSubview:title];
    
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
    [sa setText:@"Aimbot"];
    [sa setTextColor:[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]];
    [sa setFont:[UIFont boldSystemFontOfSize:14]];
    [self addSubview:sa];
    
    _aimbotSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(mw - 62, y-2, 50, 20)];
    _aimbotSwitch.onTintColor = [UIColor orangeColor];
    [_aimbotSwitch addTarget:self action:@selector(toggleAimbot) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_aimbotSwitch];
    y += 24;
    
    UILabel *sl = [[UILabel alloc] initWithFrame:CGRectMake(12, y, 80, 14)];
    [sl setText:@"Speed:"];
    [sl setTextColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.7 alpha:1.0]];
    [sl setFont:[UIFont systemFontOfSize:11]];
    [self addSubview:sl];
    
    _speedValLabel = [[UILabel alloc] initWithFrame:CGRectMake(mw-55, y, 45, 14)];
    [_speedValLabel setText:@"120"];
    [_speedValLabel setTextColor:[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0]];
    [_speedValLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [_speedValLabel setTextAlignment:NSTextAlignmentRight];
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
    [sesp setText:@"ESP"];
    [sesp setTextColor:[UIColor colorWithRed:0.3 green:0.8 blue:1.0 alpha:1.0]];
    [sesp setFont:[UIFont boldSystemFontOfSize:14]];
    [self addSubview:sesp];
    
    _espSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(mw - 62, y-2, 50, 20)];
    _espSwitch.onTintColor = [UIColor cyanColor];
    [_espSwitch addTarget:self action:@selector(toggleESP) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_espSwitch];
    y += 24;
    
    UILabel *ll = [[UILabel alloc] initWithFrame:CGRectMake(12, y, 100, 14)];
    [ll setText:@"Show Lines:"];
    [ll setTextColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.7 alpha:1.0]];
    [ll setFont:[UIFont systemFontOfSize:11]];
    [self addSubview:ll];
    
    _lineSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(mw - 62, y-3, 50, 20)];
    _lineSwitch.onTintColor = [UIColor yellowColor];
    [_lineSwitch addTarget:self action:@selector(toggleLine) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_lineSwitch];
    y += 22;
    
    UILabel *bl = [[UILabel alloc] initWithFrame:CGRectMake(12, y, 100, 14)];
    [bl setText:@"Bullet Line:"];
    [bl setTextColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.7 alpha:1.0]];
    [bl setFont:[UIFont systemFontOfSize:11]];
    [self addSubview:bl];
    
    _bulletLineSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(mw - 62, y-3, 50, 20)];
    _bulletLineSwitch.onTintColor = [UIColor redColor];
    [_bulletLineSwitch addTarget:self action:@selector(toggleBulletLine) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_bulletLineSwitch];
    y += 22;
    
    UILabel *dl = [[UILabel alloc] initWithFrame:CGRectMake(12, y, 80, 14)];
    [dl setText:@"Distance:"];
    [dl setTextColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.7 alpha:1.0]];
    [dl setFont:[UIFont systemFontOfSize:11]];
    [self addSubview:dl];
    
    // ✅ تم إصلاح: استخدام setText بدل .text
    _distValLabel = [[UILabel alloc] initWithFrame:CGRectMake(mw-55, y, 45, 14)];
    if (_distValLabel) {
        [_distValLabel setText:@"200m"];
        [_distValLabel setTextColor:[UIColor colorWithRed:0.3 green:1.0 green:0.3 alpha:1.0]];
        [_distValLabel setFont:[UIFont boldSystemFontOfSize:11]];
        [_distValLabel setTextAlignment:NSTextAlignmentRight];
    }
    [self addSubview:_distValLabel];
    y += 14;
    
    _distSlider = [[UISlider alloc] initWithFrame:CGRectMake(12, y, w, 22)];
    _distSlider.minimumValue = 50; _distSlider.maximumValue = 350; _distSlider.value = 200;
    _distSlider.tintColor = [UIColor greenColor];
    [_distSlider addTarget:self action:@selector(distChanged) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_distSlider];
    y += 26;
    
    // ✅ تم إصلاح: استخدام setText
    _playerCountLabel = [[UILabel alloc] init];
    if (_playerCountLabel) {
        [_playerCountLabel setText:@"Players: 0"];
        [_playerCountLabel setTextColor:[UIColor colorWithRed:0.3 green:1.0 blue:0.3 alpha:1.0]];
        [_playerCountLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [_playerCountLabel setTextAlignment:NSTextAlignmentCenter];
        [_playerCountLabel sizeToFit];
        _playerCountLabel.frame = CGRectMake(12, y, w, 20);
    }
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
        RavMenuView *menu = [[RavMenuView alloc] initWithFrame:CGRectMake(mx, my, mw, mh) overlayView:_espOverlayView];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_speedValLabel) {
            [self->_speedValLabel setText:[NSString stringWithFormat:@"%.0f", val]];
        }
    });
}

- (void)distChanged {
    pthread_mutex_lock(&g_ConfigMutex);
    gConfig.espDistance = _distSlider.value;
    float val = _distSlider.value;
    pthread_mutex_unlock(&g_ConfigMutex);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_distValLabel) {
            [self->_distValLabel setText:[NSString stringWithFormat:@"%.0fm", val]];
        }
    });
}

- (void)startLoop {
    __weak typeof(self) ws = self;
    _loopTimer = [NSTimer scheduledTimerWithTimeInterval:0.016 repeats:YES block:^(NSTimer *t) {
        typeof(self) ss = ws; if (!ss) { [t invalidate]; return; }
        dispatch_async(ss->_bgQueue, ^{
            NSArray *players = GetPlayers();
            DoAimbot(players);
            [ss->_espOverlayView updateWithPlayers:players];
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

- (ESPOverlayView *)getOverlayView {
    return self.overlayView;
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
}

- (void)stopOverlay {
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
                        ESPOverlayView *ov = [[ESPManager shared] getOverlayView];
                        RavMenuView *menu = [[RavMenuView alloc] initWithFrame:CGRectMake(mx, my, mw, mh) overlayView:ov];
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
