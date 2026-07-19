// ====================================================================
// RavFen Shadow v8.2 – PUBG Mobile 4.5.0 TW (Full Code)
// New UI, Golden Knight Button, Jailbreak Bypass
// ====================================================================

#import <UIKit/UIKit.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <pthread.h>
#import <dlfcn.h>
#import <math.h>
#import <sys/sysctl.h>
#import <unistd.h>
#import <objc/runtime.h>

// ====================================================================
// 🛡️ Jailbreak / Modified App Bypass
// ====================================================================
static IMP originalBundleIdentifier = NULL;

static NSString* replacedBundleIdentifier(id self, SEL _cmd) {
    // عندما تطلب اللعبة معرف الحزمة للتأكد من التوقيع
    // نرد عليها بمعرف الحزمة الرسمي للعبة
    return @"com.tencent.ig";
}

__attribute__((constructor))
static void initBypass(void) {
    // اعتراض دالة bundleIdentifier الخاصة بـ NSBundle
    Method m = class_getInstanceMethod([NSBundle class], @selector(bundleIdentifier));
    if (m) {
        originalBundleIdentifier = method_setImplementation(m, (IMP)replacedBundleIdentifier);
    }
}

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
#define ADDR_ACTORARRAY     0x106419D7C
#define ADDR_GNAMES_PTR     0x1050C4AB4
#define ADDR_VIEWMATRIX     0x106367344

// Offsets (valid for 4.5 TW)
#define OFFSET_ACTORID      0x18
#define OFFSET_HEALTH       0xE60
#define OFFSET_TEAMID       0x998
#define OFFSET_ROOTCOMP     0x208
#define OFFSET_LOCATION     0x1E4
#define OFFSET_bDEAD        0xE7C
#define OFFSET_bLOCALPC     0x0810

// ====================================================================
// 🧵 Config
// ====================================================================
static pthread_mutex_t g_Mutex = PTHREAD_MUTEX_INITIALIZER;

typedef enum { Target_Head = 0, Target_Body = 1, Target_Random = 2 } AimTarget;

