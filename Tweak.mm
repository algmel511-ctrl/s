// ====================================================================
// RavFen Shadow v7.0 - PUBG Mobile 4.5.0 iOS Tweak (Final)
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
    kern_return_t kr = vm_read_overwrite(mach_task_self(), (vm_address_t)addr, (vm_size_t)sz, (vm_address_t)buf, &outsize);
    return kr == KERN_SUCCESS;
}

static BOOL WriteMem(uint64_t addr, const void *buf, size_t sz) {
    if (!addr || !buf) return NO;
    kern_return_t kr = vm_write(mach_task_self(), (vm_address_t)addr, (vm_offset_t)buf, (vm_size_t)sz);
    return kr == KERN_SUCCESS;
}

// ====================================================================
// 🧵 Config
// ====================================================================
static pthread_mutex_t g_ConfigMutex = PTHREAD_MUTEX_INITIALIZER;

typedef enum {
    AimbotMode_None = 0,
    AimbotMode_Lock = 1,
    AimbotMode_Fire = 2,
    AimbotMode_Scope = 3
} AimbotMode;

typedef struct {
    volatile BOOL aimbotEnabled;
    volatile float aimbotSpeed;
    volatile AimbotMode aimbotMode;
    volatile BOOL espEnabled;
    volatile BOOL espLine;
    volatile BOOL espBulletLine;
    volatile float espDistance;
    volatile BOOL menuVisible;
    volatile BOOL fps120Enabled;
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
        gOffsets[OFF_GW]  = 0xA9FA970;
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
// 📍 Memory Readers
// ====================================================================
static uint64_t ReadPtr(uint64_t addr) {
    uint64_t val = 0;
    if (!addr) return 0;
    if (!ReadMem(addr, &val, 8)) return 0;
    if (val < 0x100000 || val > 0x7FFFFFFFFFFFULL) return 0;
    return val;
}

static float ReadFloat(uint64_t addr) { float v=0; if(addr)ReadMem(addr,&v,4); return v; }
static int32_t ReadInt(uint64_t addr) { int32_t v=0; if(addr)ReadMem(addr,&v,4); return v; }
static BOOL WriteFloat(uint64_t addr, float val) {
    if(!addr)return NO; float c=ReadFloat(addr); if(fabsf(c-val)<0.001f)return YES; return WriteMem(addr,&val,4);
}
static BOOL WriteInt(uint64_t addr, int32_t val) {
    if(!addr)return NO; int32_t c=ReadInt(addr); if(c==val)return YES; return WriteMem(addr,&val,4);
}

// ====================================================================
// 👤 IsPlayer
// ====================================================================
static BOOL IsPlayer(uint64_t actor) {
    if(!actor)return NO;
    uint64_t gnBase=ReadPtr(GetBaseAddress()+OFF(OFF_GN)); if(!gnBase)return NO;
    uint32_t actorId=ReadInt(actor+OFF(OFF_AD)); if(actorId==0||actorId>10000000)return NO;
    uint32_t ci=actorId/0x3FE0,ni=actorId%0x3FE0;
    uint64_t chunk=ReadPtr(gnBase+ci*8); if(!chunk)return NO;
    uint64_t entry=chunk+ni*48; if(!entry)return NO;
    char name[24]={0}; if(!ReadMem(entry+8,name,20))return NO; name[20]='\0';
    char p1[]={0x50^0x21,0x6C^0x21,0x61^0x21,0x79^0x21,0x65^0x21,0x72^0x21,0x50^0x21,0x61^0x21,0x77^0x21,0x6E^0x21,0};
    char p2[]={0x42^0x21,0x50^0x21,0x5F^0x21,0x50^0x21,0x6C^0x21,0x61^0x21,0x79^0x21,0x65^0x21,0x72^0x21,0};
    char p3[]={0x50^0x21,0x6C^0x21,0x61^0x21,0x79^0x21,0x65^0x21,0x72^0x21,0x43^0x21,0x68^0x21,0x61^0x21,0x72^0x21,0x61^0x21,0x63^0x21,0x74^0x21,0x65^0x21,0x72^0x21,0};
    for(int i=0;p1[i];i++)p1[i]^=0x21; for(int i=0;p2[i];i++)p2[i]^=0x21; for(int i=0;p3[i];i++)p3[i]^=0x21;
    if(strstr(name,p1)||strstr(name,p2)||strstr(name,p3)){
        char b1[]={0x50^0x42,0x69^0x42,0x63^0x42,0x6B^0x42,0x75^0x42,0x70^0x42,0};
        char b2[]={0x44^0x42,0x72^0x42,0x6F^0x42,0x70^0x42,0x70^0x42,0x65^0x42,0x64^0x42,0};
        char b3[]={0x49^0x42,0x74^0x42,0x65^0x42,0x6D^0x42,0};
        for(int i=0;b1[i];i++)b1[i]^=0x42; for(int i=0;b2[i];i++)b2[i]^=0x42; for(int i=0;b3[i];i++)b3[i]^=0x42;
        if(!strstr(name,b1)&&!strstr(name,b2)&&!strstr(name,b3))return YES;
    }
    return NO;
}

static float g_LocalX=0,g_LocalY=0,g_LocalZ=0,g_ViewMatrix[16]={0};

// ====================================================================
// PlayerData
// ====================================================================
@interface PlayerData : NSObject
@property(nonatomic,assign)uint64_t address;
@property(nonatomic,assign)float x,y,z,health,distance;
@property(nonatomic,assign)BOOL isEnemy,isAlive;
@property(nonatomic,assign)uint64_t meshAddr,boneAddr;
@property(nonatomic,assign)int32_t teamId;
@end
@implementation PlayerData
@end

// ====================================================================
// 🌐 WorldToScreen
// ====================================================================
static BOOL WorldToScreen(float wx,float wy,float wz,float*sx,float*sy){
    float cx=g_ViewMatrix[0]*wx+g_ViewMatrix[4]*wy+g_ViewMatrix[8]*wz+g_ViewMatrix[12];
    float cy=g_ViewMatrix[1]*wx+g_ViewMatrix[5]*wy+g_ViewMatrix[9]*wz+g_ViewMatrix[13];
    float cw=g_ViewMatrix[3]*wx+g_ViewMatrix[7]*wy+g_ViewMatrix[11]*wz+g_ViewMatrix[15];
    if(cw<0.1f)return NO;
    float nx=cx/cw,ny=cy/cw;
    CGFloat sw=[UIScreen mainScreen].bounds.size.width,sh=[UIScreen mainScreen].bounds.size.height;
    *sx=(sw/2)+(nx*sw/2); *sy=(sh/2)-(ny*sh/2);
    return YES;
}

// ====================================================================
// 👥 GetPlayers
// ====================================================================
static NSArray<PlayerData*>*GetPlayers(void){
    NSMutableArray*arr=[NSMutableArray array];
    uint64_t base=GetBaseAddress();
    uint64_t gw=ReadPtr(base+OFF(OFF_GW)); if(!gw)return arr;
    uint64_t lvl=ReadPtr(gw+OFF(OFF_PL)); if(!lvl)return arr;
    uint64_t act=ReadPtr(lvl+OFF(OFF_AA)); int32_t cnt=ReadInt(lvl+OFF(OFF_AC));
    if(!act||cnt<=0||cnt>1000)return arr;
    uint64_t gi=ReadPtr(gw+OFF(OFF_GI)); if(!gi)return arr;
    uint64_t lpArr=ReadPtr(gi+OFF(OFF_LP)); if(!lpArr)return arr;
    uint64_t lp=ReadPtr(lpArr); if(!lp)return arr;
    uint64_t pc=ReadPtr(lp+OFF(OFF_PC)); if(!pc)return arr;
    uint64_t localPawn=ReadPtr(pc+OFF(OFF_AP));
    if(localPawn){uint64_t root=ReadPtr(localPawn+OFF(OFF_RC)); if(root){uint64_t ctw=ReadPtr(root+OFF(OFF_CTW)); if(ctw){g_LocalX=ReadFloat(ctw+0x10);g_LocalY=ReadFloat(ctw+0x14);g_LocalZ=ReadFloat(ctw+0x18);}}}
    int32_t localTeam=0; if(localPawn)localTeam=ReadInt(localPawn+OFF(OFF_TM));
    uint64_t vmAddr=ReadPtr(base+OFF(OFF_VMC)); if(vmAddr)ReadMem(vmAddr+OFF(OFF_VM),g_ViewMatrix,64);
    float maxDist=500.0f; pthread_mutex_lock(&g_ConfigMutex);maxDist=gConfig.espDistance;pthread_mutex_unlock(&g_ConfigMutex);
    for(int i=0;i<cnt;i++){
        @autoreleasepool{
            uint64_t actor=ReadPtr(act+i*8); if(!actor||actor==localPawn)continue; if(!IsPlayer(actor))continue;
            uint64_t root=ReadPtr(actor+OFF(OFF_RC)); if(!root)continue;
            float ax=0,ay=0,az=0; uint64_t ctw=ReadPtr(root+OFF(OFF_CTW)); if(ctw){ax=ReadFloat(ctw+0x10);ay=ReadFloat(ctw+0x14);az=ReadFloat(ctw+0x18);}
            if(ax==0&&ay==0&&az==0)continue;
            float dx=ax-g_LocalX,dy=ay-g_LocalY,dz=az-g_LocalZ,dist=sqrtf(dx*dx+dy*dy+dz*dz);
            if(dist<0.5f||dist>maxDist)continue;
            float hp=ReadFloat(actor+OFF(OFF_HP)); int32_t team=ReadInt(actor+OFF(OFF_TM)); uint64_t mesh=ReadPtr(actor+OFF(OFF_MS));
            PlayerData*p=[[PlayerData alloc]init]; p.address=actor;p.x=ax;p.y=ay;p.z=az;p.health=hp;p.distance=dist;
            p.isAlive=(hp>0.1f);p.teamId=team;p.isEnemy=(team!=localTeam)||(team==0);p.meshAddr=mesh; if(mesh)p.boneAddr=ReadPtr(mesh+OFF(OFF_BA));
            [arr addObject:p];
        }
    }
    return arr;
}

// ====================================================================
// 🛡️ Lobby & Anti-Ban
// ====================================================================
static BOOL isInLobby=YES;
static void UpdateLobbyStatus(void){
    uint64_t base=GetBaseAddress(); uint64_t gw=ReadPtr(base+OFF(OFF_GW)); if(!gw){isInLobby=YES;return;}
    uint64_t lvl=ReadPtr(gw+OFF(OFF_PL)); if(!lvl){isInLobby=YES;return;}
    isInLobby=(ReadInt(lvl+OFF(OFF_AC))<10);
}
static void AntiBanCheck(void){
    if(isInLobby)return; static int cc=0; cc++; if(cc%((arc4random()%3000)+2000)!=0)return;
    int mib[4]={CTL_KERN,KERN_PROC,KERN_PROC_PID,getpid()}; struct kinfo_proc info; size_t sz=sizeof(info);
    if(sysctl(mib,4,&info,&sz,NULL,0)==0){if(info.kp_proc.p_flag&P_TRACED){static int dc=0;dc++;if(dc>=3)__asm__ volatile("mov x0,#0; str x0,[x0]");}}
}

// ====================================================================
// 🎯 Aimbot
// ====================================================================
static BOOL isFiring=NO,isScoping=NO;
static void DoAimbot(NSArray<PlayerData*>*players){
    if(isInLobby)return;
    BOOL en=NO;float sp=5.0f;AimbotMode mode=AimbotMode_None;
    pthread_mutex_lock(&g_ConfigMutex);en=gConfig.aimbotEnabled;sp=gConfig.aimbotSpeed;mode=gConfig.aimbotMode;pthread_mutex_unlock(&g_ConfigMutex);
    if(!en||!players||players.count==0||mode==AimbotMode_None)return;
    BOOL aim=NO; switch(mode){case AimbotMode_Lock:aim=YES;break;case AimbotMode_Fire:aim=isFiring;break;case AimbotMode_Scope:aim=isScoping;break;default:break;}
    if(!aim)return;
    PlayerData*best=nil;float closest=FLT_MAX;
    for(PlayerData*p in players){if(!p.isAlive||p.distance>500.0f)continue; if(p.distance<closest){closest=p.distance;best=p;}}
    if(!best)return;
    uint64_t base=GetBaseAddress(); uint64_t gw=ReadPtr(base+OFF(OFF_GW));if(!gw)return;
    uint64_t gi=ReadPtr(gw+OFF(OFF_GI));if(!gi)return; uint64_t lpArr=ReadPtr(gi+OFF(OFF_LP));if(!lpArr)return;
    uint64_t lp=ReadPtr(lpArr);if(!lp)return; uint64_t pc=ReadPtr(lp+OFF(OFF_PC));if(!pc)return;
    float camX=g_LocalX,camY=g_LocalY,camZ=g_LocalZ,targetH=1.75f+((arc4random()%10)/100.0f),tz=best.z+targetH;
    float dx=best.x-camX,dy=best.y-camY,dz=tz-camZ;
    float yaw=atan2f(dy,dx)*(180.0f/M_PI),pitch=-atan2f(dz,sqrtf(dx*dx+dy*dy))*(180.0f/M_PI);
    if(yaw<0)yaw+=360.0f; if(pitch>89.0f)pitch=89.0f; if(pitch<-89.0f)pitch=-89.0f;
    yaw+=((arc4random()%100)-50)/500.0f; pitch+=((arc4random()%100)-50)/500.0f;
    uint64_t crAddr=pc+OFF(OFF_CR); float curPitch=ReadFloat(crAddr),curYaw=ReadFloat(crAddr+4);
    float dist=best.distance,factor;
    if(sp<=50.0f){factor=(dist>50.0f)?0.08f:0.15f;}
    else if(sp<=115.0f){factor=(dist>100.0f)?sp/250.0f:sp/200.0f;}
    else if(sp<=135.0f){factor=sp/160.0f;}else{factor=1.0f;}
    if(factor>1.0f)factor=1.0f; if(factor<0.01f)factor=0.01f;
    float dyaw=yaw-curYaw,dpitch=pitch-curPitch; if(dyaw>180.0f)dyaw-=360.0f; if(dyaw<-180.0f)dyaw+=360.0f;
    WriteFloat(crAddr,curPitch+dpitch*factor); WriteFloat(crAddr+4,curYaw+dyaw*factor);
}

// ====================================================================
// ⚡ 120 FPS
// ====================================================================
static void SetFPS120(void){
    BOOL en=NO; pthread_mutex_lock(&g_ConfigMutex);en=gConfig.fps120Enabled;pthread_mutex_unlock(&g_ConfigMutex);
    if(!en||isInLobby)return;
    uint64_t base=GetBaseAddress(); static uint64_t addr=0; static dispatch_once_t ot;
    dispatch_once(&ot,^{for(uint64_t a=base;a<base+0x20000000;a+=8){float v=ReadFloat(a);if(v==30.0f||v==60.0f){float nv=ReadFloat(a+4);if(nv==0.0f||nv==1.0f){addr=a;break;}}}});
    if(addr){WriteFloat(addr,120.0f);WriteInt(addr+0x10,0);}
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(arc4random()%3+5)*NSEC_PER_SEC),dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0),^{SetFPS120();});
}

