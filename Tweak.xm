// ====================================================================
// RavFen Shadow v8.2 – PUBG Mobile 4.5.0 TW
// No SDK | Direct Memory Pointers | Aimbot & ESP Only
// ====================================================================

#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <pthread.h>
#import <dlfcn.h>
#import <math.h>
#import <sys/sysctl.h>
#import <unistd.h>

// ====================================================================
// 📍 Base Address (ASLR‑safe)
// ====================================================================
static uint64_t gBase = 0;
static inline uint64_t GetBaseAddress(void) {
    if (gBase == 0) gBase = (uint64_t)_dyld_get_image_header(0);
    return gBase;
}

// ====================================================================
// 🔑 Global absolute addresses (TW 4.5)
// ====================================================================
#define ADDR_ACTORARRAY     0x106419D7C   // pointer to TArray<AActor*>
#define ADDR_GNAMES_PTR     0x1050C4AB4   // pointer to FNamePool
#define ADDR_VIEWMATRIX     0x106367344   // 4x4 view‑projection matrix (float[16])

// Offsets (hardcoded, valid for 4.5 TW)
#define OFFSET_ACTORID      0x18
#define OFFSET_HEALTH       0xE60
#define OFFSET_TEAMID       0x998
#define OFFSET_ROOTCOMP     0x208
#define OFFSET_LOCATION     0x1E4        // RelativeLocation inside RootComponent
#define OFFSET_bDEAD        0xE7C
#define OFFSET_bLOCALPC     0x0810       // bIsLocalPlayerController

// ====================================================================
// 🧵 Config
// ====================================================================
static pthread_mutex_t g_Mutex = PTHREAD_MUTEX_INITIALIZER;

typedef enum { Target_Head = 0, Target_Body = 1, Target_Random = 2 } AimTarget;

typedef struct {
    volatile BOOL   aimbotEnabled;
    volatile float  aimbotSpeed;          // 50–250
    volatile AimTarget aimTarget;
    volatile BOOL   espEnabled, espLines, espBoxes;
} RavConfig;

static RavConfig gConfig = {0};

// ====================================================================
// 🌐 Globals
// ====================================================================
static float g_ViewMatrix[16] = {0};
static float g_LocalX, g_LocalY, g_LocalZ;
static int32_t g_LocalTeam = 0;
static uint64_t g_LocalPC = 0;
static BOOL g_InGame = NO;

// ====================================================================
// 🛡️ Anti‑detection helpers
// ====================================================================
static void RandomDelay(void) {
    usleep(arc4random() % 1500 + 500); // 0.5–2 ms
}

static void RandomThreadName(void) {
    pthread_setname_np("com.apple.CoreMotion.motionUpdate");
}

