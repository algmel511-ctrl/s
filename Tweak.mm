// ====================================================================
// RavFen Shadow v5.3 - PUBG Mobile 4.4.0 iOS Tweak
// Floating Button + Aimbot Speed 150 + ESP ثابت
// ====================================================================

#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <pthread.h>
#import <dlfcn.h>

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
    volatile int32_t aimbotBone;
    volatile BOOL espEnabled;
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
};

enum {
    OFF_GW, OFF_GN, OFF_PL, OFF_AA, OFF_AC, OFF_GI, OFF_LP,
    OFF_PC, OFF_AP, OFF_RC, OFF_RL, OFF_CM, OFF_CC, OFF_CP,
    OFF_CR, OFF_MS, OFF_BA, OFF_HP, OFF_TM, OFF_AD, OFF_CTW,
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
// 👥 GetPlayers - ✅ ESP يشتغل الآن
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
    
    // اللاعب المحلي
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
            } else {
                // Fallback لـ RelativeLocation
                g_LocalX = ReadFloat(root + OFF(OFF_RL));
                g_LocalY = ReadFloat(root + OFF(OFF_RL) + 4);
                g_LocalZ = ReadFloat(root + OFF(OFF_RL) + 8);
            }
        }
    }
    
    int32_t localTeam = 0;
    if (localPawn) {
        localTeam = ReadInt(localPawn + OFF(OFF_TM));
    }
    
    for (int i = 0; i < count; i++) {
        @autoreleasepool {
            uint64_t actor = ReadPtr(actors + i * 8);
            if (!actor || actor == localPawn) continue;
            
            // ✅ IsPlayer تتأكد إنه لاعب وليس Item/Drop
            if (!IsPlayer(actor)) continue;
            
            uint64_t root = ReadPtr(actor + OFF(OFF_RC));
            if (!root) continue;
            
            float ax = 0, ay = 0, az = 0;
            uint64_t ctw = ReadPtr(root + OFF(OFF_CTW));
            if (ctw) {
                ax = ReadFloat(ctw + 0x10);
                ay = ReadFloat(ctw + 0x14);
                az = ReadFloat(ctw + 0x18);
            } else {
                ax = ReadFloat(root + OFF(OFF_RL));
                ay = ReadFloat(root + OFF(OFF_RL) + 4);
                az = ReadFloat(root + OFF(OFF_RL) + 8);
            }
            
            if (ax == 0 && ay == 0 && az == 0) continue;
            
            float dx = ax - g_LocalX;
            float dy = ay - g_LocalY;
            float dz = az - g_LocalZ;
            float dist = sqrtf(dx*dx + dy*dy + dz*dz);
            if (dist < 0.5f) continue;
            
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
            // ✅ العدو: team مختلف أو team == 0 (غير معروف)
            p.isEnemy  = (team != localTeam) || (team == 0);
            p.meshAddr = mesh;
            if (mesh) p.boneAddr = ReadPtr(mesh + OFF(OFF_BA));
            
            [result addObject:p];
        }
    }
    return result;
}

// ====================================================================
// 🎯 Aimbot - سرعة 150
// ====================================================================
static void DoAimbot(void) {
    BOOL enabled = NO;
    float speed  = 5.0f;
    int32_t bone = 0;
    
    pthread_mutex_lock(&g_ConfigMutex);
    enabled = gConfig.aimbotEnabled;
    speed   = gConfig.aimbotSpeed;
    bone    = gConfig.aimbotBone;
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
    float targetH = (bone == 0) ? 1.75f : 0.9f;
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
    
    // ✅ Speed: 1-150, نحولها إلى factor (0.01 - 1.0)
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
// 🖥️ Splash View
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
// Captcha View
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
        desc.text = @"Press anywhere to unlock the RavFen menu";
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
// 🔘 Floating Button - يتحرك، إذا ضغطته تظهر القائمة
// ====================================================================
@interface RavFloatingButton : UIView {
    UILabel *_label;
    UIImageView *_dropImage;
    UIPanGestureRecognizer *_pan;
}
@property (nonatomic, copy) void (^onTap)(void);
@end

@implementation RavFloatingButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // خلفية شفافة مع ظل خفيف
        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.0 blue:1.0 alpha:0.25];
        self.layer.cornerRadius = frame.size.width / 2;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor colorWithRed:0.7 green:0.3 blue:1.0 alpha:0.4].CGColor;
        self.clipsToBounds = NO;
        self.layer.shadowColor = [UIColor purpleColor].CGColor;
        self.layer.shadowOpacity = 0.15;
        self.layer.shadowRadius = 6;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        
        // 🩸 رمز الدم (نقطة حمراء)
        _dropImage = [[UIImageView alloc] init];
        // بدل UIImage نستخدم UILabel للدم
        _dropImage.frame = CGRectMake(6, 5, frame.size.width - 12, frame.size.height - 12);
        _dropImage.layer.cornerRadius = (frame.size.width - 12) / 2;
        _dropImage.backgroundColor = [UIColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:0.5];
        _dropImage.clipsToBounds = YES;
        [self addSubview:_dropImage];
        
        // النص "RavFen"
        _label = [[UILabel alloc] init];
        _label.text = @"R";
        _label.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.9];
        _label.font = [UIFont boldSystemFontOfSize:20];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.frame = self.bounds;
        _label.shadowColor = [UIColor blackColor];
        _label.shadowOffset = CGSizeMake(1, 1);
        [self addSubview:_label];
        
        // ✅ السحب (Drag)
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:_pan];
        
        // ✅ الضغط (Tap)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    UIView *superview = self.superview;
    if (!superview) return;
    
    CGPoint translation = [gesture translationInView:superview];
    CGPoint center = self.center;
    center.x += translation.x;
    center.y += translation.y;
    
    // حدود الشاشة
    CGFloat halfW = self.bounds.size.width / 2;
    CGFloat halfH = self.bounds.size.height / 2;
    center.x = MAX(halfW, MIN(superview.bounds.size.width - halfW, center.x));
    center.y = MAX(halfH, MIN(superview.bounds.size.height - halfH, center.y));
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        self.center = center;
        [gesture setTranslation:CGPointZero inView:superview];
    }
}