typedef struct {
    volatile BOOL   aimbotEnabled;
    volatile float  aimbotSpeed;
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
static BOOL g_GameReady = NO;

// ====================================================================
// 🛡️ Helpers
// ====================================================================
static void RandomDelay(void) { usleep(arc4random() % 1500 + 500); }
static void RandomThreadName(void) { pthread_setname_np("com.apple.CoreMotion.motionUpdate"); }

static BOOL IsValidPointer(uint64_t addr) {
    if (addr < 0x100000000 || addr > 0x7FFFFFFFFFFF) return NO;
    vm_size_t size = 1; char dummy;
    return vm_read_overwrite(mach_task_self(), (vm_address_t)addr, 1, (vm_address_t)&dummy, &size) == KERN_SUCCESS;
}

// ====================================================================
// 👤 IsPlayer
// ====================================================================
static BOOL IsPlayer(uint64_t Actor) {
    if (!Actor) return NO;
    uint64_t gnAddr = GetBaseAddress() + ADDR_GNAMES_PTR;
    if (!IsValidPointer(gnAddr)) return NO;
    uint64_t GNamesBase = *(uint64_t*)gnAddr;
    if (!GNamesBase || !IsValidPointer(GNamesBase)) return NO;
    int32_t ActorId = *(int32_t*)(Actor + OFFSET_ACTORID);
    if (ActorId <= 0 || ActorId > 10000000) return NO;
    uint32_t ChunkIdx = ActorId / 0x3FE0, NameIdx = ActorId % 0x3FE0;
    uint64_t ChunkAddr = GNamesBase + ChunkIdx * 8;
    if (!IsValidPointer(ChunkAddr)) return NO;
    uint64_t Chunk = *(uint64_t*)ChunkAddr;
    if (!Chunk || !IsValidPointer(Chunk)) return NO;
    uint64_t Entry = Chunk + NameIdx * 48;
    if (!IsValidPointer(Entry + 8)) return NO;
    char Name[24] = {0};
    memcpy(Name, (void*)(Entry + 8), 20);
    Name[20] = '\0';
    if ((strstr(Name, "PlayerPawn") || strstr(Name, "BP_Player") || strstr(Name, "PlayerCharacter") ||
         strstr(Name, "PlayerMale") || strstr(Name, "PlayerFemale")) &&
        !strstr(Name, "Pickup") && !strstr(Name, "Dropped") && !strstr(Name, "Item") && !strstr(Name, "Weapon"))
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
    uint64_t base = GetBaseAddress(); RandomDelay();
    uint64_t vmAddr = base + ADDR_VIEWMATRIX;
    if (IsValidPointer(vmAddr)) memcpy(g_ViewMatrix, (void*)vmAddr, 64); else return;

    uint64_t tarrayAddr = base + ADDR_ACTORARRAY;
    if (!IsValidPointer(tarrayAddr)) return;
    uint64_t dataPtr = *(uint64_t*)(tarrayAddr);
    int32_t actorCount = *(int32_t*)(tarrayAddr + 8);
    if (!dataPtr || actorCount <= 0 || actorCount > 5000) return;

    g_GameReady = (actorCount > 200);

    // Find Local PC
    if (g_GameReady) {
        g_LocalPC = 0;
        for (int i = 0; i < actorCount && !g_LocalPC; ++i) {
            uint64_t actor = *(uint64_t*)(dataPtr + i * 8);
            if (!actor) continue;
            int32_t ActorId = *(int32_t*)(actor + OFFSET_ACTORID);
            if (ActorId <= 0) continue;
            uint64_t gnAddr = base + ADDR_GNAMES_PTR;
            if (!IsValidPointer(gnAddr)) continue;
            uint64_t GNamesBase = *(uint64_t*)gnAddr;
            if (!GNamesBase) continue;
            uint32_t ChunkIdx = ActorId / 0x3FE0, NameIdx = ActorId % 0x3FE0;
            uint64_t ChunkAddr = GNamesBase + ChunkIdx * 8;
            if (!IsValidPointer(ChunkAddr)) continue;
            uint64_t Chunk = *(uint64_t*)ChunkAddr;
            if (!Chunk) continue;
            uint64_t Entry = Chunk + NameIdx * 48;
            if (!IsValidPointer(Entry + 8)) continue;
            char Name[24] = {0};
            memcpy(Name, (void*)(Entry + 8), 20);
            if (strstr(Name, "PlayerController") && *(bool*)(actor + OFFSET_bLOCALPC)) {
                g_LocalPC = actor; break;
            }
        }
    }

    // Get Local Pawn
    uint64_t LocalPawn = 0;
    if (g_LocalPC) {
        LocalPawn = IsValidPointer(g_LocalPC + 0x528) ? *(uint64_t*)(g_LocalPC + 0x528) : 0;
        if (!LocalPawn) LocalPawn = IsValidPointer(g_LocalPC + 0x518) ? *(uint64_t*)(g_LocalPC + 0x518) : 0;
    }
    if (LocalPawn) {
        uint64_t rootAddr = LocalPawn + OFFSET_ROOTCOMP;
        if (IsValidPointer(rootAddr)) {
            uint64_t Root = *(uint64_t*)rootAddr;
            if (Root) {
                uint64_t locAddr = Root + OFFSET_LOCATION;
                if (IsValidPointer(locAddr)) {
                    g_LocalX = *(float*)(locAddr);
                    g_LocalY = *(float*)(locAddr + 4);
                    g_LocalZ = *(float*)(locAddr + 8);
                }
            }
        }
        g_LocalTeam = IsValidPointer(LocalPawn + OFFSET_TEAMID) ? *(int32_t*)(LocalPawn + OFFSET_TEAMID) : 0;
    }

    // Collect enemies
    NSMutableArray<PlayerData*>* players = [NSMutableArray array];
    float maxDist = 500.0f;
    pthread_mutex_lock(&g_Mutex); maxDist = gConfig.espDistance ? gConfig.espDistance : 500.0f; pthread_mutex_unlock(&g_Mutex);

    for (int i = 0; i < actorCount; ++i) {
        uint64_t actor = *(uint64_t*)(dataPtr + i * 8);
        if (!actor || actor == LocalPawn) continue;
        if (!IsPlayer(actor)) continue;

        uint64_t healthAddr = actor + OFFSET_HEALTH;
        if (!IsValidPointer(healthAddr)) continue;
        float Health = *(float*)healthAddr;
        if (Health <= 0.0f || (IsValidPointer(actor + OFFSET_bDEAD) && *(bool*)(actor + OFFSET_bDEAD))) continue;

        int32_t Team = IsValidPointer(actor + OFFSET_TEAMID) ? *(int32_t*)(actor + OFFSET_TEAMID) : 0;
        uint64_t rootAddr = actor + OFFSET_ROOTCOMP;
        if (!IsValidPointer(rootAddr)) continue;
        uint64_t Root = *(uint64_t*)rootAddr;
        if (!Root) continue;
        uint64_t locAddr = Root + OFFSET_LOCATION;
        if (!IsValidPointer(locAddr)) continue;

        float ax = *(float*)(locAddr);
        float ay = *(float*)(locAddr + 4);
        float az = *(float*)(locAddr + 8);
        float dx = ax - g_LocalX, dy = ay - g_LocalY, dz = az - g_LocalZ;
        float dist = sqrtf(dx*dx + dy*dy + dz*dz);
        if (dist > maxDist) continue;

        PlayerData* data = [[PlayerData alloc] init];
        data.address = actor; data.x = ax; data.y = ay; data.z = az;
        data.health = Health; data.distance = dist;
        data.isAlive = YES; data.teamId = Team;
        data.isEnemy = (Team != g_LocalTeam) || (Team == 0);
        [players addObject:data];
    }

    // Aimbot
    if (gConfig.aimbotEnabled && g_LocalPC && players.count) {
        PlayerData* best = nil; float bestDist = FLT_MAX;
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
            float yaw = atan2f(dy, dx) * (180.0f / M_PI);
            float pitch = -atan2f(dz, sqrtf(dx*dx + dy*dy)) * (180.0f / M_PI);
            if (yaw < 0) yaw += 360.0f;
            pitch = fmaxf(-89.0f, fminf(89.0f, pitch));

            float humanErr = ((arc4random() % 100) - 50.0f) / 100.0f * 0.3f;
            yaw += humanErr; pitch += humanErr * 0.5f;

            float factor = 1.0f;
            float speed = gConfig.aimbotSpeed;
            if (speed <= 50) factor = 0.06f;
            else if (speed <= 115) factor = speed / 280.0f;
            else if (speed <= 135) factor = speed / 180.0f;
            else factor = 1.0f;
            factor = fmaxf(0.01f, fminf(1.0f, factor));

            uint64_t crAddr = g_LocalPC + 0x4E0;
            if (IsValidPointer(crAddr) && IsValidPointer(crAddr + 4)) {
                float curPitch = *(float*)(crAddr);
                float curYaw = *(float*)(crAddr + 4);
                float dYaw = yaw - curYaw, dPitch = pitch - curPitch;
                if (dYaw > 180) dYaw -= 360;
                if (dYaw < -180) dYaw += 360;

                float newYaw = curYaw + dYaw * factor;
                float newPitch = curPitch + dPitch * factor;
                if (fabsf(newYaw - curYaw) > 0.01f || fabsf(newPitch - curPitch) > 0.01f) {
                    *(float*)(crAddr) = newPitch;
                    *(float*)(crAddr + 4) = newYaw;
                }
            }
        }
    }

    // ESP Update
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RavFenUpdateESP" object:nil userInfo:@{@"players": players}];
    });
}