// ====================================================================
// 👤 IsPlayer (GNames direct memory)
// ====================================================================
static BOOL IsPlayer(uint64_t Actor) {
    if (!Actor) return NO;

    uint64_t GNamesBase = *(uint64_t*)(GetBaseAddress() + ADDR_GNAMES_PTR);
    if (!GNamesBase) return NO;

    int32_t ActorId = *(int32_t*)(Actor + OFFSET_ACTORID);
    if (ActorId <= 0 || ActorId > 10000000) return NO;

    uint32_t ChunkIdx = ActorId / 0x3FE0;
    uint32_t NameIdx  = ActorId % 0x3FE0;
    uint64_t Chunk = ((uint64_t*)GNamesBase)[ChunkIdx];
    if (!Chunk) return NO;

    uint64_t Entry = Chunk + NameIdx * 48;
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
// 👥 PlayerData
// ====================================================================
@interface PlayerData : NSObject
@property (nonatomic) uint64_t address;
@property (nonatomic) float x, y, z, health, distance;
@property (nonatomic) BOOL isEnemy, isAlive;
@property (nonatomic) int32_t teamId;
@end
@implementation PlayerData @end

// ====================================================================
// 🔄 Core Game Loop (Aimbot + ESP)
// ====================================================================
static void GameLoop(void) {
    uint64_t base = GetBaseAddress();
    RandomDelay();

    // 1. Read ViewMatrix
    memcpy(g_ViewMatrix, (void*)(base + ADDR_VIEWMATRIX), 64);

    // 2. Get Actor Array
    uint64_t ActorArrayPtr = *(uint64_t*)(base + ADDR_ACTORARRAY);
    if (!ActorArrayPtr) return;
    int32_t actorCount = *(int32_t*)(ActorArrayPtr + 8); // TArray::Num()
    if (actorCount <= 0 || actorCount > 5000) return;

    g_InGame = (actorCount > 120);

    // ── Find local PlayerController ──────────────────────────
    g_LocalPC = 0;
    for (int i = 0; i < actorCount; ++i) {
        uint64_t actor = *(uint64_t*)(ActorArrayPtr + i * 8);
        if (!actor) continue;
        int32_t ActorId = *(int32_t*)(actor + OFFSET_ACTORID);
        if (ActorId <= 0) continue;
        uint64_t GNamesBase = *(uint64_t*)(base + ADDR_GNAMES_PTR);
        uint32_t ChunkIdx = ActorId / 0x3FE0;
        uint32_t NameIdx  = ActorId % 0x3FE0;
        uint64_t Chunk = ((uint64_t*)GNamesBase)[ChunkIdx];
        if (!Chunk) continue;
        uint64_t Entry = Chunk + NameIdx * 48;
        char Name[24] = {0};
        memcpy(Name, (void*)(Entry + 8), 20);
        if (strstr(Name, "PlayerController")) {
            bool bIsLocal = *(bool*)(actor + OFFSET_bLOCALPC);
            if (bIsLocal) {
                g_LocalPC = actor;
                break;
            }
        }
    }

    // ── Get local Pawn ───────────────────────────────────────
    uint64_t LocalPawn = 0;
    if (g_LocalPC) {
        LocalPawn = *(uint64_t*)(g_LocalPC + 0x528); // AcknowledgedPawn
        if (!LocalPawn) LocalPawn = *(uint64_t*)(g_LocalPC + 0x518); // Character
    }
    if (LocalPawn) {
        uint64_t Root = *(uint64_t*)(LocalPawn + OFFSET_ROOTCOMP);
        if (Root) {
            g_LocalX = *(float*)(Root + OFFSET_LOCATION);
            g_LocalY = *(float*)(Root + OFFSET_LOCATION + 4);
            g_LocalZ = *(float*)(Root + OFFSET_LOCATION + 8);
        }
        g_LocalTeam = *(int32_t*)(LocalPawn + OFFSET_TEAMID);
    }

    // ── Collect enemy players ────────────────────────────────
    NSMutableArray<PlayerData*>* players = [NSMutableArray array];
    float maxDist = 500.0f;
    pthread_mutex_lock(&g_Mutex);
    maxDist = gConfig.espDistance ? gConfig.espDistance : 500.0f;
    pthread_mutex_unlock(&g_Mutex);

    for (int i = 0; i < actorCount; ++i) {
        uint64_t actor = *(uint64_t*)(ActorArrayPtr + i * 8);
        if (!actor || actor == LocalPawn) continue;
        if (!IsPlayer(actor)) continue;

        float Health = *(float*)(actor + OFFSET_HEALTH);
        if (Health <= 0.0f || *(bool*)(actor + OFFSET_bDEAD)) continue;

        int32_t Team = *(int32_t*)(actor + OFFSET_TEAMID);
        uint64_t Root = *(uint64_t*)(actor + OFFSET_ROOTCOMP);
        if (!Root) continue;

        float ax = *(float*)(Root + OFFSET_LOCATION);
        float ay = *(float*)(Root + OFFSET_LOCATION + 4);
        float az = *(float*)(Root + OFFSET_LOCATION + 8);
        float dx = ax - g_LocalX, dy = ay - g_LocalY, dz = az - g_LocalZ;
        float dist = sqrtf(dx*dx + dy*dy + dz*dz);
        if (dist > maxDist) continue;

        PlayerData* data = [[PlayerData alloc] init];
        data.address = actor;
        data.x = ax; data.y = ay; data.z = az;
        data.health = Health;
        data.distance = dist;
        data.isAlive = YES;
        data.teamId = Team;
        data.isEnemy = (Team != g_LocalTeam) || (Team == 0);
        [players addObject:data];
    }

    // ── Aimbot ───────────────────────────────────────────────
    if (gConfig.aimbotEnabled && g_LocalPC && players.count) {
        PlayerData* best = nil;
        float bestDist = FLT_MAX;
        for (PlayerData* p in players) {
            if (!p.isAlive || !p.isEnemy) continue;
            if (p.distance < bestDist) { bestDist = p.distance; best = p; }
        }
        if (best) {
            float targetZ = best.z;
            if (gConfig.aimTarget == Target_Head) targetZ += 1.7f;
            else if (gConfig.aimTarget == Target_Body) targetZ += 1.0f;
            else targetZ += 1.2f + ((arc4random() % 40) / 100.0f);

            float dx = best.x - g_LocalX, dy = best.y - g_LocalY, dz = targetZ - g_LocalZ;
            float yaw   = atan2f(dy, dx) * (180.0f / M_PI);
            float pitch = -atan2f(dz, sqrtf(dx*dx + dy*dy)) * (180.0f / M_PI);
            if (yaw < 0) yaw += 360.0f;
            pitch = fmaxf(-89.0f, fminf(89.0f, pitch));

            float humanErr = ((arc4random() % 100) - 50.0f) / 100.0f * 0.3f;
            yaw   += humanErr;
            pitch += humanErr * 0.5f;

            float factor = 1.0f;
            float speed = gConfig.aimbotSpeed;
            if (speed <= 50) factor = 0.06f;
            else if (speed <= 115) factor = speed / 280.0f;
            else if (speed <= 135) factor = speed / 180.0f;
            else factor = 1.0f;
            factor = fmaxf(0.01f, fminf(1.0f, factor));

            // Read current ControlRotation (offset 0x4E0)
            float curPitch = *(float*)(g_LocalPC + 0x4E0);
            float curYaw   = *(float*)(g_LocalPC + 0x4E4);
            float dYaw   = yaw   - curYaw;
            float dPitch = pitch - curPitch;
            if (dYaw > 180) dYaw -= 360;
            if (dYaw < -180) dYaw += 360;

            float newYaw   = curYaw   + dYaw * factor;
            float newPitch = curPitch + dPitch * factor;
            if (fabsf(newYaw - curYaw) > 0.01f || fabsf(newPitch - curPitch) > 0.01f) {
                *(float*)(g_LocalPC + 0x4E0) = newPitch;
                *(float*)(g_LocalPC + 0x4E4) = newYaw;
            }
        }
    }

    // ── ESP update ───────────────────────────────────────────
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RavFenUpdateESP"
                                                            object:nil
                                                          userInfo:@{@"players": players}];
    });
}