- (void)handleTap {
    if (self.onTap) self.onTap();
}

@end

// ====================================================================
// 📋 Menu View
// ====================================================================
@interface RavMenuView : UIView {
    dispatch_queue_t _bgQueue;
    NSTimer *_loopTimer;
    UILabel *_playerCountLabel;
    UISlider *_speedSlider, *_distSlider;
    UILabel *_speedValLabel, *_distValLabel;
    UISwitch *_aimbotSwitch, *_espSwitch;
    UIButton *_boneBtn;
}
@end

@implementation RavMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _bgQueue = dispatch_queue_create("com.ravfen.bg", DISPATCH_QUEUE_SERIAL);
        self.backgroundColor = [UIColor colorWithRed:0.06 green:0.06 blue:0.12 alpha:0.94];
        self.layer.cornerRadius = 18;
        self.layer.borderWidth = 1.5;
        self.layer.borderColor = [UIColor colorWithRed:0.5 green:0.0 blue:1.0 alpha:0.7].CGColor;
        self.clipsToBounds = YES;
        [self buildUI];
        [self startLoop];
    }
    return self;
}

- (void)buildUI {
    CGFloat w = self.bounds.size.width - 30, x = 15, y = 20, mw = self.bounds.size.width;
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w, 28)];
    header.text = @"RavFen Shadow v5.3";
    header.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0];
    header.font = [UIFont boldSystemFontOfSize:20];
    header.textAlignment = NSTextAlignmentCenter;
    [self addSubview:header];
    
    // زر إخفاء مؤقت (بدل Close)
    UIButton *hideBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    hideBtn.frame = CGRectMake(mw - 42, 8, 32, 32);
    hideBtn.backgroundColor = [UIColor colorWithRed:0.3 green:0.0 blue:0.0 alpha:0.5];
    hideBtn.layer.cornerRadius = 16;
    [hideBtn setTitle:@"✕" forState:UIControlStateNormal];
    [hideBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [hideBtn addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hideBtn];
    
    y += 45;
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, y, w, 1)];
    line1.backgroundColor = [UIColor colorWithRed:0.25 green:0.2 blue:0.35 alpha:0.6];
    [self addSubview:line1];
    y += 12;
    
    // Aimbot
    UILabel *secAim = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 150, 22)];
    secAim.text = @"Aimbot"; secAim.textColor = [UIColor whiteColor];
    secAim.font = [UIFont boldSystemFontOfSize:16]; [self addSubview:secAim];
    
    _aimbotSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(mw - 70, y, 50, 22)];
    _aimbotSwitch.onTintColor = [UIColor purpleColor]; _aimbotSwitch.on = YES;
    [_aimbotSwitch addTarget:self action:@selector(toggleAimbot) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_aimbotSwitch];
    y += 28;
    
    UILabel *spLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 120, 16)];
    spLbl.text = @"Speed (1-150):"; spLbl.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.7 alpha:1.0];
    spLbl.font = [UIFont systemFontOfSize:12]; [self addSubview:spLbl];
    
    _speedValLabel = [[UILabel alloc] initWithFrame:CGRectMake(w-55, y, 50, 16)];
    _speedValLabel.text = @"75"; _speedValLabel.textColor = [UIColor whiteColor];
    _speedValLabel.font = [UIFont systemFontOfSize:12]; _speedValLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_speedValLabel];
    y += 18;
    
    _speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(15, y, w, 28)];
    _speedSlider.minimumValue = 1;
    _speedSlider.maximumValue = 150;
    _speedSlider.value = 75;
    _speedSlider.tintColor = [UIColor purpleColor];
    [_speedSlider addTarget:self action:@selector(speedChanged) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_speedSlider];
    y += 32;
    
    UILabel *bnLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 120, 16)];
    bnLbl.text = @"Bone:"; bnLbl.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.7 alpha:1.0];
    bnLbl.font = [UIFont systemFontOfSize:12]; [self addSubview:bnLbl];
    
    _boneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _boneBtn.frame = CGRectMake(w - 115, y - 3, 110, 28);
    _boneBtn.backgroundColor = [UIColor colorWithRed:0.2 green:0.15 blue:0.3 alpha:1.0];
    _boneBtn.layer.cornerRadius = 8;
    [_boneBtn setTitle:@"Head" forState:UIControlStateNormal];
    [_boneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _boneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [_boneBtn addTarget:self action:@selector(switchBone) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_boneBtn];
    y += 38;
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, y, w, 1)];
    line2.backgroundColor = [UIColor colorWithRed:0.25 green:0.2 blue:0.35 alpha:0.6];
    [self addSubview:line2];
    y += 10;
    
    // ESP
    UILabel *secEsp = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 150, 22)];
    secEsp.text = @"ESP"; secEsp.textColor = [UIColor whiteColor];
    secEsp.font = [UIFont boldSystemFontOfSize:16]; [self addSubview:secEsp];
    
    _espSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(mw - 70, y, 50, 22)];
    _espSwitch.onTintColor = [UIColor purpleColor]; _espSwitch.on = YES;
    [_espSwitch addTarget:self action:@selector(toggleESP) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_espSwitch];
    y += 28;
    
    UILabel *dsLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 120, 16)];
    dsLbl.text = @"Distance:"; dsLbl.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.7 alpha:1.0];
    dsLbl.font = [UIFont systemFontOfSize:12]; [self addSubview:dsLbl];
    
    _distValLabel = [[UILabel alloc] initWithFrame:CGRectMake(w-55, y, 50, 16)];
    _distValLabel.text = @"150m"; _distValLabel.textColor = [UIColor whiteColor];
    _distValLabel.font = [UIFont systemFontOfSize:12]; _distValLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_distValLabel];
    y += 18;
    
    _distSlider = [[UISlider alloc] initWithFrame:CGRectMake(15, y, w, 28)];
    _distSlider.minimumValue = 50; _distSlider.maximumValue = 350; _distSlider.value = 150;
    _distSlider.tintColor = [UIColor greenColor];
    [_distSlider addTarget:self action:@selector(distChanged) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_distSlider];
    y += 32;
    
    _playerCountLabel = [[UILabel alloc] init];
    _playerCountLabel.text = @"Nearby Enemies: 0";
    _playerCountLabel.textColor = [UIColor colorWithRed:0.4 green:1.0 blue:0.4 alpha:1.0];
    _playerCountLabel.font = [UIFont systemFontOfSize:12];
    [_playerCountLabel sizeToFit];
    _playerCountLabel.frame = CGRectMake(x, y, w, 18);
    [self addSubview:_playerCountLabel];
}