// ====================================================================
// 🖥️ ESP Overlay
// ====================================================================
@interface ESPOverlayView : UIView
- (void)updateWithPlayers:(NSArray<PlayerData*>*)players;
@end

@implementation ESPOverlayView { float _sw, _sh; }
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { self.backgroundColor = [UIColor clearColor]; self.userInteractionEnabled = NO; _sw = frame.size.width; _sh = frame.size.height; }
    return self;
}
- (BOOL)worldToScreenX:(float)wx y:(float)wy z:(float)wz outX:(float*)sx outY:(float*)sy {
    float* vm = g_ViewMatrix;
    float cx = vm[0]*wx + vm[4]*wy + vm[8]*wz + vm[12];
    float cy = vm[1]*wx + vm[5]*wy + vm[9]*wz + vm[13];
    float cw = vm[3]*wx + vm[7]*wy + vm[11]*wz + vm[15];
    if (cw < 0.1f) return NO;
    float nx = cx / cw, ny = cy / cw;
    *sx = (_sw/2) + (nx * _sw/2); *sy = (_sh/2) - (ny * _sh/2);
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
            float h = 800.0f / p.distance; h = fmaxf(20, fminf(120, h)); float w = h * 0.55f;
            CALayer* box = [CALayer layer];
            box.frame = CGRectMake(sx - w/2, sy - h, w, h);
            box.borderWidth = 1.5; box.borderColor = [UIColor redColor].CGColor;
            box.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2].CGColor;
            [self.layer addSublayer:box];
        }
        if (gConfig.espLines) {
            CAShapeLayer* line = [CAShapeLayer layer];
            UIBezierPath* path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(_sw/2, _sh)];
            [path addLineToPoint:CGPointMake(sx, sy)];
            line.path = path.CGPath;
            line.strokeColor = [UIColor yellowColor].CGColor; line.lineWidth = 1.2; line.opacity = 0.7;
            [self.layer addSublayer:line];
        }
    }
}
@end