// ====================================================================
// 🖥️ ESP Overlay
// ====================================================================
@interface ESPOverlayView : UIView
- (void)updateWithPlayers:(NSArray<PlayerData*>*)players;
@end

@implementation ESPOverlayView {
    float _sw, _sh;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        _sw = frame.size.width; _sh = frame.size.height;
    }
    return self;
}

- (BOOL)worldToScreenX:(float)wx y:(float)wy z:(float)wz outX:(float*)sx outY:(float*)sy {
    float* vm = g_ViewMatrix;
    float cx = vm[0]*wx + vm[4]*wy + vm[8]*wz  + vm[12];
    float cy = vm[1]*wx + vm[5]*wy + vm[9]*wz  + vm[13];
    float cw = vm[3]*wx + vm[7]*wy + vm[11]*wz + vm[15];
    if (cw < 0.1f) return NO;
    float nx = cx / cw, ny = cy / cw;
    *sx = (_sw/2) + (nx * _sw/2);
    *sy = (_sh/2) - (ny * _sh/2);
    return YES;
}

- (void)updateWithPlayers:(NSArray<PlayerData*>*)players {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    if (!gConfig.espEnabled) return;

    for (PlayerData* p in players) {
        float sx, sy;
        if (![self worldToScreenX:p.x y:p.y z:p.z+1.8f outX:&sx outY:&sy]) continue;
        if (sx < 0 || sx > _sw || sy < 0 || sy > _sh) continue;

        if (gConfig.espBoxes) {
            float h = 800.0f / p.distance;
            h = fmaxf(20, fminf(120, h));
            float w = h * 0.55f;
            CALayer* box = [CALayer layer];
            box.frame = CGRectMake(sx - w/2, sy - h, w, h);
            box.borderWidth = 1.5;
            box.borderColor = [UIColor redColor].CGColor;
            box.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2].CGColor;
            [self.layer addSublayer:box];
        }
        if (gConfig.espLines) {
            CAShapeLayer* line = [CAShapeLayer layer];
            UIBezierPath* path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(_sw/2, _sh)];
            [path addLineToPoint:CGPointMake(sx, sy)];
            line.path = path.CGPath;
            line.strokeColor = [UIColor yellowColor].CGColor;
            line.lineWidth = 1.2;
            line.opacity = 0.7;
            [self.layer addSublayer:line];
        }
    }
}
@end