// ✅ Hide Menu (يخفي القائمة ويرجع الفلوتينق)
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
        
        // إظهار الفلوتينق بوتن
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *key = nil;
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    key = scene.windows.firstObject; break;
                }
            }
            if (!key) return;
            
            // نتأكد ما في فلوتينق موجود
            for (UIView *v in key.subviews) {
                if ([v isKindOfClass:[RavFloatingButton class]]) return;
            }
            
            CGFloat btnSize = 45;
            CGFloat fx = key.bounds.size.width - btnSize - 15;
            CGFloat fy = key.bounds.size.height * 0.55;
            
            RavFloatingButton *fb = [[RavFloatingButton alloc] initWithFrame:CGRectMake(fx, fy, btnSize, btnSize)];
            fb.alpha = 0;
            fb.onTap = ^{
                // إخفاء الفلوتينق وإظهار القائمة
                [fb removeFromSuperview];
                [self showMenuAgain];
            };
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
        
        CGFloat mw = 290, mh = 380;
        CGFloat mx = (key.bounds.size.width - mw) / 2;
        CGFloat my = (key.bounds.size.height - mh) / 2;
        
        RavMenuView *menu = [[RavMenuView alloc] initWithFrame:CGRectMake(mx, my - 20, mw, mh)];
        menu.alpha = 0;
        menu.transform = CGAffineTransformMakeScale(0.85, 0.85);
        [key addSubview:menu];
        [key bringSubviewToFront:menu];
        
        pthread_mutex_lock(&g_ConfigMutex);
        gConfig.menuVisible = YES;
        pthread_mutex_unlock(&g_ConfigMutex);
        
        [UIView animateWithDuration:0.35 delay:0
              usingSpringWithDamping:0.7 initialSpringVelocity:0.6
                            options:0 animations:^{ menu.alpha = 1; menu.transform = CGAffineTransformIdentity; }
                        completion:nil];
    });
}