// ====================================================================
// 🖥️ Anti-Detach
// ====================================================================
static void*AntiDetachLoop(void*arg){
    char*name=NULL; uint32_t cnt=_dyld_image_count(); for(uint32_t i=0;i<cnt;i++){const char*n=_dyld_get_image_name(i); if(n){name=strdup(n);break;}}
    if(!name)return NULL;
    while(YES){uint32_t c=_dyld_image_count();BOOL f=NO; for(uint32_t i=0;i<c;i++){const char*n=_dyld_get_image_name(i); if(n&&strcmp(n,name)==0){f=YES;break;}} usleep(f?(arc4random()%3000000+5000000):(arc4random()%500000+1000000));}
    free(name);return NULL;
}

// ====================================================================
// 🎨 ESP Overlay
// ====================================================================
@interface ESPOverlayView : UIView
@property(nonatomic,strong)CAShapeLayer*boxLayer,*lineLayer,*bulletLineLayer;
@property(nonatomic,strong)UILabel*playerCountLabel,*watermark;
@end
@implementation ESPOverlayView
- (instancetype)initWithFrame:(CGRect)f{
    self=[super initWithFrame:f]; if(self){self.backgroundColor=[UIColor clearColor];self.userInteractionEnabled=NO;
        _boxLayer=[CAShapeLayer layer];_boxLayer.strokeColor=[[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.9]CGColor];_boxLayer.fillColor=[[UIColor clearColor]CGColor];_boxLayer.lineWidth=1.5;[self.layer addSublayer:_boxLayer];
        _lineLayer=[CAShapeLayer layer];_lineLayer.strokeColor=[[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.7]CGColor];_lineLayer.lineWidth=1.0;_lineLayer.lineDashPattern=@[@3,@3];[self.layer addSublayer:_lineLayer];
        _bulletLineLayer=[CAShapeLayer layer];_bulletLineLayer.strokeColor=[[UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:0.9]CGColor];_bulletLineLayer.lineWidth=2.0;[self.layer addSublayer:_bulletLineLayer];
        _playerCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,60,f.size.width,25)];
        [_playerCountLabel setText:@"Players: 0"];[_playerCountLabel setTextColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.9]];
        [_playerCountLabel setFont:[UIFont boldSystemFontOfSize:15]];[_playerCountLabel setTextAlignment:NSTextAlignmentCenter];
        [_playerCountLabel setShadowColor:[UIColor blackColor]];[_playerCountLabel setShadowOffset:CGSizeMake(1,1)];
        [self addSubview:_playerCountLabel];
        _watermark=[[UILabel alloc]initWithFrame:CGRectMake(-200,f.size.height*0.92,200,25)];
        [_watermark setText:@"RavFen Shadow"];[_watermark setTextColor:[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.15]];
        [_watermark setFont:[UIFont boldSystemFontOfSize:16]];[self addSubview:_watermark];
        [NSTimer scheduledTimerWithTimeInterval:0.033 repeats:YES block:^(NSTimer*t){if(!self.superview){[t invalidate];return;}CGRect r=_watermark.frame;r.origin.x+=1.5;if(r.origin.x>f.size.width)r.origin.x=-200;_watermark.frame=r;}];
    }return self;
}
- (void)updateWithPlayers:(NSArray<PlayerData*>*)players{
    BOOL espOn=NO,lineOn=NO,bulletOn=NO;
    pthread_mutex_lock(&g_ConfigMutex);espOn=gConfig.espEnabled;lineOn=gConfig.espLine;bulletOn=gConfig.espBulletLine;pthread_mutex_unlock(&g_ConfigMutex);
    if(!espOn||!players||players.count==0){self.boxLayer.path=nil;self.lineLayer.path=nil;self.bulletLineLayer.path=nil;[_playerCountLabel setText:@"Players: 0"];return;}
    UIBezierPath*bp=[UIBezierPath bezierPath],*lp=[UIBezierPath bezierPath],*blp=[UIBezierPath bezierPath];
    int c=0;CGFloat sw=self.bounds.size.width,sh=self.bounds.size.height;
    for(PlayerData*p in players){if(!p.isEnemy||!p.isAlive)continue;c++;float sx=0,sy=0;if(!WorldToScreen(p.x,p.y,p.z+1.75f,&sx,&sy))continue;if(sx<-50||sx>sw+50||sy<-50||sy>sh+50)continue;CGRect b=CGRectMake(sx-25,sy-50,50,100);[bp appendPath:[UIBezierPath bezierPathWithRect:b]];if(lineOn){[lp moveToPoint:CGPointMake(sw/2,sh/2)];[lp addLineToPoint:CGPointMake(sx,sy)];}if(bulletOn){[blp moveToPoint:CGPointMake(sx,sy-50)];[blp addLineToPoint:CGPointMake(sx,sy+50)];}}
    dispatch_async(dispatch_get_main_queue(),^{self.boxLayer.path=bp.CGPath;self.lineLayer.path=lp.CGPath;self.bulletLineLayer.path=blp.CGPath;[_playerCountLabel setText:[NSString stringWithFormat:@"Players: %d",c]];});
}
@end

