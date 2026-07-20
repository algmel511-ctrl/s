// ====================================================================
// RavFen Shadow v8.4 – PUBG Mobile 4.5.0 TW
// Fixed: base address calc, menu reopen, design, armor icon
// ====================================================================

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <pthread.h>
#import <dlfcn.h>
#import <math.h>
#import <sys/sysctl.h>
#import <unistd.h>

// ====================================================================
// 📍 Base Address — ASLR-safe
// FIX: ننزل 0x100000000 لنحصل على الـ slide فقط، ثم نضيف العنوان الثابت
// ====================================================================
static uint64_t gBase = 0;
static inline uint64_t GetBase(void) {
    if (gBase == 0) gBase = (uint64_t)_dyld_get_image_header(0);
    return gBase;
}
// الاستخدام الصحيح: GetBase() - 0x100000000 + STATIC_ADDR
#define REBASE(addr) (GetBase() - 0x100000000 + (uint64_t)(addr))

// ====================================================================
// 🔑 Static addresses – TW 4.5.0
// ====================================================================
#define STATIC_ACTORARR   0x106419D7C
#define STATIC_GNAMES     0x1050C4AB4
#define STATIC_GUOBJECT   0x10A88BA60
#define STATIC_VIEWMATRIX 0x106367344

// ====================================================================
// 📐 Offsets
// ====================================================================
#define OFF_ACTORID    0x18
#define OFF_HEALTH     0xE60
#define OFF_TEAMID     0x998
#define OFF_ROOTCOMP   0x208
#define OFF_LOCATION   0x1E4
#define OFF_bDEAD      0xE7C
#define OFF_bLOCALPC   0x0810
#define OFF_PAWN_1     0x528
#define OFF_PAWN_2     0x518
#define OFF_ROTATION   0x4E0

// ====================================================================
// 🧵 Config
// ====================================================================
static pthread_mutex_t g_Mutex = PTHREAD_MUTEX_INITIALIZER;

typedef enum { Target_Head = 0, Target_Body = 1, Target_Random = 2 } AimTarget;

typedef struct {
    volatile BOOL      aimbotEnabled;
    volatile float     aimbotSpeed;
    volatile AimTarget aimTarget;
    volatile BOOL      espEnabled;
    volatile BOOL      espLines;
    volatile BOOL      espBoxes;
    volatile float     espDistance;
} RavConfig;

static RavConfig gConfig = {
    .aimbotEnabled = NO,
    .aimbotSpeed   = 120.0f,
    .aimTarget     = Target_Body,
    .espEnabled    = NO,
    .espLines      = NO,
    .espBoxes      = NO,
    .espDistance   = 500.0f
};

// ====================================================================
// 🌐 Globals
// ====================================================================
static float    g_ViewMatrix[16] = {0};
static float    g_LocalX = 0, g_LocalY = 0, g_LocalZ = 0;
static int32_t  g_LocalTeam = 0;
static uint64_t g_LocalPC   = 0;
static uint64_t g_LocalPawn = 0;

// ====================================================================
// 🛡️ Safe memory
// ====================================================================
static inline BOOL safe_addr(uint64_t addr) {
    return (addr >= 0x100000000ULL && addr <= 0x7FFFFFFFFFFFULL);
}
static uint64_t read_ptr(uint64_t a)   { return safe_addr(a) ? *(uint64_t*)a : 0; }
static float    read_f32(uint64_t a)   { return safe_addr(a) ? *(float*)a    : 0.f; }
static int32_t  read_i32(uint64_t a)   { return safe_addr(a) ? *(int32_t*)a  : 0; }