// ====================================================================
// 📱 UI – Floating button & menu
// ====================================================================
@interface RavMenuView : UIView
@end

static UIView* menuView = nil;
static BOOL menuVisible = NO;

static void ShowMenu(void) {
    if (menuVisible) return;
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) return;

    menuView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    menuView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    [keyWindow addSubview:menuView];
    menuVisible = YES;

    // Beta warning
    UILabel* beta = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, menuView.bounds.size.width-40, 60)];
    beta.text = @"⚠️ This is a beta version‼️\n⚠️ هذه النسخة تجريبية ‼️";
    beta.textColor = [UIColor redColor];
    beta.numberOfLines = 2;
    beta.textAlignment = NSTextAlignmentCenter;
    [menuView addSubview:beta];

    // Close button
    UIButton* close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(menuView.bounds.size.width-50, 30, 40, 40);
    [close setTitle:@"X" forState:UIControlStateNormal];
    close.tintColor = [UIColor whiteColor];
    [close addTarget:^{ HideMenu(); } forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:close];

    // Tab container
    UIScrollView* tabs = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 160, menuView.bounds.size.width, 50)];
    tabs.contentSize = CGSizeMake(menuView.bounds.size.width, 50);
    [menuView addSubview:tabs];

    NSArray* tabNames = @[@"Aimbot", @"Player", @"Memory"];
    for (int i=0; i<3; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(i*menuView.bounds.size.width/3, 0, menuView.bounds.size.width/3, 50);
        [btn setTitle:tabNames[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:^{ [self tabTapped:i]; } forControlEvents:UIControlEventTouchUpInside];
        [tabs addSubview:btn];
    }
    [self tabTapped:0];
}

static void HideMenu(void) {
    [menuView removeFromSuperview];
    menuView = nil;
    menuVisible = NO;
}

// Aimbot page
- (void)buildAimbotPage {
    UIView* page = [[UIView alloc] initWithFrame:CGRectMake(0, 220, menuView.bounds.size.width, menuView.bounds.size.height-220)];
    [menuView addSubview:page];

    UISwitch* enableSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(page.bounds.size.width-60, 20, 50, 30)];
    [enableSwitch addTarget:^{ gConfig.aimbotEnabled = enableSwitch.isOn; } forControlEvents:UIControlEventValueChanged];
    [page addSubview:enableSwitch];
    UILabel* enableLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
    enableLabel.text = @"Enable Aimbot\nتفعيل الايم بوت";
    enableLabel.numberOfLines = 2;
    enableLabel.textColor = [UIColor whiteColor];
    [page addSubview:enableLabel];

    UISlider* speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 80, page.bounds.size.width-40, 30)];
    speedSlider.minimumValue = 50; speedSlider.maximumValue = 250; speedSlider.value = 120;
    [speedSlider addTarget:^{ gConfig.aimbotSpeed = speedSlider.value; } forControlEvents:UIControlEventValueChanged];
    [page addSubview:speedSlider];
    UILabel* speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 200, 20)];
    speedLabel.text = @"Aimbot Speed\nسرعة الايم بوت";
    speedLabel.numberOfLines = 2;
    speedLabel.textColor = [UIColor whiteColor];
    [page addSubview:speedLabel];

    UILabel* warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, page.bounds.size.width-40, 40)];
    warnLabel.text = @"May increase the likelihood of being banned\nقد تزيد نسبة التعرض للحظر";
    warnLabel.numberOfLines = 2;
    warnLabel.textColor = [UIColor redColor];
    warnLabel.hidden = YES;
    [page addSubview:warnLabel];

    UISegmentedControl* targetSegment = [[UISegmentedControl alloc] initWithItems:@[@"Head\nراس", @"Body\nجسم", @"Random\nعشوائي"]];
    targetSegment.frame = CGRectMake(20, 160, page.bounds.size.width-40, 60);
    [targetSegment addTarget:^{ gConfig.aimTarget = (AimTarget)targetSegment.selectedSegmentIndex; } forControlEvents:UIControlEventValueChanged];
    [page addSubview:targetSegment];

    UILabel* headWarn = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, page.bounds.size.width-40, 40)];
    headWarn.text = @"May increase the likelihood of being banned\nقد تزيد نسبة التعرض للحظر";
    headWarn.numberOfLines = 2;
    headWarn.textColor = [UIColor redColor];
    headWarn.hidden = YES;
    [page addSubview:headWarn];

    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer* t){
        warnLabel.hidden = (speedSlider.value <= 115);
        headWarn.hidden = (targetSegment.selectedSegmentIndex != 0);
    }];
}