// ====================================================================
// Splash & Captcha
// ====================================================================
@interface RavSplashView : UIView @end
@implementation RavSplashView
- (instancetype)initWithFrame:(CGRect)f{self=[super initWithFrame:f];if(self){self.backgroundColor=[UIColor blackColor];
    UILabel*l=[[UILabel alloc]init];[l setText:@"R"];[l setTextColor:[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0]];[l setFont:[UIFont boldSystemFontOfSize:100]];[l setTextAlignment:NSTextAlignmentCenter];l.frame=CGRectMake(0,f.size.height*0.3,f.size.width,120);[self addSubview:l];
    UILabel*t=[[UILabel alloc]init];[t setText:@"RavFen Shadow"];[t setTextColor:[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.8]];[t setFont:[UIFont boldSystemFontOfSize:22]];[t setTextAlignment:NSTextAlignmentCenter];t.frame=CGRectMake(0,f.size.height*0.5,f.size.width,40);[self addSubview:t];
    l.alpha=0;t.alpha=0;[UIView animateWithDuration:0.6 delay:0.2 options:0 animations:^{l.alpha=1;} completion:nil];[UIView animateWithDuration:0.5 delay:0.5 options:0 animations:^{t.alpha=1;} completion:nil];
}return self;}
@end

@interface RavCaptchaView : UIView
@property(nonatomic,copy)void(^onDone)(void);
@end
@implementation RavCaptchaView
- (instancetype)initWithFrame:(CGRect)f{self=[super initWithFrame:f];if(self){self.backgroundColor=[UIColor blackColor];
    UILabel*l=[[UILabel alloc]init];[l setText:@"Tap to Start"];[l setTextColor:[UIColor whiteColor]];[l setFont:[UIFont boldSystemFontOfSize:26]];[l setTextAlignment:NSTextAlignmentCenter];l.frame=CGRectMake(0,f.size.height*0.45,f.size.width,40);[self addSubview:l];
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{l.alpha=0.3;} completion:nil];
    UITapGestureRecognizer*tg=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];[self addGestureRecognizer:tg];
}return self;}
- (void)tap{self.userInteractionEnabled=NO;[UIView animateWithDuration:0.3 animations:^{self.alpha=0;} completion:^(BOOL f){[self removeFromSuperview];if(self.onDone)self.onDone();}];}
@end