// ====================================================================
// 👤 IsPlayer
// ====================================================================
static BOOL IsPlayer(uint64_t Actor) {
    if (!Actor) return NO;
    uint64_t GNamesBase = read_ptr(REBASE(STATIC_GNAMES));
    if (!GNamesBase) return NO;
    int32_t id = read_i32(Actor + OFF_ACTORID);
    if (id <= 0 || id > 10000000) return NO;
    uint32_t ci = id / 0x3FE0, ni = id % 0x3FE0;
    uint64_t chunk = read_ptr(GNamesBase + ci * 8);
    if (!chunk) return NO;
    uint64_t entry = chunk + ni * 48;
    if (!safe_addr(entry + 8)) return NO;
    char name[24] = {0};
    memcpy(name, (void*)(entry + 8), 20);
    return (strstr(name,"PlayerPawn")||strstr(name,"BP_Player")||
            strstr(name,"PlayerCharacter")||strstr(name,"PlayerMale")||strstr(name,"PlayerFemale")) &&
           !strstr(name,"Pickup")&&!strstr(name,"Dropped")&&!strstr(name,"Item")&&!strstr(name,"Weapon");
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
// 🔄 GameLoop
// ====================================================================
static void GameLoop(void) {
    usleep(arc4random() % 500 + 200);

    uint64_t vmAddr = REBASE(STATIC_VIEWMATRIX);
    if (!safe_addr(vmAddr)) return;
    memcpy(g_ViewMatrix, (void*)vmAddr, 64);

    uint64_t arrAddr  = REBASE(STATIC_ACTORARR);
    if (!safe_addr(arrAddr)) return;
    uint64_t dataPtr  = *(uint64_t*)arrAddr;
    int32_t  count    = *(int32_t*)(arrAddr + 8);
    if (!dataPtr || count <= 0 || count > 5000) return;

    BOOL inMatch = (count > 150);

    if (inMatch && g_LocalPC == 0) {
        uint64_t GN = read_ptr(REBASE(STATIC_GNAMES));
        for (int i = 0; i < count && g_LocalPC == 0; i++) {
            uint64_t a = read_ptr(dataPtr + i * 8);
            if (!a || !GN) continue;
            int32_t id = read_i32(a + OFF_ACTORID);
            if (id <= 0) continue;
            uint64_t chunk = read_ptr(GN + (id/0x3FE0)*8);
            if (!chunk) continue;
            uint64_t entry = chunk + (id%0x3FE0)*48;
            if (!safe_addr(entry+8)) continue;
            char name[24]={0}; memcpy(name,(void*)(entry+8),20);
            if (strstr(name,"PlayerController") && read_i32(a+OFF_bLOCALPC)) {
                g_LocalPC   = a;
                g_LocalPawn = read_ptr(a + OFF_PAWN_1);
                if (!g_LocalPawn) g_LocalPawn = read_ptr(a + OFF_PAWN_2);
                if (g_LocalPawn) {
                    uint64_t root = read_ptr(g_LocalPawn + OFF_ROOTCOMP);
                    if (root) {
                        g_LocalX = read_f32(root + OFF_LOCATION);
                        g_LocalY = read_f32(root + OFF_LOCATION + 4);
                        g_LocalZ = read_f32(root + OFF_LOCATION + 8);
                    }
                    g_LocalTeam = read_i32(g_LocalPawn + OFF_TEAMID);
                }
            }
        }
    } else if (!inMatch) {
        g_LocalPC = 0; g_LocalPawn = 0;
    }

    if (g_LocalPawn) {
        uint64_t root = read_ptr(g_LocalPawn + OFF_ROOTCOMP);
        if (root) {
            g_LocalX = read_f32(root + OFF_LOCATION);
            g_LocalY = read_f32(root + OFF_LOCATION + 4);
            g_LocalZ = read_f32(root + OFF_LOCATION + 8);
        }
    }

    NSMutableArray<PlayerData*>* players = [NSMutableArray array];
    float maxDist;
    pthread_mutex_lock(&g_Mutex);
    maxDist = gConfig.espDistance > 0 ? gConfig.espDistance : 500.0f;
    pthread_mutex_unlock(&g_Mutex);

    for (int i = 0; i < count; i++) {
        uint64_t a = read_ptr(dataPtr + i * 8);
        if (!a || a == g_LocalPawn) continue;
        if (!IsPlayer(a)) continue;
        float hp = read_f32(a + OFF_HEALTH);
        if (hp <= 0.f) continue;
        if (safe_addr(a+OFF_bDEAD) && *(bool*)(a+OFF_bDEAD)) continue;
        uint64_t root = read_ptr(a + OFF_ROOTCOMP);
        if (!root) continue;
        float ax=read_f32(root+OFF_LOCATION), ay=read_f32(root+OFF_LOCATION+4), az=read_f32(root+OFF_LOCATION+8);
        float d = sqrtf((ax-g_LocalX)*(ax-g_LocalX)+(ay-g_LocalY)*(ay-g_LocalY)+(az-g_LocalZ)*(az-g_LocalZ));
        if (d > maxDist) continue;
        PlayerData* pd = [[PlayerData alloc] init];
        pd.address=a; pd.x=ax; pd.y=ay; pd.z=az;
        pd.health=hp; pd.distance=d; pd.isAlive=YES;
        pd.teamId=read_i32(a+OFF_TEAMID);
        pd.isEnemy=(pd.teamId!=g_LocalTeam)||(pd.teamId==0);
        [players addObject:pd];
    }

    if (gConfig.aimbotEnabled && g_LocalPC && players.count) {
        PlayerData* best=nil; float bd=FLT_MAX;
        for (PlayerData* p in players) { if (p.isAlive&&p.isEnemy&&p.distance<bd){bd=p.distance;best=p;} }
        if (best) {
            float tz=best.z;
            if (gConfig.aimTarget==Target_Head) tz+=1.7f;
            else if (gConfig.aimTarget==Target_Body) tz+=1.0f;
            else tz+=1.2f+((arc4random()%40)/100.f);
            float dx=best.x-g_LocalX, dy=best.y-g_LocalY, dz=tz-g_LocalZ;
            float yaw=atan2f(dy,dx)*(180.f/M_PI);
            float pitch=-atan2f(dz,sqrtf(dx*dx+dy*dy))*(180.f/M_PI);
            if (yaw<0) yaw+=360.f;
            pitch=fmaxf(-89.f,fminf(89.f,pitch));
            float err=((arc4random()%100)-50.f)/100.f*0.3f;
            yaw+=err; pitch+=err*0.5f;
            float spd=gConfig.aimbotSpeed, factor;
            if      (spd<=50)  factor=0.06f;
            else if (spd<=115) factor=spd/280.f;
            else if (spd<=135) factor=spd/180.f;
            else               factor=1.f;
            factor=fmaxf(0.01f,fminf(1.f,factor));
            uint64_t cr=g_LocalPC+OFF_ROTATION;
            if (safe_addr(cr)) {
                float cp=read_f32(cr), cy=read_f32(cr+4);
                float dY=yaw-cy, dP=pitch-cp;
                if(dY>180)dY-=360; if(dY<-180)dY+=360;
                float nY=cy+dY*factor, nP=cp+dP*factor;
                if(fabsf(nY-cy)>0.01f||fabsf(nP-cp)>0.01f){ *(float*)cr=nP; *(float*)(cr+4)=nY; }
            }
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RavFenUpdateESP" object:nil
                                                          userInfo:@{@"players":players}];
    });
}