// ====================================================================
// 📱 New Menu UI (Golden Knight Style)
// ====================================================================
@interface RavMenuView : UIView
- (void)show;
- (void)hide;
@end

@implementation RavMenuView {
    UIView* _cardView;
    UIView* _contentView;
    int _currentTab;
    UISwitch* _enableSwitch;
    UISlider* _speedSlider;
    UISegmentedControl* _targetSegment;
    UISwitch* _espSwitch, *_boxSwitch, *_lineSwitch;
    UILabel* _speedWarn, *_headWarn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self buildMenuCard];
    }
    return self;
}

- (void)buildMenuCard {
    CGFloat cardWidth = self.bounds.size.width * 0.85;
    CGFloat cardX = (self.bounds.size.width - cardWidth) / 2;
    CGFloat cardY = self.bounds.size.height * 0.1;
    CGFloat cardHeight = self.bounds.size.height * 0.8;
    
    _cardView = [[UIView alloc] initWithFrame:CGRectMake(cardX, cardY, cardWidth, cardHeight)];
    _cardView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.15 alpha:0.95];
    _cardView.layer.cornerRadius = 20;
    _cardView.layer.borderWidth = 2;
    _cardView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.8].CGColor; // Gold border
    _cardView.clipsToBounds = YES;
    [self addSubview:_cardView];
    
    // Header with Knight Icon
    UILabel* headerIcon = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, cardWidth, 50)];
    headerIcon.text = @"🛡️";
    headerIcon.textAlignment = NSTextAlignmentCenter;
    headerIcon.font = [UIFont systemFontOfSize:40];
    [_cardView addSubview:headerIcon];
    
    UILabel* headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, cardWidth, 30)];
    headerTitle.text = @"RAVFEN SHIELD";
    headerTitle.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0]; // Gold
    headerTitle.textAlignment = NSTextAlignmentCenter;
    headerTitle.font = [UIFont boldSystemFontOfSize:20];
    [_cardView addSubview:headerTitle];
    
    UILabel* headerSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, cardWidth, 20)];
    headerSubtitle.text = @"v8.2 Beta • TW 4.5";
    headerSubtitle.textColor = [UIColor lightGrayColor];
    headerSubtitle.textAlignment = NSTextAlignmentCenter;
    headerSubtitle.font = [UIFont systemFontOfSize:12];
    [_cardView addSubview:headerSubtitle];
    
    // Close Button
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(cardWidth - 45, 15, 35, 35);
    closeBtn.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    closeBtn.layer.cornerRadius = 17.5;
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [_cardView addSubview:closeBtn];

    // Tabs
    NSArray* tabNames = @[@"Aimbot", @"ESP", @"Memory"];
    CGFloat tabWidth = cardWidth / 3;
    for (int i=0; i<3; i++) {
        UIButton* tabBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        tabBtn.frame = CGRectMake(i*tabWidth, 120, tabWidth, 40);
        [tabBtn setTitle:tabNames[i] forState:UIControlStateNormal];
        [tabBtn setTitleColor:(i==0 ? [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0] : [UIColor grayColor]) forState:UIControlStateNormal];
        tabBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        tabBtn.tag = i;
        [tabBtn addTarget:self action:@selector(tabTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_cardView addSubview:tabBtn];
    }
    
    // Separator
    UIView* sep = [[UIView alloc] initWithFrame:CGRectMake(15, 160, cardWidth-30, 1)];
    sep.backgroundColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.4];
    [_cardView addSubview:sep];
    
    // Content Area
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 170, cardWidth, cardHeight - 180)];
    [_cardView addSubview:_contentView];
    
    [self switchToTab:0];
}

- (void)tabTapped:(UIButton*)sender { [self switchToTab:(int)sender.tag]; }