// ====================================================================
// 🔘 Floating Button
// ====================================================================
@interface RavFloatingButton : UIView{UILabel*_l;UILabel*_rt;UIPanGestureRecognizer*_p;CGFloat _a;}
@property(nonatomic,copy)void(^onTap)(void);
@end
@implementation RavFloatingButton
- (instancetype)initWithFrame:(CGRect)f{self=[super initWithFrame:f];if(self){_a=0;
    self.backgroundColor=[UIColor colorWithRed:0.3 green:0.0 blue:0.5 alpha:0.7];self.layer.cornerRadius=f.size.width/2;self.layer.borderWidth=2;self.layer.borderColor=[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.8].CGColor;
    _l=[[UILabel alloc]init];[_l setText:@"R"];[_l setTextColor:[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0]];[_l setFont:[UIFont boldSystemFontOfSize:26]];[_l setTextAlignment:NSTextAlignmentCenter];_l.frame=self.bounds;_l.userInteractionEnabled=NO;[self addSubview:_l];
    _rt=[[UILabel alloc]init];[_rt setText:@"RavFen"];[_rt setTextColor:[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.5]];[_rt setFont:[UIFont boldSystemFontOfSize:9]];_rt.frame=CGRectMake(0,0,45,12);_rt.userInteractionEnabled=NO;[self addSubview:_rt];
    _p=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];[self addGestureRecognizer:_p];
    UITapGestureRecognizer*tp=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];[self addGestureRecognizer:tp];[_p requireGestureRecognizerToFail:tp];
    [NSTimer scheduledTimerWithTimeInterval:0.03 repeats:YES block:^(NSTimer*t){if(!self.superview){[t invalidate];return;}_a+=0.1;CGFloat r=30,cx=self.bounds.size.width/2,cy=self.bounds.size.height/2;_rt.frame=CGRectMake(cx+cos(_a)*r-22,cy+sin(_a)*r-6,45,12);}];
}return self;}
- (void)pan:(UIPanGestureRecognizer*)g{UIView*v=self.superview;if(!v)return;if(g.state==UIGestureRecognizerStateChanged){CGPoint t=[g translationInView:v],c=self.center;c.x+=t.x;c.y+=t.y;CGFloat h=self.bounds.size.width/2+10;c.x=MAX(h,MIN(v.bounds.size.width-h,c.x));c.y=MAX(h+50,MIN(v.bounds.size.height-h-50,c.y));self.center=c;[g setTranslation:CGPointZero inView:v];}}
- (void)tap{if(self.onTap)self.onTap();}
@end