// ====================================================================
// 🖥️ ESP Overlay
// ====================================================================
@interface ESPOverlayView : UIView
@end
@implementation ESPOverlayView {
    float _sw, _sh;
    NSArray<PlayerData*>* _players;
}
- (instancetype)initWithFrame:(CGRect)f {
    self=[super initWithFrame:f];
    if(self){ self.backgroundColor=[UIColor clearColor]; self.userInteractionEnabled=NO;
        _sw=f.size.width; _sh=f.size.height;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onESP:) name:@"RavFenUpdateESP" object:nil]; }
    return self;
}
- (void)onESP:(NSNotification*)n { _players=n.userInfo[@"players"]; [self setNeedsDisplay]; }
- (BOOL)w2s:(float)wx y:(float)wy z:(float)wz ox:(float*)ox oy:(float*)oy {
    float*m=g_ViewMatrix;
    float cx=m[0]*wx+m[4]*wy+m[8]*wz+m[12], cy=m[1]*wx+m[5]*wy+m[9]*wz+m[13], cw=m[3]*wx+m[7]*wy+m[11]*wz+m[15];
    if(cw<0.1f) return NO;
    *ox=(_sw/2)+(cx/cw)*(_sw/2); *oy=(_sh/2)-(cy/cw)*(_sh/2); return YES;
}
- (void)drawRect:(CGRect)r {
    if(!gConfig.espEnabled||!_players.count) return;
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    for(PlayerData* p in _players) {
        if(!p.isAlive||!p.isEnemy) continue;
        float sx,sy;
        if(![self w2s:p.x y:p.y z:p.z+1.8f ox:&sx oy:&sy]) continue;
        if(sx<0||sx>_sw||sy<0||sy>_sh) continue;
        if(gConfig.espBoxes) {
            float h=fmaxf(20,fminf(120,800.f/p.distance)), w=h*0.55f;
            CGContextSetStrokeColorWithColor(ctx,[UIColor redColor].CGColor);
            CGContextSetLineWidth(ctx,1.5f);
            CGContextStrokeRect(ctx,CGRectMake(sx-w/2,sy-h,w,h));
        }
        if(gConfig.espLines) {
            CGContextSetStrokeColorWithColor(ctx,[UIColor yellowColor].CGColor);
            CGContextSetLineWidth(ctx,1.2f);
            CGContextMoveToPoint(ctx,_sw/2,_sh);
            CGContextAddLineToPoint(ctx,sx,sy);
            CGContextStrokePath(ctx);
        }
        // HP bar
        float hRatio=fmaxf(0,fminf(1,p.health/100.f));
        float bh=fmaxf(20,fminf(120,800.f/p.distance));
        CGContextSetFillColorWithColor(ctx,[UIColor colorWithRed:1-hRatio green:hRatio blue:0 alpha:0.8].CGColor);
        CGContextFillRect(ctx,CGRectMake(sx+bh*0.55f/2+2,sy-bh*hRatio,4,bh*hRatio));
    }
}
@end