// Player page
- (void)buildPlayerPage {
    UIView* page = [[UIView alloc] initWithFrame:CGRectMake(0, 220, menuView.bounds.size.width, menuView.bounds.size.height-220)];
    [menuView addSubview:page];

    UISwitch* espSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(page.bounds.size.width-60, 20, 50, 30)];
    [espSwitch addTarget:^{ gConfig.espEnabled = espSwitch.isOn; } forControlEvents:UIControlEventValueChanged];
    [page addSubview:espSwitch];
    UILabel* espLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
    espLabel.text = @"Enable ESP\nتفعيل الـESP";
    espLabel.numberOfLines = 2;
    espLabel.textColor = [UIColor whiteColor];
    [page addSubview:espLabel];

    UISwitch* boxSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(page.bounds.size.width-60, 70, 50, 30)];
    [boxSwitch addTarget:^{ gConfig.espBoxes = boxSwitch.isOn; } forControlEvents:UIControlEventValueChanged];
    [page addSubview:boxSwitch];
    UILabel* boxLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 200, 30)];
    boxLabel.text = @"Boxes\nمربعات";
    boxLabel.numberOfLines = 2;
    boxLabel.textColor = [UIColor whiteColor];
    [page addSubview:boxLabel];

    UISwitch* lineSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(page.bounds.size.width-60, 120, 50, 30)];
    [lineSwitch addTarget:^{ gConfig.espLines = lineSwitch.isOn; } forControlEvents:UIControlEventValueChanged];
    [page addSubview:lineSwitch];
    UILabel* lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 200, 30)];
    lineLabel.text = @"Lines\nخطوط";
    lineLabel.numberOfLines = 2;
    lineLabel.textColor = [UIColor whiteColor];
    [page addSubview:lineLabel];
}

// Memory page
- (void)buildMemoryPage {
    UIView* page = [[UIView alloc] initWithFrame:CGRectMake(0, 220, menuView.bounds.size.width, menuView.bounds.size.height-220)];
    [menuView addSubview:page];
    UILabel* soonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, page.bounds.size.width, page.bounds.size.height)];
    soonLabel.text = @"Soon 🔜\nقريبا";
    soonLabel.numberOfLines = 2;
    soonLabel.textColor = [UIColor whiteColor];
    soonLabel.textAlignment = NSTextAlignmentCenter;
    soonLabel.font = [UIFont boldSystemFontOfSize:32];
    [page addSubview:soonLabel];
}

static int currentTab = 0;
- (void)tabTapped:(int)index {
    currentTab = index;
    for (UIView* v in menuView.subviews) {
        if (v.frame.origin.y >= 220) [v removeFromSuperview];
    }
    if (index == 0) [self buildAimbotPage];
    else if (index == 1) [self buildPlayerPage];
    else [self buildMemoryPage];
}
@end

// ====================================================================
// 🚀 Constructor
// ====================================================================
__attribute__((constructor))
static void Init(void) {
    GetBaseAddress();
    RandomThreadName();

    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton* floatBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        floatBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-60, 200, 50, 50);
        floatBtn.backgroundColor = [UIColor blackColor];
        floatBtn.layer.cornerRadius = 25;
        [floatBtn addTarget:^{ ShowMenu(); } forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:floatBtn];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        while (YES) {
            @autoreleasepool {
                GameLoop();
                usleep(25000 + arc4random() % 10000); // 25-35 ms
            }
        }
    });
}