// ====================================================================
// 📋 Menu View - Compact Black
// ====================================================================
@interface RavMenuView : UIView{dispatch_queue_t _q;NSTimer*_t;UISlider*_ss,*_ds;UILabel*_sv,*_dv;UISwitch*_as,*_es,*_ls,*_bls;UISegmentedControl*_ms;UIButton*_fps;BOOL _fc;ESPOverlayView*_ev;}
@end
@implementation RavMenuView
- (instancetype)initWithFrame:(CGRect)f overlayView:(ESPOverlayView*)ov{self=[super initWithFrame:f];if(self){_q=dispatch_queue_create("rf.bg",DISPATCH_QUEUE_SERIAL);_ev=ov;
    self.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.95];self.layer.cornerRadius=14;self.layer.borderWidth=1;self.layer.borderColor=[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.5].CGColor;self.clipsToBounds=YES;
    [self ui];[self syncUI];[self loop];
}return self;}
- (void)syncUI{pthread_mutex_lock(&g_ConfigMutex);
    _as.on=gConfig.aimbotEnabled;_ss.value=gConfig.aimbotSpeed;_ms.selectedSegmentIndex=(NSInteger)(gConfig.aimbotMode-1);
    _es.on=gConfig.espEnabled;_ls.on=gConfig.espLine;_bls.on=gConfig.espBulletLine;_ds.value=gConfig.espDistance;_fc=gConfig.fps120Enabled;pthread_mutex_unlock(&g_ConfigMutex);
    [_sv setText:[NSString stringWithFormat:@"%.0f",gConfig.aimbotSpeed]];[_dv setText:[NSString stringWithFormat:@"%.0fm",gConfig.espDistance]];
    if(_fc){[_fps setTitle:@"✓" forState:UIControlStateNormal];[_fps setTitleColor:[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0] forState:UIControlStateNormal];_fps.backgroundColor=[UIColor colorWithRed:0.2 green:0.1 blue:0.3 alpha:0.9];}
    else{[_fps setTitle:@"" forState:UIControlStateNormal];_fps.backgroundColor=[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:0.8];}
}
- (void)ui{CGFloat w=self.bounds.size.width-20,mw=self.bounds.size.width,y=10;
    UILabel*tt=[[UILabel alloc]initWithFrame:CGRectMake(10,y,mw-40,22)];[tt setText:@"RAVFEN"];[tt setTextColor:[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0]];[tt setFont:[UIFont boldSystemFontOfSize:16]];[self addSubview:tt];
    UIButton*x=[UIButton buttonWithType:UIButtonTypeSystem];x.frame=CGRectMake(mw-32,y,24,24);x.backgroundColor=[UIColor colorWithRed:0.4 green:0.0 blue:0.0 alpha:0.7];x.layer.cornerRadius=12;[x setTitle:@"✕" forState:UIControlStateNormal];[x setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];x.titleLabel.font=[UIFont systemFontOfSize:12];[x addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];[self addSubview:x];y+=30;
    UILabel*ah=[[UILabel alloc]initWithFrame:CGRectMake(10,y,80,18)];[ah setText:@"Aimbot"];[ah setTextColor:[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]];[ah setFont:[UIFont boldSystemFontOfSize:13]];[self addSubview:ah];
    _as=[[UISwitch alloc]initWithFrame:CGRectMake(mw-60,y-2,45,20)];_as.onTintColor=[UIColor orangeColor];_as.transform=CGAffineTransformMakeScale(0.7,0.7);[_as addTarget:self action:@selector(tgA) forControlEvents:UIControlEventValueChanged];[self addSubview:_as];y+=22;
    _ms=[[UISegmentedControl alloc]initWithItems:@[@"Lock",@"Fire",@"Scope"]];_ms.frame=CGRectMake(10,y,w,24);_ms.selectedSegmentIndex=0;_ms.tintColor=[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];[_ms addTarget:self action:@selector(mCh) forControlEvents:UIControlEventValueChanged];[self addSubview:_ms];y+=30;
    _sv=[[UILabel alloc]initWithFrame:CGRectMake(mw-50,y,40,14)];[_sv setText:@"120"];[_sv setTextColor:[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0]];[_sv setFont:[UIFont boldSystemFontOfSize:10]];[_sv setTextAlignment:NSTextAlignmentRight];[self addSubview:_sv];
    _ss=[[UISlider alloc]initWithFrame:CGRectMake(10,y,w-50,18)];_ss.minimumValue=1;_ss.maximumValue=150;_ss.value=120;_ss.tintColor=[UIColor orangeColor];[_ss addTarget:self action:@selector(sCh) forControlEvents:UIControlEventValueChanged];[self addSubview:_ss];y+=22;
    UIView*ln=[[UIView alloc]initWithFrame:CGRectMake(10,y,w,0.5)];ln.backgroundColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];[self addSubview:ln];y+=6;
    UILabel*eh=[[UILabel alloc]initWithFrame:CGRectMake(10,y,80,18)];[eh setText:@"ESP"];[eh setTextColor:[UIColor colorWithRed:0.3 green:0.8 blue:1.0 alpha:1.0]];[eh setFont:[UIFont boldSystemFontOfSize:13]];[self addSubview:eh];
    _es=[[UISwitch alloc]initWithFrame:CGRectMake(mw-60,y-2,45,20)];_es.onTintColor=[UIColor cyanColor];_es.transform=CGAffineTransformMakeScale(0.7,0.7);[_es addTarget:self action:@selector(tgE) forControlEvents:UIControlEventValueChanged];[self addSubview:_es];y+=22;
    _ls=[[UISwitch alloc]initWithFrame:CGRectMake(mw-60,y-2,45,20)];_ls.onTintColor=[UIColor yellowColor];_ls.transform=CGAffineTransformMakeScale(0.65,0.65);[_ls addTarget:self action:@selector(tgL) forControlEvents:UIControlEventValueChanged];[self addSubview:_ls];
    UILabel*ll=[[UILabel alloc]initWithFrame:CGRectMake(10,y,90,16)];[ll setText:@"Lines"];[ll setTextColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0]];[ll setFont:[UIFont systemFontOfSize:11]];[self addSubview:ll];y+=18;
    _bls=[[UISwitch alloc]initWithFrame:CGRectMake(mw-60,y-2,45,20)];_bls.onTintColor=[UIColor redColor];_bls.transform=CGAffineTransformMakeScale(0.65,0.65);[_bls addTarget:self action:@selector(tgB) forControlEvents:UIControlEventValueChanged];[self addSubview:_bls];
    UILabel*bl=[[UILabel alloc]initWithFrame:CGRectMake(10,y,90,16)];[bl setText:@"Bullet"];[bl setTextColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0]];[bl setFont:[UIFont systemFontOfSize:11]];[self addSubview:bl];y+=18;
    _dv=[[UILabel alloc]initWithFrame:CGRectMake(mw-50,y,40,14)];[_dv setText:@"200m"];[_dv setTextColor:[UIColor colorWithRed:0.3 green:1.0 blue:0.3 alpha:1.0]];[_dv setFont:[UIFont boldSystemFontOfSize:10]];[_dv setTextAlignment:NSTextAlignmentRight];[self addSubview:_dv];
    _ds=[[UISlider alloc]initWithFrame:CGRectMake(10,y,w-50,18)];_ds.minimumValue=50;_ds.maximumValue=350;_ds.value=200;_ds.tintColor=[UIColor greenColor];[_ds addTarget:self action:@selector(dCh) forControlEvents:UIControlEventValueChanged];[self addSubview:_ds];y+=22;
    UIView*ln2=[[UIView alloc]initWithFrame:CGRectMake(10,y,w,0.5)];ln2.backgroundColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];[self addSubview:ln2];y+=6;
    UILabel*fpsl=[[UILabel alloc]initWithFrame:CGRectMake(10,y,100,20)];[fpsl setText:@"120 FPS"];[fpsl setTextColor:[UIColor whiteColor]];[fpsl setFont:[UIFont boldSystemFontOfSize:12]];[self addSubview:fpsl];
    _fps=[UIButton buttonWithType:UIButtonTypeSystem];_fps.frame=CGRectMake(mw-36,y,24,20);_fps.backgroundColor=[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:0.8];_fps.layer.cornerRadius=4;_fps.layer.borderWidth=1;_fps.layer.borderColor=[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:0.5].CGColor;[_fps addTarget:self action:@selector(tgF) forControlEvents:UIControlEventTouchUpInside];[self addSubview:_fps];y+=26;
    UIButton*tg=[UIButton buttonWithType:UIButtonTypeSystem];tg.frame=CGRectMake(10,y,w,28);[tg setTitle:@"📢 RavFen Channel" forState:UIControlStateNormal];[tg setTitleColor:[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0] forState:UIControlStateNormal];tg.titleLabel.font=[UIFont boldSystemFontOfSize:11];tg.backgroundColor=[UIColor colorWithRed:0.15 green:0.1 blue:0.2 alpha:0.7];tg.layer.cornerRadius=6;[tg addTarget:self action:@selector(openTG) forControlEvents:UIControlEventTouchUpInside];[self addSubview:tg];
}
- (void)openTG{[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://t.me/RavFenupdate"]options:@{}completionHandler:nil];}
- (void)tgF{_fc=!_fc;if(_fc){[_fps setTitle:@"✓" forState:UIControlStateNormal];[_fps setTitleColor:[UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0] forState:UIControlStateNormal];_fps.backgroundColor=[UIColor colorWithRed:0.2 green:0.1 blue:0.3 alpha:0.9];pthread_mutex_lock(&g_ConfigMutex);gConfig.fps120Enabled=YES;pthread_mutex_unlock(&g_ConfigMutex);dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0),^{SetFPS120();});}else{[_fps setTitle:@"" forState:UIControlStateNormal];_fps.backgroundColor=[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:0.8];pthread_mutex_lock(&g_ConfigMutex);gConfig.fps120Enabled=NO;pthread_mutex_unlock(&g_ConfigMutex);}}
- (void)hide{pthread_mutex_lock(&g_ConfigMutex);gConfig.menuVisible=NO;pthread_mutex_unlock(&g_ConfigMutex);[_t invalidate];_t=nil;[UIView animateWithDuration:0.25 animations:^{self.alpha=0;self.transform=CGAffineTransformMakeScale(0.85,0.85);}completion:^(BOOL f){[self removeFromSuperview];dispatch_async(dispatch_get_main_queue(),^{UIWindow*k=nil;for(UIWindowScene*s in[UIApplication sharedApplication].connectedScenes){if(s.activationState==UISceneActivationStateForegroundActive){k=s.windows.firstObject;break;}}if(!k)return;for(UIView*v in k.subviews){if([v isKindOfClass:[RavFloatingButton class]])return;}RavFloatingButton*fb=[[RavFloatingButton alloc]initWithFrame:CGRectMake(k.bounds.size.width-50-12,k.bounds.size.height*0.55,50,50)];fb.alpha=0;__weak typeof(fb)wfb=fb;fb.onTap=^{[wfb removeFromSuperview];[self showAgain];};[k addSubview:fb];[k bringSubviewToFront:fb];[UIView animateWithDuration:0.3 animations:^{fb.alpha=1;}];});}];}
- (void)showAgain{dispatch_async(dispatch_get_main_queue(),^{UIWindow*k=nil;for(UIWindowScene*s in[UIApplication sharedApplication].connectedScenes){if(s.activationState==UISceneActivationStateForegroundActive){k=s.windows.firstObject;break;}}if(!k)return;RavMenuView*m=[[RavMenuView alloc]initWithFrame:CGRectMake((k.bounds.size.width-220)/2,(k.bounds.size.height-320)/2,220,320)overlayView:_ev];m.alpha=0;m.transform=CGAffineTransformMakeScale(0.85,0.85);[k addSubview:m];[k bringSubviewToFront:m];pthread_mutex_lock(&g_ConfigMutex);gConfig.menuVisible=YES;pthread_mutex_unlock(&g_ConfigMutex);[UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.7 options:0 animations:^{m.alpha=1;m.transform=CGAffineTransformIdentity;}completion:nil];});}
- (void)tgA{pthread_mutex_lock(&g_ConfigMutex);gConfig.aimbotEnabled=_as.isOn;pthread_mutex_unlock(&g_ConfigMutex);}
- (void)tgE{pthread_mutex_lock(&g_ConfigMutex);gConfig.espEnabled=_es.isOn;pthread_mutex_unlock(&g_ConfigMutex);}
- (void)tgL{pthread_mutex_lock(&g_ConfigMutex);gConfig.espLine=_ls.isOn;pthread_mutex_unlock(&g_ConfigMutex);}
- (void)tgB{pthread_mutex_lock(&g_ConfigMutex);gConfig.espBulletLine=_bls.isOn;pthread_mutex_unlock(&g_ConfigMutex);}
- (void)mCh{pthread_mutex_lock(&g_ConfigMutex);gConfig.aimbotMode=(AimbotMode)(_ms.selectedSegmentIndex+1);pthread_mutex_unlock(&g_ConfigMutex);}
- (void)sCh{pthread_mutex_lock(&g_ConfigMutex);gConfig.aimbotSpeed=_ss.value;float v=_ss.value;pthread_mutex_unlock(&g_ConfigMutex);dispatch_async(dispatch_get_main_queue(),^{[_sv setText:[NSString stringWithFormat:@"%.0f",v]];});}
- (void)dCh{pthread_mutex_lock(&g_ConfigMutex);gConfig.espDistance=_ds.value;float v=_ds.value;pthread_mutex_unlock(&g_ConfigMutex);dispatch_async(dispatch_get_main_queue(),^{[_dv setText:[NSString stringWithFormat:@"%.0fm",v]];});}
- (void)loop{__weak typeof(self)ws=self;_t=[NSTimer scheduledTimerWithTimeInterval:(0.014+(arc4random()%4)*0.001)repeats:YES block:^(NSTimer*t){typeof(self)ss=ws;if(!ss){[t invalidate];return;}dispatch_async(ss->_q,^{UpdateLobbyStatus();AntiBanCheck();NSArray*p=GetPlayers();DoAimbot(p);[ss->_ev updateWithPlayers:p];});}];[[NSRunLoop mainRunLoop]addTimer:_t forMode:NSRunLoopCommonModes];}
- (void)dealloc{[_t invalidate];}
@end