- (void)switchToTab:(int)index {
    for (UIView* v in _contentView.subviews) [v removeFromSuperview];
    if (index == 0) [self buildAimbotPage];
    else if (index == 1) [self buildEspPage];
    else [self buildMemoryPage];
}

- (void)buildAimbotPage {
    UIView* page = [[UIView alloc] initWithFrame:_contentView.bounds];
    [_contentView addSubview:page];
    CGFloat w = page.bounds.size.width;
    
    // Enable
    _enableSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(w-70, 15, 50, 30)];
    [_enableSwitch addTarget:self action:@selector(toggleAimbot) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_enableSwitch];
    [page addSubview:[self labelWithText:@"Enable Aimbot" frame:CGRectMake(20, 15, w-100, 30) size:16]];
    
    // Speed
    _speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 70, w-40, 30)];
    _speedSlider.minimumValue = 50; _speedSlider.maximumValue = 250; _speedSlider.value = 120;
    _speedSlider.tintColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0];
    [_speedSlider addTarget:self action:@selector(speedChanged) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_speedSlider];
    [page addSubview:[self labelWithText:@"Speed: 120" frame:CGRectMake(20, 50, w-40, 20) size:12]];
    
    _speedWarn = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, w-40, 30)];
    _speedWarn.text = @"⚠️ High speed may cause ban";
    _speedWarn.textColor = [UIColor redColor]; _speedWarn.font = [UIFont systemFontOfSize:10];
    _speedWarn.hidden = YES;
    [page addSubview:_speedWarn];
    
    // Target
    _targetSegment = [[UISegmentedControl alloc] initWithItems:@[@"Head", @"Body", @"Random"]];
    _targetSegment.frame = CGRectMake(20, 150, w-40, 35);
    _targetSegment.tintColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0];
    [_targetSegment addTarget:self action:@selector(targetChanged) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_targetSegment];
    
    _headWarn = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, w-40, 30)];
    _headWarn.text = @"⚠️ Head aim may cause ban";
    _headWarn.textColor = [UIColor redColor]; _headWarn.font = [UIFont systemFontOfSize:10];
    _headWarn.hidden = YES;
    [page addSubview:_headWarn];
}

- (void)buildEspPage {
    UIView* page = [[UIView alloc] initWithFrame:_contentView.bounds];
    [_contentView addSubview:page];
    CGFloat w = page.bounds.size.width;
    
    _espSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(w-70, 15, 50, 30)];
    [_espSwitch addTarget:self action:@selector(toggleESP) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_espSwitch];
    [page addSubview:[self labelWithText:@"Enable ESP" frame:CGRectMake(20, 15, w-100, 30) size:16]];
    
    _boxSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(w-70, 65, 50, 30)];
    [_boxSwitch addTarget:self action:@selector(toggleBoxes) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_boxSwitch];
    [page addSubview:[self labelWithText:@"Boxes" frame:CGRectMake(20, 65, w-100, 30) size:16]];
    
    _lineSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(w-70, 115, 50, 30)];
    [_lineSwitch addTarget:self action:@selector(toggleLines) forControlEvents:UIControlEventValueChanged];
    [page addSubview:_lineSwitch];
    [page addSubview:[self labelWithText:@"Lines" frame:CGRectMake(20, 115, w-100, 30) size:16]];
}

- (void)buildMemoryPage {
    UILabel* soon = [[UILabel alloc] initWithFrame:_contentView.bounds];
    soon.text = @"Soon 🔜\nقريبا"; soon.numberOfLines = 2; soon.textColor = [UIColor whiteColor];
    soon.textAlignment = NSTextAlignmentCenter; soon.font = [UIFont boldSystemFontOfSize:32];
    [_contentView addSubview:soon];
}

- (UILabel*)labelWithText:(NSString*)text frame:(CGRect)frame size:(CGFloat)size {
    UILabel* l = [[UILabel alloc] initWithFrame:frame];
    l.text = text; l.textColor = [UIColor whiteColor]; l.font = [UIFont systemFontOfSize:size];
    return l;
}

// Actions
- (void)toggleAimbot { gConfig.aimbotEnabled = _enableSwitch.isOn; }
- (void)speedChanged { gConfig.aimbotSpeed = _speedSlider.value; _speedWarn.hidden = (_speedSlider.value <= 115); }
- (void)targetChanged { gConfig.aimTarget = (AimTarget)_targetSegment.selectedSegmentIndex; _headWarn.hidden = (_targetSegment.selectedSegmentIndex != 0); }
- (void)toggleESP { gConfig.espEnabled = _espSwitch.isOn; }
- (void)toggleBoxes { gConfig.espBoxes = _boxSwitch.isOn; }
- (void)toggleLines { gConfig.espLines = _lineSwitch.isOn; }