- (void)toggleAimbot { pthread_mutex_lock(&g_ConfigMutex); gConfig.aimbotEnabled = _aimbotSwitch.isOn; pthread_mutex_unlock(&g_ConfigMutex); }
- (void)toggleESP    { pthread_mutex_lock(&g_ConfigMutex); gConfig.espEnabled = _espSwitch.isOn; pthread_mutex_unlock(&g_ConfigMutex); }

- (void)switchBone {
    pthread_mutex_lock(&g_ConfigMutex);
    gConfig.aimbotBone = !gConfig.aimbotBone;
    int32_t bone = gConfig.aimbotBone;
    pthread_mutex_unlock(&g_ConfigMutex);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_boneBtn setTitle:(bone == 0 ? @"Head" : @"Body") forState:UIControlStateNormal];
    });
}

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
            float espDist = 150.0f;
            pthread_mutex_lock(&g_ConfigMutex);
            espOn = gConfig.espEnabled;
            espDist = gConfig.espDistance;
            pthread_mutex_unlock(&g_ConfigMutex);
            
            if (espOn) {
                NSArray *players = GetPlayers();
                int cnt = 0;
                for (PlayerData *p in players) {
                    if (p.isEnemy && p.isAlive && p.distance <= espDist)
                        cnt++;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    ss->_playerCountLabel.text = [NSString stringWithFormat:@"Nearby Enemies: %d", cnt];
                });
            }
        });
    }];
    [[NSRunLoop mainRunLoop] addTimer:_loopTimer forMode:NSRunLoopCommonModes];
}

- (void)dealloc { [_loopTimer invalidate]; }
@end

// ====================================================================
// 🚀 Launch
// ====================================================================
static void LaunchRavFen(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *key = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                key = scene.windows.firstObject;
                break;
            }
        }
        if (!key) return;
        
        // 1. Splash
        RavSplashView *splash = [[RavSplashView alloc] initWithFrame:key.bounds];
        [key addSubview:splash];
        [key bringSubviewToFront:splash];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.3 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4 animations:^{ splash.alpha = 0; }
            completion:^(BOOL f) {
                [splash removeFromSuperview];
                
                // 2. Captcha
                RavCaptchaView *captcha = [[RavCaptchaView alloc] initWithFrame:key.bounds];
                captcha.onDone = ^{
                    // 3. بعد الكابتشا → فلوتينق بوتن مباشرة
                    CGFloat btnSize = 45;
                    CGFloat fx = key.bounds.size.width - btnSize - 15;
                    CGFloat fy = key.bounds.size.height * 0.55;
                    
                    RavFloatingButton *fb = [[RavFloatingButton alloc] initWithFrame:CGRectMake(fx, fy, btnSize, btnSize)];
                    fb.alpha = 0;
                    fb.onTap = ^{
                        [fb removeFromSuperview];
                        
                        // إظهار القائمة
                        CGFloat mw = 290, mh = 380;
                        CGFloat mx = (key.bounds.size.width - mw) / 2;
                        CGFloat my = (key.bounds.size.height - mh) / 2;
                        
                        for (UIView *v in key.subviews) {
                            if ([v isKindOfClass:[RavMenuView class]]) return;
                        }
                        
                        RavMenuView *menu = [[RavMenuView alloc] initWithFrame:CGRectMake(mx, my - 20, mw, mh)];
                        menu.alpha = 0;
                        menu.transform = CGAffineTransformMakeScale(0.85, 0.85);
                        [key addSubview:menu];
                        [key bringSubviewToFront:menu];
                        
                        pthread_mutex_lock(&g_ConfigMutex);
                        gConfig.menuVisible = YES;
                        pthread_mutex_unlock(&g_ConfigMutex);
                        
                        [UIView animateWithDuration:0.35 delay:0
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
    gConfig.aimbotEnabled = YES;
    gConfig.aimbotSpeed = 75.0f; // سرعة متوسطة
    gConfig.aimbotBone = 0;
    gConfig.espEnabled = YES;
    gConfig.espDistance = 150.0f;
    gConfig.menuVisible = NO; // تبدأ مخفية، الفلوتينق يظهر
    pthread_mutex_unlock(&g_ConfigMutex);
    
    pthread_t th;
    pthread_create(&th, NULL, AntiDetachLoop, NULL);
    pthread_detach(th);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{ LaunchRavFen(); });
}