// ====================================================================
// ESP Manager
// ====================================================================
@interface ESPManager : NSObject
@property(nonatomic,strong)UIWindow*w;@property(nonatomic,strong)ESPOverlayView*v;
@end
@implementation ESPManager
+ (instancetype)shared{static ESPManager*m;static dispatch_once_t o;dispatch_once(&o,^{m=[[ESPManager alloc]init];});return m;}
- (ESPOverlayView*)getOverlayView{return self.v;}
- (void)start{if(self.w)return;CGRect sb=[UIScreen mainScreen].bounds;self.w=[[UIWindow alloc]initWithFrame:sb];self.w.windowLevel=UIWindowLevelAlert+1;self.w.backgroundColor=[UIColor clearColor];self.w.hidden=NO;self.w.userInteractionEnabled=NO;self.v=[[ESPOverlayView alloc]initWithFrame:sb];[self.w addSubview:self.v];}
- (void)stop{self.w.hidden=YES;self.w=nil;self.v=nil;}
@end

// ====================================================================
// Launch
// ====================================================================
static void Launch(void){
    [[ESPManager shared]start];
    dispatch_async(dispatch_get_main_queue(),^{
        UIWindow*k=nil;for(UIWindowScene*s in[UIApplication sharedApplication].connectedScenes){if(s.activationState==UISceneActivationStateForegroundActive){k=s.windows.firstObject;break;}}if(!k)return;
        RavSplashView*sp=[[RavSplashView alloc]initWithFrame:k.bounds];[k addSubview:sp];[k bringSubviewToFront:sp];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(arc4random()%2+3)*NSEC_PER_SEC),dispatch_get_main_queue(),^{
            [UIView animateWithDuration:0.4 animations:^{sp.alpha=0;}completion:^(BOOL f){[sp removeFromSuperview];
                RavCaptchaView*cp=[[RavCaptchaView alloc]initWithFrame:k.bounds];cp.onDone=^{
                    RavFloatingButton*fb=[[RavFloatingButton alloc]initWithFrame:CGRectMake(k.bounds.size.width-50-12,k.bounds.size.height*0.55,50,50)];fb.alpha=0;
                    __weak typeof(fb)wfb=fb;fb.onTap=^{[wfb removeFromSuperview];
                        ESPOverlayView*ov=[[ESPManager shared]getOverlayView];
                        RavMenuView*m=[[RavMenuView alloc]initWithFrame:CGRectMake((k.bounds.size.width-220)/2,(k.bounds.size.height-320)/2,220,320)overlayView:ov];m.alpha=0;m.transform=CGAffineTransformMakeScale(0.85,0.85);[k addSubview:m];[k bringSubviewToFront:m];
                        pthread_mutex_lock(&g_ConfigMutex);gConfig.menuVisible=YES;pthread_mutex_unlock(&g_ConfigMutex);
                        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.7 options:0 animations:^{m.alpha=1;m.transform=CGAffineTransformIdentity;}completion:nil];
                    };
                    [k addSubview:fb];[k bringSubviewToFront:fb];[UIView animateWithDuration:0.3 animations:^{fb.alpha=1;}];
                };
                [k addSubview:cp];[k bringSubviewToFront:cp];
            }];
        });
    });
}

// ====================================================================
// Constructor
// ====================================================================
__attribute__((constructor))
static void Init(void){
    GetBaseAddress();InitOffsets();
    pthread_mutex_lock(&g_ConfigMutex);
    gConfig.aimbotEnabled=NO;gConfig.aimbotSpeed=120.0f;gConfig.aimbotMode=AimbotMode_Lock;
    gConfig.espEnabled=NO;gConfig.espLine=NO;gConfig.espBulletLine=NO;gConfig.espDistance=200.0f;
    gConfig.menuVisible=NO;gConfig.fps120Enabled=NO;
    pthread_mutex_unlock(&g_ConfigMutex);
    pthread_t th;pthread_create(&th,NULL,AntiDetachLoop,NULL);pthread_detach(th);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(arc4random()%2+2)*NSEC_PER_SEC),dispatch_get_main_queue(),^{Launch();});
}