- (void)show {
    self.alpha = 0;
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) return;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{ self.alpha = 1; }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{ self.alpha = 0; } completion:^(BOOL finished) { [self removeFromSuperview]; }];
}
@end

// ====================================================================
// 📱 UI Manager – Golden Knight Floating Button
// ====================================================================
@interface RavUIManager : NSObject
+ (instancetype)shared;
- (void)setup;
- (void)showMenu;
- (void)hideMenu;
@end

@implementation RavUIManager {
    UIButton*       _floatBtn;
    RavMenuView*    _menuView;
    BOOL            _menuVisible;
}

+ (instancetype)shared {
    static RavUIManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ manager = [[RavUIManager alloc] init]; });
    return manager;
}

- (void)setup {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self createFloatingButton];
    });
}

- (void)createFloatingButton {
    if (_floatBtn) return;

    UIWindow* targetWindow = [self findKeyWindow];
    if (!targetWindow) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self createFloatingButton];
        });
        return;
    }

    _floatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _floatBtn.frame = CGRectMake(targetWindow.bounds.size.width - 65, 250, 55, 55);
    _floatBtn.backgroundColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.9]; // Gold
    _floatBtn.layer.cornerRadius = 27.5;
    _floatBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _floatBtn.layer.borderWidth = 2.0;
    _floatBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    _floatBtn.layer.shadowOffset = CGSizeMake(0, 2);
    _floatBtn.layer.shadowOpacity = 0.8;
    
    // Knight icon
    UILabel* iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    iconLabel.text = @"🛡️";
    iconLabel.textAlignment = NSTextAlignmentCenter;
    iconLabel.font = [UIFont systemFontOfSize:28];
    iconLabel.userInteractionEnabled = NO;
    [_floatBtn addSubview:iconLabel];

    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_floatBtn addGestureRecognizer:pan];
    [_floatBtn addTarget:self action:@selector(floatButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    [targetWindow addSubview:_floatBtn];
}

- (UIWindow*)findKeyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow* window in scene.windows) {
                    if (window.isKeyWindow) return window;
                }
            }
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

- (void)handlePan:(UIPanGestureRecognizer*)gesture {
    CGPoint translation = [gesture translationInView:_floatBtn.superview];
    CGPoint newCenter = CGPointMake(_floatBtn.center.x + translation.x, _floatBtn.center.y + translation.y);
    _floatBtn.center = newCenter;
    [gesture setTranslation:CGPointZero inView:_floatBtn.superview];
}

- (void)floatButtonTapped { [self showMenu]; }

- (void)showMenu {
    if (_menuVisible) return;
    if (!_menuView) _menuView = [[RavMenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _menuView.alpha = 0;
    UIWindow* window = [self findKeyWindow] ?: [UIApplication sharedApplication].keyWindow;
    [window addSubview:_menuView];
    [window bringSubviewToFront:_menuView];
    [UIView animateWithDuration:0.3 animations:^{ _menuView.alpha = 1; }];
    _menuVisible = YES;
}

- (void)hideMenu {
    if (!_menuVisible) return;
    [UIView animateWithDuration:0.3 animations:^{ _menuView.alpha = 0; } completion:^(BOOL finished) { [self->_menuView removeFromSuperview]; }];
    _menuVisible = NO;
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
        [[RavUIManager shared] setup];
        
        // ESP Overlay setup
        ESPOverlayView* espView = [[ESPOverlayView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UIWindow* targetWindow = [[RavUIManager shared] findKeyWindow] ?: [UIApplication sharedApplication].keyWindow;
        if (targetWindow) {
            [targetWindow addSubview:espView];
            [targetWindow sendSubviewToBack:espView]; // Behind UI elements
        }
        [[NSNotificationCenter defaultCenter] addObserverForName:@"RavFenUpdateESP" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* note) {
            [espView updateWithPlayers:note.userInfo[@"players"]];
        }];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        while (YES) {
            @autoreleasepool {
                GameLoop();
                usleep(25000 + arc4random() % 10000);
            }
        }
    });
}