// ====================================================================
// 🏰 Armor icon drawing
// ====================================================================
static void DrawArmorFigure(CGContextRef ctx, CGRect rect) {
    CGFloat w=rect.size.width, h=rect.size.height;
    CGFloat cx=CGRectGetMidX(rect);

    // Gold gradient
    CGColorSpaceRef cs=CGColorSpaceCreateDeviceRGB();
    CGFloat gc[]={1.0,0.84,0.0,1.0, 0.8,0.6,0.0,1.0};
    CGGradientRef gr=CGGradientCreateWithColorComponents(cs,gc,(CGFloat[]){0,1},2);

    // Helmet (visor shape)
    CGMutablePathRef helm=CGPathCreateMutable();
    CGPathAddEllipseInRect(helm,nil,CGRectMake(cx-w*0.20,h*0.04,w*0.40,h*0.28));
    CGContextAddPath(ctx,helm);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx,gr,CGPointMake(cx,h*0.04),CGPointMake(cx,h*0.32),0);
    CGContextResetClip(ctx);
    // Visor slit
    CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithWhite:0.1 alpha:0.9].CGColor);
    CGContextSetLineWidth(ctx,2.0);
    CGContextMoveToPoint(ctx,cx-w*0.13,h*0.20);
    CGContextAddLineToPoint(ctx,cx+w*0.13,h*0.20);
    CGContextStrokePath(ctx);
    // Plume
    CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.9].CGColor);
    CGContextSetLineWidth(ctx,3.0);
    for(int i=-1;i<=1;i++){
        CGContextMoveToPoint(ctx,cx+i*w*0.06,h*0.04);
        CGContextAddCurveToPoint(ctx,cx+i*w*0.12,-h*0.04,cx+i*w*0.08,-h*0.06,cx+i*w*0.03,-h*0.02);
    }
    CGContextStrokePath(ctx);

    // Body armor
    CGMutablePathRef body=CGPathCreateMutable();
    CGPathMoveToPoint(body,nil,cx-w*0.26,h*0.34);
    CGPathAddLineToPoint(body,nil,cx+w*0.26,h*0.34);
    CGPathAddLineToPoint(body,nil,cx+w*0.20,h*0.70);
    CGPathAddLineToPoint(body,nil,cx-w*0.20,h*0.70);
    CGPathCloseSubpath(body);
    CGContextAddPath(ctx,body);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx,gr,CGPointMake(cx,h*0.34),CGPointMake(cx,h*0.70),0);
    CGContextResetClip(ctx);
    // Armor lines
    CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithRed:0.6 green:0.45 blue:0.0 alpha:0.8].CGColor);
    CGContextSetLineWidth(ctx,1.0);
    CGContextMoveToPoint(ctx,cx,h*0.34); CGContextAddLineToPoint(ctx,cx,h*0.70); CGContextStrokePath(ctx);
    CGContextMoveToPoint(ctx,cx-w*0.22,h*0.50); CGContextAddLineToPoint(ctx,cx+w*0.22,h*0.50); CGContextStrokePath(ctx);

    // Shield (left side)
    CGMutablePathRef shield=CGPathCreateMutable();
    CGPathMoveToPoint(shield,nil,cx-w*0.48,h*0.34);
    CGPathAddLineToPoint(shield,nil,cx-w*0.22,h*0.34);
    CGPathAddLineToPoint(shield,nil,cx-w*0.22,h*0.65);
    CGPathAddQuadCurveToPoint(shield,nil,cx-w*0.45,h*0.72,cx-w*0.50,h*0.60);
    CGPathCloseSubpath(shield);
    CGContextAddPath(ctx,shield);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx,gr,CGPointMake(cx-w*0.48,h*0.34),CGPointMake(cx-w*0.22,h*0.65),0);
    CGContextResetClip(ctx);
    // Shield cross
    CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithRed:0.6 green:0.45 blue:0.0 alpha:0.9].CGColor);
    CGContextSetLineWidth(ctx,1.5);
    CGContextMoveToPoint(ctx,cx-w*0.35,h*0.38); CGContextAddLineToPoint(ctx,cx-w*0.35,h*0.63); CGContextStrokePath(ctx);
    CGContextMoveToPoint(ctx,cx-w*0.46,h*0.50); CGContextAddLineToPoint(ctx,cx-w*0.24,h*0.50); CGContextStrokePath(ctx);

    // Sword (right side)
    CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithWhite:0.9 alpha:0.95].CGColor);
    CGContextSetLineWidth(ctx,3.0);
    CGContextMoveToPoint(ctx,cx+w*0.34,h*0.22);
    CGContextAddLineToPoint(ctx,cx+w*0.44,h*0.72);
    CGContextStrokePath(ctx);
    // Guard
    CGContextSetLineWidth(ctx,2.0);
    CGContextMoveToPoint(ctx,cx+w*0.27,h*0.43); CGContextAddLineToPoint(ctx,cx+w*0.49,h*0.43); CGContextStrokePath(ctx);

    // Pauldrons (shoulder pads)
    CGContextSetFillColorWithColor(ctx,[UIColor colorWithRed:0.9 green:0.75 blue:0.0 alpha:0.9].CGColor);
    CGContextFillEllipseInRect(ctx,CGRectMake(cx-w*0.42,h*0.28,w*0.18,h*0.12));
    CGContextFillEllipseInRect(ctx,CGRectMake(cx+w*0.24,h*0.28,w*0.18,h*0.12));

    // Border
    CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithRed:0.5 green:0.35 blue:0.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(ctx,1.5);
    CGContextAddPath(ctx,body); CGContextStrokePath(ctx);
    CGContextAddPath(ctx,helm); CGContextStrokePath(ctx);
    CGContextAddPath(ctx,shield); CGContextStrokePath(ctx);

    CGGradientRelease(gr); CGColorSpaceRelease(cs);
    CGPathRelease(helm); CGPathRelease(body); CGPathRelease(shield);
}

@interface ArmorIconView : UIView @end
@implementation ArmorIconView
- (void)drawRect:(CGRect)r {
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    DrawArmorFigure(ctx,r);
}
@end

// ====================================================================
// 📱 RavMenuView (forward declaration for RavUIManager close callback)
// ====================================================================
@class RavMenuView;

// ====================================================================
// 📱 Menu UI – Golden Knight
// ====================================================================
@interface RavMenuView : UIView
@property (nonatomic, copy) void(^onClose)(void);  // FIX: callback to notify UIManager
@end

@implementation RavMenuView {
    UIView* _card;
    UIView* _content;
    UISwitch* _swAim, *_swESP, *_swBox, *_swLine;
    UISlider* _slSpeed;
    UISegmentedControl* _segTarget;
    UILabel* _lblSpeedVal;
}

- (instancetype)initWithFrame:(CGRect)f {
    self=[super initWithFrame:f];
    if(self){ self.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6]; [self build]; }
    return self;
}

- (UIColor*)gold     { return [UIColor colorWithRed:1.00 green:0.84 blue:0.00 alpha:1.0]; }
- (UIColor*)goldDim  { return [UIColor colorWithRed:0.80 green:0.65 blue:0.00 alpha:1.0]; }
- (UIColor*)darkBG   { return [UIColor colorWithRed:0.07 green:0.07 blue:0.12 alpha:0.97]; }
- (UIColor*)panelBG  { return [UIColor colorWithRed:0.10 green:0.10 blue:0.18 alpha:1.0]; }

- (void)build {
    CGFloat W=self.bounds.size.width, H=self.bounds.size.height;
    CGFloat cw=MIN(W*0.88f, 380), ch=MIN(H*0.82f, 560);
    CGFloat cx=(W-cw)/2, cy=(H-ch)/2;

    _card=[[UIView alloc] initWithFrame:CGRectMake(cx,cy,cw,ch)];
    _card.backgroundColor=[self darkBG];
    _card.layer.cornerRadius=22;
    _card.layer.borderWidth=1.5;
    _card.layer.borderColor=[self goldDim].CGColor;
    _card.clipsToBounds=NO;

    // Shadow
    _card.layer.shadowColor=[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.5].CGColor;
    _card.layer.shadowOffset=CGSizeMake(0,4);
    _card.layer.shadowRadius=16;
    _card.layer.shadowOpacity=0.6;
    [self addSubview:_card];

    // Inner clip view (so content clips to corner)
    UIView* inner=[[UIView alloc] initWithFrame:_card.bounds];
    inner.layer.cornerRadius=22;
    inner.clipsToBounds=YES;
    inner.backgroundColor=[UIColor clearColor];
    [_card addSubview:inner];

    // Header gradient banner
    UIView* header=[[UIView alloc] initWithFrame:CGRectMake(0,0,cw,88)];
    CAGradientLayer* hg=[CAGradientLayer layer];
    hg.frame=header.bounds;
    hg.colors=@[(id)[UIColor colorWithRed:0.18 green:0.14 blue:0.05 alpha:1.0].CGColor,
                (id)[UIColor colorWithRed:0.07 green:0.07 blue:0.12 alpha:1.0].CGColor];
    hg.startPoint=CGPointMake(0,0); hg.endPoint=CGPointMake(0,1);
    [header.layer addSublayer:hg];
    [inner addSubview:header];

    // Armor figure in header
    ArmorIconView* av=[[ArmorIconView alloc] initWithFrame:CGRectMake(cw/2-30,6,60,76)];
    av.backgroundColor=[UIColor clearColor];
    [header addSubview:av];

    // Title
    UILabel* title=[[UILabel alloc] initWithFrame:CGRectMake(0,90,cw,22)];
    title.textAlignment=NSTextAlignmentCenter;
    title.font=[UIFont fontWithName:@"AvenirNext-Heavy" size:14] ?: [UIFont boldSystemFontOfSize:14];
    // FIX: use attributedText directly instead of category letterSpacing (iOS 7 target)
    title.attributedText=[[NSAttributedString alloc] initWithString:@"⚔  RAVFEN SHADOW  ⚔"
        attributes:@{NSKernAttributeName:@(2.0),
                     NSForegroundColorAttributeName:[self gold],
                     NSFontAttributeName:title.font}];
    [inner addSubview:title];

    UILabel* sub=[[UILabel alloc] initWithFrame:CGRectMake(0,112,cw,16)];
    sub.text=@"PUBG TW 4.5  •  v8.4";
    sub.textColor=[UIColor colorWithWhite:0.5 alpha:1.0];
    sub.textAlignment=NSTextAlignmentCenter;
    sub.font=[UIFont systemFontOfSize:11];
    [inner addSubview:sub];

    // Divider
    UIView* div=[[UIView alloc] initWithFrame:CGRectMake(20,134,cw-40,1)];
    div.backgroundColor=[self goldDim];
    div.alpha=0.4;
    [inner addSubview:div];

    // Close button
    UIButton* close=[UIButton buttonWithType:UIButtonTypeSystem];
    close.frame=CGRectMake(cw-42,10,32,32);
    close.backgroundColor=[UIColor colorWithWhite:0.15 alpha:0.9];
    close.layer.cornerRadius=16;
    close.layer.borderWidth=1;
    close.layer.borderColor=[self goldDim].CGColor;
    [close setTitle:@"✕" forState:UIControlStateNormal];
    [close setTitleColor:[self gold] forState:UIControlStateNormal];
    close.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    [close addTarget:self action:@selector(doClose) forControlEvents:UIControlEventTouchUpInside];
    [inner addSubview:close];

    // Content
    _content=[[UIView alloc] initWithFrame:CGRectMake(0,142,cw,ch-150)];
    [inner addSubview:_content];

    // Tabs
    NSArray* tabs=@[@"AIMBOT",@"ESP",@"INFO"];
    CGFloat tw=cw/3;
    for(int i=0;i<3;i++){
        UIButton* tb=[UIButton buttonWithType:UIButtonTypeSystem];
        tb.frame=CGRectMake(i*tw,0,tw,36);
        [tb setTitle:tabs[i] forState:UIControlStateNormal];
        [tb setTitleColor:(i==0?[self gold]:[UIColor colorWithWhite:0.4 alpha:1]) forState:UIControlStateNormal];
        tb.titleLabel.font=[UIFont fontWithName:@"AvenirNext-DemiBold" size:11]?:[UIFont boldSystemFontOfSize:11];
        tb.tag=i;
        [tb addTarget:self action:@selector(tab:) forControlEvents:UIControlEventTouchUpInside];
        [_content addSubview:tb];
    }

    UIView* tdiv=[[UIView alloc] initWithFrame:CGRectMake(10,36,cw-20,1)];
    tdiv.backgroundColor=[self goldDim]; tdiv.alpha=0.3;
    [_content addSubview:tdiv];

    UIView* page=[[UIView alloc] initWithFrame:CGRectMake(0,40,cw,ch-195)];
    page.tag=99;
    [_content addSubview:page];
    [self buildAimbot:page];
}

- (void)tab:(UIButton*)btn {
    for(UIView* v in _content.subviews) if([v isKindOfClass:[UIButton class]]&&v.tag<10)
        [(UIButton*)v setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
    [(UIButton*)btn setTitleColor:[self gold] forState:UIControlStateNormal];
    UIView* pg=[_content viewWithTag:99];
    for(UIView* v in pg.subviews) [v removeFromSuperview];
    if(btn.tag==0)[self buildAimbot:pg];
    else if(btn.tag==1)[self buildESP:pg];
    else [self buildInfo:pg];
}

- (UIView*)rowAt:(CGFloat)y in:(UIView*)p label:(NSString*)lbl sub:(NSString*)sub {
    UIView* row=[[UIView alloc] initWithFrame:CGRectMake(16,y,p.bounds.size.width-32,60)];
    row.backgroundColor=[self panelBG];
    row.layer.cornerRadius=12;
    row.layer.borderWidth=1;
    row.layer.borderColor=[UIColor colorWithWhite:0.15 alpha:1.0].CGColor;
    [p addSubview:row];
    UILabel* l=[[UILabel alloc] initWithFrame:CGRectMake(14,8,180,22)];
    l.text=lbl; l.textColor=[UIColor whiteColor];
    l.font=[UIFont fontWithName:@"AvenirNext-Medium" size:14]?:[UIFont systemFontOfSize:14];
    [row addSubview:l];
    if(sub.length){
        UILabel* s=[[UILabel alloc] initWithFrame:CGRectMake(14,30,180,18)];
        s.text=sub; s.textColor=[UIColor colorWithWhite:0.45 alpha:1];
        s.font=[UIFont systemFontOfSize:11]; [row addSubview:s];
    }
    return row;
}

- (UISwitch*)switchAt:(CGFloat)x y:(CGFloat)y in:(UIView*)p sel:(SEL)sel {
    UISwitch* sw=[[UISwitch alloc] initWithFrame:CGRectMake(x,y,0,0)];
    sw.onTintColor=[self gold];
    [sw addTarget:self action:sel forControlEvents:UIControlEventValueChanged];
    [p addSubview:sw];
    return sw;
}

- (void)buildAimbot:(UIView*)p {
    UIView* r1=[self rowAt:10 in:p label:@"Aimbot" sub:@"Silent aim assist"];
    _swAim=[self switchAt:r1.bounds.size.width-64 y:15 in:r1 sel:@selector(togAim)];

    UIView* r2=[self rowAt:80 in:p label:@"Target Zone" sub:@"Head / Body / Random"];
    _segTarget=[[UISegmentedControl alloc] initWithItems:@[@"Head",@"Body",@"Random"]];
    _segTarget.frame=CGRectMake(r2.bounds.size.width-230,12,220,36);
    _segTarget.selectedSegmentIndex=1;
    [_segTarget setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [_segTarget setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    // FIX: selectedSegmentTintColor requires iOS 13+
    if (@available(iOS 13.0, *)) {
        _segTarget.selectedSegmentTintColor=[self gold];
    }
    _segTarget.backgroundColor=[UIColor colorWithWhite:0.12 alpha:1.0];
    [_segTarget addTarget:self action:@selector(togTarget) forControlEvents:UIControlEventValueChanged];
    [r2 addSubview:_segTarget];

    UIView* r3=[self rowAt:150 in:p label:@"Speed" sub:@""];
    _lblSpeedVal=(UILabel*)[r3 viewWithTag:0];
    UILabel* sv=[[UILabel alloc] initWithFrame:CGRectMake(14,30,60,18)];
    sv.text=@"120"; sv.textColor=[self gold]; sv.font=[UIFont boldSystemFontOfSize:12];
    sv.tag=77; [r3 addSubview:sv]; _lblSpeedVal=sv;
    _slSpeed=[[UISlider alloc] initWithFrame:CGRectMake(80,32,r3.bounds.size.width-94,14)];
    _slSpeed.minimumValue=50; _slSpeed.maximumValue=250; _slSpeed.value=120;
    _slSpeed.minimumTrackTintColor=[self gold];
    [_slSpeed addTarget:self action:@selector(spdChg) forControlEvents:UIControlEventValueChanged];
    [r3 addSubview:_slSpeed];

    UILabel* warn=[[UILabel alloc] initWithFrame:CGRectMake(16,224,p.bounds.size.width-32,20)];
    warn.text=@"⚠️  Speed > 135 or Head aim increases ban risk";
    warn.textColor=[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:0.9];
    warn.font=[UIFont systemFontOfSize:11]; warn.textAlignment=NSTextAlignmentCenter;
    [p addSubview:warn];
}

- (void)buildESP:(UIView*)p {
    UIView* r1=[self rowAt:10 in:p label:@"ESP" sub:@"Player highlights"];
    _swESP=[self switchAt:r1.bounds.size.width-64 y:15 in:r1 sel:@selector(togESP)];
    UIView* r2=[self rowAt:80 in:p label:@"Boxes" sub:@"Bounding box around enemies"];
    _swBox=[self switchAt:r2.bounds.size.width-64 y:15 in:r2 sel:@selector(togBox)];
    UIView* r3=[self rowAt:150 in:p label:@"Lines" sub:@"Line to enemy feet"];
    _swLine=[self switchAt:r3.bounds.size.width-64 y:15 in:r3 sel:@selector(togLine)];
}

- (void)buildInfo:(UIView*)p {
    NSArray* rows=@[@[@"GUObject",  @"0x10A88BA60"],
                    @[@"GNames",    @"0x1050C4AB4"],
                    @[@"ActorArr",  @"0x106419D7C"],
                    @[@"ViewMatrix",@"0x106367344"],
                    @[@"Game",      @"PUBG TW 4.5.0"]];
    for(int i=0;i<rows.count;i++){
        UIView* r=[self rowAt:10+i*70 in:p label:rows[i][0] sub:rows[i][1]];
        (void)r;
    }
}

- (void)togAim   { gConfig.aimbotEnabled=_swAim.isOn; }
- (void)spdChg   { gConfig.aimbotSpeed=_slSpeed.value; _lblSpeedVal.text=[NSString stringWithFormat:@"%.0f",_slSpeed.value]; }
- (void)togTarget{ gConfig.aimTarget=(AimTarget)_segTarget.selectedSegmentIndex; }
- (void)togESP   { gConfig.espEnabled=_swESP.isOn; }
- (void)togBox   { gConfig.espBoxes=_swBox.isOn; }
- (void)togLine  { gConfig.espLines=_swLine.isOn; }

// FIX: instead of removing self directly, call the callback so UIManager resets _menuVisible
- (void)doClose {
    if(self.onClose) self.onClose();
}

- (void)animateIn {
    self.alpha=0; self.transform=CGAffineTransformMakeScale(0.9,0.9);
    [UIView animateWithDuration:0.28 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha=1; self.transform=CGAffineTransformIdentity;
    } completion:nil];
}

- (void)animateOut:(void(^)(void))done {
    [UIView animateWithDuration:0.20 animations:^{
        self.alpha=0; self.transform=CGAffineTransformMakeScale(0.9,0.9);
    } completion:^(BOOL f){ if(done) done(); }];
}
@end

// Trick for letterSpacing on UILabel (runtime method)
@interface UILabel (Spacing) @end
@implementation UILabel (Spacing)
- (void)setLetterSpacing:(CGFloat)s {
    NSMutableAttributedString* as=[[NSMutableAttributedString alloc] initWithString:self.text attributes:@{
        NSKernAttributeName:@(s), NSForegroundColorAttributeName:self.textColor, NSFontAttributeName:self.font}];
    self.attributedText=as;
}
@end

// ====================================================================
// 📱 UI Manager
// ====================================================================
@interface RavUIManager : NSObject
+ (instancetype)shared;
- (void)setup;
- (UIWindow*)findKeyWindow;
@end

@implementation RavUIManager {
    UIButton*    _btn;
    RavMenuView* _menu;
    BOOL         _menuVisible;
}

+ (instancetype)shared {
    static RavUIManager* s=nil;
    static dispatch_once_t t;
    dispatch_once(&t,^{ s=[[RavUIManager alloc] init]; });
    return s;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                      object:nil queue:[NSOperationQueue mainQueue]
                                                 usingBlock:^(NSNotification* n){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(4.0*NSEC_PER_SEC)),dispatch_get_main_queue(),^{
            [self makeButton];
        });
    }];
}

- (void)makeButton {
    if(_btn) return;
    UIWindow* win=[self findKeyWindow];
    if(!win){ dispatch_after(dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC),dispatch_get_main_queue(),^{[self makeButton];}); return; }

    _btn=[UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame=CGRectMake(win.bounds.size.width-70,220,60,70);
    _btn.backgroundColor=[UIColor clearColor];

    // Armor icon
    ArmorIconView* icon=[[ArmorIconView alloc] initWithFrame:_btn.bounds];
    icon.backgroundColor=[UIColor clearColor];
    icon.userInteractionEnabled=NO;
    [_btn addSubview:icon];

    // Glow ring
    _btn.layer.shadowColor=[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.9].CGColor;
    _btn.layer.shadowRadius=8;
    _btn.layer.shadowOpacity=0.7;
    _btn.layer.shadowOffset=CGSizeZero;

    UIPanGestureRecognizer* pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_btn addGestureRecognizer:pan];
    [_btn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [win addSubview:_btn];

    // Idle pulse animation
    CABasicAnimation* pulse=[CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    pulse.fromValue=@0.4; pulse.toValue=@0.9;
    pulse.duration=1.4; pulse.autoreverses=YES; pulse.repeatCount=HUGE_VALF;
    [_btn.layer addAnimation:pulse forKey:@"pulse"];
}

- (void)pan:(UIPanGestureRecognizer*)g {
    CGPoint t=[g translationInView:_btn.superview];
    _btn.center=CGPointMake(_btn.center.x+t.x,_btn.center.y+t.y);
    [g setTranslation:CGPointZero inView:_btn.superview];
}

- (void)tap {
    // FIX: if menu was removed externally (via close callback), _menuVisible is already NO
    if(_menuVisible) { [self closeMenu]; return; }
    [self openMenu];
}

- (void)openMenu {
    if(_menuVisible) return;
    UIWindow* win=[self findKeyWindow]; if(!win) return;

    _menu=[[RavMenuView alloc] initWithFrame:win.bounds];

    // FIX: close callback resets _menuVisible so tap works again
    __weak typeof(self) ws=self;
    _menu.onClose=^{
        __strong typeof(ws) ss=ws;
        if(!ss) return;
        [ss->_menu animateOut:^{
            [ss->_menu removeFromSuperview];
            ss->_menu=nil;
            ss->_menuVisible=NO;
        }];
    };

    [win addSubview:_menu];
    [win bringSubviewToFront:_menu];
    [_menu animateIn];
    _menuVisible=YES;
}

- (void)closeMenu {
    if(!_menuVisible||!_menu) return;
    [_menu animateOut:^{
        [self->_menu removeFromSuperview];
        self->_menu=nil;
        self->_menuVisible=NO;
    }];
}

- (UIWindow*)findKeyWindow {
    if(@available(iOS 13.0,*)) {
        for(UIWindowScene* sc in [UIApplication sharedApplication].connectedScenes)
            if(sc.activationState==UISceneActivationStateForegroundActive)
                for(UIWindow* w in sc.windows) if(w.isKeyWindow) return w;
    }
    return [UIApplication sharedApplication].keyWindow;
}
@end

// ====================================================================
// 🚀 Constructor
// ====================================================================
__attribute__((constructor))
static void Init(void) {
    GetBase();
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RavUIManager shared] setup];

        UIWindow* win=[[RavUIManager shared] findKeyWindow] ?: [UIApplication sharedApplication].keyWindow;
        if(win) {
            ESPOverlayView* esp=[[ESPOverlayView alloc] initWithFrame:win.bounds];
            [win addSubview:esp];
            [win sendSubviewToBack:esp];
        }
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 8*NSEC_PER_SEC),
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        while(YES) { @autoreleasepool { GameLoop(); usleep(25000+arc4random()%10000); } }
    });
}
