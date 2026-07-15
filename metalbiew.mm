
#import "ESP/metalbiew.h"
#import "ESP/mahoa.h"
#include "sys/mman.h"
#include "ESP/Tools.h"
#import <AVFoundation/AVFoundation.h>
#include <stdio.h>
#include <stdint.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/utsname.h>
#include <string>
#include <vector>
#include <locale>
#include <codecvt>
#include <sys/sysctl.h>
#include <signal.h>
#include <unistd.h>
#include <math.h>
#include <map>
#include <vector>
#include <dlfcn.h>
#include <unistd.h>
#include <stdlib.h>
#include "ESP/Icon.h"
#include "ESP/Iconcpp.h"
#include "ESP/ico_font.h"
#include "ESP/XORstringV2.h"
#include "ESP/XMMemory.h"
#include <string>
#include <filesystem>
#import "ESP/HideFunsion.h"
#include "ESP/API/APIClient.h"
#include "ESP/JRMemory.framework/Headers/MemScan.h"
#include <stdio.h>
#include <string.h>
#include "ESP/Vector3.hpp"
#include "ESP/Vector2.hpp"
#import <Foundation/Foundation.h>
#import "ESP/UE4.h"
#import "ESP/PubgLoad.h"
#include "ESP/imgui/imgui.h"
#include "ESP/imgui_notify.h"
#import "ESP/HeeeNoScreenShotView.h"
#import "ESP/font.h"
#import "ESP/Logo.h"
#import "ESP/imagepoong.h"
#import "ESP/imgui/stb_image.h"
#import "ESP/ini_rw.h"
#define ImClamp(X, MIN, MAX) ((X) < (MIN) ? (MIN) : ((X) > (MAX) ? (MAX) : (X)))
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_s_main_queue(), ^
NSString *xrpb = NSSENCRYPT("Paste Key...");
#define ICON_FA_EXCLAMATION_TRIANGLE "\xef\x81\xb1"

#define E(str) _xor_(str).c_str()


#define iPhone8P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

float Z = 0.5f;               
float guanxing = 9999999.f;   
float zuli = 0.1f;            

NSInteger 自身头 = 0x9D0C338;

static float values[90]    = {};
                            static int values_offset   = 0;
                            static double refresh_time = 0.0;
static float phase    = 0.0f;

static float AnimLerp(float a, float b, float s) { return a + (b - a) * s; }


@interface metalbiew () <MTKViewDelegate>
@property (nonatomic, strong) IBOutlet MTKView *mtkView;
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@property (nonatomic,  weak) NSTimer *timer;
@property (nonatomic,  assign) NSInteger aimcir;
@property (nonatomic,  assign) NSInteger rpr;

@end
bool isAimKnocked = true;
static uintptr_t Get_module_base() {
    uint32_t count = _dyld_image_count();
    for (int i = 0; i < count; i++) {
  std::string path = (const char *)_dyld_get_image_name(i);
        if (path.find("ShadowTrackerExtra.app/ShadowTrackerExtra") != path.npos) {
            return (uintptr_t)_dyld_get_image_vmaddr_slide(i);
        }
    }
    return 0;
}
bool IsValidAddress(kaddr addr) {
    return addr > 0x100000000 && addr < 0x2000000000;
}

bool MenDeal;              
static uint8_t _md_key = 0xA5;

static inline void RainbowV1(bool v) {
    MenDeal = (v ^ _md_key);
}

static inline bool VSXM() {   
    return (MenDeal ^ _md_key);
}

static float dotSizeAnim = 1.0f;

float tabAnimSpeed = 0.05f;

float gSliderHeight = 12.0f;

float sliderfillsize = 120.0f;

ImVec4 sliderfillcolor = ImVec4(1.0f, 0.196f, 0.196f, 1.0f); // default: Red

ImVec4 sliderbgcolor = ImVec4(40.0f/255.0f, 40.0f/255.0f, 40.0f/255.0f, 1.0f); // default #282828

ImVec4 sliderdotcolor = ImVec4(255.0f/255.0f, 80.0f/255.0f, 80.0f/255.0f, 1.0f); // default #FF5050

void DrawCustomSliderFloat(const char* label, float* value, float min, float max, const char* format = "%.1f", float width = sliderfillsize, float spacing = 30.5f) {
    ImGui::PushID(label); 

    ImVec2 labelPos = ImGui::GetCursorScreenPos();
    ImGui::TextUnformatted(label);

    ImGui::SameLine();
    ImGui::SetCursorScreenPos(ImVec2(labelPos.x + ImGui::CalcTextSize(label).x + spacing, labelPos.y));

    ImVec2 pos = ImGui::GetCursorScreenPos();
    ImVec2 size = ImVec2(width, gSliderHeight);
    ImDrawList* draw_list = ImGui::GetWindowDrawList();

    draw_list->AddRectFilled(pos, ImVec2(pos.x + size.x, pos.y + size.y),
                         ImColor(sliderbgcolor), gSliderHeight / 2);

    float t = (*value - min) / (max - min);
    t = ImClamp(t, 0.0f, 1.0f);
    float filledWidth = size.x * t;

    draw_list->AddRectFilled(pos, ImVec2(pos.x + filledWidth, pos.y + size.y),
                         ImColor(sliderfillcolor), gSliderHeight / 2);

    bool isActive = ImGui::IsItemActive() || ImGui::IsItemHovered();
    float targetSize = isActive ? 1.4f : 1.0f;
    dotSizeAnim = dotSizeAnim + (targetSize - dotSizeAnim) * 0.15f;

    float animatedDotRadius = (gSliderHeight * 0.5f) * dotSizeAnim;

    draw_list->AddCircleFilled(ImVec2(pos.x + filledWidth, pos.y + size.y / 2),
                               animatedDotRadius,
                               ImColor(sliderdotcolor));

    ImGui::SetCursorScreenPos(pos);
    ImGui::InvisibleButton("##custom_slider", size);

    if (ImGui::IsItemActive()) {
        ImGui::SetMouseCursor(ImGuiMouseCursor_ResizeEW);
        float mouseX = ImGui::GetIO().MousePos.x;
        float newT = (mouseX - pos.x) / size.x;
        newT = ImClamp(newT, 0.0f, 1.0f);
        *value = min + (max - min) * newT;
    }

    ImGui::SetCursorScreenPos(ImVec2(pos.x + size.x + 10, pos.y));
    ImGui::Text(format, *value);

    ImGui::PopID(); 
}


extern bool aPVQRIF;
extern bool zQkX8A;
extern bool MxVsd;
extern bool MXValQy;

extern UIView *menuIconView;
extern float menuIconAlpha;

extern void updateMenuIconAlpha(float alpha);


bool ModSkinn = false;
bool KillMessage = false;
bool DeadBox = false;
bool ModSkinnLobby = false;
bool BagGun = false;
bool AccessoriesGun = true;
bool last = false;
bool CoronaLab1S = false;
bool CoronaLabHooked = false;

ImVec4 strokeColor = ImVec4(0, 0, 0, 1);  
float strokeIntensity = 1.0f;              

static ImVec4 customCyan = ImVec4(0.6f, 0.0f, 0.0f, 0.54f);

static bool showTerminal = false;
static bool showSuccessPopup = false;
static float activationStartTime = 0.0f;
static float terminalHeight = 0.0f;
static float animationSpeed = 600.0f;  
static float typingSpeed = 80.0f;          
static float lineSpawnInterval = 0.12f;    
static size_t maxLines = 40;
struct LogLine {
    std::string text;
    ImVec4 color;
    float startTime;    
    bool finished;      
    LogLine(const std::string &t, ImVec4 c, float s)
        : text(t), color(c), startTime(s), finished(false) {}
};


static std::vector<LogLine> logLines;
static const std::vector<std::string> serversToBlock = {
    "gateway.pubg.com",
    "apollo.pubg.com",
    "tencentgames.pubg.com",
    "gameapi.pubg.com",
    "hkex.pubg.com",
    "pcweb.pubg.com",
    "igame.pubg.com",
    "qos.pubg.com",
    "cds.pubg.com",
    "i18n.pubg.com",
    "119.28.109.187",
    "asia.csoversea.mbgame.anticheatexpert.com",
    "mvn.lobby.igamecj.com",
    "app-measurement.com",
};


static void PushRandomLog(float now) {
    
    int pick = rand() % 100;
    std::string msg;
    ImVec4 col;

    if (pick < 50) {
        
        const std::string &srv = serversToBlock[rand() % serversToBlock.size()];
        const char* templates[] = {
            "Blocking connection to %s ...",
            "Injecting firewall rule for %s ...",
            "Resolving %s -> applying blacklist ...",
            "Dropping packets to %s ...",
            "Adding route to /dev/null for %s ..."
        };
        msg = std::string(templates[rand() % (sizeof(templates)/sizeof(templates[0]))]);
        
        char buf[256]; snprintf(buf, sizeof(buf), msg.c_str(), srv.c_str());
        msg = buf;
        col = ImVec4(0.8f, 0.15f, 0.15f, 1.0f); 
    } else if (pick < 80) {
        
        const char* templates[] = {
            "Successfully blackholed %s",
            "[OK] Host %s blocked",
            "Rule active: %s -> BLOCKED",
            "Success: %s unreachable"
        };
        const std::string &srv = serversToBlock[rand() % serversToBlock.size()];
        msg = std::string(templates[rand() % (sizeof(templates)/sizeof(templates[0]))]);
        char buf[256]; snprintf(buf, sizeof(buf), msg.c_str(), srv.c_str());
        msg = buf;
        col = ImVec4(0.22f, 0.9f, 0.22f, 1.0f); 
    } else {
        
        const char* templates[] = {
            "Checking DNS cache...",
            "Flushing temporary routes...",
            "Verifying hosts file integrity...",
            "AntiBan engine: performing final checks..."
        };
        msg = templates[rand() % (sizeof(templates)/sizeof(templates[0]))];
        col = ImVec4(0.93f, 0.74f, 0.0f, 1.0f); // yellow-ish
    }

    logLines.emplace_back(msg, col, now);
    // cap total
    if (logLines.size() > maxLines) logLines.erase(logLines.begin());
}

ASTExtraPlayerController *g_LocalController = 0;

ASTExtraPlayerController *localPlayerController = 0;

ASTExtraPlayerCharacter *localPlayer = 0;

ImFont* mainFont = nullptr;

static bool safeGetBone(ASTExtraPlayerCharacter* p, const char* name, FVector& out) {
    if (!p) return false;
    if (!p->Mesh) return false;
    out = p->GetBonePos(name, {});
    return (out.X == out.X); // quick NaN check
}

static bool safeGetRoot(ASTExtraPlayerCharacter* p, FVector& out) {
    if (!p || !p->RootComponent) return false;
    out = p->RootComponent->RelativeLocation;
    return (out.X == out.X);
}

std::string SDKvaT(const std::string &__in) {
    std::string __alph = make_string("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/");
    std::vector<int> __T(256, -1);
    for (int __i = 0; __i < 64; ++__i) {
        unsigned char __c = (unsigned char)__alph[__i];
        __T[__c] = __i;
    }
    std::string __out;
    int __val = 0, __valb = -8;
    for (unsigned char __c : __in) {
        if (__T[__c] == -1) break;
        __val = (__val << 6) + __T[__c];
        __valb += 6;
        if (__valb >= 0) {
            __out.push_back(char((__val >> __valb) & 0xFF));
            __valb -= 8;
        }
    }
    return __out;
}
bool g_KeyValid = false;
bool g_KeyChecked = false;


/*static inline void UpdateKeyValidFlag() {

    
    if (g_KeyValid) return;

    PPAPIKey *api = [PPAPIKey sharedInstance];
    if (!api) return;

    NSString *k = [api getKey];

    if (k && k.length >= 12) {
        g_KeyValid = true;
        g_KeyChecked = true;
    }
}*/

 bool _x0x626 = false;

/*extern BOOL MesA;
extern BOOL ModGames;
extern NSString *ModGames1;


 bool PlayerzSDK() {

    volatile uint32_t _r1 = arc4random();
    _r1 ^= (_r1 << 5);
    _r1 ^= (_r1 >> 3);

    uint8_t _ok = 1;

    _ok &= ((ModGames ^ 1) & 1);

    NSString *_k9 = ModGames1;
    _ok &= ((uintptr_t)_k9 != 0);

    NSUInteger _l2 = [_k9 length];
    _ok &= (((_l2 - 12) >> 31) == 0);

    uint8_t _a7 = (uint8_t)(MesA & 1);
    _ok &= (_a7 != 0);

    volatile uint32_t _r2 = arc4random();
    _r2 ^= _r1;
    _ok &= ((_r2 | 1) != 0);

    return (_ok != 0);
}



bool ComponantSDK() {
    if (dlopen("frida-agent.dylib", RTLD_LAZY)) return false;
    if (dlopen("libfrida-gadget.dylib", RTLD_LAZY)) return false;
    uint32_t c = _dyld_image_count();
    for (uint32_t i = 0; i < c; i++) {
        const char* n = _dyld_get_image_name(i);
        if (!n) continue;
        if (strstr(n, "frida") || strstr(n, "gadget") || strstr(n, "substrate") || strstr(n, "cycript")) return false;
    }
    return true;
}

bool Player1SK() {
    if (!PlayerzSDK()) return false;
    if (!ComponantSDK()) return false;
    return true;
}



bool Velocr() {
    volatile bool ok = Player1SK();
    return ok;
}*/

bool SecurityInitCheck(void) {
    return true;
}


void XOREncryptDecrypt(uint8_t* data, size_t size, uint8_t key) {
    for (size_t i = 0; i < size; i++) {
        data[i] ^= key;
    }
}

typedef struct {
    uint32_t magic;
    uint16_t version;
    uint32_t dataSize;
    uint8_t  iv[16];
    uint32_t checksum;        
    uint8_t  encryptedData[]; 
} SecureDataPacket;

#pragma mark - 服务器数据上报安全函数



struct Color255 {
    uint8_t r, g, b, a;
};

static float realAliveVisibleColorF[4] = { 199.0f / 255.0f, 0.0f, 0.0f, 102.0f / 255.0f };
Color255 botAliveHpColor = { 0, 199, 0, 102 };
Color255 realAliveVisibleColor;

void UpdateRealAliveVisibleColor() {
    realAliveVisibleColor.r = (uint8_t)(realAliveVisibleColorF[0] * 255.0f);
    realAliveVisibleColor.g = (uint8_t)(realAliveVisibleColorF[1] * 255.0f);
    realAliveVisibleColor.b = (uint8_t)(realAliveVisibleColorF[2] * 255.0f);
    realAliveVisibleColor.a = (uint8_t)(realAliveVisibleColorF[3] * 255.0f);
}

//真人存活（可见）血条
Color255 realAliveHiddenColor = {199, 0, 0, 102};//真人存活（不可见）血条
Color255 DownHpColor = {255, 255, 255, 102};//倒地血条
Color255 aimCircleColor = {0, 255, 255, 255}; // 自瞄圈
Color255 realVisibleColor   = {0, 255, 0, 255}; // 真人可见 - 绿色（骨骼方框射线背敌）
Color255 realInvisibleColor = {255, 0, 0, 255};// 真人不可见 - 红色（骨骼方框射线背敌）
Color255 botVisibleColor    = {0, 255, 0, 255};// 人机可见 - 绿色（骨骼方框射线背敌）
Color255 botInvisibleColor  = {255, 255, 255, 255};// 人机不可见 - 白色（骨骼方框射线背敌）
Color255 teamidColor = {255, 255, 0, 255};//队伍ID颜色
Color255 weaponColor = {0, 255, 255, 255};//手持颜色
float globalHpAlphaF = 1.00f; // 显示为0.0~1.0f，默认全透明度，相关代码目前注释，暂时没用

static ImVec4 visibleColor   = ImVec4(0.f, 1.f, 0.f, 1.f); 
        static ImVec4 unvisibleColor = ImVec4(1.f, 0.f, 0.f, 1.f); 
 float lineThickness = 1.5f;

ImU32 COLOR_AI_Name      = IM_COL32(0, 170, 255, 255);  
ImU32 COLOR_REAL_Name    = IM_COL32(255, 255, 0, 255);   

ImU32 COLOR_AI_Team      = IM_COL32(255, 255, 255, 255); 
ImU32 COLOR_REAL_Team    = IM_COL32(255, 255, 0, 255);   

ImU32 COLOR_AI_Weapon    = IM_COL32(0, 255, 120, 255);   
ImU32 COLOR_REAL_Weapon  = IM_COL32(255, 255, 0, 255);   

ImU32 COLOR_Distance     = IM_COL32(255,255,0,255);
       
        ImColor hpColor     = ImColor(0, 255, 0, 160);   
        ImColor borderColor = ImColor(0, 255, 0, 255);   
        ImColor bgColor     = ImColor(0, 0, 0, 80);      

struct ColorRGB { int r, g, b; };

const ColorRGB palette1[7] = {
    {200, 185, 40}, {100, 150, 70}, {60, 165, 105}, {75, 110, 150},
    {80, 60, 140},  {135, 60, 130}, {140, 70, 60}
};
const ColorRGB palette2[7] = {
    {185, 180, 70}, {100, 190, 80}, {70, 160, 100}, {150, 190, 225},
    {150, 100, 220}, {150, 50, 160}, {200, 80, 80}
};

ImU32 TeamID_Color;
ImU32 TeamID_Color2;


void teamColor(int teamNumber, float alpha1, float alpha2) {
    if (teamNumber <= 0) teamNumber = 1;
    int index = (teamNumber - 1) % 7;
    TeamID_Color  = IM_COL32(palette1[index].r, palette1[index].g, palette1[index].b, (int)alpha1);
    TeamID_Color2 = IM_COL32(palette2[index].r, palette2[index].g, palette2[index].b, (int)alpha2);
}

 bool ifismembotenable = false;

namespace Settings {

    inline bool isVisibilityCheck = true;
    inline bool ifismembotenable = false;
    inline bool BypassMode = false;

    namespace SettingsTab {
        inline bool BypassMode = false;
    }

    namespace Aimbot {

        inline bool Enable = false;
        inline bool Tick = false;
        inline int AimMethod = 0;
        inline float FOV = 200.f;

        inline bool AutoClick = false;
        inline bool MemoryAimbot = false;
        inline bool SilentAim = true;

        namespace SilentAimSettings {

            inline bool Enable = true;
            inline bool AimKnocked = false;
            inline bool Highprecisiontracking = false;

            inline int Aimpositon = 0;
            inline bool Prediction = true;

            inline bool EnableFov = true;
            inline bool EnableFovSmart = false;

            inline bool BypassFOVLimit = false;
            inline float FovSize = 100.f;
            inline bool AimingLine = false;

            inline int LegitTrackSwitchrate = 6;
        }
    }
}

 bool Smothness = true;
 float smoothness = 6.0f;
 float ESPMaxDistance = 355.f;
 float AlertRadius = 50.0f;   
 float SilentAimMaxDistance = 355.f;

namespace imgui {
    bool ESP = false;
    bool HideBot = false;
    bool Health = false;
    bool Line = false;
    bool Name = false;
    bool TeamID = false;
    bool Distance = false;
    bool EnemyCount = false;
    bool Weapon = false;
    bool WeaponBackground = false;
    bool Bone = false;
    bool GameInfo = false;
    bool Alert360 = false;
    bool EnemyAiming = false;
    bool SafeZone = false;
    bool CarHealth = false;
    bool CarESP = false;
    bool Caricon = false;
    bool CarName = false;
    bool CarDistance = false;
    bool Grenade = false;
}

namespace itemesp {
    inline bool Enable = false;

    inline bool Guns = true;
    inline bool Vehicles = true;

    inline float MaxDistance = 200.0f; 
}

bool IsEnglish;
bool ShowFov = false;
bool CS;
bool RWGD;
int 玩家,人机;
float GD=40.0f;
bool 保存配置;
bool SJJS;
bool 坐标追;
float Sd=1.f;
bool FlyFuck;
bool 自动开火;
float sd;
const float offset = 21.0f; // 向上移动的偏移量
const float 最大半径 = 28.0f; // 最大半径
const float 厚度 = 3.0f; // 线条厚度
bool 水印 = true;
bool 下雨;
int UI=0;
float 巨人;
float Qo;
bool 人物变大;
bool 重置游客;
float EspTextSiz = 3;
int 打击圈 = 0;
int CL = 1;
int Al= 1;
bool 瞄准线;
 bool AimBot = false;//自瞄
 int AimF = 3;
int value = 120;
bool SDK防 = false;
bool SDK防V2 = false;
bool 越南过一秒 = false;
int Aim = 0;
float Aimsmooth = 1.2f;
float Xs=2.4,Ys=2.4;
bool 头部;
float 追踪概率 = 100; 
bool 喵身体;
bool 身体;
bool FixShoot;
 float Cross = 1500.f;
 float g_disstance = 150.0f;
float 广角大小=110.f;
 bool IgnoreKnocked = false;
bool GRWAR = false;
 bool VisCheck = false;
 bool IgnoreBot = false;
 bool AboveHeadSc = true;
bool 自瞄圈2 = false;
float 自瞄速度 = 2.22222222222;
float RadarX = 30;//雷达X
float RadarY = 10;//雷达Y
 bool 对局信息 = true;
bool IsLogin = true;
 bool Enable = false;
 bool FAKEDAMAGE = false;
 float crosshairSizeSlider = 0.0f;
 bool IsCrossHair = false;
 bool IsNorecoil = false;
 bool IsNocamerashake = false;
 bool IsFastKnock = false;
 bool IsFastshoot = false; //Фастшот
 bool IsFastSwitch = false; //Быстрая смена оружия
 bool IsNorecoil2 = false; //Убрать отдачу(RecKickADS)
 float shootIntervalValue = 0.01f;
 float gungody = 5.f;
 float gungodz = 5.f;
 float gungodx = 5.f;
 bool IsFastBullet = false;
 bool IsFastDrop = false; //Быстрый парашут
 bool IsFlash = false;
 bool WallDamage = false; 
 bool Flash6 = false;
 bool smoothflash = false;
 bool SmoothFlashEnabled = false;
 float smoothFlashSpeed = 1.0f;
 float bunnyJumpStrength = 1050.0f;
 float bunnyGravityScale = 0.9f;
 float bunnyAirControl = 10.0f;
 float bunnyMaxWalkSpeed = 1500.0f;
 float bunnyGroundFriction = 8.0f;
 bool AutoFire = false;
 bool IsHitXPL = false;
 bool InstantHit = false;
 bool IsOneShotKill = false;
 float carx;
 float cary;
 float carz;
 bool CarFly = false;
 bool SDKcar = false;
 bool crazycar = false;
 bool tudongnhay = false;
 bool chaynhanhv2 = false; //супербег 
 float tocdoquay;
 bool isSpinning = false;
 bool isSpinningLon = false;
 float DanceValue;
 float Dancevalue;
 float DancerValue;
 float CarBoost = 999.0f;
 float FuckValue = 7.0f;
 bool IsAimlock = false;
 bool xEffect = false;
 float xEffectRadius = 3500.0f;
 bool HitX222 = false;
 bool CrosshairRainbow = false;
 float rainbowSpeed = 0.02f;
 bool CrosshairSpin = false;
 float CrosshairSpinSpeed = 1.5f;
 float CrosshairAngle = 0.0f;
 bool ShowDamage = false;
 bool ParachuteVIP = false;
 float parachute_CurrentFallSpeed = 8300.f;
 float parachute_FreeFall_AcceFall = 25000.f;
 float parachute_FreeFall_MaxFreeFallSpeed = 25000.f;
 float parachute_FreeFall_AcceForward = 25000.f;
 float parachute_FreeFall_MaxForwardExtraFallSpeed = 25000.f;
 float parachute_Opened_AcceFall = 5000.f;
 float parachute_Opened_MaxFreeFallSpeed = 5000.f;
 float parachute_Opened_AcceForward = 5000.f;
 float parachute_Opened_MaxForwardSpeed = 5000.f;
 float parachute_Opened_MaxForwardExtraFallSpeed = 5000.f;
 float parachute_AllowMaxDiatanceSqAtServer = 40000.f;
 float parachute_MaxZAllowDistance = 40000.f;
 float energyScaleSlider = 6.f;
 bool SlowMotion = false;
 bool AutoFlashUPP = false;
 bool FlashUPP = false;
 bool FlashPrivate = false;
 bool TPHook = false;
 bool TeleportEnemy = false;
 float teleportSpeedValue = 8.0f; 
 bool TPVehicle = false;
 bool MaxStep = false;
 float MagicBulletX = 200.0f;
 float MagicBulletY = 300.0f;
 float MagicBulletZ = 400.0f;
 float flashFuckk1 = 8.f;
 bool FuckJump = false;
 bool TigerJUMP = false;
 bool VIPJUMP = false;
 float EnergyScale = 4.3f;
 float VIPHIGH = 2600.0f;
 float SPEEDAIR = 25.0f;
 float SPEEDJUMP = 50.0f;
 float GRAVITYSCALE = 1.3f;
 float JUMPANIMETION = 1.0f;
 bool JumpV2 = false;
 bool JumpControl = false;
float jumpZVelocitySlider = 3200.f;
 float airControlSlider = 10.0f;
 float gravitySliderValue = 3.5f;
 float FuckSlowValue = 0.3f;
 bool ZoomUp = false;
 float SetZoomUp = 20.0f;
 bool Deadinfo = false;
 bool hidename = false;
 bool ReloadGun = false;
 bool LongPeek = false;
 bool welapongod = false;
 bool good = false;
 bool goodview = false;
 bool Blacksky = false;
 bool SilentGodView = false;
 bool FastScope = false;
 bool IsFastGun = false;
 bool SwitchX = false;
 bool BaseImpact = false;
 bool flashparachute3 = false;
 bool IsBunnyJUMP = false;
 bool sspped = false;
 bool DrawGun = false;
 bool 骨骼 = false;
 //bool 新骨骼 = false; 
 bool 枪械变大 = false;
 bool HitX = false;
 bool CrossHair = false;
 bool ReCo = false;
 float muzzleOffsetZ = 125.0f;
 float magicX = 23.f + 150.f;
 float magicY = 25.f + 150.f;
 float magicZ = 30.5f + 150.f;
 bool MagicSDK = false;
 static bool isMagicThreadRunning = false;
 static bool MagicPrivateFix = false;        
 static bool Magic = false;
 static bool patchApplied = false;
 static bool MagicV2 = false;
 static bool MagicV3 = false;
 static bool MagicPatch = false;
 static bool MagicV4 = false;
 static bool MagicV4Patch = false;
 static bool HeadShotV2 = false;
 static bool HeadShotV2Patched = false;
 static bool Antenna = false;
 static bool AntennaPatched = false;
 float HITXPower = 999.0f;
 static float oldHITXPower = 0.0f;
 static vector<void*> hitXResults;
 static bool HITX = false;
 static bool HITXPatch = false;
 static bool HITxV2 = false;
 static bool HITXPatchV2 = false;
 bool SafeZoneESP;
 bool textBorder = true;
 bool 动态圈 = false;
 bool 人物圈 = false;
 bool 载具 = false;
 bool 概率追 = false;
static bool IsLaunch = false;
static float 子追命中率=0.4;
bool ResetGuest;
int SX = 0;
bool 射线 = false;
float Gun_Size = 2.5;
bool 防 =false;
bool 子弹信息 = false;


bool 人物自杀;
bool 据点 = false;

static int currentLanguage = 0;

bool anti1 =false;
bool anti2 =false;
bool anti3 =false;
bool anti4 =false;

bool giamgiat = false;

bool init1 = false;
bool init2 = false;
bool init3 = false;
bool init4 = false;
bool init5 = false;
uintptr_t uintptOffset = 0;
int KillMessageOffset = 999;
bool WideView = false;
int WideValue = 100;


bool initialized = false;
void InitializeMemoryProtection() {
    if (!initialized) {
        // 这里执行一次性的内存保护更改
        initialized = true;
    }
}





#include <iostream>
#include <chrono>
#include <thread>
#include <cmath>

bool hideHacker = true;
HeeeNoScreenShotView *hideesp = nullptr;

void renderHUD() {
    
    std::cout << "Rendering dynamic HUD..." << std::endl;
    
    static bool staticContentRendered = false;
    if (!staticContentRendered) {
        std::cout << "Rendering static HUD elements..." << std::endl;
        staticContentRendered = true;
    }
}


float smoothTransition(float currentValue, float targetValue, float speed) {
    return currentValue + (targetValue - currentValue) * speed;
}


void updateHUDAnimation(float &currentPosition, float targetPosition) {
    currentPosition = smoothTransition(currentPosition, targetPosition, 0.1f);
    std::cout << "Updating HUD animation position: " << currentPosition << std::endl;
}


void runHUD(int targetFPS) {
    using namespace std::chrono;
    milliseconds frameDuration(1000 / targetFPS);

    float hudPosition = 0.0f;  
    float targetPosition = 100.0f;  
    while (true) {
        auto frameStart = steady_clock::now();

        
        renderHUD();
        
        
        updateHUDAnimation(hudPosition, targetPosition);

        
        auto frameEnd = steady_clock::now();
        auto renderTime = duration_cast<milliseconds>(frameEnd - frameStart);

        
        if (renderTime < frameDuration) {
            std::this_thread::sleep_for(frameDuration - renderTime);
        }
    }
}


void loadResourcesAsync() {
    std::thread resourceLoader([]() {
        std::cout << "Loading resources in background..." << std::endl;
       
        std::this_thread::sleep_for(std::chrono::seconds(2));
        std::cout << "Resources loaded." << std::endl;
    });
    resourceLoader.detach();  
}

int main() {
    
    loadResourcesAsync();

    int targetFPS = 120;  // 保持高帧率以提高流畅度
    std::cout << "Running HUD at " << targetFPS << " FPS" << std::endl;

    
    runHUD(targetFPS);

    return 0;
}



uintptr_t UE4;
kaddr module= (unsigned long)Get_module_base();
namespace YN
{
int boxtype = 1;
int healthbartype = 0;
int Nationtype = 2;
int DirectionLineSize = 70;
int VehicleDirectionLineSize = 100;
int offscreen_range = 40;
int max_distance_offscreen = 400;
int playersdistancessize = 600;
bool esp_Outline = true;
int distance_Radar = 150;
}

enum EAimTarget {
    Head = 0,
    Chest = 1
};



long l1 = 0xFF544;
long l2 = 0xFFFFF;
//const char * stack230 = 0;//index of class array 75

int stack_20;
NSString * val_1;
NSString * val_x2 ;
int sort = 1,sort_1 = 3;
long RAMADDRESS = 0x4332443;//0x4332443 + F = 0x4332452
bool stack_193 = NO;
using namespace std;
using namespace SDK;
using namespace ImGui;

static int Styleesp = 2;
static int 血条 = 0;//原0
static int Radar = 0;
//后加 xm

//bool chongchongche =false;
bool 下雪特效 =false;


bool ConfigSilentAimEnable = false;//原false
    struct sConfig {
        struct sESPMenu {
            bool Health;
            bool 血条二;
            bool 血条三;
            bool 无;
            bool 死亡盒子;
            bool Name;
            bool Distance;
            bool TeamID;
            bool 对局信息;
            bool Weapon;
            bool 背敌;
            bool Vehicle;
            bool IgnoreBot;
            bool LootBox;
            bool Throwables;
        };
        sESPMenu ESPMenu{false};//false

        
    };
    sConfig Config{false};//false
//


struct JsonPreferences {

 int xsuit = 0;
int skinm4 = 0;
int skinakm = 0;
int para = 0;
int helmet = 0;
int bag = 0;
int Short = 0;
bool Outfit = false;
bool Face = false;
bool Bagg = false;
bool Emote = false; 
bool Helmett = false;
bool Parachute = false;
bool FlyMachine = false;
bool Gloves = false;
bool Shortsx = false;
bool Shoes = true;
bool M416 = true;
bool M4168 = true;
bool M4169 = true;
bool M4161 = true;
bool M4162 = true;
bool M4163 = true;
bool M4164 = true;
bool AKM = true;
bool AKM1 = true;
bool AKM2 = true;
bool AKM3 = true;
bool AKM4 = true;
bool AKM5 = true;
bool AKM6 = true;
bool MK14 = true;
bool MK145 = true;
bool MK146 = true;
bool MK147 = true;
bool MK148 = true;
bool MK149 = true;
bool MK140 = true;
bool MG3 = true;
bool mg31 = true;
bool mg32 = true;
bool mg33 = true;
bool mg34 = true;
bool mg35 = true;
bool mg36 = true;
bool P90 = true;
bool P901 = true;
bool P902 = true;
bool P903 = true;
bool P904 = true;
bool P905 = true;
bool P906 = true;
bool SCARL = true;
bool SCARL1 = true;
bool SCARL2 = true;
bool SCARL3 = true;
bool SCARL4 = true;
bool SCARL5 = true;
bool SCARL6 = true;
bool M762 = true;
bool M7621 = true;
bool M7622 = true;
bool M7623 = true;
bool M7624 = true;
bool M7625 = true;
bool M7626 = true;
bool AMR = true;
bool AWM = true; 
bool AWM1 = true;
bool AWM2 = true;
bool AWM3 = true;
bool AWM4 = true;
bool AWM5 = true;
bool AWM6 = true;
bool KAR98 = true;
bool KAR981 = true;
bool KAR982 = true;
bool KAR983 = true;
bool KAR984 = true;
bool KAR985 = true;
bool KAR986 = true;
bool M24 = true;
bool M241 = true;
bool M242 = true;
bool M243 = true;
bool M244 = true; bool M245 = true; bool M246 = true;
bool M16 = true; bool M161 = true; bool M162 = true; bool M163 = true; bool M164 = true; bool M165 = true; bool M166 = true;
    bool M249 = true; bool M2491 = true; bool M2492 = true; bool M2493 = true; bool M2494 = true; bool M2495 = true; bool M2496 = true;
    bool DP28 = true; bool DP281 = true; bool DP282 = true; bool DP283 = true; bool DP284 = true; bool DP285 = true; bool DP286 = true;
    bool GROZA = true; bool GROZA1 = true; bool GROZA2 = true; bool GROZA3 = true; bool GROZA4 = true; bool GROZA5 = true; bool GROZA6 = true;
    bool QBZ = true; bool Honey = true; bool FAMAS = true;
    bool AUG = true; bool AUG1 = true; bool AUG2 = true; bool AUG3 = true; bool AUG4 = true; bool AUG5 = true; bool AUG6 = true;
    bool UZI = true; bool UZI1 = true; bool UZI2 = true; bool UZI3 = true; bool UZI4 = true; bool UZI5 = true; bool UZI6 = true;
    bool UMP = true; bool UMP1 = true; bool UMP2 = true; bool UMP3 = true; bool UMP4 = true; bool UMP5 = true; bool UMP6 = true;
    bool VECTOR = true; bool TOMMY = true; bool BIZON = true;
    bool ACE32 = true;  bool ACE321 = true; bool ACE322 = true; bool ACE323 = true; bool ACE324 = true; bool ACE325 = true; bool ACE326 = true;
    bool S12K = true; bool DBS = true; bool  NS2000 = true; bool S686 = true; bool S1897 = true;
    bool MINI14 = true; bool SKS = true; bool SLR = true;
    bool PAN = true; bool Machete = true; bool Dagger = true;
    bool Dacia = true; bool UAZ = true; bool CoupeRB = true; bool MiniBus = true; bool BigFoot = true; bool RZR = true; bool Rony = true; bool Boat = true; bool Mirado = true; bool Buggy = true; bool OMirado = true; bool Moto = true;

    struct sConfig {
         struct sAimMenu {
            bool EnableAllHack;
            bool Autofire;
            bool AimBot;
            bool CameraCache;
            EAimTarget Target;
            bool IgnoreKnocked;
            bool IgnoreBot;
            bool Prediction;
            bool VisCheck;
            bool LessRecoil;
            bool Norecoil;
            bool InstantHit;
            bool HeadShoot;
            bool ReCo;
            float Recc = 1.0f;

            bool test5;
            bool SpeedHack;
        };
        sAimMenu SilentAim{false};
        struct sModSkin {
      int XSuits = 1;
      int Short = 0;
      int FlyMachine = 0;
      int Parachute = 1;
      int AKM = 1;
      int AKM1 = 1; int AKM2 = 1; int AKM3 = 1; int AKM4 = 1; int AKM5 = 1; int AKM6 = 1;
      int M16A4 = 1; int M16A41 = 1; int M16A42 = 1; int M16A43 = 1; int M16A44 = 1; int M16A45 = 1; int M16A46 = 1;
      int Scar = 1; int Scar1 = 1; int Scar2 = 1; int Scar3 = 1; int Scar4 = 1; int Scar5 = 1; int Scar6 = 1;
      int M416 = 1; int M4168 = 1; int M4169 = 1; int M4161 = 1; int M4162 = 1; int M4163 = 1; int M4164 = 1;
      int Groza = 1;  int Groza1 = 1; int Groza2 = 1; int Groza3 = 1; int Groza4 = 1; int Groza5 = 1; int Groza6 = 1;
      int AUG = 1; int AUG1 = 1; int AUG2 = 1; int AUG3 = 1; int AUG4 = 1; int AUG5 = 1; int AUG6 = 1;  
      int M762 = 1; int M7621 = 1; int M7622 = 1; int M7623 = 1; int M7624 = 1; int M7625 = 1; int M7626 = 1;
      int QBZ = 1; int Honey = 1; int Famas = 1;
      int ACE32 = 1; int ACE321 = 1; int ACE322 = 1; int ACE323 = 1; int ACE324 = 1; int ACE325 = 1; int ACE326 = 1;
      int UZI = 1; int UZI1 = 1; int UZI2 = 1; int UZI3 = 1; int UZI4 = 1; int UZI5 = 1; int UZI6 = 1;
      int UMP = 1; int UMP1 = 1; int UMP2 = 1; int UMP3 = 1; int UMP4 = 1; int UMP5 = 1; int UMP6 = 1;
      int Vector = 1; int Thompson = 1; int Bizon = 1;
      int MK14 = 1; int MK145 = 1; int MK146 = 1; int MK147 = 1; int MK148 = 1; int MK149 = 1; int MK140 = 1;
      int mg31 = 1; int mg32 = 1; int mg33 = 1; int mg34 = 1; int mg35 = 1; int mg36 = 1;
      int P90 = 1; int P901 = 1; int P902 = 1; int P903 = 1; int P904 = 1; int P905 = 1; int P906 = 1;
      int K98 = 1; int K981 = 1; int K982 = 1; int K983 = 1; int K984 = 1; int K985 = 1; int K986 = 1;
      int M24 = 1; int M241 = 1; int M242 = 1; int M243 = 1; int M244 = 1; int M245 = 1; int M246 = 1;
      int AWM = 1; int AWM1 = 1; int AWM2 = 1; int AWM3 = 1; int AWM4 = 1; int AWM5 = 1; int AWM6 = 1;
      int DP28 = 1; int DP281 = 1; int DP282 = 1; int DP283 = 1; int DP284 = 1; int DP285 = 1; int DP286 = 1;
      int M249 = 1; int M2491 = 1; int M2492 = 1; int M2493 = 1; int M2494 = 1; int M2495 = 1; int M2496 = 1;
      int AMR = 1;
      int MG3 = 1;
      int S12K = 1; int DBS = 1; int  NS2000 = 1; int S686 = 1; int S1897 = 1;
      int Mini14 = 1; int SKS = 1; int SLR = 1;
      int Pan = 1; int Machete = 1; int Dagger = 1;
      int Boat = 1; int MiniBus = 1; int Buggy = 1; int Bigfoot = 1; int RZR = 1; int Rony = 1; int Moto = 1; int CoupeRP = 1; int UAZ = 1; int Dacia = 1; int Mirado = 1; int OMirado = 1;
        };
        sModSkin Skin;
    };
    sConfig Config;
};
// Tạo instance
JsonPreferences preferences;
static int helmett1 = 1;
static int helmett2 = 1;
static int helmett3 = 1;
static int bag1 = 1;
static int bag2 = 1;
static int bag3 = 1;
int ModEmote1 = 0;
int sEmote1 = 2200101;
int sEmote2 = 2200201;
int sEmote3 = 2200301;
namespace Active {
    inline int SkinCarDefault = 0; inline int SkinCarMod = 0;
inline int SkinCarNew = 0;
}
UISlider * Auto1;//autofire
UISlider * Auto1Interval;//autofire interval
UISlider * sliderrr;//aimpos
extern float TurnRate; //No scope turn rate - aim speed
extern float NoScopeAimDisSliderVal;
extern float HiddenFOVSliderVal;
extern float NoScopeFOVSliderVal;
UISlider * aimspeed;
CGSize AutoFireCircelSize;// CGSizeMake(w, h);
bool IsAirDrop = false;
int Interval = 1;
int counter;
int iAwareTexSiz = 20;
bool iAwareText = true;
float EspBoxThik = 2.0f;
float EspSktonThik = 1.5f;
float IsfovSlider = 150.0f;
float AimSpeed = 2.0f;
float AimSmooth = 1.5f;
bool AimTouch = false;
bool antibypass = false;
bool FovRadousVal = false;//true


int boxtype = 1;
int healthbartype = 0;
int Nationtype = 2;
int DirectionLineSize = 70;
int VehicleDirectionLineSize = 100;
int offscreen_range = 40;
int max_distance_offscreen = 400;
int playersdistancessize = 600;
bool esp_Outline = true;
int distance_Radar = 150;

uintptr_t ProcessEvent_Offset,AimBullet_Offset,AimBullet_Offset2,SetControlRotation_Offset;
#define SLEEP_TIME 1000LL / 120LL
#define TORAD(x) ((x) * (M_PI / 180.f))
#define DefineHook(RET, NAME, ARGS) \          \
    ARGS;                           
int g_screenWidth ;
int g_screenHeight ;
int screenWidth ;
int screenHeight ;
int screenDensity = 0;
int getEspFramerate;
int SCOLOR;
int scc;
class FPSCounter {
protected:
    unsigned int m_fps;
    unsigned int m_fpscount;
    long m_fpsinterval;
public:
    FPSCounter() : m_fps(0), m_fpscount(0), m_fpsinterval(0) {
    }
    void update() {
        m_fpscount++;
        if (m_fpsinterval < time(0)) {
            m_fps = m_fpscount;
            m_fpscount = 0;
            m_fpsinterval = time(0) + 1;
        }
    }
    unsigned int get() const {
        return m_fps;
    }
};
FPSCounter fps;


char extra[30];
float density = -1;
float gDistance;
int localFiring{0};
BOOL kaiguan1 = NO;
BOOL kaiguan2 = NO;
BOOL kaiguan3 = NO;
BOOL kaiguan4 = NO;
#define PI 3.14159265358979323846
#define __fastcall
bool ARWP = false;
bool SMGWP =false;
bool SNPWP = false;
bool otherWP =false;
bool AmmoWP =false;
bool LIGHTMW = false;
bool SHOTGUNWP = false;
bool scopewp = false;
bool POSTOLWP = false;
bool ARMORWP =false;
//IsAimBotRecc = 1.183f;
bool IsAimBotRecc = false;
bool IsRecoilComparison = false;
static int Istargets = 2;

static int loaixe = 0;
static int xedacia = 0;
bool modxe = false;
bool tamnho = false;


bool effectm44 = false;

float dorong = 88.0f;

float IsDistance = 68;






float aimspeedsl()
{
    // return aimspeed.value;
    float val1 = 20;//50
    //return TurnRate;// aim speed from slider
    return val1;
}
int aimpos()
{
    float speedVal = 25;//100
    //return sliderrr.value;//maybe speed
    return speedVal;
}
int autodiss()
{
    return Auto1.value;
}


NSString *resultx;
@implementation metalbiew
INI* config;








- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}


- (void)loadView {

self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];

}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;
   
}

ImVec4 to_vec5(float r, float g, float b, float a)
{
    return ImVec4(r / 255.0, g / 255.0, b / 255.0, a / 255.0);
    

    
    
}
static id<MTLTexture> LoadTextureFromBase64(id<MTLDevice> device, const std::string &base64Data) {
    // Giải mã base64 sang NSData
    NSData *data = [[NSData alloc] initWithBase64EncodedString:[NSString stringWithUTF8String:base64Data.c_str()]
                                                      options:NSDataBase64DecodingIgnoreUnknownCharacters];

    if (!data) return nil;

    // Load ảnh từ memory bằng stb_image
    int width, height, channels;
    unsigned char *pixels = stbi_load_from_memory(
        (const stbi_uc *)[data bytes],
        (int)[data length],
        &width,
        &height,
        &channels,
        4);

    if (!pixels) return nil;

    // Tạo MTLTextureDescriptor
    MTLTextureDescriptor *desc =
        [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatRGBA8Unorm
                                                           width:(NSUInteger)width
                                                          height:(NSUInteger)height
                                                       mipmapped:NO];
    desc.usage = MTLTextureUsageShaderRead;
    desc.storageMode = MTLStorageModeShared;

    // Tạo texture
    id<MTLTexture> texture = [device newTextureWithDescriptor:desc];

    // Copy data vào texture
    [texture replaceRegion:MTLRegionMake2D(0, 0, (NSUInteger)width, (NSUInteger)height)
               mipmapLevel:0
                 withBytes:pixels
               bytesPerRow:(NSUInteger)width * 4];

    // Giải phóng bộ nhớ tạm
    stbi_image_free(pixels);

    return texture;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"IMGUI.ini"];

    if(![fileManager fileExistsAtPath:filePath]){

        [fileManager createFileAtPath:filePath contents:[NSData data] attributes:nil];
    }

    config = ini_load((char*)filePath.UTF8String);
    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];
    if (!self.device) abort();
    
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGui::StyleColorsDark();
    ImGuiIO& io = ImGui::GetIO(); (void)io;

       
ImGuiStyle& style = ImGui::GetStyle();
        
        style.WindowPadding = ImVec2(8, 8);
        style.WindowRounding = 3.5f;
        style.FramePadding = ImVec2(4, 4);
        style.ScrollbarSize = 15.0f;
        style.FrameRounding = 3.5f;
        style.FrameBorderSize = 0.0f;
        style.WindowBorderSize = 0.0f;
        style.WindowTitleAlign = ImVec2(0.5f, 0.5f);
        style.GrabMinSize = 20.f;
           
        
        style.WindowTitleAlign = ImVec2(0.5, 0.5);
        style.ButtonTextAlign = ImVec2(0.5,0.5);
        
    style.Colors[ImGuiCol_Text] = ImVec4(1.0f, 1.0f, 1.0f, 1.0f);
    style.Colors[ImGuiCol_TextDisabled] = ImVec4(0.3733868300914764f, 0.3733879625797272f, 0.3733905553817749f, 1.0f);
    style.Colors[ImGuiCol_WindowBg] = ImVec4(0.0784313753247261f, 0.08627451211214066f, 0.1019607856869698f, 0.44f);
    style.Colors[ImGuiCol_ChildBg] = ImVec4(0.0784313753247261f, 0.08627451211214066f, 0.1019607856869698f, 0.65f);
    style.Colors[ImGuiCol_ChildBg] = ImVec4(0.09250493347644806f, 0.100297249853611f, 0.1158798336982727f, 1.0f);
    style.Colors[ImGuiCol_Border] = ImVec4(0.1568627506494522f, 0.168627455830574f, 0.1921568661928177f, 1.0f);
    style.Colors[ImGuiCol_BorderShadow] = ImVec4(0.0784313753247261f, 0.08627451211214066f, 0.1019607856869698f, 1.0f);
    style.Colors[ImGuiCol_FrameBg] = ImVec4(0.1176470592617989f, 0.1333333402872086f, 0.1490196138620377f, 1.0f);
    style.Colors[ImGuiCol_FrameBgHovered] = ImVec4(0.1568627506494522f, 0.168627455830574f, 0.1921568661928177f, 1.0f);
    style.Colors[ImGuiCol_FrameBgActive] = ImVec4(0.3819709122180939f, 0.3819704055786133f, 0.3819742202758789f, 1.0f);
    style.Colors[ImGuiCol_TitleBg] = ImVec4(0.0470588244497776f, 0.05490196123719215f, 0.07058823853731155f, 1.0f);
    style.Colors[ImGuiCol_TitleBgActive] = ImVec4(0.0470588244497776f, 0.05490196123719215f, 0.07058823853731155f, 1.0f);
    style.Colors[ImGuiCol_TitleBgCollapsed] = ImVec4(0.0784313753247261f, 0.08627451211214066f, 0.1019607856869698f, 1.0f);
    style.Colors[ImGuiCol_MenuBarBg] = ImVec4(0.09803921729326248f, 0.105882354080677f, 0.1215686276555061f, 1.0f);
    style.Colors[ImGuiCol_ScrollbarBg] = ImVec4(0.0470588244497776f, 0.05490196123719215f, 0.07058823853731155f, 1.0f);
    style.Colors[ImGuiCol_ScrollbarGrab] = ImVec4(0.1176470592617989f, 0.1333333402872086f, 0.1490196138620377f, 1.0f);
    style.Colors[ImGuiCol_ScrollbarGrabHovered] = ImVec4(0.1568627506494522f, 0.168627455830574f, 0.1921568661928177f, 1.0f);
    style.Colors[ImGuiCol_ScrollbarGrabActive] = ImVec4(0.1176470592617989f, 0.1333333402872086f, 0.1490196138620377f, 1.0f);
    style.Colors[ImGuiCol_CheckMark] = ImVec4(0.5836910009384155f, 0.8123930692672729f, 1.0f, 1.0f);
    style.Colors[ImGuiCol_SliderGrab] = ImVec4(0.252629429101944f, 0.2689886689186096f, 0.278969943523407f, 1.0f);
    style.Colors[ImGuiCol_SliderGrabActive] = ImVec4(0.5193081498146057f, 0.5193088054656982f, 0.5193133354187012f, 1.0f);
    style.Colors[ImGuiCol_Button] = ImVec4(0.1176470592617989f, 0.1333333402872086f, 0.1490196138620377f, 1.0f);
    style.Colors[ImGuiCol_ButtonHovered] = ImVec4(0.2789671421051025f, 0.278969943523407f, 0.2789685428142548f, 1.0f);
    style.Colors[ImGuiCol_ButtonActive] = ImVec4(0.3004265427589417f, 0.3004261553287506f, 0.3004291653633118f, 1.0f);
    style.Colors[ImGuiCol_Header] = ImVec4(0.1176470592617989f, 0.1333333402872086f, 0.1490196138620377f, 1.0f);
    style.Colors[ImGuiCol_HeaderHovered] = ImVec4(0.557934582233429f, 0.5579342842102051f, 0.557939887046814f, 1.0f);
    style.Colors[ImGuiCol_HeaderActive] = ImVec4(0.6137280464172363f, 0.6137277483940125f, 0.6137338876724243f, 1.0f);
    style.Colors[ImGuiCol_Separator] = ImVec4(0.1568627506494522f, 0.1843137294054031f, 0.250980406999588f, 1.0f);
    style.Colors[ImGuiCol_SeparatorHovered] = ImVec4(0.1568627506494522f, 0.1843137294054031f, 0.250980406999588f, 1.0f);
    style.Colors[ImGuiCol_SeparatorActive] = ImVec4(0.1568627506494522f, 0.1843137294054031f, 0.250980406999588f, 1.0f);
    style.Colors[ImGuiCol_ResizeGrip] = ImVec4(0.1176470592617989f, 0.1333333402872086f, 0.1490196138620377f, 1.0f);
    style.Colors[ImGuiCol_ResizeGripHovered] = ImVec4(0.5364755988121033f, 0.5364753007888794f, 0.5364806652069092f, 1.0f);
    style.Colors[ImGuiCol_ResizeGripActive] = ImVec4(0.5622264742851257f, 0.5622261762619019f, 0.5622317790985107f, 1.0f);
    style.Colors[ImGuiCol_Tab] = ImVec4(0.0470588244497776f, 0.05490196123719215f, 0.07058823853731155f, 1.0f);
    style.Colors[ImGuiCol_TabHovered] = ImVec4(0.1176470592617989f, 0.1333333402872086f, 0.1490196138620377f, 1.0f);
    style.Colors[ImGuiCol_TabActive] = ImVec4(0.09803921729326248f, 0.105882354080677f, 0.1215686276555061f, 1.0f);
    style.Colors[ImGuiCol_TabUnfocused] = ImVec4(0.0470588244497776f, 0.05490196123719215f, 0.07058823853731155f, 1.0f);
    style.Colors[ImGuiCol_TabUnfocusedActive] = ImVec4(0.0784313753247261f, 0.08627451211214066f, 0.1019607856869698f, 1.0f);
    style.Colors[ImGuiCol_PlotLines] = ImVec4(0.5215686559677124f, 0.6000000238418579f, 0.7019608020782471f, 1.0f);
    style.Colors[ImGuiCol_PlotLinesHovered] = ImVec4(0.03921568766236305f, 0.9803921580314636f, 0.9803921580314636f, 1.0f);
    style.Colors[ImGuiCol_PlotHistogram] = ImVec4(0.9999930858612061f, 0.9999899864196777f, 1.0f, 1.0f);
    style.Colors[ImGuiCol_PlotHistogramHovered] = ImVec4(0.8326179981231689f, 0.8326096534729004f, 0.8326135873794556f, 1.0f);
    style.Colors[ImGuiCol_TableHeaderBg] = ImVec4(0.0470588244497776f, 0.05490196123719215f, 0.07058823853731155f, 1.0f);
    style.Colors[ImGuiCol_TableBorderStrong] = ImVec4(0.0470588244497776f, 0.05490196123719215f, 0.07058823853731155f, 1.0f);
    style.Colors[ImGuiCol_TableBorderLight] = ImVec4(0.0f, 0.0f, 0.0f, 1.0f);
    style.Colors[ImGuiCol_TableRowBg] = ImVec4(0.1176470592617989f, 0.1333333402872086f, 0.1490196138620377f, 1.0f);
    style.Colors[ImGuiCol_TableRowBgAlt] = ImVec4(0.09803921729326248f, 0.105882354080677f, 0.1215686276555061f, 1.0f);
    style.Colors[ImGuiCol_TextSelectedBg] = ImVec4(0.5879772901535034f, 0.5879769325256348f, 0.5879828333854675f, 1.0f);
    style.Colors[ImGuiCol_DragDropTarget] = ImVec4(0.9999899864196777f, 0.9999902844429016f, 1.0f, 1.0f);
    style.Colors[ImGuiCol_NavHighlight] = ImVec4(0.9999899864196777f, 0.9999902844429016f, 1.0f, 1.0f);
    style.Colors[ImGuiCol_NavWindowingHighlight] = ImVec4(0.9999899864196777f, 0.9999903440475464f, 1.0f, 1.0f);
    style.Colors[ImGuiCol_NavWindowingDimBg] = ImVec4(9.999915846492513e-07f, 9.999899930335232e-07f, 9.999999974752427e-07f, 0.501960813999176f);
    style.Colors[ImGuiCol_ModalWindowDimBg] = ImVec4(9.999905614677118e-07f, 9.999899930335232e-07f, 9.999999974752427e-07f, 0.501960813999176f);


ImGui::PushStyleColor(ImGuiCol_WindowBg, ImVec4(0.0784f, 0.0862f, 0.1019f, 1.0f));

ImGui::PushStyleColor(ImGuiCol_TitleBg, ImVec4(0.0784313753f, 0.0862745121f, 0.1019607857f, 0.85f));

ImGui::PushStyleColor(ImGuiCol_TitleBgActive, ImVec4(0.0784313753f, 0.0862745121f, 0.1019607857f, 0.95f));


ImFontConfig font_cfg;
static const ImWchar icons_ranges[] = { ICON_MIN_FA, ICON_MAX_FA, 0 };

NSString *FontPath = @"/System/Library/Fonts/Core/AvenirNext.ttc";
    io.ConfigWindowsMoveFromTitleBarOnly = true;
    mainFont = io.Fonts->AddFontFromFileTTF(FontPath.UTF8String, 13.0f, &font_cfg, io.Fonts->GetGlyphRangesVietnamese());

    ImGui::MergeIconsWithLatestFont(12.f, false);
    ImGui_ImplMetal_Init(_device);
    
    return self;
}


ImVec4 to_vec4(float r, float g, float b, float a)
    {
        return ImVec4(r / 255.0, g / 255.0, b / 255.0, a / 255.0);
    }
//用Fname读取骨骼名称
FVector GetBoneByName(ASTExtraPlayerCharacter *Actor, const struct FName BoneName) {
    return Actor->GetBonePos(BoneName, FVector());
}
static auto start = std::chrono::steady_clock::now();
static auto noww = std::chrono::high_resolution_clock::now();
auto elapsedd = std::chrono::duration_cast<std::chrono::milliseconds>(noww - start).count();
namespace Settings
{
    static int Tab = 0;
    static int Tabmod = 0;
}
int newUAZID = 0;
int lastUAZID = 0;
int newDaciaID = 0;
int lastDaciaID = 0;
int newCoupeID = 0;
int lastCoupeID = 0;
struct snew_Skin {
  int XSuits = 403003;
  int XSuits1 = 40604002;
  int Balo1 = 501001;
  int Balo2 = 501002;
  int Balo3 = 501003;
  int Balo4 = 501004;
  int Balo5 = 501005;
  int Balo6 = 501006;
  int Helmet1 = 502001;
  int Helmet2 = 502002;
  int Helmet3 = 502003;
  int Helmet4 = 502004;
  int Helmet5 = 502005;

  int Helmet6 = 502114;
  int Helmet7 = 502115;
  int Helmet8 = 502116;

  int Parachute = 703001;
  int FlyMachine = 4151077;
  int Shoes = 0;
  int Shortss = 404026;
  int Kaaba = 410517;
  int Gloves = 0;
  int Face = 401993;
    int AKM = 101001;
    int AKM_Mag = 291001;
    int AKM_flash = 201010;
    int AKM_compe = 201009;
    int AKM_silent = 201011;
    int AKM_reddot = 203001;
    int AKM_holo = 203002;
    int AKM_x2 = 203003;
    int AKM_x3 = 203014;
    int AKM_x4 = 203004;
    int AKM_x6 = 203015;
    int AKM_quickMag = 204012;
    int AKM_extendedMag = 204011;
    int AKM_quickNextended = 204013;
  int AKM1 = 1010012;
  int AKM2 = 1010013;
  int AKM3 = 1010014;
  int AKM4 = 1010015;
  int AKM5 = 1010016;
  int AKM6 = 1010017;

  int M16A4 = 101002;
  int M16A41 = 1010022;
  int M16A42 = 1010023;
  int M16A43 = 1010024;
  int M16A44 = 1010025;
  int M16A45 = 1010026;
  int M16A46 = 1010027;
  int M16A4_Stock = 205007;
  int M16A4_Mag = 291002;

    int Scar = 101003;
    int Scar_Mag = 291003;
    int Scar_3 = 203007;
    int Scar_flash = 201010;
    int Scar_compe = 201009;
    int Scar_silent = 201011;
    int Scar_reddot = 203001;
    int Scar_holo = 203002;
    int Scar_x2 = 203003;
    int Scar_x3 = 203014;
    int Scar_x4 = 203004;
    int Scar_x6 = 203015;
    int Scar_quickMag = 204012;
    int Scar_extendedMag = 204011;
    int Scar_quickNextended = 204013;
    int Scar_verical = 202002;
    int Scar_angle = 202001;
    int Scar_lightgrip = 202004;
    int Scar_pink = 202005;
    int Scar_lazer = 202007;
    int Scar_thumb = 202006;
  int Scar1 = 1010032;
  int Scar2 = 1010033;
  int Scar3 = 1010034;
  int Scar4 = 1010035;
  int Scar5 = 1010036;
  int Scar6 = 1010037;


  int Pan = 108004;
  int Machete = 108001;

  int longyin_x6666 = 203015;
  int longyin_x8888 = 203005;
  int longyin_x1111 = 203001;
  int longyin_x2222 = 203008;
  int longyin_x3333 = 203014;
  int longyin_x4444 = 203004;
  int tuosb = 205003;
  int tuosb1 = 2050032;
  int tuosb2 = 2050033;
  int tuosb3 = 2050034;
  int tuosb4 = 2050035;


  int M4a = 203004;
  int M4b = 202002;
  int M416_1 = 101004;
  int M4168 = 1010042;
  int M4169 = 1010043;
  int M4161 = 1010044;
  int M4162 = 1010045;
  int M4163 = 1010046;
  int M4164 = 1010047;
  int M416_2 = 291004;
  int M416_3 = 203008;
  int M416_4 = 205005;
  int M416_flash = 201010;
  int M416_compe = 201009;
  int M416_silent = 201011;
  int M416_reddot = 203001;
  int M416_holo = 203002;
  int M416_x2 = 203003;
  int M416_x3 = 203014;
  int M416_x4 = 203004;
  int M416_x6 = 203015;
  int M416_quickMag = 204012;
  int M416_extendedMag = 204011;
  int M416_quickNextended = 204013;
  int M416_stock = 205002;
  int M416_stock2 = 2050022;
  int M416_stock3 = 2050023;
  int M416_stock4 = 2050024;
  int M416_stock5 = 2050025;
  int M416_verical = 203015;
  int M416_angle = 202001;
  int M416_lightgrip = 202004;
  int M416_pink = 202005;
  int M416_lazer = 202007;
  int M416_thumb = 202006;

    int Groza = 101005;
    int Groza_2 = 291005;
    int Groza_silent = 201011;
    int Groza_reddot = 203001;
    int Groza_holo = 203002;
    int Groza_x2 = 203003;
    int Groza_x3 = 203014;
    int Groza_x4 = 203004;
    int Groza_x6 = 203015;
    int Groza_quickMag = 204012;
    int Groza_extendedMag = 204011;
    int Groza_quickNextended = 204013;
  int Groza1 = 1010052;
  int Groza2 = 1010053;
  int Groza3 = 1010054;
  int Groza4 = 1010055;
  int Groza5 = 1010056;
  int Groza6 = 1010057;

    int Famas = 101100;
    int Famas_reddot = 203001;
    int Famas_holo = 203002;
    int Famas_x2 = 203003;
    int Famas_x3 = 203014;
    int Famas_x4 = 203004;
    int Famas_x6 = 203015;

    int MK145 = 1030075;
    int MK146 = 1030074;
    int MK147 = 1030072;
    int MK148 = 1030073;
    int MK149 = 1030076;
    int MK140 = 1030077;
    int MK14 = 1030075;
    int MK14_4 = 2040095;
    int MK14_2 = 203005;
    int MK14_5 = 2050035;
    int MK14_6 = 2010035;
    int MK14_10 = 203001;
    int MK14_11 = 203015;
    int MK14_12 = 2040135;
    int MK14_13 = 2010095;
    int MK14_14 = 2010075;
    int MK14_15 = 2010115;

  int mg31 = 1050105;
  int mg32 = 1050106;
  int mg33 = 1050107;
  int mg34 = 1050102;
  int mg35 = 1050103;
  int mg36 = 1050104;

    int QBZ = 101007;
    int QBZ_reddot = 203001;
    int QBZ_holo = 203002;
    int QBZ_x2 = 203003;
    int QBZ_x3 = 203014;
    int QBZ_x4 = 203004;
    int QBZ_x6 = 203015;
    int QBZ_quickMag = 204012;
    int QBZ_extendedMag = 204011;
    int QBZ_quickNextended = 204013;
    int QBZ_silent = 201011;
    int QBZ_flash = 2010105;
    int QBZ_compe = 201009;
    int QBZ_thumb = 202006;
    int QBZ_verical = 202002;
    int QBZ_angle = 202001;

    int AUG = 101006;
    int AUG_reddot = 203001;
    int AUG_holo = 203002;
    int AUG_x2 = 203003;
    int AUG_x3 = 203014;
    int AUG_x4 = 203004;
    int AUG_x6 = 203015;
    int AUG_lazer = 202007;
    int AUG_flash = 201010;
    int AUG_extendedMag = 204011;
    int AUG_quickMag = 204012;
    int AUG_quickNextended = 204013;
    int AUG_compe = 201009;
    int AUG_silent = 201011;
    int AUG_angle = 202001;
    int AUG_thumb = 202006;
    int AUG_verical = 202002;
    int AUG_lightgrip = 202004;
    int AUG_pink = 202005;
    int AUG1 = 1010062;
    int AUG2 = 1010063;
    int AUG3 = 1010064;
    int AUG4 = 1010065;
    int AUG5 = 1010066;
    int AUG6 = 1010067;

    int M762 = 101008;
    int M762_Mag = 291008;
    int M762_reddot = 203001;
    int M762_holo = 203002;
    int M762_x2 = 203003;
    int M762_x3 = 203014;
    int M762_x4 = 203004;
    int M762_x6 = 203015;
    int M762_lazer = 202007;
    int M762_flash = 201010;
    int M762_extendedMag = 204011;
    int M762_quickMag = 204012;
    int M762_quickNextended = 204013;
    int M762_compe = 201009;
    int M762_silent = 201011;
    int M762_angle = 202001;
    int M762_verical = 202002;
    int M762_lightgrip = 202004;
    int M762_pink = 202005;
    int M762_thumb = 202006;
    int M7621 = 1010082;
    int M7622 = 1010083;
    int M7623 = 1010084;
    int M7624 = 1010085;
    int M7625 = 1010086;
    int M7626 = 1010087;

    int ACE32 = 101102;
    int ACE32_Mag = 291008;
    int ACE32_extendedMag = 204011;
    int ACE32_quickMag = 204012;
    int ACE32_quickNextended = 204013;
    int ACE32_flash = 201010;
    int ACE32_compe = 201009;
    int ACE32_silent = 201011;
    int ACE32_angle = 202001;
    int ACE32_thumb = 202006;
    int ACE32_verical = 202002;
    int ACE32_lightgrip = 202004;
    int ACE32_stock = 205002;
    int ACE32_heavyStock = 205010;
    int ACE32_laser = 202007;
    int ACE32_side = 203018;
    int ACE32_reddot = 203001;
    int ACE32_holo = 203002;
    int ACE32_x2 = 203003;
    int ACE32_x3 = 203014;
    int ACE32_x4 = 203004;
    int ACE32_x6 = 203015;
    int ACE321 = 1011022;
    int ACE322 = 1011023;
    int ACE323 = 1011024;
    int ACE324 = 1011025;
    int ACE325 = 1011026;
    int ACE326 = 1011027;

    int Honey = 101012;

    int UZI = 102001;
    int UZI_reddot = 203001;
    int UZI_holo = 203002;
    int UZI_extendedMag = 204004;
    int UZI_quickMag = 204005;
    int UZI_quickNextended = 204006;
    int UZI_flash = 201004;
    int UZI_compe = 201002;
    int UZI_silent = 201006;
    int UZI_stock = 205001;
    int UZI1 = 1020012;
    int UZI2 = 1020013;
    int UZI3 = 1020014;
    int UZI4 = 1020015;
    int UZI5 = 1020016;
    int UZI6 = 1020017;

    int UMP = 102002;
    int UMP_2 = 292002;
    int UMP_flash = 201004;
    int UMP_compe = 201002;
    int UMP_silent = 201006;
    int UMP_reddot = 203001;
    int UMP_holo = 203002;
    int UMP_x2 = 203003;
    int UMP_x3 = 203014;
    int UMP_x4 = 203004;
    int UMP_x6 = 203015;
    int UMP_quickMag = 204005;
    int UMP_extendedMag = 204004;
    int UMP_quickNextended = 204006;
    int UMP_verical = 202002;
    int UMP_angle = 202001;
    int UMP_lightgrip = 202004;
    int UMP_pink = 202005;
    int UMP_lazer = 202007;
    int UMP_thumb = 202006;
    int UMP1 = 1020022;
    int UMP2 = 1020023;
    int UMP3 = 1020024;
    int UMP4 = 1020025;
    int UMP5 = 1020026;
    int UMP6 = 1020027;

    int Vector = 102003;
    int Thompson = 102004;
    int Bizon = 102005;

    int K98 = 103001;
    int K98_reddot = 203001;
    int K98_holo = 203002;
    int K98_x2 = 203003;
    int K98_x3 = 203014;
    int K98_x4 = 203004;
    int K98_x6 = 203015;
    int K98_x8 = 203005;
    int K981 = 1030012;
    int K982 = 1030013;
    int K983 = 1030014;
    int K984 = 1030015;
    int K985 = 1030016;
    int K986 = 1030017;

    int M24 = 103002;
    int M24_reddot = 203001;
    int M24_holo = 203002;
    int M24_x2 = 203003;
    int M24_x3 = 203014;
    int M24_x4 = 203004;
    int M24_x6 = 203015;
    int M24_x8 = 203005;
    int M24_extendedMag = 204007;
    int M24_quickMag = 204008;
    int M24_quickNextended = 204009;
    int M24_flash = 201005;
    int M24_compe = 201003;
    int M24_silent = 201007;
    int M24_cheek = 205003;
    int M241 = 1030022;
    int M242 = 1030023;
    int M243 = 1030024;
    int M244 = 1030025;
    int M245 = 1030026;
    int M246 = 1030027;

    int AWM = 103003;
    int AWM_reddot = 203001;
    int AWM_holo = 203002;
    int AWM_x2 = 203003;
    int AWM_x3 = 203014;
    int AWM_x4 = 203004;
    int AWM_x6 = 203015;
    int AWM_x8 = 203005;
    int AWM_extendedMag = 204007;
    int AWM_quickMag = 204008;
    int AWM_quickNextended = 204009;
    int AWM_flash = 201005;
    int AWM_compe = 201003;
    int AWM_silent = 201007;
    int AWM_cheek = 205003;
    int AWM1 = 1030032;
    int AWM2 = 1030033;
    int AWM3 = 1030034;
    int AWM4 = 1030035;
    int AWM5 = 1030036;
    int AWM6 = 1030037;

    int AMR = 103012;
    int AMR_reddot = 203001;
    int AMR_holo = 203002;
    int AMR_x2 = 203003;
    int AMR_x3 = 203014;
    int AMR_x4 = 203004;
    int AMR_x6 = 203015;
    int AMR_x8 = 203005;

    int VSS = 103005;
    int SKS = 103004;
    int Mini14 = 103006;

    int SLR = 103009;
    int DP28 = 105002;
    int DP281 = 1050022;
    int DP282 = 1050023;
    int DP283 = 1050024;
    int DP284 = 1050025;
    int DP285 = 1050026;
    int DP286 = 1050027;
    int M249 = 105001;
    int M2491 = 1050012;
    int M2492 = 1050013;
    int M2493 = 1050014;
    int M2494 = 1050015;
    int M2495 = 1050016;
    int M2496 = 1050017;

    int MG3 = 105010;
    int MG3_reddot = 203001;
    int MG3_holo = 203002;
    int MG3_x2 = 203003;
    int MG3_x3 = 203014;
    int MG3_x4 = 203004;
    int MG3_x6 = 203015;

    int P90 = 102105;
    int P901 = 1021052;
    int P902 = 1021053;
    int P903 = 1021054;
    int P904 = 1021055;
    int P905 = 1021056;
    int P906 = 1021057;
    int Skorpion = 106008;

    int S12K = 104003;
    int DBS = 104004;
    int NS2000 = 104102;
    int S686 = 104001;
    int S1897 = 104002;

    int Moto = 1901001;
    int CoupeRP = 1961001;
    int Dacia = 1903001;
    int UAZ = 1908001;
    int Bigfoot = 1953001; int RZR = 1966017; int Rony = 1916001;
    int Mirado = 1914004;
    int OMirado = 1915001;
    int Buggy = 1907001;
    int MiniBus = 1904001;
    int Boat = 1911001;
    int M249s = 205009;
};

inline snew_Skin new_Skin;



std::chrono::steady_clock::time_point lastChangeTime;
std::chrono::steady_clock::time_point lastWeaponChangeTime;

void updateSkin() {
    if (preferences.bag == 0)
    bag1 = 501003;
    if (preferences.bag == 1)
    bag1 = 1501001174;
    if (preferences.bag == 2)
    bag1 = 1501001220;
    if (preferences.bag == 3)
    bag1 = 1501001024;
    if (preferences.bag == 4)
    bag1 = 1501001311;
    if (preferences.bag == 5)
    bag1 = 1501003136;
    if (preferences.bag == 6)
    bag1 = 1501001457;
    if (preferences.bag == 7)
    bag1 = 1501001422;
    if (preferences.bag == 8)
    bag1 = 1501001443;
    if (preferences.bag == 9)
    bag1 = 1501001466;
    if (preferences.bag == 10)
    bag1 = 1501001047;
    if (preferences.bag == 11)
    bag1 = 1501001567;
    if (preferences.bag == 12)
    bag1 = 1501001588;
    if (preferences.bag == 13)
    bag1 = 1501001577;
    if (preferences.bag == 14)
    bag1 = 1501001503;
    if (preferences.bag == 15)
    bag1 = 1501001515;
    if (preferences.bag == 16)
    bag1 = 1501001550;
    if (preferences.bag == 17)
    bag1 = 1501001558;
    if (preferences.bag == 18)
    bag1 = 1501001058;
    if (preferences.bag == 19)
    bag1 = 1501001057;
    if (preferences.bag == 20)
    bag1 = 1501001051;
    if (preferences.bag == 21)
    bag1 = 1501001043;
    if (preferences.bag == 22)
    bag1 = 1501001042;
    if (preferences.bag == 23)
    bag1 = 1501001229;
    if (preferences.bag == 24)
    bag1 = 1501001023;
    if (preferences.bag == 25)
    bag1 = 1501001022;
    if (preferences.bag == 26)
    bag1 = 1501001608;
    if (preferences.bag == 27)
    bag1 = 1501001605;
    if (preferences.bag == 28)
    bag1 = 1501001061;
    if (preferences.bag == 29)
    bag1 = 1501001487;
    if (preferences.bag == 30)
    bag1 = 1501001039;
    if (preferences.bag == 31)
    bag1 = 1501001471;
    if (preferences.bag == 32)
    bag1 = 1501001411;
    if (preferences.bag == 33)
    bag1 = 1501001411;
    if (preferences.bag == 34)
    bag1 = 1501001607;
    if (preferences.bag == 35)
    bag1 = 1501001318;
    if (preferences.bag == 36)
    bag1 = 1501001649;

    if (preferences.bag == 0)
    bag2 = 501003;
    if (preferences.bag == 1)
    bag2 = 1501002174;
    if (preferences.bag == 2)
    bag2 = 1501002220;
    if (preferences.bag == 3)
    bag2 = 1501002024;
    if (preferences.bag == 4)
    bag2 = 1501002311;
    if (preferences.bag == 5)
    bag2 = 1501002336;
    if (preferences.bag == 6)
    bag2 = 1501002457;
    if (preferences.bag == 7)
    bag2 = 1501002422;
    if (preferences.bag == 8)
    bag2 = 1501002443;
    if (preferences.bag == 9)
    bag2 = 1501002466;
    if (preferences.bag == 10)
    bag2 = 1501002047;
    if (preferences.bag == 11)
    bag2 = 1501002567;
    if (preferences.bag == 12)
    bag2 = 1501002588;
    if (preferences.bag == 13)
    bag2 = 1501002577;
    if (preferences.bag == 14)
    bag2 = 1501002503;
    if (preferences.bag == 15)
    bag2 = 1501002515;
    if (preferences.bag == 16)
    bag2 = 1501002550;
    if (preferences.bag == 17)
    bag2 = 1501002558;
    if (preferences.bag == 18)
    bag2 = 1501002058;
    if (preferences.bag == 19)
    bag2 = 1501002057;
    if (preferences.bag == 20)
    bag2 = 1501002051;
    if (preferences.bag == 21)
    bag2 = 1501002043;
    if (preferences.bag == 22)
    bag2 = 1501002042;
    if (preferences.bag == 23)
    bag2 = 1501002229;
    if (preferences.bag == 24)
    bag2 = 1501002023;
    if (preferences.bag == 25)
    bag2 = 1501002022;
    if (preferences.bag == 26)
    bag2 = 1501002608;
    if (preferences.bag == 27)
    bag2 = 1501002605;
    if (preferences.bag == 28)
    bag2 = 1501002061;
    if (preferences.bag == 29)
    bag2 = 1501002487;
    if (preferences.bag == 30)
    bag2 = 1501002039;
    if (preferences.bag == 31)
    bag2 = 1501002471;
    if (preferences.bag == 32)
    bag2 = 1501002411;
    if (preferences.bag == 33)
    bag2 = 1501002411;
    if (preferences.bag == 34)
    bag2 = 1501002607;
    if (preferences.bag == 35)
    bag2 = 1501002318;
    if (preferences.bag == 36)
    bag2 = 1501002649;

    if (preferences.bag == 0)
    bag3 = 501003;
    if (preferences.bag == 1)
    bag3 = 1501003174;
    if (preferences.bag == 2)
    bag3 = 1501003220;
    if (preferences.bag == 3)
    bag3 = 1501003024;
    if (preferences.bag == 4)
    bag3 = 1501003311;
    if (preferences.bag == 5)
    bag3 = 1501003336;
    if (preferences.bag == 6)
    bag3 = 1501003457;
    if (preferences.bag == 7)
    bag3 = 1501003422;
    if (preferences.bag == 8)
    bag3 = 1501003443;
    if (preferences.bag == 9)
    bag3 = 1501003466;
    if (preferences.bag == 10)
    bag3 = 1501003047;
    if (preferences.bag == 11)
    bag3 = 1501003567;
    if (preferences.bag == 12)
    bag3 = 1501003588;
    if (preferences.bag == 13)
    bag3 = 1501003577;
    if (preferences.bag == 14)
    bag3 = 1501003503;
    if (preferences.bag == 15)
    bag3 = 1501003515;
    if (preferences.bag == 16)
    bag3 = 1501003550;
    if (preferences.bag == 17)
    bag3 = 1501003558;
    if (preferences.bag == 18)
    bag3 = 1501003058;
    if (preferences.bag == 19)
    bag3 = 1501003057;
    if (preferences.bag == 20)
    bag3 = 1501003051;
    if (preferences.bag == 21)
    bag3 = 1501003043;
    if (preferences.bag == 22)
    bag3 = 1501003042;
    if (preferences.bag == 23)
    bag3 = 1501003229;
    if (preferences.bag == 24)
    bag3 = 1501003023;
    if (preferences.bag == 25)
    bag3 = 1501003022;
    if (preferences.bag == 26)
    bag3 = 1501003608;
    if (preferences.bag == 27)
    bag3 = 1501003605;
    if (preferences.bag == 28)
    bag3 = 1501003061;
    if (preferences.bag == 29)
    bag3 = 1501003487;
    if (preferences.bag == 30)
    bag3 = 1501003039;
    if (preferences.bag == 31)
    bag3 = 1501003471;
    if (preferences.bag == 32)
    bag3 = 1501003411;
    if (preferences.bag == 33)
    bag3 = 1501003411;
    if (preferences.bag == 34)
    bag3 = 1501003607;
    if (preferences.bag == 35)
    bag3 = 1501003318;
    if (preferences.bag == 36)
    bag3 = 1501003649;

    //Helmet
    if (preferences.helmet == 0)
    helmett1 = 502003;
    if (preferences.helmet == 1)
    helmett1 = 1502001014;
    if (preferences.helmet == 2)
    helmett1 = 1502001349;
    if (preferences.helmet == 3)
    helmett1 = 1502001012;
    if (preferences.helmet == 4)
    helmett1 = 1502001009;
    if (preferences.helmet == 5)
    helmett1 = 1502001397;
    if (preferences.helmet == 6)
    helmett1 = 1502001390;
    if (preferences.helmet == 7)
    helmett1 = 1502001381;
    if (preferences.helmet == 8)
    helmett1 = 1502001358;
    if (preferences.helmet == 9)
    helmett1 = 1502001350;
    if (preferences.helmet == 10)
    helmett1 = 1502001342;
    if (preferences.helmet == 11)
    helmett1 = 1502001336;
    if (preferences.helmet == 12)
    helmett1 = 1502001333;
    if (preferences.helmet == 13)
    helmett1 = 1502001327;
    if (preferences.helmet == 14)
    helmett1 = 1502001325;
    if (preferences.helmet == 15)
    helmett1 = 1502001299;
    if (preferences.helmet == 16)
    helmett1 = 1502001295;
    if (preferences.helmet == 17)
    helmett1 = 1502001222;
    if (preferences.helmet == 18)
    helmett1 = 1502001069;
    if (preferences.helmet == 19)
    helmett1 = 1502001054;
    if (preferences.helmet == 20)
    helmett1 = 1502001033;
    if (preferences.helmet == 21)
    helmett1 = 1502001016;
    if (preferences.helmet == 22)
    helmett1 = 1502001031;
    if (preferences.helmet == 23)
    helmett1 = 1502001023;
    if (preferences.helmet == 24)
    helmett1 = 1502001018;
    if (preferences.helmet == 25)
    helmett1 = 1502001410;
    if (preferences.helmet == 26)
    helmett1 = 1502001408;
    if (preferences.helmet == 27)
    helmett1 = 1502001439;

                    
    if (preferences.helmet == 0)
    helmett2 = 502003;
    if (preferences.helmet == 1)
    helmett2 = 1502002014;
    if (preferences.helmet == 2)
    helmett2 = 1502002349;
    if (preferences.helmet == 3)
    helmett2 = 1502002012;
    if (preferences.helmet == 4)
    helmett2 = 1502002009;
    if (preferences.helmet == 5)
    helmett2 = 1502002397;
    if (preferences.helmet == 6)
    helmett2 = 1502002390;
    if (preferences.helmet == 7)
    helmett2 = 1502002381;
    if (preferences.helmet == 8)
    helmett2 = 1502002358;
    if (preferences.helmet == 9)
    helmett2 = 1502002350;
    if (preferences.helmet == 10)
    helmett2 = 1502002342;
    if (preferences.helmet == 11)
    helmett2 = 1502002336;
    if (preferences.helmet == 12)
    helmett2 = 1502002333;
    if (preferences.helmet == 13)
    helmett2 = 1502002327;
    if (preferences.helmet == 14)
    helmett2 = 1502002325;
    if (preferences.helmet == 15)
    helmett2 = 1502002299;
    if (preferences.helmet == 16)
    helmett2 = 1502002295;
    if (preferences.helmet == 17)
    helmett2 = 1502002222;
    if (preferences.helmet == 18)
    helmett2 = 1502002069;
    if (preferences.helmet == 19)
    helmett2 = 1502002054;
    if (preferences.helmet == 20)
    helmett2 = 1502002033;
    if (preferences.helmet == 21)
    helmett2 = 1502002016;
    if (preferences.helmet == 22)
    helmett2 = 1502002031;
    if (preferences.helmet == 23)
    helmett2 = 1502002023;
    if (preferences.helmet == 24)
    helmett2 = 1502002018;
    if (preferences.helmet == 25)
    helmett2 = 1502002410;
    if (preferences.helmet == 26)
    helmett2 = 1502002408;
    if (preferences.helmet == 27)
    helmett2 = 1502002439;

    if (preferences.helmet == 0)
    helmett3 = 502003;
    if (preferences.helmet == 1)
    helmett3 = 1502003014;
    if (preferences.helmet == 2)
    helmett3 = 1502003349;
    if (preferences.helmet == 3)
    helmett3 = 1502003012;
    if (preferences.helmet == 4)
    helmett3 = 1502003009;
    if (preferences.helmet == 5)
    helmett3 = 1502003397;
    if (preferences.helmet == 6)
    helmett3 = 1502003390;
    if (preferences.helmet == 7)
    helmett3 = 1502003381;
    if (preferences.helmet == 8)
    helmett3 = 1502003358;
    if (preferences.helmet == 9)
    helmett3 = 1502003350;
    if (preferences.helmet == 10)
    helmett3 = 1502003342;
    if (preferences.helmet == 11)
    helmett3 = 1502003336;
    if (preferences.helmet == 12)
    helmett3 = 1502003333;
    if (preferences.helmet == 13)
    helmett3 = 1502003327;
    if (preferences.helmet == 14)
    helmett3 = 1502003325;
    if (preferences.helmet == 15)
    helmett3 = 1502003299;
    if (preferences.helmet == 16)
    helmett3 = 1502003295;
    if (preferences.helmet == 17)
    helmett3 = 1502003222;
    if (preferences.helmet == 18)
    helmett3 = 1502003069;
    if (preferences.helmet == 19)
    helmett3 = 1502003054;
    if (preferences.helmet == 20)
    helmett3 = 1502003033;
    if (preferences.helmet == 21)
    helmett3 = 1502003016;
    if (preferences.helmet == 22)
    helmett3 = 1502003031;
    if (preferences.helmet == 23)
    helmett3 = 1502003023;
    if (preferences.helmet == 24)
    helmett3 = 1502003018;
    if (preferences.helmet == 25)
    helmett3 = 1502003410;
    if (preferences.helmet == 26)
    helmett3 = 1502003408;
    if (preferences.helmet == 27)
    helmett3 = 1502003439;

if (ModEmote1 == 0)
sEmote1 = 2200101;
if (ModEmote1 == 1)
sEmote1 = 12220023;
if (ModEmote1 == 2)
sEmote1 = 12219677;
if (ModEmote1 == 3)
sEmote1 = 12219716;
if (ModEmote1 == 4)
sEmote1 = 12209401;
if (ModEmote1 == 5)
sEmote1 = 12209501;
if (ModEmote1 == 6)
sEmote1 = 12209701;
if (ModEmote1 == 7)
sEmote1 = 12209801;
if (ModEmote1 == 8)
sEmote1 = 12209901;


if (ModEmote1 == 0)
sEmote2 = 2200201;
if (ModEmote1 == 1)
sEmote2 = 12210201;
if (ModEmote1 == 2)
sEmote2 = 12210601;
if (ModEmote1 == 3)
sEmote2 = 12220028;
if (ModEmote1 == 4)
sEmote2 = 12219819;
if (ModEmote1 == 5)
sEmote2 = 12211801;
if (ModEmote1 == 6)
sEmote2 = 12212001;
if (ModEmote1 == 7)
sEmote2 = 12212201;
if (ModEmote1 == 8)
sEmote2 = 12212401;


if (ModEmote1 == 0)
sEmote3 = 2200301;
if (ModEmote1 == 1)
sEmote3 = 12212601;
if (ModEmote1 == 2)
sEmote3 = 12213201;
if (ModEmote1 == 3)
sEmote3 = 12219715;
if (ModEmote1 == 4)
sEmote3 = 12219814;
if (ModEmote1 == 5)
sEmote3 = 12213601;
if (ModEmote1 == 6)
sEmote3 = 12213801;
if (ModEmote1 == 7)
sEmote3 = 12214001;
if (ModEmote1 == 8)
sEmote3 = 12214201;



  if (preferences.Config.Skin.Parachute == 0)
    new_Skin.Parachute = 703001;
  if (preferences.Config.Skin.Parachute == 1)
    new_Skin.Parachute = 1401619;
  if (preferences.Config.Skin.Parachute == 2)
    new_Skin.Parachute = 1401625;
  if (preferences.Config.Skin.Parachute == 3)
    new_Skin.Parachute = 1401624;
  if (preferences.Config.Skin.Parachute == 4)
    new_Skin.Parachute = 1401836;
  if (preferences.Config.Skin.Parachute == 5)
    new_Skin.Parachute = 1401833;
  if (preferences.Config.Skin.Parachute == 6)
    new_Skin.Parachute = 1401287;
  if (preferences.Config.Skin.Parachute == 7)
    new_Skin.Parachute = 1401282;
  if (preferences.Config.Skin.Parachute == 8)
    new_Skin.Parachute = 1401385;
  if (preferences.Config.Skin.Parachute == 9)
    new_Skin.Parachute = 1401549;
  if (preferences.Config.Skin.Parachute == 10)
    new_Skin.Parachute = 1401336;
  if (preferences.Config.Skin.Parachute == 11)
    new_Skin.Parachute = 1401335;
  if (preferences.Config.Skin.Parachute == 12)
    new_Skin.Parachute = 1401629;
  if (preferences.Config.Skin.Parachute == 13)
    new_Skin.Parachute = 1401628;
  if (preferences.Config.Skin.Parachute == 14)
    new_Skin.Parachute = 1401615;
  if (preferences.Config.Skin.Parachute == 15)
    new_Skin.Parachute = 1401613;

  if (preferences.Config.Skin.FlyMachine == 0)
    new_Skin.FlyMachine = 4151077; 
  if (preferences.Config.Skin.FlyMachine == 1)
    new_Skin.FlyMachine = 4151048; 
  if (preferences.Config.Skin.FlyMachine == 2)
    new_Skin.FlyMachine = 4151050; 
  if (preferences.Config.Skin.FlyMachine == 3)
    new_Skin.FlyMachine = 4151052; 
  if (preferences.Config.Skin.FlyMachine == 4)
    new_Skin.FlyMachine = 4151054; 
  if (preferences.Config.Skin.FlyMachine == 5)
    new_Skin.FlyMachine = 4151026; 
  if (preferences.Config.Skin.FlyMachine == 6)
    new_Skin.FlyMachine = 4151030; 
  if (preferences.Config.Skin.FlyMachine == 7)
    new_Skin.FlyMachine = 4151039; 
  if (preferences.Config.Skin.FlyMachine == 8)
    new_Skin.FlyMachine = 4151040; 
  if (preferences.Config.Skin.FlyMachine == 9)
    new_Skin.FlyMachine = 4151044; 
  if (preferences.Config.Skin.FlyMachine == 10)
    new_Skin.FlyMachine = 4151045;

    if (preferences.Config.Skin.Pan == 0)
    new_Skin.Pan = 108004;
    if (preferences.Config.Skin.Pan == 1)
    new_Skin.Pan = 1108004283;
    if (preferences.Config.Skin.Pan == 2)
    new_Skin.Pan = 1108004145;
    if (preferences.Config.Skin.Pan == 3)
    new_Skin.Pan = 1108004160;
    if (preferences.Config.Skin.Pan == 4)
    new_Skin.Pan = 1108004125;
    if (preferences.Config.Skin.Pan == 5)
    new_Skin.Pan = 1108004337;
    if (preferences.Config.Skin.Pan == 6)
    new_Skin.Pan = 1108004356;
    if (preferences.Config.Skin.Pan == 7)
    new_Skin.Pan = 1108004365;
    if (preferences.Config.Skin.Pan == 8)
    new_Skin.Pan = 1108004054;
    if (preferences.Config.Skin.Pan == 9)
    new_Skin.Pan = 1108004008;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.Machete == 0)
    new_Skin.Machete = 103003;
    if (preferences.Config.Skin.Machete == 1)
    new_Skin.Machete = 1108001069;
    if (preferences.Config.Skin.Machete == 2)
    new_Skin.Machete = 1108001081;
    if (preferences.Config.Skin.Machete == 3)
    new_Skin.Machete = 1108001064;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   

if (preferences.Config.Skin.Short == 0)
    new_Skin.Shortss = 0;
if (preferences.Config.Skin.Short == 1) // Commander
    new_Skin.Shortss = 1400122;
if (preferences.Config.Skin.Short == 2) // Bape Mix Shorts
    new_Skin.Shortss = 1400650;
if (preferences.Config.Skin.Short == 3) // Bape City Short
    new_Skin.Shortss = 1404002;
if (preferences.Config.Skin.Short == 4) // Bape Shark Shorts
    new_Skin.Shortss = 1404050;

    if (preferences.Config.Skin.XSuits == 0) {
// DEFAULT
        new_Skin.XSuits = 403003;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 1) {
// Golden Pharaoh X-Suit
        new_Skin.XSuits = 1405628;
        new_Skin.XSuits1 = 1402578;
    }
    if (preferences.Config.Skin.XSuits == 2) {
// Blood Raven X-Suit
        new_Skin.XSuits = 1405870;
        new_Skin.XSuits1 = 1403257;
    }
    if (preferences.Config.Skin.XSuits == 3) {
// Poseidon X-Suit
        new_Skin.XSuits = 1407140;
        new_Skin.XSuits1 = 1402874;
    }
    if (preferences.Config.Skin.XSuits == 4) {
// Avalanche X-Suit
        new_Skin.XSuits = 1407141;
        new_Skin.XSuits1 = 1403393;
    }
    if (preferences.Config.Skin.XSuits == 5) {
// Silvanus X-Suit
        new_Skin.XSuits = 1406311;
        new_Skin.XSuits1 = 1410011; 
    }
    if (preferences.Config.Skin.XSuits == 6) {
// Iridescence X-Suit
        new_Skin.XSuits = 1406475;
        new_Skin.XSuits1 = 1410131;
    }
    if (preferences.Config.Skin.XSuits == 7) {
// Arcane Jester X-Suit
        new_Skin.XSuits = 1406638;
        new_Skin.XSuits1 = 1410242;
    }
    if (preferences.Config.Skin.XSuits == 8) {
// Stygian Liege X-Suit
        new_Skin.XSuits = 1406872;
        new_Skin.XSuits1 = 402133;
    }
    if (preferences.Config.Skin.XSuits == 9) {
// Marmoris X-Suit
        new_Skin.XSuits = 1406971;
        new_Skin.XSuits1 = 402147;
    }
    if (preferences.Config.Skin.XSuits == 10) {
// Fiore X-Suit
        new_Skin.XSuits = 1407103;
        new_Skin.XSuits1 = 40604002;
    }
    
    if (preferences.Config.Skin.XSuits == 11) {
// Vampyra Countess Set
        new_Skin.XSuits = 1407391;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 12) {
// Galadria X-Suit
        new_Skin.XSuits = 1407366;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 13) {
// Spectral Admiral Set
        new_Skin.XSuits = 1407330;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 14) {
// Serene Lumina Set
        new_Skin.XSuits = 1407329;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 15) {
// Devious Cybercat Set
        new_Skin.XSuits = 1407286;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 16) {
// Mercury Soldier Set
        new_Skin.XSuits = 1407285;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 17) {
// Inferno Fiend Set
        new_Skin.XSuits = 1407277;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 18) {
// The Lover's Grace Set
        new_Skin.XSuits = 1407276;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 19) {
// Temperance's Virtue Set
        new_Skin.XSuits = 1407275;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 20) {
// Luminous Muse Set
        new_Skin.XSuits = 1407225;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 21) {
// Origin Lumen Set
        new_Skin.XSuits = 1407224;
        new_Skin.XSuits1 = 40604002;
    }

    if (preferences.Config.Skin.XSuits == 22) {
// Biker Jacket
        new_Skin.XSuits = 403034;
        
    }
    
    if (preferences.Config.Skin.XSuits == 23) {
// City Defender
        new_Skin.XSuits = 403170;
        
    }
    if (preferences.Config.Skin.XSuits == 24) {
// Serpengleam Set
        new_Skin.XSuits = 1407161;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 25) {
// Shinobi Spirit Set
        new_Skin.XSuits = 1407160;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 26) {
// Winter Highness Set
        new_Skin.XSuits = 1407107;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 27) {
// Foxy Flare Set
        new_Skin.XSuits = 1407106;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 28) {
// The Fool's Delight Set
        new_Skin.XSuits = 1407079;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 29) {
// Boxerbolt Set
        new_Skin.XSuits = 1407048;
        new_Skin.XSuits1 = 40604002;
    }
    
    if (preferences.Config.Skin.XSuits == 30) {
// Wrathful Neptune Set
        new_Skin.XSuits = 1406977;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 31) {
// Crew Set
    new_Skin.XSuits = 1400708; 
    new_Skin.XSuits1 = 40605011;
    //new_Skin.Shortss = 1400122;  
    new_Skin.Shoes = 1404293;  
    new_Skin.Face = 1400563; 
}
    if (preferences.Config.Skin.XSuits == 32) {
// Sweet Pineapple
        new_Skin.XSuits = 1404153;
        new_Skin.XSuits1 = 40605015;
        new_Skin.Shortss = 1404152;  
        new_Skin.Shoes = 1404151;         
    }
    
    if (preferences.Config.Skin.XSuits == 33) {
// BAPE MIX CAMO HOODIE
        new_Skin.XSuits = 1400569;
        //new_Skin.Shortss = 1400650;  
        new_Skin.Shoes = 1404003; 
    }
    if (preferences.Config.Skin.XSuits == 34) {
// BAPE City Camo Hoodie
        new_Skin.XSuits = 1404000;
        new_Skin.XSuits1 = 40604012;
        new_Skin.Face = 1400563;        
        //new_Skin.Shortss = 1404002;  
        new_Skin.Shoes = 1404003; 
    }
    if (preferences.Config.Skin.XSuits == 35) {
// BAPE CAMO Shark Hoodie
        new_Skin.XSuits = 1404049;
        //new_Skin.Shortss = 1404050;  
        new_Skin.Shoes = 1404051; 
    }
    if (preferences.Config.Skin.XSuits == 36) {
// Wanderer 
        new_Skin.XSuits = 1400119;
        //new_Skin.XSuits1 = 1400426;
    }
    if (preferences.Config.Skin.XSuits == 37) {
// Fireman Suit
        new_Skin.XSuits = 1400117;
        new_Skin.XSuits1 = 40605011;
        new_Skin.Face = 1400563;
    }
    if (preferences.Config.Skin.XSuits == 38) {
// Bonds of Blood Set
        new_Skin.XSuits = 1406060;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 39) {
// Mummy New Color
        new_Skin.XSuits = 1406891;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 40) {
// Mummy Set
        new_Skin.XSuits = 1400687;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 41) {
// MUMMY BLUE
        new_Skin.XSuits = 1407618;
        //new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 42) {
// Invader Set
        new_Skin.XSuits = 1405145;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 43) {
// Lonzo Ball Jersey
        new_Skin.XSuits = 1405436;
        new_Skin.XSuits1 = 40605011;
        new_Skin.Face = 1400563;
    }
    if (preferences.Config.Skin.XSuits == 44) {
// Ben Simmons Jersey
        new_Skin.XSuits = 1405435;
        new_Skin.XSuits1 = 40605011;
        new_Skin.Face = 1400563;
    }
    if (preferences.Config.Skin.XSuits == 45) {
// Isaiah Thomas Jersey
        new_Skin.XSuits = 1405434;
        new_Skin.XSuits1 = 40605011;
        new_Skin.Face = 1400563;
    }
    if (preferences.Config.Skin.XSuits == 46) {
// Marvin Costume
        new_Skin.XSuits = 1405064;
        new_Skin.XSuits1 = 40604002;
    }    
    
    if (preferences.Config.Skin.XSuits == 47) {
// Ryan Set
        new_Skin.XSuits = 1405207;
        new_Skin.XSuits1 = 40605011;
        new_Skin.Face = 1400563;
    }
    if (preferences.Config.Skin.XSuits == 48) {
// Angel Set
        new_Skin.XSuits = 1702266;
        new_Skin.XSuits1 = 40605011;
        new_Skin.Face = 1400563;
    }
    
    if (preferences.Config.Skin.XSuits == 49) {
// Summer Breeze Suit
        new_Skin.XSuits = 1400333;
        new_Skin.XSuits1 = 40605011;
        new_Skin.Face = 1400563;
    }
    if (preferences.Config.Skin.XSuits == 50) {
// Paradise Bikini (White)
        new_Skin.XSuits = 1400377;
        new_Skin.XSuits1 = 40605011;
        new_Skin.Face = 1400563;
    }
    if (preferences.Config.Skin.XSuits == 51) {
// The Fool Set
        new_Skin.XSuits = 1405092;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 52) {
// Infected Patient Set
        new_Skin.XSuits = 1405121;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 53) {
// Horned Kingpin Set
        new_Skin.XSuits = 1406889;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 54) {
// Myriam Fares Festival Set
        new_Skin.XSuits = 1407278;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 55) {
// Myriam Fares Warrior Set
        new_Skin.XSuits = 1407279;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 56) {
// Restless Pocong Set
        new_Skin.XSuits = 1407381;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 57) {
// Nina Williams Set
        new_Skin.XSuits = 1407380;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 58) {
// Draco Disciple Set
        new_Skin.XSuits = 1407385;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 59) {
// Mission Impossible Shirt
        new_Skin.XSuits = 1400324;
        new_Skin.XSuits1 = 40605011;
        new_Skin.Face = 1400563;
        //new_Skin.Shortss = 1400122;  
    }
    if (preferences.Config.Skin.XSuits == 60) {
// Commander Coat
        new_Skin.XSuits = 1400101;
        new_Skin.XSuits1 = 40605011;
        //new_Skin.Shortss = 1400122;
        new_Skin.Face = 1400563;
    }
    if (preferences.Config.Skin.XSuits == 61) {
// Evangelion Asuka Plugsuit
        new_Skin.XSuits = 1400122;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 62) {
// Evangelion Rei Plugsuit
        new_Skin.XSuits = 1406386;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 63) {
// Evangelion Shinji Plugsuit
        new_Skin.XSuits = 1406385;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 64) {
// Jinx Suit
        new_Skin.XSuits = 1406140;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 65) {
// Glacier Set
        new_Skin.XSuits = 1400782;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 66) {
// Feral Ravager Set
        new_Skin.XSuits = 1407392;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 67) {
// Fallen Spirit Set
        new_Skin.XSuits = 1407318;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 68) {
// Swiftfoot Phantom Set
        new_Skin.XSuits = 1407317;
        new_Skin.XSuits1 = 40604002;
    }
    if (preferences.Config.Skin.XSuits == 69) {
// Suzaku Kururugi Set
        new_Skin.XSuits = 1407404;
        new_Skin.XSuits1 = 40604002;
    }


    ///////////////////////////////////////////////////////////////////////////////////////

    if (preferences.Config.Skin.AKM == 0) {
    new_Skin.AKM = 101001;
    new_Skin.AKM_Mag = 291001;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 1) {
    new_Skin.AKM = 1101001265;
    new_Skin.AKM_Mag = 1010011541;
    new_Skin.AKM_flash = 1010011487;
    new_Skin.AKM_compe = 1010011488;
    new_Skin.AKM_silent = 1010011489;
    //new_Skin.AKM_reddot = 1010011486;
    new_Skin.AKM_holo = 1010011485;
    new_Skin.AKM_x2 = 1010011484;
    new_Skin.AKM_x3 = 1010011483;
    new_Skin.AKM_x4 = 1010011482;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011490;
    new_Skin.AKM_extendedMag = 1010011493;
    new_Skin.AKM_quickNextended = 1010011494;
    }
    if (preferences.Config.Skin.AKM == 2) {
    new_Skin.AKM = 1101001213;
    new_Skin.AKM_Mag = 1010012131;
    new_Skin.AKM_flash = 1010012067;
    new_Skin.AKM_compe = 1010012068;
    new_Skin.AKM_silent = 1010012069;
    new_Skin.AKM_reddot = 1010012066;
    new_Skin.AKM_holo = 1010012065;
    new_Skin.AKM_x2 = 1010012064;
    new_Skin.AKM_x3 = 1010012063;
    new_Skin.AKM_x4 = 1010012062;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010012070;
    new_Skin.AKM_extendedMag = 1010012072;
    new_Skin.AKM_quickNextended = 1010012073;
    }
    if (preferences.Config.Skin.AKM == 3) {
    new_Skin.AKM = 1101001103;
    new_Skin.AKM_Mag = 1010011031;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 4) {
    new_Skin.AKM = 1101001116;
    new_Skin.AKM_Mag = 1010011161;
    new_Skin.AKM_flash = 1010011106;
    new_Skin.AKM_compe = 21010011107;
    new_Skin.AKM_silent = 1010011108;
    new_Skin.AKM_reddot = 1010011105;
    new_Skin.AKM_holo = 1010011104;
    new_Skin.AKM_x2 = 1010011103;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 1010011102;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011109;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 1010011112;
    }
    if (preferences.Config.Skin.AKM == 5) {
    new_Skin.AKM = 1101001128;
    new_Skin.AKM_Mag = 1010011281;
    new_Skin.AKM_flash = 1010011232;
    new_Skin.AKM_compe = 1010011233;
    new_Skin.AKM_silent = 1010011234;
    new_Skin.AKM_reddot = 1010011226;
    new_Skin.AKM_holo = 1010011225;
    new_Skin.AKM_x2 = 1010011224;
    new_Skin.AKM_x3 = 1010011223;
    new_Skin.AKM_x4 = 1010011222;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011227;
    new_Skin.AKM_extendedMag = 1010011228;
    new_Skin.AKM_quickNextended = 1010011229;
    }
    if (preferences.Config.Skin.AKM == 6) {
    new_Skin.AKM = 1101001143;
    new_Skin.AKM_Mag = 1010011431;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 7) {
    new_Skin.AKM = 1101001154;
    new_Skin.AKM_Mag = 1010011541;
    new_Skin.AKM_flash = 1010011487;
    new_Skin.AKM_compe = 1010011488;
    new_Skin.AKM_silent = 1010011489;
    new_Skin.AKM_reddot = 1010011486;
    new_Skin.AKM_holo = 1010011485;
    new_Skin.AKM_x2 = 1010011484;
    new_Skin.AKM_x3 = 1010011483;
    new_Skin.AKM_x4 = 1010011482;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011490;
    new_Skin.AKM_extendedMag = 1010011493;
    new_Skin.AKM_quickNextended = 1010011494;
    }
    if (preferences.Config.Skin.AKM == 8) {
    new_Skin.AKM = 1101001174;
    new_Skin.AKM_Mag = 1010011741;
    new_Skin.AKM_flash = 1010011667;
    new_Skin.AKM_compe = 1010011668;
    new_Skin.AKM_silent = 1010011669;
    new_Skin.AKM_reddot = 1010011666;
    new_Skin.AKM_holo = 1010011665;
    new_Skin.AKM_x2 = 1010011664;
    new_Skin.AKM_x3 = 1010011663;
    new_Skin.AKM_x4 = 1010011662;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011670;
    new_Skin.AKM_extendedMag = 1010011673;
    new_Skin.AKM_quickNextended = 1010011674;
    }
    if (preferences.Config.Skin.AKM == 9) {
    new_Skin.AKM = 1101001231;
    new_Skin.AKM_Mag = 1010012311;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 10) {
    new_Skin.AKM = 1101001242;
    new_Skin.AKM_Mag = 1010012421;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 11) {
    new_Skin.AKM = 1101001089;
    new_Skin.AKM_Mag = 1010010891;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }

  ////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AKM == 0) {
    new_Skin.AKM1 = 1010012;
    new_Skin.AKM_Mag = 291001;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 1) {
    new_Skin.AKM1 = 1101001265;
    new_Skin.AKM_Mag = 1010011541;
    new_Skin.AKM_flash = 1010011487;
    new_Skin.AKM_compe = 1010011488;
    new_Skin.AKM_silent = 1010011489;
    new_Skin.AKM_reddot = 1010011486;
    new_Skin.AKM_holo = 1010011485;
    new_Skin.AKM_x2 = 1010011484;
    new_Skin.AKM_x3 = 1010011483;
    new_Skin.AKM_x4 = 1010011482;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011490;
    new_Skin.AKM_extendedMag = 1010011493;
    new_Skin.AKM_quickNextended = 1010011494;
    }
    if (preferences.Config.Skin.AKM == 2) {
    new_Skin.AKM1 = 1101001213;
    new_Skin.AKM_Mag = 1010012131;
    new_Skin.AKM_flash = 1010012067;
    new_Skin.AKM_compe = 1010012068;
    new_Skin.AKM_silent = 1010012069;
    new_Skin.AKM_reddot = 1010012066;
    new_Skin.AKM_holo = 1010012065;
    new_Skin.AKM_x2 = 1010012064;
    new_Skin.AKM_x3 = 1010012063;
    new_Skin.AKM_x4 = 1010012062;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010012070;
    new_Skin.AKM_extendedMag = 1010012072;
    new_Skin.AKM_quickNextended = 1010012073;
    }
    if (preferences.Config.Skin.AKM == 3) {
    new_Skin.AKM1 = 1101001103;
    new_Skin.AKM_Mag = 1010011031;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 4) {
    new_Skin.AKM1 = 1101001116;
    new_Skin.AKM_Mag = 1010011161;
    new_Skin.AKM_flash = 1010011106;
    new_Skin.AKM_compe = 21010011107;
    new_Skin.AKM_silent = 1010011108;
    new_Skin.AKM_reddot = 1010011105;
    new_Skin.AKM_holo = 1010011104;
    new_Skin.AKM_x2 = 1010011103;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 1010011102;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011109;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 1010011112;
    }
    if (preferences.Config.Skin.AKM == 5) {
    new_Skin.AKM1 = 1101001128;
    new_Skin.AKM_Mag = 1010011281;
    new_Skin.AKM_flash = 1010011232;
    new_Skin.AKM_compe = 1010011233;
    new_Skin.AKM_silent = 1010011234;
    new_Skin.AKM_reddot = 1010011226;
    new_Skin.AKM_holo = 1010011225;
    new_Skin.AKM_x2 = 1010011224;
    new_Skin.AKM_x3 = 1010011223;
    new_Skin.AKM_x4 = 1010011222;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011227;
    new_Skin.AKM_extendedMag = 1010011228;
    new_Skin.AKM_quickNextended = 1010011229;
    }
    if (preferences.Config.Skin.AKM == 6) {
    new_Skin.AKM1 = 1101001143;
    new_Skin.AKM_Mag = 1010011431;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 7) {
    new_Skin.AKM1 = 1101001154;
    new_Skin.AKM_Mag = 1010011541;
    new_Skin.AKM_flash = 1010011487;
    new_Skin.AKM_compe = 1010011488;
    new_Skin.AKM_silent = 1010011489;
    new_Skin.AKM_reddot = 1010011486;
    new_Skin.AKM_holo = 1010011485;
    new_Skin.AKM_x2 = 1010011484;
    new_Skin.AKM_x3 = 1010011483;
    new_Skin.AKM_x4 = 1010011482;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011490;
    new_Skin.AKM_extendedMag = 1010011493;
    new_Skin.AKM_quickNextended = 1010011494;
    }
    if (preferences.Config.Skin.AKM == 8) {
    new_Skin.AKM1 = 1101001174;
    new_Skin.AKM_Mag = 1010011741;
    new_Skin.AKM_flash = 1010011667;
    new_Skin.AKM_compe = 1010011668;
    new_Skin.AKM_silent = 1010011669;
    new_Skin.AKM_reddot = 1010011666;
    new_Skin.AKM_holo = 1010011665;
    new_Skin.AKM_x2 = 1010011664;
    new_Skin.AKM_x3 = 1010011663;
    new_Skin.AKM_x4 = 1010011662;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011670;
    new_Skin.AKM_extendedMag = 1010011673;
    new_Skin.AKM_quickNextended = 1010011674;
    }
    if (preferences.Config.Skin.AKM == 9) {
    new_Skin.AKM1 = 1101001231;
    new_Skin.AKM_Mag = 1010012311;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 10) {
    new_Skin.AKM1 = 1101001242;
    new_Skin.AKM_Mag = 1010012421;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 11) {
    new_Skin.AKM1 = 1101001089;
    new_Skin.AKM_Mag = 1010010891;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }

  ////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AKM == 0) {
    new_Skin.AKM2 = 1010013;
    new_Skin.AKM_Mag = 291001;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 1) {
    new_Skin.AKM2 = 1101001265;
    new_Skin.AKM_Mag = 1010011541;
    new_Skin.AKM_flash = 1010011487;
    new_Skin.AKM_compe = 1010011488;
    new_Skin.AKM_silent = 1010011489;
    new_Skin.AKM_reddot = 1010011486;
    new_Skin.AKM_holo = 1010011485;
    new_Skin.AKM_x2 = 1010011484;
    new_Skin.AKM_x3 = 1010011483;
    new_Skin.AKM_x4 = 1010011482;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011490;
    new_Skin.AKM_extendedMag = 1010011493;
    new_Skin.AKM_quickNextended = 1010011494;
    }
    if (preferences.Config.Skin.AKM == 2) {
    new_Skin.AKM2 = 1101001213;
    new_Skin.AKM_Mag = 1010012131;
    new_Skin.AKM_flash = 1010012067;
    new_Skin.AKM_compe = 1010012068;
    new_Skin.AKM_silent = 1010012069;
    new_Skin.AKM_reddot = 1010012066;
    new_Skin.AKM_holo = 1010012065;
    new_Skin.AKM_x2 = 1010012064;
    new_Skin.AKM_x3 = 1010012063;
    new_Skin.AKM_x4 = 1010012062;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010012070;
    new_Skin.AKM_extendedMag = 1010012072;
    new_Skin.AKM_quickNextended = 1010012073;
    }
    if (preferences.Config.Skin.AKM == 3) {
    new_Skin.AKM2 = 1101001103;
    new_Skin.AKM_Mag = 1010011031;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 4) {
    new_Skin.AKM2 = 1101001116;
    new_Skin.AKM_Mag = 1010011161;
    new_Skin.AKM_flash = 1010011106;
    new_Skin.AKM_compe = 21010011107;
    new_Skin.AKM_silent = 1010011108;
    new_Skin.AKM_reddot = 1010011105;
    new_Skin.AKM_holo = 1010011104;
    new_Skin.AKM_x2 = 1010011103;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 1010011102;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011109;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 1010011112;
    }
    if (preferences.Config.Skin.AKM == 5) {
    new_Skin.AKM2 = 1101001128;
    new_Skin.AKM_Mag = 1010011281;
    new_Skin.AKM_flash = 1010011232;
    new_Skin.AKM_compe = 1010011233;
    new_Skin.AKM_silent = 1010011234;
    new_Skin.AKM_reddot = 1010011226;
    new_Skin.AKM_holo = 1010011225;
    new_Skin.AKM_x2 = 1010011224;
    new_Skin.AKM_x3 = 1010011223;
    new_Skin.AKM_x4 = 1010011222;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011227;
    new_Skin.AKM_extendedMag = 1010011228;
    new_Skin.AKM_quickNextended = 1010011229;
    }
    if (preferences.Config.Skin.AKM == 6) {
    new_Skin.AKM2 = 1101001143;
    new_Skin.AKM_Mag = 1010011431;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 7) {
    new_Skin.AKM2 = 1101001154;
    new_Skin.AKM_Mag = 1010011541;
    new_Skin.AKM_flash = 1010011487;
    new_Skin.AKM_compe = 1010011488;
    new_Skin.AKM_silent = 1010011489;
    new_Skin.AKM_reddot = 1010011486;
    new_Skin.AKM_holo = 1010011485;
    new_Skin.AKM_x2 = 1010011484;
    new_Skin.AKM_x3 = 1010011483;
    new_Skin.AKM_x4 = 1010011482;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011490;
    new_Skin.AKM_extendedMag = 1010011493;
    new_Skin.AKM_quickNextended = 1010011494;
    }
    if (preferences.Config.Skin.AKM == 8) {
    new_Skin.AKM2 = 1101001174;
    new_Skin.AKM_Mag = 1010011741;
    new_Skin.AKM_flash = 1010011667;
    new_Skin.AKM_compe = 1010011668;
    new_Skin.AKM_silent = 1010011669;
    new_Skin.AKM_reddot = 1010011666;
    new_Skin.AKM_holo = 1010011665;
    new_Skin.AKM_x2 = 1010011664;
    new_Skin.AKM_x3 = 1010011663;
    new_Skin.AKM_x4 = 1010011662;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011670;
    new_Skin.AKM_extendedMag = 1010011673;
    new_Skin.AKM_quickNextended = 1010011674;
    }
    if (preferences.Config.Skin.AKM == 9) {
    new_Skin.AKM2 = 1101001231;
    new_Skin.AKM_Mag = 1010012311;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 10) {
    new_Skin.AKM2 = 1101001242;
    new_Skin.AKM_Mag = 1010012421;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 11) {
    new_Skin.AKM2 = 1101001089;
    new_Skin.AKM_Mag = 1010010891;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }

  ////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AKM == 0) {
    new_Skin.AKM3 = 1010014;
    new_Skin.AKM_Mag = 291001;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 1) {
    new_Skin.AKM3 = 1101001265;
    new_Skin.AKM_Mag = 1010011541;
    new_Skin.AKM_flash = 1010011487;
    new_Skin.AKM_compe = 1010011488;
    new_Skin.AKM_silent = 1010011489;
    new_Skin.AKM_reddot = 1010011486;
    new_Skin.AKM_holo = 1010011485;
    new_Skin.AKM_x2 = 1010011484;
    new_Skin.AKM_x3 = 1010011483;
    new_Skin.AKM_x4 = 1010011482;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011490;
    new_Skin.AKM_extendedMag = 1010011493;
    new_Skin.AKM_quickNextended = 1010011494;
    }
    if (preferences.Config.Skin.AKM == 2) {
    new_Skin.AKM3 = 1101001213;
    new_Skin.AKM_Mag = 1010012131;
    new_Skin.AKM_flash = 1010012067;
    new_Skin.AKM_compe = 1010012068;
    new_Skin.AKM_silent = 1010012069;
    new_Skin.AKM_reddot = 1010012066;
    new_Skin.AKM_holo = 1010012065;
    new_Skin.AKM_x2 = 1010012064;
    new_Skin.AKM_x3 = 1010012063;
    new_Skin.AKM_x4 = 1010012062;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010012070;
    new_Skin.AKM_extendedMag = 1010012072;
    new_Skin.AKM_quickNextended = 1010012073;
    }
    if (preferences.Config.Skin.AKM == 3) {
    new_Skin.AKM3 = 1101001103;
    new_Skin.AKM_Mag = 1010011031;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 4) {
    new_Skin.AKM3 = 1101001116;
    new_Skin.AKM_Mag = 1010011161;
    new_Skin.AKM_flash = 1010011106;
    new_Skin.AKM_compe = 21010011107;
    new_Skin.AKM_silent = 1010011108;
    new_Skin.AKM_reddot = 1010011105;
    new_Skin.AKM_holo = 1010011104;
    new_Skin.AKM_x2 = 1010011103;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 1010011102;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011109;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 1010011112;
    }
    if (preferences.Config.Skin.AKM == 5) {
    new_Skin.AKM3 = 1101001128;
    new_Skin.AKM_Mag = 1010011281;
    new_Skin.AKM_flash = 1010011232;
    new_Skin.AKM_compe = 1010011233;
    new_Skin.AKM_silent = 1010011234;
    new_Skin.AKM_reddot = 1010011226;
    new_Skin.AKM_holo = 1010011225;
    new_Skin.AKM_x2 = 1010011224;
    new_Skin.AKM_x3 = 1010011223;
    new_Skin.AKM_x4 = 1010011222;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011227;
    new_Skin.AKM_extendedMag = 1010011228;
    new_Skin.AKM_quickNextended = 1010011229;
    }
    if (preferences.Config.Skin.AKM == 6) {
    new_Skin.AKM3 = 1101001143;
    new_Skin.AKM_Mag = 1010011431;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 7) {
    new_Skin.AKM3 = 1101001154;
    new_Skin.AKM_Mag = 1010011541;
    new_Skin.AKM_flash = 1010011487;
    new_Skin.AKM_compe = 1010011488;
    new_Skin.AKM_silent = 1010011489;
    new_Skin.AKM_reddot = 1010011486;
    new_Skin.AKM_holo = 1010011485;
    new_Skin.AKM_x2 = 1010011484;
    new_Skin.AKM_x3 = 1010011483;
    new_Skin.AKM_x4 = 1010011482;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011490;
    new_Skin.AKM_extendedMag = 1010011493;
    new_Skin.AKM_quickNextended = 1010011494;
    }
    if (preferences.Config.Skin.AKM == 8) {
    new_Skin.AKM3 = 1101001174;
    new_Skin.AKM_Mag = 1010011741;
    new_Skin.AKM_flash = 1010011667;
    new_Skin.AKM_compe = 1010011668;
    new_Skin.AKM_silent = 1010011669;
    new_Skin.AKM_reddot = 1010011666;
    new_Skin.AKM_holo = 1010011665;
    new_Skin.AKM_x2 = 1010011664;
    new_Skin.AKM_x3 = 1010011663;
    new_Skin.AKM_x4 = 1010011662;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011670;
    new_Skin.AKM_extendedMag = 1010011673;
    new_Skin.AKM_quickNextended = 1010011674;
    }
    if (preferences.Config.Skin.AKM == 9) {
    new_Skin.AKM3 = 1101001231;
    new_Skin.AKM_Mag = 1010012311;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 10) {
    new_Skin.AKM3 = 1101001242;
    new_Skin.AKM_Mag = 1010012421;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 11) {
    new_Skin.AKM3 = 1101001089;
    new_Skin.AKM_Mag = 1010010891;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }

  ////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AKM == 0) {
    new_Skin.AKM4 = 1010015;
    new_Skin.AKM_Mag = 291001;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 1) {
    new_Skin.AKM4 = 1101001265;
    new_Skin.AKM_Mag = 1010011541;
    new_Skin.AKM_flash = 1010011487;
    new_Skin.AKM_compe = 1010011488;
    new_Skin.AKM_silent = 1010011489;
    new_Skin.AKM_reddot = 1010011486;
    new_Skin.AKM_holo = 1010011485;
    new_Skin.AKM_x2 = 1010011484;
    new_Skin.AKM_x3 = 1010011483;
    new_Skin.AKM_x4 = 1010011482;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011490;
    new_Skin.AKM_extendedMag = 1010011493;
    new_Skin.AKM_quickNextended = 1010011494;
    }
    if (preferences.Config.Skin.AKM == 2) {
    new_Skin.AKM4 = 1101001213;
    new_Skin.AKM_Mag = 1010012131;
    new_Skin.AKM_flash = 1010012067;
    new_Skin.AKM_compe = 1010012068;
    new_Skin.AKM_silent = 1010012069;
    new_Skin.AKM_reddot = 1010012066;
    new_Skin.AKM_holo = 1010012065;
    new_Skin.AKM_x2 = 1010012064;
    new_Skin.AKM_x3 = 1010012063;
    new_Skin.AKM_x4 = 1010012062;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010012070;
    new_Skin.AKM_extendedMag = 1010012072;
    new_Skin.AKM_quickNextended = 1010012073;
    }
    if (preferences.Config.Skin.AKM == 3) {
    new_Skin.AKM4 = 1101001103;
    new_Skin.AKM_Mag = 1010011031;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 4) {
    new_Skin.AKM4 = 1101001116;
    new_Skin.AKM_Mag = 1010011161;
    new_Skin.AKM_flash = 1010011106;
    new_Skin.AKM_compe = 21010011107;
    new_Skin.AKM_silent = 1010011108;
    new_Skin.AKM_reddot = 1010011105;
    new_Skin.AKM_holo = 1010011104;
    new_Skin.AKM_x2 = 1010011103;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 1010011102;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011109;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 1010011112;
    }
    if (preferences.Config.Skin.AKM == 5) {
    new_Skin.AKM4 = 1101001128;
    new_Skin.AKM_Mag = 1010011281;
    new_Skin.AKM_flash = 1010011232;
    new_Skin.AKM_compe = 1010011233;
    new_Skin.AKM_silent = 1010011234;
    new_Skin.AKM_reddot = 1010011226;
    new_Skin.AKM_holo = 1010011225;
    new_Skin.AKM_x2 = 1010011224;
    new_Skin.AKM_x3 = 1010011223;
    new_Skin.AKM_x4 = 1010011222;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011227;
    new_Skin.AKM_extendedMag = 1010011228;
    new_Skin.AKM_quickNextended = 1010011229;
    }
    if (preferences.Config.Skin.AKM == 6) {
    new_Skin.AKM4 = 1101001143;
    new_Skin.AKM_Mag = 1010011431;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 7) {
    new_Skin.AKM4 = 1101001154;
    new_Skin.AKM_Mag = 1010011541;
    new_Skin.AKM_flash = 1010011487;
    new_Skin.AKM_compe = 1010011488;
    new_Skin.AKM_silent = 1010011489;
    new_Skin.AKM_reddot = 1010011486;
    new_Skin.AKM_holo = 1010011485;
    new_Skin.AKM_x2 = 1010011484;
    new_Skin.AKM_x3 = 1010011483;
    new_Skin.AKM_x4 = 1010011482;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011490;
    new_Skin.AKM_extendedMag = 1010011493;
    new_Skin.AKM_quickNextended = 1010011494;
    }
    if (preferences.Config.Skin.AKM == 8) {
    new_Skin.AKM4 = 1101001174;
    new_Skin.AKM_Mag = 1010011741;
    new_Skin.AKM_flash = 1010011667;
    new_Skin.AKM_compe = 1010011668;
    new_Skin.AKM_silent = 1010011669;
    new_Skin.AKM_reddot = 1010011666;
    new_Skin.AKM_holo = 1010011665;
    new_Skin.AKM_x2 = 1010011664;
    new_Skin.AKM_x3 = 1010011663;
    new_Skin.AKM_x4 = 1010011662;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011670;
    new_Skin.AKM_extendedMag = 1010011673;
    new_Skin.AKM_quickNextended = 1010011674;
    }
    if (preferences.Config.Skin.AKM == 9) {
    new_Skin.AKM4 = 1101001231;
    new_Skin.AKM_Mag = 1010012311;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 10) {
    new_Skin.AKM4 = 1101001242;
    new_Skin.AKM_Mag = 1010012421;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 11) {
    new_Skin.AKM4 = 1101001089;
    new_Skin.AKM_Mag = 1010010891;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }

  ////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AKM == 0) {
    new_Skin.AKM5 = 1010016;
    new_Skin.AKM_Mag = 291001;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 1) {
    new_Skin.AKM5 = 1101001265;
    new_Skin.AKM_Mag = 1010011541;
    new_Skin.AKM_flash = 1010011487;
    new_Skin.AKM_compe = 1010011488;
    new_Skin.AKM_silent = 1010011489;
    new_Skin.AKM_reddot = 1010011486;
    new_Skin.AKM_holo = 1010011485;
    new_Skin.AKM_x2 = 1010011484;
    new_Skin.AKM_x3 = 1010011483;
    new_Skin.AKM_x4 = 1010011482;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011490;
    new_Skin.AKM_extendedMag = 1010011493;
    new_Skin.AKM_quickNextended = 1010011494;
    }
    if (preferences.Config.Skin.AKM == 2) {
    new_Skin.AKM5 = 1101001213;
    new_Skin.AKM_Mag = 1010012131;
    new_Skin.AKM_flash = 1010012067;
    new_Skin.AKM_compe = 1010012068;
    new_Skin.AKM_silent = 1010012069;
    new_Skin.AKM_reddot = 1010012066;
    new_Skin.AKM_holo = 1010012065;
    new_Skin.AKM_x2 = 1010012064;
    new_Skin.AKM_x3 = 1010012063;
    new_Skin.AKM_x4 = 1010012062;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010012070;
    new_Skin.AKM_extendedMag = 1010012072;
    new_Skin.AKM_quickNextended = 1010012073;
    }
    if (preferences.Config.Skin.AKM == 3) {
    new_Skin.AKM5 = 1101001103;
    new_Skin.AKM_Mag = 1010011031;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 4) {
    new_Skin.AKM5 = 1101001116;
    new_Skin.AKM_Mag = 1010011161;
    new_Skin.AKM_flash = 1010011106;
    new_Skin.AKM_compe = 21010011107;
    new_Skin.AKM_silent = 1010011108;
    new_Skin.AKM_reddot = 1010011105;
    new_Skin.AKM_holo = 1010011104;
    new_Skin.AKM_x2 = 1010011103;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 1010011102;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011109;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 1010011112;
    }
    if (preferences.Config.Skin.AKM == 5) {
    new_Skin.AKM5 = 1101001128;
    new_Skin.AKM_Mag = 1010011281;
    new_Skin.AKM_flash = 1010011232;
    new_Skin.AKM_compe = 1010011233;
    new_Skin.AKM_silent = 1010011234;
    new_Skin.AKM_reddot = 1010011226;
    new_Skin.AKM_holo = 1010011225;
    new_Skin.AKM_x2 = 1010011224;
    new_Skin.AKM_x3 = 1010011223;
    new_Skin.AKM_x4 = 1010011222;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011227;
    new_Skin.AKM_extendedMag = 1010011228;
    new_Skin.AKM_quickNextended = 1010011229;
    }
    if (preferences.Config.Skin.AKM == 6) {
    new_Skin.AKM5 = 1101001143;
    new_Skin.AKM_Mag = 1010011431;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 7) {
    new_Skin.AKM5 = 1101001154;
    new_Skin.AKM_Mag = 1010011541;
    new_Skin.AKM_flash = 1010011487;
    new_Skin.AKM_compe = 1010011488;
    new_Skin.AKM_silent = 1010011489;
    new_Skin.AKM_reddot = 1010011486;
    new_Skin.AKM_holo = 1010011485;
    new_Skin.AKM_x2 = 1010011484;
    new_Skin.AKM_x3 = 1010011483;
    new_Skin.AKM_x4 = 1010011482;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011490;
    new_Skin.AKM_extendedMag = 1010011493;
    new_Skin.AKM_quickNextended = 1010011494;
    }
    if (preferences.Config.Skin.AKM == 8) {
    new_Skin.AKM5 = 1101001174;
    new_Skin.AKM_Mag = 1010011741;
    new_Skin.AKM_flash = 1010011667;
    new_Skin.AKM_compe = 1010011668;
    new_Skin.AKM_silent = 1010011669;
    new_Skin.AKM_reddot = 1010011666;
    new_Skin.AKM_holo = 1010011665;
    new_Skin.AKM_x2 = 1010011664;
    new_Skin.AKM_x3 = 1010011663;
    new_Skin.AKM_x4 = 1010011662;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011670;
    new_Skin.AKM_extendedMag = 1010011673;
    new_Skin.AKM_quickNextended = 1010011674;
    }
    if (preferences.Config.Skin.AKM == 9) {
    new_Skin.AKM5 = 1101001231;
    new_Skin.AKM_Mag = 1010012311;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 10) {
    new_Skin.AKM5 = 1101001242;
    new_Skin.AKM_Mag = 1010012421;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 11) {
    new_Skin.AKM5 = 1101001089;
    new_Skin.AKM_Mag = 1010010891;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }

  ////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AKM == 0) {
    new_Skin.AKM6 = 1010017;
    new_Skin.AKM_Mag = 291001;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 1) {
    new_Skin.AKM6 = 1101001265;
    new_Skin.AKM_Mag = 1010011541;
    new_Skin.AKM_flash = 1010011487;
    new_Skin.AKM_compe = 1010011488;
    new_Skin.AKM_silent = 1010011489;
    new_Skin.AKM_reddot = 1010011486;
    new_Skin.AKM_holo = 1010011485;
    new_Skin.AKM_x2 = 1010011484;
    new_Skin.AKM_x3 = 1010011483;
    new_Skin.AKM_x4 = 1010011482;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011490;
    new_Skin.AKM_extendedMag = 1010011493;
    new_Skin.AKM_quickNextended = 1010011494;
    }
    if (preferences.Config.Skin.AKM == 2) {
    new_Skin.AKM6 = 1101001213;
    new_Skin.AKM_Mag = 1010012131;
    new_Skin.AKM_flash = 1010012067;
    new_Skin.AKM_compe = 1010012068;
    new_Skin.AKM_silent = 1010012069;
    new_Skin.AKM_reddot = 1010012066;
    new_Skin.AKM_holo = 1010012065;
    new_Skin.AKM_x2 = 1010012064;
    new_Skin.AKM_x3 = 1010012063;
    new_Skin.AKM_x4 = 1010012062;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010012070;
    new_Skin.AKM_extendedMag = 1010012072;
    new_Skin.AKM_quickNextended = 1010012073;
    }
    if (preferences.Config.Skin.AKM == 3) {
    new_Skin.AKM6 = 1101001103;
    new_Skin.AKM_Mag = 1010011031;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 4) {
    new_Skin.AKM6 = 1101001116;
    new_Skin.AKM_Mag = 1010011161;
    new_Skin.AKM_flash = 1010011106;
    new_Skin.AKM_compe = 21010011107;
    new_Skin.AKM_silent = 1010011108;
    new_Skin.AKM_reddot = 1010011105;
    new_Skin.AKM_holo = 1010011104;
    new_Skin.AKM_x2 = 1010011103;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 1010011102;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011109;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 1010011112;
    }
    if (preferences.Config.Skin.AKM == 5) {
    new_Skin.AKM6 = 1101001128;
    new_Skin.AKM_Mag = 1010011281;
    new_Skin.AKM_flash = 1010011232;
    new_Skin.AKM_compe = 1010011233;
    new_Skin.AKM_silent = 1010011234;
    new_Skin.AKM_reddot = 1010011226;
    new_Skin.AKM_holo = 1010011225;
    new_Skin.AKM_x2 = 1010011224;
    new_Skin.AKM_x3 = 1010011223;
    new_Skin.AKM_x4 = 1010011222;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011227;
    new_Skin.AKM_extendedMag = 1010011228;
    new_Skin.AKM_quickNextended = 1010011229;
    }
    if (preferences.Config.Skin.AKM == 6) {
    new_Skin.AKM6 = 1101001143;
    new_Skin.AKM_Mag = 1010011431;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 7) {
    new_Skin.AKM6 = 1101001154;
    new_Skin.AKM_Mag = 1010011541;
    new_Skin.AKM_flash = 1010011487;
    new_Skin.AKM_compe = 1010011488;
    new_Skin.AKM_silent = 1010011489;
    new_Skin.AKM_reddot = 1010011486;
    new_Skin.AKM_holo = 1010011485;
    new_Skin.AKM_x2 = 1010011484;
    new_Skin.AKM_x3 = 1010011483;
    new_Skin.AKM_x4 = 1010011482;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011490;
    new_Skin.AKM_extendedMag = 1010011493;
    new_Skin.AKM_quickNextended = 1010011494;
    }
    if (preferences.Config.Skin.AKM == 8) {
    new_Skin.AKM6 = 1101001174;
    new_Skin.AKM_Mag = 1010011741;
    new_Skin.AKM_flash = 1010011667;
    new_Skin.AKM_compe = 1010011668;
    new_Skin.AKM_silent = 1010011669;
    new_Skin.AKM_reddot = 1010011666;
    new_Skin.AKM_holo = 1010011665;
    new_Skin.AKM_x2 = 1010011664;
    new_Skin.AKM_x3 = 1010011663;
    new_Skin.AKM_x4 = 1010011662;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 1010011670;
    new_Skin.AKM_extendedMag = 1010011673;
    new_Skin.AKM_quickNextended = 1010011674;
    }
    if (preferences.Config.Skin.AKM == 9) {
    new_Skin.AKM6 = 1101001231;
    new_Skin.AKM_Mag = 1010012311;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 10) {
    new_Skin.AKM6 = 1101001242;
    new_Skin.AKM_Mag = 1010012421;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }
    if (preferences.Config.Skin.AKM == 11) {
    new_Skin.AKM6 = 1101001089;
    new_Skin.AKM_Mag = 1010010891;
    new_Skin.AKM_flash = 201010;
    new_Skin.AKM_compe = 201009;
    new_Skin.AKM_silent = 201011;
    new_Skin.AKM_reddot = 203001;
    new_Skin.AKM_holo = 203002;
    new_Skin.AKM_x2 = 203003;
    new_Skin.AKM_x3 = 203014;
    new_Skin.AKM_x4 = 203004;
    new_Skin.AKM_x6 = 203015;
    new_Skin.AKM_quickMag = 204012;
    new_Skin.AKM_extendedMag = 204011;
    new_Skin.AKM_quickNextended = 204013;
    }

////////////////////////////////////////////////////////

  if (preferences.Config.Skin.M16A4 == 0) {
    new_Skin.M16A4 = 101002;
    new_Skin.M16A4_Stock = 205007;
    new_Skin.M16A4_Mag = 291002;
  }
  if (preferences.Config.Skin.M16A4 == 1) {
    new_Skin.M16A4 = 1101002029;
    new_Skin.M16A4_Stock = 1010020292;
    new_Skin.M16A4_Mag = 1010020291;
  }
  if (preferences.Config.Skin.M16A4 == 2) {
    new_Skin.M16A4 = 1101002056;
    new_Skin.M16A4_Stock = 1010020562;
    new_Skin.M16A4_Mag = 1010020561;
  }
  if (preferences.Config.Skin.M16A4 == 3) {
    new_Skin.M16A4 = 1101002068;
    new_Skin.M16A4_Stock = 1010020682;
    new_Skin.M16A4_Mag = 1010020681;
  }
  if (preferences.Config.Skin.M16A4 == 4) {
    new_Skin.M16A4 = 1101002081;
    new_Skin.M16A4_Stock = 1010020812;
    new_Skin.M16A4_Mag = 1010020811;
  }
  if (preferences.Config.Skin.M16A4 == 5) {
    new_Skin.M16A4 = 1101002103;
    new_Skin.M16A4_Stock = 1010021032;
    new_Skin.M16A4_Mag = 1010021031;
  }
////////////////////////////////////////////////////////

  if (preferences.Config.Skin.M16A4 == 0) {
    new_Skin.M16A41 = 1010022;
    new_Skin.M16A4_Stock = 205007;
    new_Skin.M16A4_Mag = 291002;
  }
  if (preferences.Config.Skin.M16A4 == 1) {
    new_Skin.M16A41 = 1101002029;
    new_Skin.M16A4_Stock = 1010020292;
    new_Skin.M16A4_Mag = 1010020291;
  }
  if (preferences.Config.Skin.M16A4 == 2) {
    new_Skin.M16A41 = 1101002056;
    new_Skin.M16A4_Stock = 1010020562;
    new_Skin.M16A4_Mag = 1010020561;
  }
  if (preferences.Config.Skin.M16A4 == 3) {
    new_Skin.M16A41 = 1101002068;
    new_Skin.M16A4_Stock = 1010020682;
    new_Skin.M16A4_Mag = 1010020681;
  }
  if (preferences.Config.Skin.M16A4 == 4) {
    new_Skin.M16A41 = 1101002081;
    new_Skin.M16A4_Stock = 1010020812;
    new_Skin.M16A4_Mag = 1010020811;
  }
  if (preferences.Config.Skin.M16A4 == 5) {
    new_Skin.M16A41 = 1101002103;
    new_Skin.M16A4_Stock = 1010021032;
    new_Skin.M16A4_Mag = 1010021031;
  }
////////////////////////////////////////////////////////

  if (preferences.Config.Skin.M16A4 == 0) {
    new_Skin.M16A42 = 1010023;
    new_Skin.M16A4_Stock = 205007;
    new_Skin.M16A4_Mag = 291002;
  }
  if (preferences.Config.Skin.M16A4 == 1) {
    new_Skin.M16A42 = 1101002029;
    new_Skin.M16A4_Stock = 1010020292;
    new_Skin.M16A4_Mag = 1010020291;
  }
  if (preferences.Config.Skin.M16A4 == 2) {
    new_Skin.M16A42 = 1101002056;
    new_Skin.M16A4_Stock = 1010020562;
    new_Skin.M16A4_Mag = 1010020561;
  }
  if (preferences.Config.Skin.M16A4 == 3) {
    new_Skin.M16A42 = 1101002068;
    new_Skin.M16A4_Stock = 1010020682;
    new_Skin.M16A4_Mag = 1010020681;
  }
  if (preferences.Config.Skin.M16A4 == 4) {
    new_Skin.M16A42 = 1101002081;
    new_Skin.M16A4_Stock = 1010020812;
    new_Skin.M16A4_Mag = 1010020811;
  }
  if (preferences.Config.Skin.M16A4 == 5) {
    new_Skin.M16A42 = 1101002103;
    new_Skin.M16A4_Stock = 1010021032;
    new_Skin.M16A4_Mag = 1010021031;
  }
////////////////////////////////////////////////////////

  if (preferences.Config.Skin.M16A4 == 0) {
    new_Skin.M16A43 = 1010024;
    new_Skin.M16A4_Stock = 205007;
    new_Skin.M16A4_Mag = 291002;
  }
  if (preferences.Config.Skin.M16A4 == 1) {
    new_Skin.M16A43 = 1101002029;
    new_Skin.M16A4_Stock = 1010020292;
    new_Skin.M16A4_Mag = 1010020291;
  }
  if (preferences.Config.Skin.M16A4 == 2) {
    new_Skin.M16A43 = 1101002056;
    new_Skin.M16A4_Stock = 1010020562;
    new_Skin.M16A4_Mag = 1010020561;
  }
  if (preferences.Config.Skin.M16A4 == 3) {
    new_Skin.M16A43 = 1101002068;
    new_Skin.M16A4_Stock = 1010020682;
    new_Skin.M16A4_Mag = 1010020681;
  }
  if (preferences.Config.Skin.M16A4 == 4) {
    new_Skin.M16A43 = 1101002081;
    new_Skin.M16A4_Stock = 1010020812;
    new_Skin.M16A4_Mag = 1010020811;
  }
  if (preferences.Config.Skin.M16A4 == 5) {
    new_Skin.M16A43 = 1101002103;
    new_Skin.M16A4_Stock = 1010021032;
    new_Skin.M16A4_Mag = 1010021031;
  }
////////////////////////////////////////////////////////

  if (preferences.Config.Skin.M16A4 == 0) {
    new_Skin.M16A44 = 1010025;
    new_Skin.M16A4_Stock = 205007;
    new_Skin.M16A4_Mag = 291002;
  }
  if (preferences.Config.Skin.M16A4 == 1) {
    new_Skin.M16A44 = 1101002029;
    new_Skin.M16A4_Stock = 1010020292;
    new_Skin.M16A4_Mag = 1010020291;
  }
  if (preferences.Config.Skin.M16A4 == 2) {
    new_Skin.M16A44 = 1101002056;
    new_Skin.M16A4_Stock = 1010020562;
    new_Skin.M16A4_Mag = 1010020561;
  }
  if (preferences.Config.Skin.M16A4 == 3) {
    new_Skin.M16A44 = 1101002068;
    new_Skin.M16A4_Stock = 1010020682;
    new_Skin.M16A4_Mag = 1010020681;
  }
  if (preferences.Config.Skin.M16A4 == 4) {
    new_Skin.M16A44 = 1101002081;
    new_Skin.M16A4_Stock = 1010020812;
    new_Skin.M16A4_Mag = 1010020811;
  }
  if (preferences.Config.Skin.M16A4 == 5) {
    new_Skin.M16A44 = 1101002103;
    new_Skin.M16A4_Stock = 1010021032;
    new_Skin.M16A4_Mag = 1010021031;
  }
////////////////////////////////////////////////////////

  if (preferences.Config.Skin.M16A4 == 0) {
    new_Skin.M16A45 = 1010026;
    new_Skin.M16A4_Stock = 205007;
    new_Skin.M16A4_Mag = 291002;
  }
  if (preferences.Config.Skin.M16A4 == 1) {
    new_Skin.M16A45 = 1101002029;
    new_Skin.M16A4_Stock = 1010020292;
    new_Skin.M16A4_Mag = 1010020291;
  }
  if (preferences.Config.Skin.M16A4 == 2) {
    new_Skin.M16A45 = 1101002056;
    new_Skin.M16A4_Stock = 1010020562;
    new_Skin.M16A4_Mag = 1010020561;
  }
  if (preferences.Config.Skin.M16A4 == 3) {
    new_Skin.M16A45 = 1101002068;
    new_Skin.M16A4_Stock = 1010020682;
    new_Skin.M16A4_Mag = 1010020681;
  }
  if (preferences.Config.Skin.M16A4 == 4) {
    new_Skin.M16A45 = 1101002081;
    new_Skin.M16A4_Stock = 1010020812;
    new_Skin.M16A4_Mag = 1010020811;
  }
  if (preferences.Config.Skin.M16A4 == 5) {
    new_Skin.M16A45 = 1101002103;
    new_Skin.M16A4_Stock = 1010021032;
    new_Skin.M16A4_Mag = 1010021031;
  }
////////////////////////////////////////////////////////

  if (preferences.Config.Skin.M16A4 == 0) {
    new_Skin.M16A46 = 1010027;
    new_Skin.M16A4_Stock = 205007;
    new_Skin.M16A4_Mag = 291002;
  }
  if (preferences.Config.Skin.M16A4 == 1) {
    new_Skin.M16A46 = 1101002029;
    new_Skin.M16A4_Stock = 1010020292;
    new_Skin.M16A4_Mag = 1010020291;
  }
  if (preferences.Config.Skin.M16A4 == 2) {
    new_Skin.M16A46 = 1101002056;
    new_Skin.M16A4_Stock = 1010020562;
    new_Skin.M16A4_Mag = 1010020561;
  }
  if (preferences.Config.Skin.M16A4 == 3) {
    new_Skin.M16A46 = 1101002068;
    new_Skin.M16A4_Stock = 1010020682;
    new_Skin.M16A4_Mag = 1010020681;
  }
  if (preferences.Config.Skin.M16A4 == 4) {
    new_Skin.M16A46 = 1101002081;
    new_Skin.M16A4_Stock = 1010020812;
    new_Skin.M16A4_Mag = 1010020811;
  }
  if (preferences.Config.Skin.M16A4 == 5) {
    new_Skin.M16A46 = 1101002103;
    new_Skin.M16A4_Stock = 1010021032;
    new_Skin.M16A4_Mag = 1010021031;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.MK14 == 0) {
    new_Skin.MK145 = 1030075;
    new_Skin.longyin_x6666 = 203015;
    new_Skin.longyin_x8888 = 203005;
    new_Skin.longyin_x1111 = 203001;
    new_Skin.longyin_x2222 = 203003;
    new_Skin.longyin_x3333 = 203014;
    new_Skin.longyin_x4444 = 203004;
    new_Skin.tuosb = 205003;
    new_Skin.tuosb1 = 2050032;
    new_Skin.tuosb2 = 2050033;
    new_Skin.tuosb3 = 2050034;
    new_Skin.tuosb4 = 2050035;
  }
  if (preferences.Config.Skin.MK14 == 1) {
    new_Skin.MK145 = 1103007028;
    new_Skin.longyin_x1111 = 1030070218;
    new_Skin.longyin_x2222 = 1030070216;
    new_Skin.longyin_x3333 = 1030070215;
    new_Skin.longyin_x4444 = 1030070214;
    new_Skin.longyin_x6666 = 1030070213;
    new_Skin.longyin_x8888 = 1030070212;
    new_Skin.tuosb = 1030070236;
    new_Skin.tuosb1 = 1030070236;
    new_Skin.tuosb2 = 1030070236;
    new_Skin.tuosb3 = 1030070236;
    new_Skin.tuosb4 = 1030070236;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.MK14 == 0) {
    new_Skin.MK147 = 1030072;
    new_Skin.longyin_x6666 = 203015;
    new_Skin.longyin_x8888 = 203005;
    new_Skin.longyin_x1111 = 203001;
    new_Skin.longyin_x2222 = 203003;
    new_Skin.longyin_x3333 = 203014;
    new_Skin.longyin_x4444 = 203004;
    new_Skin.tuosb = 205003;
    new_Skin.tuosb1 = 2050032;
    new_Skin.tuosb2 = 2050033;
    new_Skin.tuosb3 = 2050034;
    new_Skin.tuosb4 = 2050035;
  }
  if (preferences.Config.Skin.MK14 == 1) {
    new_Skin.MK147 = 1103007028;
    new_Skin.longyin_x1111 = 1030070218;
    new_Skin.longyin_x2222 = 1030070216;
    new_Skin.longyin_x3333 = 1030070215;
    new_Skin.longyin_x4444 = 1030070214;
    new_Skin.longyin_x6666 = 1030070213;
    new_Skin.longyin_x8888 = 1030070212;
    new_Skin.tuosb = 1030070236;
    new_Skin.tuosb1 = 1030070236;
    new_Skin.tuosb2 = 1030070236;
    new_Skin.tuosb3 = 1030070236;
    new_Skin.tuosb4 = 1030070236;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.MK14 == 0) {
    new_Skin.MK148 = 1030073;
    new_Skin.longyin_x6666 = 203015;
    new_Skin.longyin_x8888 = 203005;
    new_Skin.longyin_x1111 = 203001;
    new_Skin.longyin_x2222 = 203003;
    new_Skin.longyin_x3333 = 203014;
    new_Skin.longyin_x4444 = 203004;
    new_Skin.tuosb = 205003;
    new_Skin.tuosb1 = 2050032;
    new_Skin.tuosb2 = 2050033;
    new_Skin.tuosb3 = 2050034;
    new_Skin.tuosb4 = 2050035;
  }
  if (preferences.Config.Skin.MK14 == 1) {
    new_Skin.MK148 = 1103007028;
    new_Skin.longyin_x1111 = 1030070218;
    new_Skin.longyin_x2222 = 1030070216;
    new_Skin.longyin_x3333 = 1030070215;
    new_Skin.longyin_x4444 = 1030070214;
    new_Skin.longyin_x6666 = 1030070213;
    new_Skin.longyin_x8888 = 1030070212;
    new_Skin.tuosb = 1030070236;
    new_Skin.tuosb1 = 1030070236;
    new_Skin.tuosb2 = 1030070236;
    new_Skin.tuosb3 = 1030070236;
    new_Skin.tuosb4 = 1030070236;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.MK14 == 0) {
    new_Skin.MK149 = 1030076;
    new_Skin.longyin_x6666 = 203015;
    new_Skin.longyin_x8888 = 203005;
    new_Skin.longyin_x1111 = 203001;
    new_Skin.longyin_x2222 = 203003;
    new_Skin.longyin_x3333 = 203014;
    new_Skin.longyin_x4444 = 203004;
    new_Skin.tuosb = 205003;
    new_Skin.tuosb1 = 2050032;
    new_Skin.tuosb2 = 2050033;
    new_Skin.tuosb3 = 2050034;
    new_Skin.tuosb4 = 2050035;
  }
  if (preferences.Config.Skin.MK14 == 1) {
    new_Skin.MK149 = 1103007028;
    new_Skin.longyin_x1111 = 1030070218;
    new_Skin.longyin_x2222 = 1030070216;
    new_Skin.longyin_x3333 = 1030070215;
    new_Skin.longyin_x4444 = 1030070214;
    new_Skin.longyin_x6666 = 1030070213;
    new_Skin.longyin_x8888 = 1030070212;
    new_Skin.tuosb = 1030070236;
    new_Skin.tuosb1 = 1030070236;
    new_Skin.tuosb2 = 1030070236;
    new_Skin.tuosb3 = 1030070236;
    new_Skin.tuosb4 = 1030070236;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.MK14 == 0) {
    new_Skin.MK140 = 1030077;
    new_Skin.longyin_x6666 = 203015;
    new_Skin.longyin_x8888 = 203005;
    new_Skin.longyin_x1111 = 203001;
    new_Skin.longyin_x2222 = 203003;
    new_Skin.longyin_x3333 = 203014;
    new_Skin.longyin_x4444 = 203004;
    new_Skin.tuosb = 205003;
    new_Skin.tuosb1 = 2050032;
    new_Skin.tuosb2 = 2050033;
    new_Skin.tuosb3 = 2050034;
    new_Skin.tuosb4 = 2050035;
  }
  if (preferences.Config.Skin.MK14 == 1) {
    new_Skin.MK140 = 1103007028;
    new_Skin.longyin_x1111 = 1030070218;
    new_Skin.longyin_x2222 = 1030070216;
    new_Skin.longyin_x3333 = 1030070215;
    new_Skin.longyin_x4444 = 1030070214;
    new_Skin.longyin_x6666 = 1030070213;
    new_Skin.longyin_x8888 = 1030070212;
    new_Skin.tuosb = 1030070236;
    new_Skin.tuosb1 = 1030070236;
    new_Skin.tuosb2 = 1030070236;
    new_Skin.tuosb3 = 1030070236;
    new_Skin.tuosb4 = 1030070236;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.MK14 == 0) {
    new_Skin.MK14 = 103007;
    new_Skin.longyin_x6666 = 203015;
    new_Skin.longyin_x8888 = 203005;
    new_Skin.longyin_x1111 = 203001;
    new_Skin.longyin_x2222 = 203003;
    new_Skin.longyin_x3333 = 203014;
    new_Skin.longyin_x4444 = 203004;
    new_Skin.tuosb = 205003;
    new_Skin.tuosb1 = 2050032;
    new_Skin.tuosb2 = 2050033;
    new_Skin.tuosb3 = 2050034;
    new_Skin.tuosb4 = 2050035;
  }
  if (preferences.Config.Skin.MK14 == 1) {
    new_Skin.MK14 = 1103007028;
    new_Skin.longyin_x1111 = 1030070218;
    new_Skin.longyin_x2222 = 1030070216;
    new_Skin.longyin_x3333 = 1030070215;
    new_Skin.longyin_x4444 = 1030070214;
    new_Skin.longyin_x6666 = 1030070213;
    new_Skin.longyin_x8888 = 1030070212;
    new_Skin.tuosb = 1030070236;
    new_Skin.tuosb1 = 1030070236;
    new_Skin.tuosb2 = 1030070236;
    new_Skin.tuosb3 = 1030070236;
    new_Skin.tuosb4 = 1030070236;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.MK14 == 0) {
    new_Skin.MK146 = 1030074;
    new_Skin.longyin_x6666 = 203015;
    new_Skin.longyin_x8888 = 203005;
    new_Skin.longyin_x1111 = 203001;
    new_Skin.longyin_x2222 = 203008;
    new_Skin.longyin_x3333 = 203014;
    new_Skin.longyin_x4444 = 203004;
    new_Skin.tuosb = 205003;
    new_Skin.tuosb1 = 2050032;
    new_Skin.tuosb2 = 2050033;
    new_Skin.tuosb3 = 2050034;
    new_Skin.tuosb4 = 2050035;
  }
  if (preferences.Config.Skin.MK14 == 1) {
    new_Skin.MK146 = 1103007028;
    new_Skin.longyin_x1111 = 1030070218;
    new_Skin.longyin_x2222 = 1030070216;
    new_Skin.longyin_x3333 = 1030070215;
    new_Skin.longyin_x4444 = 1030070214;
    new_Skin.longyin_x6666 = 1030070213;
    new_Skin.longyin_x8888 = 1030070212;
    new_Skin.tuosb = 1030070236;
    new_Skin.tuosb1 = 1030070236;
    new_Skin.tuosb2 = 1030070236;
    new_Skin.tuosb3 = 1030070236;
    new_Skin.tuosb4 = 1030070236;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.MG3 == 0){
    new_Skin.MG3 = 105010;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    if (preferences.Config.Skin.MG3 == 1){
    new_Skin.MG3 = 1105010019;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    if (preferences.Config.Skin.MG3 == 2){
    new_Skin.MG3 = 1105010008;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.MG3 == 0) {
    new_Skin.mg31 = 1050105;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    if (preferences.Config.Skin.MG3 == 1){
    new_Skin.mg31 = 1105010019;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    if (preferences.Config.Skin.MG3 == 2){
    new_Skin.mg31 = 1105010008;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.MG3 == 0) {
    new_Skin.mg32 = 1050106;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    if (preferences.Config.Skin.MG3 == 1){
    new_Skin.mg32 = 1105010019;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    if (preferences.Config.Skin.MG3 == 2){
    new_Skin.mg32 = 1105010008;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.MG3 == 0) {
    new_Skin.mg33 = 1050107;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    if (preferences.Config.Skin.MG3 == 1){
    new_Skin.mg33 = 1105010019;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    if (preferences.Config.Skin.MG3 == 2){
    new_Skin.mg33 = 1105010008;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.MG3 == 0) {
    new_Skin.mg34 = 1050102;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    if (preferences.Config.Skin.MG3 == 1){
    new_Skin.mg34 = 1105010019;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    if (preferences.Config.Skin.MG3 == 2){
    new_Skin.mg34 = 1105010008;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.MG3 == 0) {
    new_Skin.mg35 = 1050103;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    if (preferences.Config.Skin.MG3 == 1){
    new_Skin.mg35 = 1105010019;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    if (preferences.Config.Skin.MG3 == 2){
    new_Skin.mg35 = 1105010008;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.MG3 == 0) {
    new_Skin.mg36 = 1050104;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    if (preferences.Config.Skin.MG3 == 1){
    new_Skin.mg36 = 1105010019;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
    if (preferences.Config.Skin.MG3 == 2){
    new_Skin.mg36 = 1105010008;
    new_Skin.MG3_reddot = 203001;
    new_Skin.MG3_holo = 203002;
    new_Skin.MG3_x2 = 203003;
    new_Skin.MG3_x3 = 203014;
    new_Skin.MG3_x4 = 203004;
    new_Skin.MG3_x6 = 203015;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (new_Skin.P90 == 0)
    new_Skin.P90 = 102105;
  if (preferences.Config.Skin.P90 == 1)
    new_Skin.P90 = 1102105012;
   if (preferences.Config.Skin.P90 == 2)
    new_Skin.P90 = 1102105018;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (new_Skin.P90 == 0)
    new_Skin.P901 = 1021052;
  if (preferences.Config.Skin.P90 == 1)
    new_Skin.P901 = 1102105012;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (new_Skin.P90 == 0)
    new_Skin.P902 = 1021053;
  if (preferences.Config.Skin.P90 == 1)
    new_Skin.P902 = 1102105012;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (new_Skin.P90 == 0)
    new_Skin.P903 = 1021054;
  if (preferences.Config.Skin.P90 == 1)
    new_Skin.P903 = 1102105012;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (new_Skin.P90 == 0)
    new_Skin.P904 = 1021055;
  if (preferences.Config.Skin.P90 == 1)
    new_Skin.P904 = 1102105012;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (new_Skin.P90 == 0)
    new_Skin.P905 = 1021056;
  if (preferences.Config.Skin.P90 == 1)
    new_Skin.P905 = 1102105012;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (new_Skin.P90 == 0)
    new_Skin.P906 = 1021057;
  if (preferences.Config.Skin.P90 == 1)
    new_Skin.P906 = 1102105012;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if (preferences.Config.Skin.Scar == 0) {
    new_Skin.Scar = 101003;
    new_Skin.Scar_Mag = 291003;
    new_Skin.Scar_3 = 203007;
    new_Skin.Scar_flash = 201010;
    new_Skin.Scar_compe = 201009;
    new_Skin.Scar_silent = 201011;
    new_Skin.Scar_reddot = 203001;
    new_Skin.Scar_holo = 203002;
    new_Skin.Scar_x2 = 203003;
    new_Skin.Scar_x3 = 203014;
    new_Skin.Scar_x4 = 203004;
    new_Skin.Scar_x6 = 203015;
    new_Skin.Scar_quickMag = 204012;
    new_Skin.Scar_extendedMag = 204011;
    new_Skin.Scar_quickNextended = 204013;
    new_Skin.Scar_verical = 202002;
    new_Skin.Scar_angle = 202001;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_pink = 202005;
    new_Skin.Scar_lazer = 202007;
    new_Skin.Scar_thumb = 202006;
    }
if (preferences.Config.Skin.Scar == 1) {

    new_Skin.Scar = 1101003219; // Skin chính – Kính Pha Lê (Cấp 7)

    // -------- Ống ngắm --------
    new_Skin.Scar_reddot = 1010031136;
    new_Skin.Scar_holo   = 1010031135;
    new_Skin.Scar_x2     = 1010031134;
    new_Skin.Scar_x3     = 1010031133;
    new_Skin.Scar_x4     = 1010031132;
    new_Skin.Scar_x6     = 1010031618;   // 6x (nằm ở cấp 3)

    // -------- Băng đạn --------
    new_Skin.Scar_Mag            = 1010031131; // Default Mag (Cấp 1)
    new_Skin.Scar_extendedMag    = 1010031137; // Extended
    new_Skin.Scar_quickMag       = 1010031138; // Quick
    new_Skin.Scar_quickNextended = 1010031146; // Quick-Extended

    // -------- Nòng súng --------
    new_Skin.Scar_flash  = 1010031139; // Flash Hider
    new_Skin.Scar_compe  = 1010031140; // Compensator
    new_Skin.Scar_silent = 1010031142; // Silencer

    // -------- Tay cầm --------
    new_Skin.Scar_angle      = 1010031143; // Tay cầm tam giác
    new_Skin.Scar_verical    = 1010031144; // Tay cầm đứng
    new_Skin.Scar_thumb      = 1010031145; // Ngón cái
    new_Skin.Scar_lightgrip  = 1010031620; // Tay cầm nhẹ
    new_Skin.Scar_pink       = 1010031622; // Tay cầm dạng nửa

    // -------- Khác --------
    new_Skin.Scar_lazer = 1010031619; // Laser
    new_Skin.Scar_3     = 0;          // SCAR không có phụ kiện slot 3 riêng
}

    if (preferences.Config.Skin.Scar == 2) {
    new_Skin.Scar = 1101003208;
    new_Skin.Scar_Mag = 1010032021;
    new_Skin.Scar_quickMag = 1010032029;
    new_Skin.Scar_extendedMag = 1010032028;
    new_Skin.Scar_quickNextended = 1010032032;
    new_Skin.Scar_compe = 1010032033;
    new_Skin.Scar_silent = 1010032045;
    new_Skin.Scar_flash = 1010032034;
    new_Skin.Scar_reddot = 1010032027;
    new_Skin.Scar_holo = 1010032026;
    new_Skin.Scar_x2 = 1010032025;
    new_Skin.Scar_x3 = 1010032024;
    new_Skin.Scar_x4 = 1010032023;
    new_Skin.Scar_x6 = 1010032022;
    new_Skin.Scar_lazer = 1010032039;
    new_Skin.Scar_verical = 1010032038;
    new_Skin.Scar_angle = 1010032036;
    new_Skin.Scar_thumb = 1010032037;
    new_Skin.Scar_lightgrip = 1010032042;
    new_Skin.Scar_pink = 1010032043;
    }


    if (preferences.Config.Skin.Scar == 3) {
    new_Skin.Scar = 1101003181;
    new_Skin.Scar_Mag = 1010031811;
    new_Skin.Scar_flash = 1010031765;
    new_Skin.Scar_compe = 1010031764;
    new_Skin.Scar_silent = 1010031766;
    new_Skin.Scar_reddot = 1010031757;
    new_Skin.Scar_holo = 1010031756;
    new_Skin.Scar_x2 = 1010031755;
    new_Skin.Scar_x3 = 1010031754;
    new_Skin.Scar_x4 = 1010031753;
    new_Skin.Scar_x6 = 1010031752;
    new_Skin.Scar_quickMag = 1010031758;
    new_Skin.Scar_extendedMag = 1010031759;
    new_Skin.Scar_quickNextended = 1010031763;
    new_Skin.Scar_verical = 1010031769;
    new_Skin.Scar_angle = 1010031767;
    new_Skin.Scar_lightgrip = 1010031773;
    new_Skin.Scar_pink = 1010031774;
    new_Skin.Scar_lazer = 1010031772;
    new_Skin.Scar_thumb = 1010031768;
    }
    if (preferences.Config.Skin.Scar == 4) {
    new_Skin.Scar = 1101003167;
    new_Skin.Scar_Mag = 1010031671;
    new_Skin.Scar_3 = 1010031672;
    new_Skin.Scar_flash = 1010031609;
    new_Skin.Scar_compe = 1010031610;
    new_Skin.Scar_silent = 1010031613;
    new_Skin.Scar_reddot = 1010031606;
    new_Skin.Scar_holo = 1010031605;
    new_Skin.Scar_x2 = 1010031604;
    new_Skin.Scar_x3 = 1010031603;
    new_Skin.Scar_x4 = 1010031602;
    new_Skin.Scar_quickMag = 1010031607;
    new_Skin.Scar_extendedMag = 1010031608;
    new_Skin.Scar_quickNextended = 1010031617;
    new_Skin.Scar_verical = 1010031615;
    new_Skin.Scar_angle = 1010031614;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_thumb = 1010031616;
    }
    if (preferences.Config.Skin.Scar == 5) {
    new_Skin.Scar = 1101003119;
    new_Skin.Scar_Mag = 1010031191;
    new_Skin.Scar_3 = 1010031192;
    new_Skin.Scar_flash = 1010031139;
    new_Skin.Scar_compe = 1010031140;
    new_Skin.Scar_silent = 1010031142;
    new_Skin.Scar_reddot = 1010031136;
    new_Skin.Scar_holo = 1010031135;
    new_Skin.Scar_x2 = 1010031134;
    new_Skin.Scar_x3 = 1010031133;
    new_Skin.Scar_x4 = 1010031132;
    new_Skin.Scar_quickMag = 1010031137;
    new_Skin.Scar_extendedMag = 1010031138;
    new_Skin.Scar_quickNextended = 1010031146;
    new_Skin.Scar_verical = 1010031144;
    new_Skin.Scar_angle = 1010031143;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_thumb = 1010031145;
    }


  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.Scar == 0) {
    new_Skin.Scar1 = 1010032;
    new_Skin.Scar_Mag = 291003;
    new_Skin.Scar_3 = 203007;
    new_Skin.Scar_flash = 201010;
    new_Skin.Scar_compe = 201009;
    new_Skin.Scar_silent = 201011;
    new_Skin.Scar_reddot = 203001;
    new_Skin.Scar_holo = 203002;
    new_Skin.Scar_x2 = 203003;
    new_Skin.Scar_x3 = 203014;
    new_Skin.Scar_x4 = 203004;
    new_Skin.Scar_x6 = 203015;
    new_Skin.Scar_quickMag = 204012;
    new_Skin.Scar_extendedMag = 204011;
    new_Skin.Scar_quickNextended = 204013;
    new_Skin.Scar_verical = 202002;
    new_Skin.Scar_angle = 202001;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_pink = 202005;
    new_Skin.Scar_lazer = 202007;
    new_Skin.Scar_thumb = 202006;
    }
    if (preferences.Config.Skin.Scar == 1) {

        new_Skin.Scar1 = 1101003219; // Skin chính – Kính Pha Lê (Cấp 7)

        // -------- Ống ngắm --------
        new_Skin.Scar_reddot = 1010031136;
        new_Skin.Scar_holo   = 1010031135;
        new_Skin.Scar_x2     = 1010031134;
        new_Skin.Scar_x3     = 1010031133;
        new_Skin.Scar_x4     = 1010031132;
        new_Skin.Scar_x6     = 1010031618;   // 6x (nằm ở cấp 3)

        // -------- Băng đạn --------
        new_Skin.Scar_Mag            = 1010031131; // Default Mag (Cấp 1)
        new_Skin.Scar_extendedMag    = 1010031137; // Extended
        new_Skin.Scar_quickMag       = 1010031138; // Quick
        new_Skin.Scar_quickNextended = 1010031146; // Quick-Extended

        // -------- Nòng súng --------
        new_Skin.Scar_flash  = 1010031139; // Flash Hider
        new_Skin.Scar_compe  = 1010031140; // Compensator
        new_Skin.Scar_silent = 1010031142; // Silencer

        // -------- Tay cầm --------
        new_Skin.Scar_angle      = 1010031143; // Tay cầm tam giác
        new_Skin.Scar_verical    = 1010031144; // Tay cầm đứng
        new_Skin.Scar_thumb      = 1010031145; // Ngón cái
        new_Skin.Scar_lightgrip  = 1010031620; // Tay cầm nhẹ
        new_Skin.Scar_pink       = 1010031622; // Tay cầm dạng nửa

        // -------- Khác --------
        new_Skin.Scar_lazer = 1010031619; // Laser
        new_Skin.Scar_3     = 0;          // SCAR không có phụ kiện slot 3 riêng
    }
    if (preferences.Config.Skin.Scar == 2) {
    new_Skin.Scar1 = 1101003208;
    new_Skin.Scar_Mag = 1010032021;
    new_Skin.Scar_quickMag = 1010032029;
    new_Skin.Scar_extendedMag = 1010032028;
    new_Skin.Scar_quickNextended = 1010032032;
    new_Skin.Scar_compe = 1010032033;
    new_Skin.Scar_silent = 1010032045;
    new_Skin.Scar_flash = 1010032034;
    new_Skin.Scar_reddot = 1010032027;
    new_Skin.Scar_holo = 1010032026;
    new_Skin.Scar_x2 = 1010032025;
    new_Skin.Scar_x3 = 1010032024;
    new_Skin.Scar_x4 = 1010032023;
    new_Skin.Scar_x6 = 1010032022;
    new_Skin.Scar_lazer = 1010032039;
    new_Skin.Scar_verical = 1010032038;
    new_Skin.Scar_angle = 1010032036;
    new_Skin.Scar_thumb = 1010032037;
    new_Skin.Scar_lightgrip = 1010032042;
    new_Skin.Scar_pink = 1010032043;
    }


    if (preferences.Config.Skin.Scar == 3) {
    new_Skin.Scar1 = 1101003181;
    new_Skin.Scar_Mag = 1010031811;
    new_Skin.Scar_flash = 1010031765;
    new_Skin.Scar_compe = 1010031764;
    new_Skin.Scar_silent = 1010031766;
    new_Skin.Scar_reddot = 1010031757;
    new_Skin.Scar_holo = 1010031756;
    new_Skin.Scar_x2 = 1010031755;
    new_Skin.Scar_x3 = 1010031754;
    new_Skin.Scar_x4 = 1010031753;
    new_Skin.Scar_x6 = 1010031752;
    new_Skin.Scar_quickMag = 1010031758;
    new_Skin.Scar_extendedMag = 1010031759;
    new_Skin.Scar_quickNextended = 1010031763;
    new_Skin.Scar_verical = 1010031769;
    new_Skin.Scar_angle = 1010031767;
    new_Skin.Scar_lightgrip = 1010031773;
    new_Skin.Scar_pink = 1010031774;
    new_Skin.Scar_lazer = 1010031772;
    new_Skin.Scar_thumb = 1010031768;
    }
    if (preferences.Config.Skin.Scar == 4) {
    new_Skin.Scar1 = 1101003167;
    new_Skin.Scar_Mag = 1010031671;
    new_Skin.Scar_3 = 1010031672;
    new_Skin.Scar_flash = 1010031609;
    new_Skin.Scar_compe = 1010031610;
    new_Skin.Scar_silent = 1010031613;
    new_Skin.Scar_reddot = 1010031606;
    new_Skin.Scar_holo = 1010031605;
    new_Skin.Scar_x2 = 1010031604;
    new_Skin.Scar_x3 = 1010031603;
    new_Skin.Scar_x4 = 1010031602;
    new_Skin.Scar_quickMag = 1010031607;
    new_Skin.Scar_extendedMag = 1010031608;
    new_Skin.Scar_quickNextended = 1010031617;
    new_Skin.Scar_verical = 1010031615;
    new_Skin.Scar_angle = 1010031614;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_thumb = 1010031616;
    }
    if (preferences.Config.Skin.Scar == 5) {
    new_Skin.Scar1 = 1101003119;
    new_Skin.Scar_Mag = 1010031191;
    new_Skin.Scar_3 = 1010031192;
    new_Skin.Scar_flash = 1010031139;
    new_Skin.Scar_compe = 1010031140;
    new_Skin.Scar_silent = 1010031142;
    new_Skin.Scar_reddot = 1010031136;
    new_Skin.Scar_holo = 1010031135;
    new_Skin.Scar_x2 = 1010031134;
    new_Skin.Scar_x3 = 1010031133;
    new_Skin.Scar_x4 = 1010031132;
    new_Skin.Scar_quickMag = 1010031137;
    new_Skin.Scar_extendedMag = 1010031138;
    new_Skin.Scar_quickNextended = 1010031146;
    new_Skin.Scar_verical = 1010031144;
    new_Skin.Scar_angle = 1010031143;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_thumb = 1010031145;
    }


  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.Scar == 0) {
    new_Skin.Scar2 = 1010033;
    new_Skin.Scar_Mag = 291003;
    new_Skin.Scar_3 = 203007;
    new_Skin.Scar_flash = 201010;
    new_Skin.Scar_compe = 201009;
    new_Skin.Scar_silent = 201011;
    new_Skin.Scar_reddot = 203001;
    new_Skin.Scar_holo = 203002;
    new_Skin.Scar_x2 = 203003;
    new_Skin.Scar_x3 = 203014;
    new_Skin.Scar_x4 = 203004;
    new_Skin.Scar_x6 = 203015;
    new_Skin.Scar_quickMag = 204012;
    new_Skin.Scar_extendedMag = 204011;
    new_Skin.Scar_quickNextended = 204013;
    new_Skin.Scar_verical = 202002;
    new_Skin.Scar_angle = 202001;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_pink = 202005;
    new_Skin.Scar_lazer = 202007;
    new_Skin.Scar_thumb = 202006;
    }
    if (preferences.Config.Skin.Scar == 1) {

        new_Skin.Scar2 = 1101003219; // Skin chính – Kính Pha Lê (Cấp 7)

        // -------- Ống ngắm --------
        new_Skin.Scar_reddot = 1010031136;
        new_Skin.Scar_holo   = 1010031135;
        new_Skin.Scar_x2     = 1010031134;
        new_Skin.Scar_x3     = 1010031133;
        new_Skin.Scar_x4     = 1010031132;
        new_Skin.Scar_x6     = 1010031618;   // 6x (nằm ở cấp 3)

        // -------- Băng đạn --------
        new_Skin.Scar_Mag            = 1010031131; // Default Mag (Cấp 1)
        new_Skin.Scar_extendedMag    = 1010031137; // Extended
        new_Skin.Scar_quickMag       = 1010031138; // Quick
        new_Skin.Scar_quickNextended = 1010031146; // Quick-Extended

        // -------- Nòng súng --------
        new_Skin.Scar_flash  = 1010031139; // Flash Hider
        new_Skin.Scar_compe  = 1010031140; // Compensator
        new_Skin.Scar_silent = 1010031142; // Silencer

        // -------- Tay cầm --------
        new_Skin.Scar_angle      = 1010031143; // Tay cầm tam giác
        new_Skin.Scar_verical    = 1010031144; // Tay cầm đứng
        new_Skin.Scar_thumb      = 1010031145; // Ngón cái
        new_Skin.Scar_lightgrip  = 1010031620; // Tay cầm nhẹ
        new_Skin.Scar_pink       = 1010031622; // Tay cầm dạng nửa

        // -------- Khác --------
        new_Skin.Scar_lazer = 1010031619; // Laser
        new_Skin.Scar_3     = 0;          // SCAR không có phụ kiện slot 3 riêng
    }
    if (preferences.Config.Skin.Scar == 2) {
    new_Skin.Scar2 = 1101003208;
    new_Skin.Scar_Mag = 1010032021;
    new_Skin.Scar_quickMag = 1010032029;
    new_Skin.Scar_extendedMag = 1010032028;
    new_Skin.Scar_quickNextended = 1010032032;
    new_Skin.Scar_compe = 1010032033;
    new_Skin.Scar_silent = 1010032045;
    new_Skin.Scar_flash = 1010032034;
    new_Skin.Scar_reddot = 1010032027;
    new_Skin.Scar_holo = 1010032026;
    new_Skin.Scar_x2 = 1010032025;
    new_Skin.Scar_x3 = 1010032024;
    new_Skin.Scar_x4 = 1010032023;
    new_Skin.Scar_x6 = 1010032022;
    new_Skin.Scar_lazer = 1010032039;
    new_Skin.Scar_verical = 1010032038;
    new_Skin.Scar_angle = 1010032036;
    new_Skin.Scar_thumb = 1010032037;
    new_Skin.Scar_lightgrip = 1010032042;
    new_Skin.Scar_pink = 1010032043;
    }
    if (preferences.Config.Skin.Scar == 3) {
    new_Skin.Scar2 = 1101003181;
    new_Skin.Scar_Mag = 1010031811;
    new_Skin.Scar_flash = 1010031765;
    new_Skin.Scar_compe = 1010031764;
    new_Skin.Scar_silent = 1010031766;
    new_Skin.Scar_reddot = 1010031757;
    new_Skin.Scar_holo = 1010031756;
    new_Skin.Scar_x2 = 1010031755;
    new_Skin.Scar_x3 = 1010031754;
    new_Skin.Scar_x4 = 1010031753;
    new_Skin.Scar_x6 = 1010031752;
    new_Skin.Scar_quickMag = 1010031758;
    new_Skin.Scar_extendedMag = 1010031759;
    new_Skin.Scar_quickNextended = 1010031763;
    new_Skin.Scar_verical = 1010031769;
    new_Skin.Scar_angle = 1010031767;
    new_Skin.Scar_lightgrip = 1010031773;
    new_Skin.Scar_pink = 1010031774;
    new_Skin.Scar_lazer = 1010031772;
    new_Skin.Scar_thumb = 1010031768;
    }
    if (preferences.Config.Skin.Scar == 4) {
    new_Skin.Scar2 = 1101003167;
    new_Skin.Scar_Mag = 1010031671;
    new_Skin.Scar_3 = 1010031672;
    new_Skin.Scar_flash = 1010031609;
    new_Skin.Scar_compe = 1010031610;
    new_Skin.Scar_silent = 1010031613;
    new_Skin.Scar_reddot = 1010031606;
    new_Skin.Scar_holo = 1010031605;
    new_Skin.Scar_x2 = 1010031604;
    new_Skin.Scar_x3 = 1010031603;
    new_Skin.Scar_x4 = 1010031602;
    new_Skin.Scar_quickMag = 1010031607;
    new_Skin.Scar_extendedMag = 1010031608;
    new_Skin.Scar_quickNextended = 1010031617;
    new_Skin.Scar_verical = 1010031615;
    new_Skin.Scar_angle = 1010031614;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_thumb = 1010031616;
    }
    if (preferences.Config.Skin.Scar == 5) {
    new_Skin.Scar2 = 1101003119;
    new_Skin.Scar_Mag = 1010031191;
    new_Skin.Scar_3 = 1010031192;
    new_Skin.Scar_flash = 1010031139;
    new_Skin.Scar_compe = 1010031140;
    new_Skin.Scar_silent = 1010031142;
    new_Skin.Scar_reddot = 1010031136;
    new_Skin.Scar_holo = 1010031135;
    new_Skin.Scar_x2 = 1010031134;
    new_Skin.Scar_x3 = 1010031133;
    new_Skin.Scar_x4 = 1010031132;
    new_Skin.Scar_quickMag = 1010031137;
    new_Skin.Scar_extendedMag = 1010031138;
    new_Skin.Scar_quickNextended = 1010031146;
    new_Skin.Scar_verical = 1010031144;
    new_Skin.Scar_angle = 1010031143;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_thumb = 1010031145;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.Scar == 0) {
    new_Skin.Scar3 = 1010034;
    new_Skin.Scar_Mag = 291003;
    new_Skin.Scar_3 = 203007;
    new_Skin.Scar_flash = 201010;
    new_Skin.Scar_compe = 201009;
    new_Skin.Scar_silent = 201011;
    new_Skin.Scar_reddot = 203001;
    new_Skin.Scar_holo = 203002;
    new_Skin.Scar_x2 = 203003;
    new_Skin.Scar_x3 = 203014;
    new_Skin.Scar_x4 = 203004;
    new_Skin.Scar_x6 = 203015;
    new_Skin.Scar_quickMag = 204012;
    new_Skin.Scar_extendedMag = 204011;
    new_Skin.Scar_quickNextended = 204013;
    new_Skin.Scar_verical = 202002;
    new_Skin.Scar_angle = 202001;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_pink = 202005;
    new_Skin.Scar_lazer = 202007;
    new_Skin.Scar_thumb = 202006;
    }
    if (preferences.Config.Skin.Scar == 1) {

        new_Skin.Scar3 = 1101003219; // Skin chính – Kính Pha Lê (Cấp 7)

        // -------- Ống ngắm --------
        new_Skin.Scar_reddot = 1010031136;
        new_Skin.Scar_holo   = 1010031135;
        new_Skin.Scar_x2     = 1010031134;
        new_Skin.Scar_x3     = 1010031133;
        new_Skin.Scar_x4     = 1010031132;
        new_Skin.Scar_x6     = 1010031618;   // 6x (nằm ở cấp 3)

        // -------- Băng đạn --------
        new_Skin.Scar_Mag            = 1010031131; // Default Mag (Cấp 1)
        new_Skin.Scar_extendedMag    = 1010031137; // Extended
        new_Skin.Scar_quickMag       = 1010031138; // Quick
        new_Skin.Scar_quickNextended = 1010031146; // Quick-Extended

        // -------- Nòng súng --------
        new_Skin.Scar_flash  = 1010031139; // Flash Hider
        new_Skin.Scar_compe  = 1010031140; // Compensator
        new_Skin.Scar_silent = 1010031142; // Silencer

        // -------- Tay cầm --------
        new_Skin.Scar_angle      = 1010031143; // Tay cầm tam giác
        new_Skin.Scar_verical    = 1010031144; // Tay cầm đứng
        new_Skin.Scar_thumb      = 1010031145; // Ngón cái
        new_Skin.Scar_lightgrip  = 1010031620; // Tay cầm nhẹ
        new_Skin.Scar_pink       = 1010031622; // Tay cầm dạng nửa

        // -------- Khác --------
        new_Skin.Scar_lazer = 1010031619; // Laser
        new_Skin.Scar_3     = 0;          // SCAR không có phụ kiện slot 3 riêng
    }
    if (preferences.Config.Skin.Scar == 2) {
    new_Skin.Scar3 = 1101003208;
    new_Skin.Scar_Mag = 1010032021;
    new_Skin.Scar_quickMag = 1010032029;
    new_Skin.Scar_extendedMag = 1010032028;
    new_Skin.Scar_quickNextended = 1010032032;
    new_Skin.Scar_compe = 1010032033;
    new_Skin.Scar_silent = 1010032045;
    new_Skin.Scar_flash = 1010032034;
    new_Skin.Scar_reddot = 1010032027;
    new_Skin.Scar_holo = 1010032026;
    new_Skin.Scar_x2 = 1010032025;
    new_Skin.Scar_x3 = 1010032024;
    new_Skin.Scar_x4 = 1010032023;
    new_Skin.Scar_x6 = 1010032022;
    new_Skin.Scar_lazer = 1010032039;
    new_Skin.Scar_verical = 1010032038;
    new_Skin.Scar_angle = 1010032036;
    new_Skin.Scar_thumb = 1010032037;
    new_Skin.Scar_lightgrip = 1010032042;
    new_Skin.Scar_pink = 1010032043;
    }


    if (preferences.Config.Skin.Scar == 3) {
    new_Skin.Scar3 = 1101003181;
    new_Skin.Scar_Mag = 1010031811;
    new_Skin.Scar_flash = 1010031765;
    new_Skin.Scar_compe = 1010031764;
    new_Skin.Scar_silent = 1010031766;
    new_Skin.Scar_reddot = 1010031757;
    new_Skin.Scar_holo = 1010031756;
    new_Skin.Scar_x2 = 1010031755;
    new_Skin.Scar_x3 = 1010031754;
    new_Skin.Scar_x4 = 1010031753;
    new_Skin.Scar_x6 = 1010031752;
    new_Skin.Scar_quickMag = 1010031758;
    new_Skin.Scar_extendedMag = 1010031759;
    new_Skin.Scar_quickNextended = 1010031763;
    new_Skin.Scar_verical = 1010031769;
    new_Skin.Scar_angle = 1010031767;
    new_Skin.Scar_lightgrip = 1010031773;
    new_Skin.Scar_pink = 1010031774;
    new_Skin.Scar_lazer = 1010031772;
    new_Skin.Scar_thumb = 1010031768;
    }
    if (preferences.Config.Skin.Scar == 4) {
    new_Skin.Scar3 = 1101003167;
    new_Skin.Scar_Mag = 1010031671;
    new_Skin.Scar_3 = 1010031672;
    new_Skin.Scar_flash = 1010031609;
    new_Skin.Scar_compe = 1010031610;
    new_Skin.Scar_silent = 1010031613;
    new_Skin.Scar_reddot = 1010031606;
    new_Skin.Scar_holo = 1010031605;
    new_Skin.Scar_x2 = 1010031604;
    new_Skin.Scar_x3 = 1010031603;
    new_Skin.Scar_x4 = 1010031602;
    new_Skin.Scar_quickMag = 1010031607;
    new_Skin.Scar_extendedMag = 1010031608;
    new_Skin.Scar_quickNextended = 1010031617;
    new_Skin.Scar_verical = 1010031615;
    new_Skin.Scar_angle = 1010031614;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_thumb = 1010031616;
    }
    if (preferences.Config.Skin.Scar == 5) {
    new_Skin.Scar3 = 1101003119;
    new_Skin.Scar_Mag = 1010031191;
    new_Skin.Scar_3 = 1010031192;
    new_Skin.Scar_flash = 1010031139;
    new_Skin.Scar_compe = 1010031140;
    new_Skin.Scar_silent = 1010031142;
    new_Skin.Scar_reddot = 1010031136;
    new_Skin.Scar_holo = 1010031135;
    new_Skin.Scar_x2 = 1010031134;
    new_Skin.Scar_x3 = 1010031133;
    new_Skin.Scar_x4 = 1010031132;
    new_Skin.Scar_quickMag = 1010031137;
    new_Skin.Scar_extendedMag = 1010031138;
    new_Skin.Scar_quickNextended = 1010031146;
    new_Skin.Scar_verical = 1010031144;
    new_Skin.Scar_angle = 1010031143;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_thumb = 1010031145;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.Scar == 0) {
    new_Skin.Scar4 = 1010035;
    new_Skin.Scar_Mag = 291003;
    new_Skin.Scar_3 = 203007;
    new_Skin.Scar_flash = 201010;
    new_Skin.Scar_compe = 201009;
    new_Skin.Scar_silent = 201011;
    new_Skin.Scar_reddot = 203001;
    new_Skin.Scar_holo = 203002;
    new_Skin.Scar_x2 = 203003;
    new_Skin.Scar_x3 = 203014;
    new_Skin.Scar_x4 = 203004;
    new_Skin.Scar_x6 = 203015;
    new_Skin.Scar_quickMag = 204012;
    new_Skin.Scar_extendedMag = 204011;
    new_Skin.Scar_quickNextended = 204013;
    new_Skin.Scar_verical = 202002;
    new_Skin.Scar_angle = 202001;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_pink = 202005;
    new_Skin.Scar_lazer = 202007;
    new_Skin.Scar_thumb = 202006;
    }
    if (preferences.Config.Skin.Scar == 1) {

        new_Skin.Scar4 = 1101003219; // Skin chính – Kính Pha Lê (Cấp 7)

        // -------- Ống ngắm --------
        new_Skin.Scar_reddot = 1010031136;
        new_Skin.Scar_holo   = 1010031135;
        new_Skin.Scar_x2     = 1010031134;
        new_Skin.Scar_x3     = 1010031133;
        new_Skin.Scar_x4     = 1010031132;
        new_Skin.Scar_x6     = 1010031618;   // 6x (nằm ở cấp 3)

        // -------- Băng đạn --------
        new_Skin.Scar_Mag            = 1010031131; // Default Mag (Cấp 1)
        new_Skin.Scar_extendedMag    = 1010031137; // Extended
        new_Skin.Scar_quickMag       = 1010031138; // Quick
        new_Skin.Scar_quickNextended = 1010031146; // Quick-Extended

        // -------- Nòng súng --------
        new_Skin.Scar_flash  = 1010031139; // Flash Hider
        new_Skin.Scar_compe  = 1010031140; // Compensator
        new_Skin.Scar_silent = 1010031142; // Silencer

        // -------- Tay cầm --------
        new_Skin.Scar_angle      = 1010031143; // Tay cầm tam giác
        new_Skin.Scar_verical    = 1010031144; // Tay cầm đứng
        new_Skin.Scar_thumb      = 1010031145; // Ngón cái
        new_Skin.Scar_lightgrip  = 1010031620; // Tay cầm nhẹ
        new_Skin.Scar_pink       = 1010031622; // Tay cầm dạng nửa

        // -------- Khác --------
        new_Skin.Scar_lazer = 1010031619; // Laser
        new_Skin.Scar_3     = 0;          // SCAR không có phụ kiện slot 3 riêng
    }
    if (preferences.Config.Skin.Scar == 2) {
    new_Skin.Scar4 = 1101003208;
    new_Skin.Scar_Mag = 1010032021;
    new_Skin.Scar_quickMag = 1010032029;
    new_Skin.Scar_extendedMag = 1010032028;
    new_Skin.Scar_quickNextended = 1010032032;
    new_Skin.Scar_compe = 1010032033;
    new_Skin.Scar_silent = 1010032045;
    new_Skin.Scar_flash = 1010032034;
    new_Skin.Scar_reddot = 1010032027;
    new_Skin.Scar_holo = 1010032026;
    new_Skin.Scar_x2 = 1010032025;
    new_Skin.Scar_x3 = 1010032024;
    new_Skin.Scar_x4 = 1010032023;
    new_Skin.Scar_x6 = 1010032022;
    new_Skin.Scar_lazer = 1010032039;
    new_Skin.Scar_verical = 1010032038;
    new_Skin.Scar_angle = 1010032036;
    new_Skin.Scar_thumb = 1010032037;
    new_Skin.Scar_lightgrip = 1010032042;
    new_Skin.Scar_pink = 1010032043;
    }
    if (preferences.Config.Skin.Scar == 3) {
    new_Skin.Scar4 = 1101003181;
    new_Skin.Scar_Mag = 1010031811;
    new_Skin.Scar_flash = 1010031765;
    new_Skin.Scar_compe = 1010031764;
    new_Skin.Scar_silent = 1010031766;
    new_Skin.Scar_reddot = 1010031757;
    new_Skin.Scar_holo = 1010031756;
    new_Skin.Scar_x2 = 1010031755;
    new_Skin.Scar_x3 = 1010031754;
    new_Skin.Scar_x4 = 1010031753;
    new_Skin.Scar_x6 = 1010031752;
    new_Skin.Scar_quickMag = 1010031758;
    new_Skin.Scar_extendedMag = 1010031759;
    new_Skin.Scar_quickNextended = 1010031763;
    new_Skin.Scar_verical = 1010031769;
    new_Skin.Scar_angle = 1010031767;
    new_Skin.Scar_lightgrip = 1010031773;
    new_Skin.Scar_pink = 1010031774;
    new_Skin.Scar_lazer = 1010031772;
    new_Skin.Scar_thumb = 1010031768;
    }
    if (preferences.Config.Skin.Scar == 4) {
    new_Skin.Scar4 = 1101003167;
    new_Skin.Scar_Mag = 1010031671;
    new_Skin.Scar_3 = 1010031672;
    new_Skin.Scar_flash = 1010031609;
    new_Skin.Scar_compe = 1010031610;
    new_Skin.Scar_silent = 1010031613;
    new_Skin.Scar_reddot = 1010031606;
    new_Skin.Scar_holo = 1010031605;
    new_Skin.Scar_x2 = 1010031604;
    new_Skin.Scar_x3 = 1010031603;
    new_Skin.Scar_x4 = 1010031602;
    new_Skin.Scar_quickMag = 1010031607;
    new_Skin.Scar_extendedMag = 1010031608;
    new_Skin.Scar_quickNextended = 1010031617;
    new_Skin.Scar_verical = 1010031615;
    new_Skin.Scar_angle = 1010031614;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_thumb = 1010031616;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.Scar == 0) {
    new_Skin.Scar5 = 1010036;
    new_Skin.Scar_Mag = 291003;
    new_Skin.Scar_3 = 203007;
    new_Skin.Scar_flash = 201010;
    new_Skin.Scar_compe = 201009;
    new_Skin.Scar_silent = 201011;
    new_Skin.Scar_reddot = 203001;
    new_Skin.Scar_holo = 203002;
    new_Skin.Scar_x2 = 203003;
    new_Skin.Scar_x3 = 203014;
    new_Skin.Scar_x4 = 203004;
    new_Skin.Scar_x6 = 203015;
    new_Skin.Scar_quickMag = 204012;
    new_Skin.Scar_extendedMag = 204011;
    new_Skin.Scar_quickNextended = 204013;
    new_Skin.Scar_verical = 202002;
    new_Skin.Scar_angle = 202001;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_pink = 202005;
    new_Skin.Scar_lazer = 202007;
    new_Skin.Scar_thumb = 202006;
    }
    if (preferences.Config.Skin.Scar == 1) {

        new_Skin.Scar5 = 1101003219; // Skin chính – Kính Pha Lê (Cấp 7)

        // -------- Ống ngắm --------
        new_Skin.Scar_reddot = 1010031136;
        new_Skin.Scar_holo   = 1010031135;
        new_Skin.Scar_x2     = 1010031134;
        new_Skin.Scar_x3     = 1010031133;
        new_Skin.Scar_x4     = 1010031132;
        new_Skin.Scar_x6     = 1010031618;   // 6x (nằm ở cấp 3)

        // -------- Băng đạn --------
        new_Skin.Scar_Mag            = 1010031131; // Default Mag (Cấp 1)
        new_Skin.Scar_extendedMag    = 1010031137; // Extended
        new_Skin.Scar_quickMag       = 1010031138; // Quick
        new_Skin.Scar_quickNextended = 1010031146; // Quick-Extended

        // -------- Nòng súng --------
        new_Skin.Scar_flash  = 1010031139; // Flash Hider
        new_Skin.Scar_compe  = 1010031140; // Compensator
        new_Skin.Scar_silent = 1010031142; // Silencer

        // -------- Tay cầm --------
        new_Skin.Scar_angle      = 1010031143; // Tay cầm tam giác
        new_Skin.Scar_verical    = 1010031144; // Tay cầm đứng
        new_Skin.Scar_thumb      = 1010031145; // Ngón cái
        new_Skin.Scar_lightgrip  = 1010031620; // Tay cầm nhẹ
        new_Skin.Scar_pink       = 1010031622; // Tay cầm dạng nửa

        // -------- Khác --------
        new_Skin.Scar_lazer = 1010031619; // Laser
        new_Skin.Scar_3     = 0;          // SCAR không có phụ kiện slot 3 riêng
    }
    if (preferences.Config.Skin.Scar == 2) {
    new_Skin.Scar5 = 1101003208;
    new_Skin.Scar_Mag = 1010032021;
    new_Skin.Scar_quickMag = 1010032029;
    new_Skin.Scar_extendedMag = 1010032028;
    new_Skin.Scar_quickNextended = 1010032032;
    new_Skin.Scar_compe = 1010032033;
    new_Skin.Scar_silent = 1010032045;
    new_Skin.Scar_flash = 1010032034;
    new_Skin.Scar_reddot = 1010032027;
    new_Skin.Scar_holo = 1010032026;
    new_Skin.Scar_x2 = 1010032025;
    new_Skin.Scar_x3 = 1010032024;
    new_Skin.Scar_x4 = 1010032023;
    new_Skin.Scar_x6 = 1010032022;
    new_Skin.Scar_lazer = 1010032039;
    new_Skin.Scar_verical = 1010032038;
    new_Skin.Scar_angle = 1010032036;
    new_Skin.Scar_thumb = 1010032037;
    new_Skin.Scar_lightgrip = 1010032042;
    new_Skin.Scar_pink = 1010032043;
    }
    if (preferences.Config.Skin.Scar == 3) {
    new_Skin.Scar5 = 1101003181;
    new_Skin.Scar_Mag = 1010031811;
    new_Skin.Scar_flash = 1010031765;
    new_Skin.Scar_compe = 1010031764;
    new_Skin.Scar_silent = 1010031766;
    new_Skin.Scar_reddot = 1010031757;
    new_Skin.Scar_holo = 1010031756;
    new_Skin.Scar_x2 = 1010031755;
    new_Skin.Scar_x3 = 1010031754;
    new_Skin.Scar_x4 = 1010031753;
    new_Skin.Scar_x6 = 1010031752;
    new_Skin.Scar_quickMag = 1010031758;
    new_Skin.Scar_extendedMag = 1010031759;
    new_Skin.Scar_quickNextended = 1010031763;
    new_Skin.Scar_verical = 1010031769;
    new_Skin.Scar_angle = 1010031767;
    new_Skin.Scar_lightgrip = 1010031773;
    new_Skin.Scar_pink = 1010031774;
    new_Skin.Scar_lazer = 1010031772;
    new_Skin.Scar_thumb = 1010031768;
    }
    if (preferences.Config.Skin.Scar == 4) {
    new_Skin.Scar5 = 1101003167;
    new_Skin.Scar_Mag = 1010031671;
    new_Skin.Scar_3 = 1010031672;
    new_Skin.Scar_flash = 1010031609;
    new_Skin.Scar_compe = 1010031610;
    new_Skin.Scar_silent = 1010031613;
    new_Skin.Scar_reddot = 1010031606;
    new_Skin.Scar_holo = 1010031605;
    new_Skin.Scar_x2 = 1010031604;
    new_Skin.Scar_x3 = 1010031603;
    new_Skin.Scar_x4 = 1010031602;
    new_Skin.Scar_quickMag = 1010031607;
    new_Skin.Scar_extendedMag = 1010031608;
    new_Skin.Scar_quickNextended = 1010031617;
    new_Skin.Scar_verical = 1010031615;
    new_Skin.Scar_angle = 1010031614;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_thumb = 1010031616;
    }
    if (preferences.Config.Skin.Scar == 5) {
    new_Skin.Scar5 = 1101003119;
    new_Skin.Scar_Mag = 1010031191;
    new_Skin.Scar_3 = 1010031192;
    new_Skin.Scar_flash = 1010031139;
    new_Skin.Scar_compe = 1010031140;
    new_Skin.Scar_silent = 1010031142;
    new_Skin.Scar_reddot = 1010031136;
    new_Skin.Scar_holo = 1010031135;
    new_Skin.Scar_x2 = 1010031134;
    new_Skin.Scar_x3 = 1010031133;
    new_Skin.Scar_x4 = 1010031132;
    new_Skin.Scar_quickMag = 1010031137;
    new_Skin.Scar_extendedMag = 1010031138;
    new_Skin.Scar_quickNextended = 1010031146;
    new_Skin.Scar_verical = 1010031144;
    new_Skin.Scar_angle = 1010031143;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_thumb = 1010031145;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.Scar == 0) {
    new_Skin.Scar6 = 1010037;
    new_Skin.Scar_Mag = 291003;
    new_Skin.Scar_3 = 203007;
    new_Skin.Scar_flash = 201010;
    new_Skin.Scar_compe = 201009;
    new_Skin.Scar_silent = 201011;
    new_Skin.Scar_reddot = 203001;
    new_Skin.Scar_holo = 203002;
    new_Skin.Scar_x2 = 203003;
    new_Skin.Scar_x3 = 203014;
    new_Skin.Scar_x4 = 203004;
    new_Skin.Scar_x6 = 203015;
    new_Skin.Scar_quickMag = 204012;
    new_Skin.Scar_extendedMag = 204011;
    new_Skin.Scar_quickNextended = 204013;
    new_Skin.Scar_verical = 202002;
    new_Skin.Scar_angle = 202001;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_pink = 202005;
    new_Skin.Scar_lazer = 202007;
    new_Skin.Scar_thumb = 202006;
    }
    if (preferences.Config.Skin.Scar == 1) {

        new_Skin.Scar6 = 1101003219; // Skin chính – Kính Pha Lê (Cấp 7)

        // -------- Ống ngắm --------
        new_Skin.Scar_reddot = 1010031136;
        new_Skin.Scar_holo   = 1010031135;
        new_Skin.Scar_x2     = 1010031134;
        new_Skin.Scar_x3     = 1010031133;
        new_Skin.Scar_x4     = 1010031132;
        new_Skin.Scar_x6     = 1010031618;   // 6x (nằm ở cấp 3)

        // -------- Băng đạn --------
        new_Skin.Scar_Mag            = 1010031131; // Default Mag (Cấp 1)
        new_Skin.Scar_extendedMag    = 1010031137; // Extended
        new_Skin.Scar_quickMag       = 1010031138; // Quick
        new_Skin.Scar_quickNextended = 1010031146; // Quick-Extended

        // -------- Nòng súng --------
        new_Skin.Scar_flash  = 1010031139; // Flash Hider
        new_Skin.Scar_compe  = 1010031140; // Compensator
        new_Skin.Scar_silent = 1010031142; // Silencer

        // -------- Tay cầm --------
        new_Skin.Scar_angle      = 1010031143; // Tay cầm tam giác
        new_Skin.Scar_verical    = 1010031144; // Tay cầm đứng
        new_Skin.Scar_thumb      = 1010031145; // Ngón cái
        new_Skin.Scar_lightgrip  = 1010031620; // Tay cầm nhẹ
        new_Skin.Scar_pink       = 1010031622; // Tay cầm dạng nửa

        // -------- Khác --------
        new_Skin.Scar_lazer = 1010031619; // Laser
        new_Skin.Scar_3     = 0;          // SCAR không có phụ kiện slot 3 riêng
    }
    if (preferences.Config.Skin.Scar == 2) {
    new_Skin.Scar6 = 1101003208;
    new_Skin.Scar_Mag = 1010032021;
    new_Skin.Scar_quickMag = 1010032029;
    new_Skin.Scar_extendedMag = 1010032028;
    new_Skin.Scar_quickNextended = 1010032032;
    new_Skin.Scar_compe = 1010032033;
    new_Skin.Scar_silent = 1010032045;
    new_Skin.Scar_flash = 1010032034;
    new_Skin.Scar_reddot = 1010032027;
    new_Skin.Scar_holo = 1010032026;
    new_Skin.Scar_x2 = 1010032025;
    new_Skin.Scar_x3 = 1010032024;
    new_Skin.Scar_x4 = 1010032023;
    new_Skin.Scar_x6 = 1010032022;
    new_Skin.Scar_lazer = 1010032039;
    new_Skin.Scar_verical = 1010032038;
    new_Skin.Scar_angle = 1010032036;
    new_Skin.Scar_thumb = 1010032037;
    new_Skin.Scar_lightgrip = 1010032042;
    new_Skin.Scar_pink = 1010032043;
    }
    if (preferences.Config.Skin.Scar == 3) {
    new_Skin.Scar6 = 1101003181;
    new_Skin.Scar_Mag = 1010031811;
    new_Skin.Scar_flash = 1010031765;
    new_Skin.Scar_compe = 1010031764;
    new_Skin.Scar_silent = 1010031766;
    new_Skin.Scar_reddot = 1010031757;
    new_Skin.Scar_holo = 1010031756;
    new_Skin.Scar_x2 = 1010031755;
    new_Skin.Scar_x3 = 1010031754;
    new_Skin.Scar_x4 = 1010031753;
    new_Skin.Scar_x6 = 1010031752;
    new_Skin.Scar_quickMag = 1010031758;
    new_Skin.Scar_extendedMag = 1010031759;
    new_Skin.Scar_quickNextended = 1010031763;
    new_Skin.Scar_verical = 1010031769;
    new_Skin.Scar_angle = 1010031767;
    new_Skin.Scar_lightgrip = 1010031773;
    new_Skin.Scar_pink = 1010031774;
    new_Skin.Scar_lazer = 1010031772;
    new_Skin.Scar_thumb = 1010031768;
    }
    if (preferences.Config.Skin.Scar == 4) {
    new_Skin.Scar6 = 1101003167;
    new_Skin.Scar_Mag = 1010031671;
    new_Skin.Scar_3 = 1010031672;
    new_Skin.Scar_flash = 1010031609;
    new_Skin.Scar_compe = 1010031610;
    new_Skin.Scar_silent = 1010031613;
    new_Skin.Scar_reddot = 1010031606;
    new_Skin.Scar_holo = 1010031605;
    new_Skin.Scar_x2 = 1010031604;
    new_Skin.Scar_x3 = 1010031603;
    new_Skin.Scar_x4 = 1010031602;
    new_Skin.Scar_quickMag = 1010031607;
    new_Skin.Scar_extendedMag = 1010031608;
    new_Skin.Scar_quickNextended = 1010031617;
    new_Skin.Scar_verical = 1010031615;
    new_Skin.Scar_angle = 1010031614;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_thumb = 1010031616;
    }
    if (preferences.Config.Skin.Scar == 5) {
    new_Skin.Scar6 = 1101003119;
    new_Skin.Scar_Mag = 1010031191;
    new_Skin.Scar_3 = 1010031192;
    new_Skin.Scar_flash = 1010031139;
    new_Skin.Scar_compe = 1010031140;
    new_Skin.Scar_silent = 1010031142;
    new_Skin.Scar_reddot = 1010031136;
    new_Skin.Scar_holo = 1010031135;
    new_Skin.Scar_x2 = 1010031134;
    new_Skin.Scar_x3 = 1010031133;
    new_Skin.Scar_x4 = 1010031132;
    new_Skin.Scar_quickMag = 1010031137;
    new_Skin.Scar_extendedMag = 1010031138;
    new_Skin.Scar_quickNextended = 1010031146;
    new_Skin.Scar_verical = 1010031144;
    new_Skin.Scar_angle = 1010031143;
    new_Skin.Scar_lightgrip = 202004;
    new_Skin.Scar_thumb = 1010031145;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if (preferences.Config.Skin.M416 == 0) {
    new_Skin.M416_1 = 101004;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
  if (preferences.Config.Skin.M416 == 1) {
    new_Skin.M416_1 = 1101004236;
    if (AccessoriesGun) {
        new_Skin.M416_2 = 1010042271;
        new_Skin.M416_3 = 1010042272;
        new_Skin.M416_4 = 1010042273;
        new_Skin.M416_flash = 1010042307;
        new_Skin.M416_compe = 1010042306;
        new_Skin.M416_silent = 1010042308;
        new_Skin.M416_reddot = 1010042299;
        new_Skin.M416_holo = 1010042298;
        new_Skin.M416_x2 = 1010042297;
        new_Skin.M416_x3 = 1010042296;
        new_Skin.M416_x4 = 1010042295;
        new_Skin.M416_x6 = 1010042294;
        new_Skin.M416_quickMag = 1010042304;
        new_Skin.M416_extendedMag = 1010042300;
        new_Skin.M416_quickNextended = 1010042305;
        new_Skin.M416_verical = 1010042314;
        new_Skin.M416_angle = 1010042309;
        new_Skin.M416_thumb = 1010042310;
        new_Skin.M416_lightgrip = 1010042316;
        new_Skin.M416_pink = 1010042317;
        new_Skin.M416_stock = 1010042315;
        new_Skin.M416_lazer = 1010042318;
    }
}

if (preferences.Config.Skin.M416 == 2) {
    new_Skin.M416_1 = 1101004046;
    if (AccessoriesGun) {
        new_Skin.M416_2 = 1010040461;
        new_Skin.M416_3 = 1010040462;
        new_Skin.M416_4 = 1010040463;
        new_Skin.M416_flash = 1010040474;
        new_Skin.M416_compe = 1010040475;
        new_Skin.M416_silent = 1010040476;
        new_Skin.M416_reddot = 1010040470;
        new_Skin.M416_holo = 1010040469;
        new_Skin.M416_x2 = 1010040468;
        new_Skin.M416_x3 = 1010040467;
        new_Skin.M416_x4 = 1010040466;
        new_Skin.M416_x6 = 1010040481;
        new_Skin.M416_quickMag = 1010040471;
        new_Skin.M416_extendedMag = 1010040472;
        new_Skin.M416_quickNextended = 1010040473;
        new_Skin.M416_stock = 1010040480;
        new_Skin.M416_verical = 1010040479;
        new_Skin.M416_thumb = 1010040478;
        new_Skin.M416_angle = 1010040477;
        new_Skin.M416_lightgrip = 1010040482;
        new_Skin.M416_pink = 1010040483;
        new_Skin.M416_lazer = 1010040484;
    }
}

if (preferences.Config.Skin.M416 == 3) {
    new_Skin.M416_1 = 1101004218;
    if (AccessoriesGun) {
        new_Skin.M416_2 = 1010042153;
        new_Skin.M416_3 = 1010042163;
        new_Skin.M416_4 = 1010042173;
        new_Skin.M416_flash = 1010042128;
        new_Skin.M416_compe = 1010042127;
        new_Skin.M416_silent = 1010042129;
        new_Skin.M416_reddot = 1010042119;
        new_Skin.M416_holo = 1010042118;
        new_Skin.M416_x2 = 1010042117;
        new_Skin.M416_x3 = 1010042116;
        new_Skin.M416_x4 = 1010042115;
        new_Skin.M416_x6 = 1010042114;
        new_Skin.M416_quickMag = 1010042124;
        new_Skin.M416_extendedMag = 1010042125;
        new_Skin.M416_quickNextended = 1010042126;
        new_Skin.M416_stock = 1010042137;
        new_Skin.M416_verical = 1010042136;
        new_Skin.M416_angle = 1010042134;
        new_Skin.M416_lightgrip = 1010042138;
        new_Skin.M416_pink = 1010042139;
        new_Skin.M416_lazer = 1010042144;
        new_Skin.M416_thumb = 1010042135;
    }
}

if (preferences.Config.Skin.M416 == 4) {
    new_Skin.M416_1 = 1101004078;
    if (AccessoriesGun) {
        new_Skin.M416_2 = 1010040781;
        new_Skin.M416_3 = 1010040782;
        new_Skin.M416_4 = 1010040783;
        new_Skin.M416_flash = 201010;
        new_Skin.M416_compe = 201009;
        new_Skin.M416_silent = 201011;
        new_Skin.M416_reddot = 203001;
        new_Skin.M416_holo = 203002;
        new_Skin.M416_x2 = 203003;
        new_Skin.M416_x3 = 203014;
        new_Skin.M416_x4 = 203004;
        new_Skin.M416_x6 = 203015;
        new_Skin.M416_quickMag = 204012;
        new_Skin.M416_extendedMag = 204011;
        new_Skin.M416_quickNextended = 204013;
        new_Skin.M416_stock = 205002;
        new_Skin.M416_verical = 202002;
        new_Skin.M416_angle = 202001;
        new_Skin.M416_lightgrip = 202004;
        new_Skin.M416_pink = 202005;
        new_Skin.M416_lazer = 202007;
        new_Skin.M416_thumb = 202006;
    }
}

if (preferences.Config.Skin.M416 == 5) {
    new_Skin.M416_1 = 1101004086;
    if (AccessoriesGun) {
        new_Skin.M416_2 = 1010040861;
        new_Skin.M416_3 = 1010040862;
        new_Skin.M416_4 = 1010040863;
        new_Skin.M416_flash = 201010;
        new_Skin.M416_compe = 201009;
        new_Skin.M416_silent = 201011;
        new_Skin.M416_reddot = 203001;
        new_Skin.M416_holo = 203002;
        new_Skin.M416_x2 = 203003;
        new_Skin.M416_x3 = 203014;
        new_Skin.M416_x4 = 203004;
        new_Skin.M416_x6 = 203015;
        new_Skin.M416_quickMag = 204012;
        new_Skin.M416_extendedMag = 204011;
        new_Skin.M416_quickNextended = 204013;
        new_Skin.M416_stock = 205002;
        new_Skin.M416_verical = 202002;
        new_Skin.M416_angle = 202001;
        new_Skin.M416_lightgrip = 202004;
        new_Skin.M416_pink = 202005;
        new_Skin.M416_lazer = 202007;
        new_Skin.M416_thumb = 202006;
    }
}

    if (preferences.Config.Skin.M416 == 6) {
    new_Skin.M416_1 = 1101004098;
    if (AccessoriesGun) {
        new_Skin.M416_2 = 1010040981;
        new_Skin.M416_3 = 1010040982;
        new_Skin.M416_4 = 1010040983;
        new_Skin.M416_flash = 201010;
        new_Skin.M416_compe = 201009;
        new_Skin.M416_silent = 201011;
        new_Skin.M416_reddot = 203001;
        new_Skin.M416_holo = 203002;
        new_Skin.M416_x2 = 203003;
        new_Skin.M416_x3 = 203014;
        new_Skin.M416_x4 = 203004;
        new_Skin.M416_x6 = 203015;
        new_Skin.M416_quickMag = 204012;
        new_Skin.M416_extendedMag = 204011;
        new_Skin.M416_quickNextended = 204013;
        new_Skin.M416_stock = 205002;
        new_Skin.M416_verical = 202002;
        new_Skin.M416_angle = 202001;
        new_Skin.M416_lightgrip = 202004;
        new_Skin.M416_pink = 202005;
        new_Skin.M416_lazer = 202007;
        new_Skin.M416_thumb = 202006;
    }
}

if (preferences.Config.Skin.M416 == 7) {
    new_Skin.M416_1 = 1101004138;
    if (AccessoriesGun) {
        new_Skin.M416_2 = 1010041381;
        new_Skin.M416_3 = 1010041382;
        new_Skin.M416_4 = 1010041383;
        new_Skin.M416_flash = 1010041136;
        new_Skin.M416_compe = 1010041137;
        new_Skin.M416_silent = 1010041138;
        new_Skin.M416_reddot = 1010041128;
        new_Skin.M416_holo = 1010041127;
        new_Skin.M416_x2 = 1010041126;
        new_Skin.M416_x3 = 1010041125;
        new_Skin.M416_x4 = 1010041124;
        new_Skin.M416_x6 = 203015;
        new_Skin.M416_quickMag = 1010041134;
        new_Skin.M416_extendedMag = 1010041129;
        new_Skin.M416_quickNextended = 1010041135;
        new_Skin.M416_stock = 1010041146;
        new_Skin.M416_verical = 1010041145;
        new_Skin.M416_angle = 1010041139;
        new_Skin.M416_lightgrip = 202004;
        new_Skin.M416_pink = 202005;
        new_Skin.M416_lazer = 202007;
        new_Skin.M416_thumb = 202006;
    }
}

if (preferences.Config.Skin.M416 == 8) {
    new_Skin.M416_1 = 1101004163;
    if (AccessoriesGun) {
        new_Skin.M416_2 = 1010041631;
        new_Skin.M416_3 = 1010041632;
        new_Skin.M416_4 = 1010041633;
        new_Skin.M416_flash = 201010;
        new_Skin.M416_compe = 1010041574;
        new_Skin.M416_silent = 1010041575;
        new_Skin.M416_reddot = 1010041566;
        new_Skin.M416_holo = 1010041565;
        new_Skin.M416_x2 = 1010041564;
        new_Skin.M416_x3 = 1010041560;
        new_Skin.M416_x4 = 1010041554;
        new_Skin.M416_x6 = 203015;
        new_Skin.M416_quickMag = 1010041568;
        new_Skin.M416_extendedMag = 1010041569;
        new_Skin.M416_quickNextended = 1010041567;
        new_Skin.M416_stock = 1010041579;
        new_Skin.M416_verical = 1010041578;
        new_Skin.M416_angle = 1010041576;
        new_Skin.M416_lightgrip = 20200400;
        new_Skin.M416_pink = 202005;
        new_Skin.M416_lazer = 202007;
        new_Skin.M416_thumb = 1010041577;
    }
}

if (preferences.Config.Skin.M416 == 9) {
    new_Skin.M416_1 = 1101004201;
    if (AccessoriesGun) {
        new_Skin.M416_2 = 1010042011;
        new_Skin.M416_3 = 1010042012;
        new_Skin.M416_4 = 1010042013;
        new_Skin.M416_flash = 1010041956;
        new_Skin.M416_compe = 1010041957;
        new_Skin.M416_silent = 1010041958;
        new_Skin.M416_reddot = 1010041948;
        new_Skin.M416_holo = 1010041947;
        new_Skin.M416_x2 = 1010041946;
        new_Skin.M416_x3 = 1010041945;
        new_Skin.M416_x4 = 1010041944;
        new_Skin.M416_x6 = 1010041967;
        new_Skin.M416_quickMag = 1010041949;
        new_Skin.M416_extendedMag = 1010041950;
        new_Skin.M416_quickNextended = 1010041955;
        new_Skin.M416_stock = 1010041966;
        new_Skin.M416_verical = 1010041965;
        new_Skin.M416_angle = 1010041959;
        new_Skin.M416_lightgrip = 202004;
        new_Skin.M416_pink = 202005;
        new_Skin.M416_lazer = 202007;
        new_Skin.M416_thumb = 202006;
    }
}

if (preferences.Config.Skin.M416 == 10) {
    new_Skin.M416_1 = 1101004209;
    if (AccessoriesGun) {
        new_Skin.M416_2 = 1010042073;
        new_Skin.M416_3 = 1010042083;
        new_Skin.M416_4 = 1010042093;
        new_Skin.M416_flash = 20101000;
        new_Skin.M416_compe = 1010042037;
        new_Skin.M416_silent = 1010042039;
        new_Skin.M416_reddot = 1010042029;
        new_Skin.M416_holo = 1010042028;
        new_Skin.M416_x2 = 1010042027;
        new_Skin.M416_x3 = 1010042026;
        new_Skin.M416_x4 = 1010042025;
        new_Skin.M416_x6 = 1010042024;
        new_Skin.M416_quickMag = 1010042034;
        new_Skin.M416_extendedMag = 1010042035;
        new_Skin.M416_quickNextended = 1010042036;
        new_Skin.M416_stock = 1010042047;
        new_Skin.M416_verical = 1010042046;
        new_Skin.M416_angle = 1010042044;
        new_Skin.M416_lightgrip = 202004;
        new_Skin.M416_pink = 202005;
        new_Skin.M416_lazer = 202007;
        new_Skin.M416_thumb = 202006;
    }
}

if (preferences.Config.Skin.M416 == 11) {
    new_Skin.M416_1 = 1101004062;
    if (AccessoriesGun) {
        new_Skin.M416_2 = 1010040011;
        new_Skin.M416_3 = 1010040012;
        new_Skin.M416_4 = 1010040613;
        new_Skin.M416_flash = 201010;
        new_Skin.M416_compe = 201009;
        new_Skin.M416_silent = 201011;
        new_Skin.M416_reddot = 203001;
        new_Skin.M416_holo = 203002;
        new_Skin.M416_x2 = 203003;
        new_Skin.M416_x3 = 203014;
        new_Skin.M416_x4 = 203004;
        new_Skin.M416_x6 = 203015;
        new_Skin.M416_quickMag = 204012;
        new_Skin.M416_extendedMag = 204011;
        new_Skin.M416_quickNextended = 204013;
        new_Skin.M416_stock = 205002;
        new_Skin.M416_verical = 202002;
        new_Skin.M416_angle = 202001;
        new_Skin.M416_lightgrip = 202004;
        new_Skin.M416_pink = 202005;
        new_Skin.M416_lazer = 202007;
        new_Skin.M416_thumb = 202006;
    }
}

if (preferences.Config.Skin.M416 == 12) {
    new_Skin.M416_1 = 1101004226;
    if (AccessoriesGun) {
        new_Skin.M416_2 = 1010042214;
        new_Skin.M416_3 = 1010042215;
        new_Skin.M416_4 = 1010042216;
        new_Skin.M416_flash = 1010042238;
        new_Skin.M416_compe = 1010042237;
        new_Skin.M416_silent = 1010042239;
        new_Skin.M416_reddot = 1010042233;
        new_Skin.M416_holo = 1010042232;
        new_Skin.M416_x2 = 1010042231;
        new_Skin.M416_x3 = 1010042219;
        new_Skin.M416_x4 = 1010042218;
        new_Skin.M416_x6 = 1010042217;
        new_Skin.M416_quickMag = 1010042235;
        new_Skin.M416_extendedMag = 1010042234;
        new_Skin.M416_quickNextended = 1010042236;
        new_Skin.M416_stock = 1010042244;
        new_Skin.M416_verical = 1010042243;
        new_Skin.M416_angle = 1010042241;
        new_Skin.M416_lightgrip = 1010042245;
        new_Skin.M416_pink = 1010042246;
        new_Skin.M416_lazer = 1010042247;
        new_Skin.M416_thumb = 1010042242;
    }
}

    if (preferences.Config.Skin.M416 == 13) {
    new_Skin.M416_1 = 1101004151;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 14) {
    new_Skin.M416_1 = 1101004089;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 15) {
    new_Skin.M416_1 = 1101004034;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 16) {
    new_Skin.M416_1 = 1101004002;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 17) {
    new_Skin.M416_1 = 1101004227;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }

    if (preferences.Config.Skin.M416 == 18) {
    new_Skin.M416_1 = 1101004154;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M416 == 0) {
    new_Skin.M4168 = 1010042;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 1) {
    new_Skin.M4168 = 1101004236;        // Skin chính
    new_Skin.M416_2 = 1010042271;        // Đạn
    new_Skin.M416_3 = 1010042272;        // Ống ngắm chính
    new_Skin.M416_4 = 1010042273;        // Báng súng

    // Nòng
    new_Skin.M416_flash = 1010042307;
    new_Skin.M416_compe = 1010042306;
    new_Skin.M416_silent = 1010042308;

    // Ống ngắm
    new_Skin.M416_reddot = 1010042299;
    new_Skin.M416_holo = 1010042298;
    new_Skin.M416_x2 = 1010042297;
    new_Skin.M416_x3 = 1010042296;
    new_Skin.M416_x4 = 1010042295;
    new_Skin.M416_x6 = 1010042294;

    // Băng đạn
    new_Skin.M416_quickMag = 1010042304;
    new_Skin.M416_extendedMag = 1010042300;
    new_Skin.M416_quickNextended = 1010042305;

    // Tay cầm
    new_Skin.M416_verical = 1010042314;
    new_Skin.M416_angle = 1010042309;
    new_Skin.M416_thumb = 1010042310;
    new_Skin.M416_lightgrip = 1010042316;
    new_Skin.M416_pink = 1010042317;

    // Khác
    new_Skin.M416_stock = 1010042315;    // Báng súng
    new_Skin.M416_lazer = 1010042318;    // Laser
    }

    if (preferences.Config.Skin.M416 == 2) {
    new_Skin.M4168 = 1101004046;
    new_Skin.M416_2 = 1010040461;
    new_Skin.M416_3 = 1010040462;
    new_Skin.M416_4 = 1010040463;
    new_Skin.M416_flash = 1010040474;
    new_Skin.M416_compe = 1010040475;
    new_Skin.M416_silent = 1010040476;
    new_Skin.M416_reddot = 1010040470;
    new_Skin.M416_holo = 1010040469;
    new_Skin.M416_x2 = 1010040468;
    new_Skin.M416_x3 = 1010040467;
    new_Skin.M416_x4 = 1010040466;
    new_Skin.M416_x6 = 1010040481;
    new_Skin.M416_quickMag = 1010040471;
    new_Skin.M416_extendedMag = 1010040472;
    new_Skin.M416_quickNextended = 1010040473;
    new_Skin.M416_stock = 1010040480;
    new_Skin.M416_verical = 1010040479;
    new_Skin.M416_thumb = 1010040478;
    new_Skin.M416_angle = 1010040477;
    new_Skin.M416_lightgrip = 1010040482;
    new_Skin.M416_pink = 1010040483;
    new_Skin.M416_lazer = 1010040484;
    }
    if (preferences.Config.Skin.M416 == 3) {
    new_Skin.M4168 = 1101004218;
    new_Skin.M416_2 = 1010042153;
    new_Skin.M416_3 = 1010042163;
    new_Skin.M416_4 = 1010042173;
    new_Skin.M416_flash = 1010042128;
    new_Skin.M416_compe = 1010042127;
    new_Skin.M416_silent = 1010042129;
    new_Skin.M416_reddot = 1010042119;
    new_Skin.M416_holo = 1010042118;
    new_Skin.M416_x2 = 1010042117;
    new_Skin.M416_x3 = 1010042116;
    new_Skin.M416_x4 = 1010042115;
    new_Skin.M416_x6 = 1010042114;
    new_Skin.M416_quickMag = 1010042124;
    new_Skin.M416_extendedMag = 1010042125;
    new_Skin.M416_quickNextended = 1010042126;
    new_Skin.M416_stock = 1010042137;
    new_Skin.M416_verical = 1010042136;
    new_Skin.M416_angle = 1010042134;
    new_Skin.M416_lightgrip = 1010042138;
    new_Skin.M416_pink = 1010042139;
    new_Skin.M416_lazer = 1010042144;
    new_Skin.M416_thumb = 1010042135;
    }
    if (preferences.Config.Skin.M416 == 4) {
    new_Skin.M4168 = 1101004078;
    new_Skin.M416_2 = 1010040781;
    new_Skin.M416_3 = 1010040782;
    new_Skin.M416_4 = 1010040783;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 5) {
    new_Skin.M4168 = 1101004086;
    new_Skin.M416_2 = 1010040861;
    new_Skin.M416_3 = 1010040862;
    new_Skin.M416_4 = 1010040863;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 6) {
    new_Skin.M4168 = 1101004098;
    new_Skin.M416_2 = 1010040981;
    new_Skin.M416_3 = 1010040982;
    new_Skin.M416_4 = 1010040983;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 7) {
    new_Skin.M4168 = 1101004138;
    new_Skin.M416_2 = 1010041381;
    new_Skin.M416_3 = 1010041382;
    new_Skin.M416_4 = 1010041383;
    new_Skin.M416_flash = 1010041136;
    new_Skin.M416_compe = 1010041137;
    new_Skin.M416_silent = 1010041138;
    new_Skin.M416_reddot = 1010041128;
    new_Skin.M416_holo = 1010041127;
    new_Skin.M416_x2 = 1010041126;
    new_Skin.M416_x3 = 1010041125;
    new_Skin.M416_x4 = 1010041124;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 1010041134;
    new_Skin.M416_extendedMag = 1010041129;
    new_Skin.M416_quickNextended = 1010041135;
    new_Skin.M416_stock = 1010041146;
    new_Skin.M416_verical = 1010041145;
    new_Skin.M416_angle = 1010041139;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 8) {
    new_Skin.M4168 = 1101004163;
    new_Skin.M416_2 = 1010041631;
    new_Skin.M416_3 = 1010041632;
    new_Skin.M416_4 = 1010041633;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 1010041574;
    new_Skin.M416_silent = 1010041575;
    new_Skin.M416_reddot = 1010041566;
    new_Skin.M416_holo = 1010041565;
    new_Skin.M416_x2 = 1010041564;
    new_Skin.M416_x3 = 1010041560;
    new_Skin.M416_x4 = 1010041554;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 1010041568;
    new_Skin.M416_extendedMag = 1010041569;
    new_Skin.M416_quickNextended = 1010041567;
    new_Skin.M416_stock = 1010041579;
    new_Skin.M416_verical = 1010041578;
    new_Skin.M416_angle = 1010041576;
    new_Skin.M416_lightgrip = 20200400;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 1010041577;
    }
    if (preferences.Config.Skin.M416 == 9) {
    new_Skin.M4168 = 1101004201;
    new_Skin.M416_2 = 1010042011;
    new_Skin.M416_3 = 1010042012;
    new_Skin.M416_4 = 1010042013;
    new_Skin.M416_flash = 1010041956;
    new_Skin.M416_compe = 1010041957;
    new_Skin.M416_silent = 1010041958;
    new_Skin.M416_reddot = 1010041948;
    new_Skin.M416_holo = 1010041947;
    new_Skin.M416_x2 = 1010041946;
    new_Skin.M416_x3 = 1010041945;
    new_Skin.M416_x4 = 1010041944;
    new_Skin.M416_x6 = 1010041967;
    new_Skin.M416_quickMag = 1010041949;
    new_Skin.M416_extendedMag = 1010041950;
    new_Skin.M416_quickNextended = 1010041955;
    new_Skin.M416_stock = 1010041966;
    new_Skin.M416_verical = 1010041965;
    new_Skin.M416_angle = 1010041959;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 10) {
    new_Skin.M4168 = 1101004209;
    new_Skin.M416_2 = 1010042073;
    new_Skin.M416_3 = 1010042083;
    new_Skin.M416_4 = 1010042093;
    new_Skin.M416_flash = 20101000;
    new_Skin.M416_compe = 1010042037;
    new_Skin.M416_silent = 1010042039;
    new_Skin.M416_reddot = 1010042029;
    new_Skin.M416_holo = 1010042028;
    new_Skin.M416_x2 = 1010042027;
    new_Skin.M416_x3 = 1010042026;
    new_Skin.M416_x4 = 1010042025;
    new_Skin.M416_x6 = 1010042024;
    new_Skin.M416_quickMag = 1010042034;
    new_Skin.M416_extendedMag = 1010042035;
    new_Skin.M416_quickNextended = 1010042036;
    new_Skin.M416_stock = 1010042047;
    new_Skin.M416_verical = 1010042046;
    new_Skin.M416_angle = 1010042044;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 11) {
    new_Skin.M4168 = 1101004062;
    new_Skin.M416_2 = 1010040011;
    new_Skin.M416_3 = 1010040012;
    new_Skin.M416_4 = 1010040613;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;      
    }
    if (preferences.Config.Skin.M416 == 12) {
    new_Skin.M4168 = 1101004226;
    new_Skin.M416_2 = 1010042214;
    new_Skin.M416_3 = 1010042215;
    new_Skin.M416_4 = 1010042216;
    new_Skin.M416_flash = 1010042238;
    new_Skin.M416_compe = 1010042237;
    new_Skin.M416_silent = 1010042239;
    new_Skin.M416_reddot = 1010042233;
    new_Skin.M416_holo = 1010042232;
    new_Skin.M416_x2 = 1010042231;
    new_Skin.M416_x3 = 1010042219;
    new_Skin.M416_x4 = 1010042218;
    new_Skin.M416_x6 = 1010042217;
    new_Skin.M416_quickMag = 1010042235;
    new_Skin.M416_extendedMag = 1010042234;
    new_Skin.M416_quickNextended = 1010042236;
    new_Skin.M416_stock = 1010042244;
    new_Skin.M416_verical = 1010042243;
    new_Skin.M416_angle = 1010042241;
    new_Skin.M416_lightgrip = 1010042245;
    new_Skin.M416_pink = 1010042246;
    new_Skin.M416_lazer = 1010042247;
    new_Skin.M416_thumb = 1010042242;
    }
    if (preferences.Config.Skin.M416 == 13) {
    new_Skin.M4168 = 1101004151;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 14) {
    new_Skin.M4168 = 1101004089;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 15) {
    new_Skin.M4168 = 1101004034;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 16) {
    new_Skin.M4168 = 1101004002;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 17) {
    new_Skin.M4168 = 1101004227;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }

    if (preferences.Config.Skin.M416 == 18) {
    new_Skin.M4168 = 1101004154;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M416 == 0) {
    new_Skin.M4169 = 1010043;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 1) {
    new_Skin.M4169 = 1101004236;        // Skin chính
    new_Skin.M416_2 = 1010042271;        // Đạn
    new_Skin.M416_3 = 1010042272;        // Ống ngắm chính
    new_Skin.M416_4 = 1010042273;        // Báng súng

    // Nòng
    new_Skin.M416_flash = 1010042307;
    new_Skin.M416_compe = 1010042306;
    new_Skin.M416_silent = 1010042308;

    // Ống ngắm
    new_Skin.M416_reddot = 1010042299;
    new_Skin.M416_holo = 1010042298;
    new_Skin.M416_x2 = 1010042297;
    new_Skin.M416_x3 = 1010042296;
    new_Skin.M416_x4 = 1010042295;
    new_Skin.M416_x6 = 1010042294;

    // Băng đạn
    new_Skin.M416_quickMag = 1010042304;
    new_Skin.M416_extendedMag = 1010042300;
    new_Skin.M416_quickNextended = 1010042305;

    // Tay cầm
    new_Skin.M416_verical = 1010042314;
    new_Skin.M416_angle = 1010042309;
    new_Skin.M416_thumb = 1010042310;
    new_Skin.M416_lightgrip = 1010042316;
    new_Skin.M416_pink = 1010042317;

    // Khác
    new_Skin.M416_stock = 1010042315;    // Báng súng
    new_Skin.M416_lazer = 1010042318;    // Laser
    }

    if (preferences.Config.Skin.M416 == 2) {
    new_Skin.M4169 = 1101004046;
    new_Skin.M416_2 = 1010040461;
    new_Skin.M416_3 = 1010040462;
    new_Skin.M416_4 = 1010040463;
    new_Skin.M416_flash = 1010040474;
    new_Skin.M416_compe = 1010040475;
    new_Skin.M416_silent = 1010040476;
    new_Skin.M416_reddot = 1010040470;
    new_Skin.M416_holo = 1010040469;
    new_Skin.M416_x2 = 1010040468;
    new_Skin.M416_x3 = 1010040467;
    new_Skin.M416_x4 = 1010040466;
    new_Skin.M416_x6 = 1010040481;
    new_Skin.M416_quickMag = 1010040471;
    new_Skin.M416_extendedMag = 1010040472;
    new_Skin.M416_quickNextended = 1010040473;
    new_Skin.M416_stock = 1010040480;
    new_Skin.M416_verical = 1010040479;
    new_Skin.M416_thumb = 1010040478;
    new_Skin.M416_angle = 1010040477;
    new_Skin.M416_lightgrip = 1010040482;
    new_Skin.M416_pink = 1010040483;
    new_Skin.M416_lazer = 1010040484;
    }
    if (preferences.Config.Skin.M416 == 3) {
    new_Skin.M4169 = 1101004218;
    new_Skin.M416_2 = 1010042153;
    new_Skin.M416_3 = 1010042163;
    new_Skin.M416_4 = 1010042173;
    new_Skin.M416_flash = 1010042128;
    new_Skin.M416_compe = 1010042127;
    new_Skin.M416_silent = 1010042129;
    new_Skin.M416_reddot = 1010042119;
    new_Skin.M416_holo = 1010042118;
    new_Skin.M416_x2 = 1010042117;
    new_Skin.M416_x3 = 1010042116;
    new_Skin.M416_x4 = 1010042115;
    new_Skin.M416_x6 = 1010042114;
    new_Skin.M416_quickMag = 1010042124;
    new_Skin.M416_extendedMag = 1010042125;
    new_Skin.M416_quickNextended = 1010042126;
    new_Skin.M416_stock = 1010042137;
    new_Skin.M416_verical = 1010042136;
    new_Skin.M416_angle = 1010042134;
    new_Skin.M416_lightgrip = 1010042138;
    new_Skin.M416_pink = 1010042139;
    new_Skin.M416_lazer = 1010042144;
    new_Skin.M416_thumb = 1010042135;
    }
    if (preferences.Config.Skin.M416 == 4) {
    new_Skin.M4169 = 1101004078;
    new_Skin.M416_2 = 1010040781;
    new_Skin.M416_3 = 1010040782;
    new_Skin.M416_4 = 1010040783;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 5) {
    new_Skin.M4169 = 1101004086;
    new_Skin.M416_2 = 1010040861;
    new_Skin.M416_3 = 1010040862;
    new_Skin.M416_4 = 1010040863;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 6) {
    new_Skin.M4169 = 1101004098;
    new_Skin.M416_2 = 1010040981;
    new_Skin.M416_3 = 1010040982;
    new_Skin.M416_4 = 1010040983;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 7) {
    new_Skin.M4169 = 1101004138;
    new_Skin.M416_2 = 1010041381;
    new_Skin.M416_3 = 1010041382;
    new_Skin.M416_4 = 1010041383;
    new_Skin.M416_flash = 1010041136;
    new_Skin.M416_compe = 1010041137;
    new_Skin.M416_silent = 1010041138;
    new_Skin.M416_reddot = 1010041128;
    new_Skin.M416_holo = 1010041127;
    new_Skin.M416_x2 = 1010041126;
    new_Skin.M416_x3 = 1010041125;
    new_Skin.M416_x4 = 1010041124;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 1010041134;
    new_Skin.M416_extendedMag = 1010041129;
    new_Skin.M416_quickNextended = 1010041135;
    new_Skin.M416_stock = 1010041146;
    new_Skin.M416_verical = 1010041145;
    new_Skin.M416_angle = 1010041139;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 8) {
    new_Skin.M4169 = 1101004163;
    new_Skin.M416_2 = 1010041631;
    new_Skin.M416_3 = 1010041632;
    new_Skin.M416_4 = 1010041633;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 1010041574;
    new_Skin.M416_silent = 1010041575;
    new_Skin.M416_reddot = 1010041566;
    new_Skin.M416_holo = 1010041565;
    new_Skin.M416_x2 = 1010041564;
    new_Skin.M416_x3 = 1010041560;
    new_Skin.M416_x4 = 1010041554;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 1010041568;
    new_Skin.M416_extendedMag = 1010041569;
    new_Skin.M416_quickNextended = 1010041567;
    new_Skin.M416_stock = 1010041579;
    new_Skin.M416_verical = 1010041578;
    new_Skin.M416_angle = 1010041576;
    new_Skin.M416_lightgrip = 20200400;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 1010041577;
    }
    if (preferences.Config.Skin.M416 == 9) {
    new_Skin.M4169 = 1101004201;
    new_Skin.M416_2 = 1010042011;
    new_Skin.M416_3 = 1010042012;
    new_Skin.M416_4 = 1010042013;
    new_Skin.M416_flash = 1010041956;
    new_Skin.M416_compe = 1010041957;
    new_Skin.M416_silent = 1010041958;
    new_Skin.M416_reddot = 1010041948;
    new_Skin.M416_holo = 1010041947;
    new_Skin.M416_x2 = 1010041946;
    new_Skin.M416_x3 = 1010041945;
    new_Skin.M416_x4 = 1010041944;
    new_Skin.M416_x6 = 1010041967;
    new_Skin.M416_quickMag = 1010041949;
    new_Skin.M416_extendedMag = 1010041950;
    new_Skin.M416_quickNextended = 1010041955;
    new_Skin.M416_stock = 1010041966;
    new_Skin.M416_verical = 1010041965;
    new_Skin.M416_angle = 1010041959;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 10) {
    new_Skin.M4169 = 1101004209;
    new_Skin.M416_2 = 1010042073;
    new_Skin.M416_3 = 1010042083;
    new_Skin.M416_4 = 1010042093;
    new_Skin.M416_flash = 20101000;
    new_Skin.M416_compe = 1010042037;
    new_Skin.M416_silent = 1010042039;
    new_Skin.M416_reddot = 1010042029;
    new_Skin.M416_holo = 1010042028;
    new_Skin.M416_x2 = 1010042027;
    new_Skin.M416_x3 = 1010042026;
    new_Skin.M416_x4 = 1010042025;
    new_Skin.M416_x6 = 1010042024;
    new_Skin.M416_quickMag = 1010042034;
    new_Skin.M416_extendedMag = 1010042035;
    new_Skin.M416_quickNextended = 1010042036;
    new_Skin.M416_stock = 1010042047;
    new_Skin.M416_verical = 1010042046;
    new_Skin.M416_angle = 1010042044;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 11) {
    new_Skin.M4169 = 1101004062;
    new_Skin.M416_2 = 1010040011;
    new_Skin.M416_3 = 1010040012;
    new_Skin.M416_4 = 1010040613;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;      
    }
    if (preferences.Config.Skin.M416 == 12) {
    new_Skin.M4169 = 1101004226;
    new_Skin.M416_2 = 1010042214;
    new_Skin.M416_3 = 1010042215;
    new_Skin.M416_4 = 1010042216;
    new_Skin.M416_flash = 1010042238;
    new_Skin.M416_compe = 1010042237;
    new_Skin.M416_silent = 1010042239;
    new_Skin.M416_reddot = 1010042233;
    new_Skin.M416_holo = 1010042232;
    new_Skin.M416_x2 = 1010042231;
    new_Skin.M416_x3 = 1010042219;
    new_Skin.M416_x4 = 1010042218;
    new_Skin.M416_x6 = 1010042217;
    new_Skin.M416_quickMag = 1010042235;
    new_Skin.M416_extendedMag = 1010042234;
    new_Skin.M416_quickNextended = 1010042236;
    new_Skin.M416_stock = 1010042244;
    new_Skin.M416_verical = 1010042243;
    new_Skin.M416_angle = 1010042241;
    new_Skin.M416_lightgrip = 1010042245;
    new_Skin.M416_pink = 1010042246;
    new_Skin.M416_lazer = 1010042247;
    new_Skin.M416_thumb = 1010042242;
    }
    if (preferences.Config.Skin.M416 == 13) {
    new_Skin.M4169 = 1101004151;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 14) {
    new_Skin.M4169 = 1101004089;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 15) {
    new_Skin.M4169 = 1101004034;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 16) {
    new_Skin.M4169 = 1101004002;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 17) {
    new_Skin.M4169 = 1101004227;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }

    if (preferences.Config.Skin.M416 == 18) {
    new_Skin.M4169 = 1101004154;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M416 == 0) {
    new_Skin.M4162 = 1010045;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 1) {
    new_Skin.M4162 = 1101004236;        // Skin chính
    new_Skin.M416_2 = 1010042271;        // Đạn
    new_Skin.M416_3 = 1010042272;        // Ống ngắm chính
    new_Skin.M416_4 = 1010042273;        // Báng súng

    // Nòng
    new_Skin.M416_flash = 1010042307;
    new_Skin.M416_compe = 1010042306;
    new_Skin.M416_silent = 1010042308;

    // Ống ngắm
    new_Skin.M416_reddot = 1010042299;
    new_Skin.M416_holo = 1010042298;
    new_Skin.M416_x2 = 1010042297;
    new_Skin.M416_x3 = 1010042296;
    new_Skin.M416_x4 = 1010042295;
    new_Skin.M416_x6 = 1010042294;

    // Băng đạn
    new_Skin.M416_quickMag = 1010042304;
    new_Skin.M416_extendedMag = 1010042300;
    new_Skin.M416_quickNextended = 1010042305;

    // Tay cầm
    new_Skin.M416_verical = 1010042314;
    new_Skin.M416_angle = 1010042309;
    new_Skin.M416_thumb = 1010042310;
    new_Skin.M416_lightgrip = 1010042316;
    new_Skin.M416_pink = 1010042317;

    // Khác
    new_Skin.M416_stock = 1010042315;    // Báng súng
    new_Skin.M416_lazer = 1010042318;    // Laser
    }

    if (preferences.Config.Skin.M416 == 2) {
    new_Skin.M4162 = 1101004046;
    new_Skin.M416_2 = 1010040461;
    new_Skin.M416_3 = 1010040462;
    new_Skin.M416_4 = 1010040463;
    new_Skin.M416_flash = 1010040474;
    new_Skin.M416_compe = 1010040475;
    new_Skin.M416_silent = 1010040476;
    new_Skin.M416_reddot = 1010040470;
    new_Skin.M416_holo = 1010040469;
    new_Skin.M416_x2 = 1010040468;
    new_Skin.M416_x3 = 1010040467;
    new_Skin.M416_x4 = 1010040466;
    new_Skin.M416_x6 = 1010040481;
    new_Skin.M416_quickMag = 1010040471;
    new_Skin.M416_extendedMag = 1010040472;
    new_Skin.M416_quickNextended = 1010040473;
    new_Skin.M416_stock = 1010040480;
    new_Skin.M416_verical = 1010040479;
    new_Skin.M416_thumb = 1010040478;
    new_Skin.M416_angle = 1010040477;
    new_Skin.M416_lightgrip = 1010040482;
    new_Skin.M416_pink = 1010040483;
    new_Skin.M416_lazer = 1010040484;
    }
    if (preferences.Config.Skin.M416 == 3) {
    new_Skin.M4162 = 1101004218;
    new_Skin.M416_2 = 1010042153;
    new_Skin.M416_3 = 1010042163;
    new_Skin.M416_4 = 1010042173;
    new_Skin.M416_flash = 1010042128;
    new_Skin.M416_compe = 1010042127;
    new_Skin.M416_silent = 1010042129;
    new_Skin.M416_reddot = 1010042119;
    new_Skin.M416_holo = 1010042118;
    new_Skin.M416_x2 = 1010042117;
    new_Skin.M416_x3 = 1010042116;
    new_Skin.M416_x4 = 1010042115;
    new_Skin.M416_x6 = 1010042114;
    new_Skin.M416_quickMag = 1010042124;
    new_Skin.M416_extendedMag = 1010042125;
    new_Skin.M416_quickNextended = 1010042126;
    new_Skin.M416_stock = 1010042137;
    new_Skin.M416_verical = 1010042136;
    new_Skin.M416_angle = 1010042134;
    new_Skin.M416_lightgrip = 1010042138;
    new_Skin.M416_pink = 1010042139;
    new_Skin.M416_lazer = 1010042144;
    new_Skin.M416_thumb = 1010042135;
    }
    if (preferences.Config.Skin.M416 == 4) {
    new_Skin.M4162 = 1101004078;
    new_Skin.M416_2 = 1010040781;
    new_Skin.M416_3 = 1010040782;
    new_Skin.M416_4 = 1010040783;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 5) {
    new_Skin.M4162 = 1101004086;
    new_Skin.M416_2 = 1010040861;
    new_Skin.M416_3 = 1010040862;
    new_Skin.M416_4 = 1010040863;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 6) {
    new_Skin.M4162 = 1101004098;
    new_Skin.M416_2 = 1010040981;
    new_Skin.M416_3 = 1010040982;
    new_Skin.M416_4 = 1010040983;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 7) {
    new_Skin.M4162 = 1101004138;
    new_Skin.M416_2 = 1010041381;
    new_Skin.M416_3 = 1010041382;
    new_Skin.M416_4 = 1010041383;
    new_Skin.M416_flash = 1010041136;
    new_Skin.M416_compe = 1010041137;
    new_Skin.M416_silent = 1010041138;
    new_Skin.M416_reddot = 1010041128;
    new_Skin.M416_holo = 1010041127;
    new_Skin.M416_x2 = 1010041126;
    new_Skin.M416_x3 = 1010041125;
    new_Skin.M416_x4 = 1010041124;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 1010041134;
    new_Skin.M416_extendedMag = 1010041129;
    new_Skin.M416_quickNextended = 1010041135;
    new_Skin.M416_stock = 1010041146;
    new_Skin.M416_verical = 1010041145;
    new_Skin.M416_angle = 1010041139;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 8) {
    new_Skin.M4162 = 1101004163;
    new_Skin.M416_2 = 1010041631;
    new_Skin.M416_3 = 1010041632;
    new_Skin.M416_4 = 1010041633;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 1010041574;
    new_Skin.M416_silent = 1010041575;
    new_Skin.M416_reddot = 1010041566;
    new_Skin.M416_holo = 1010041565;
    new_Skin.M416_x2 = 1010041564;
    new_Skin.M416_x3 = 1010041560;
    new_Skin.M416_x4 = 1010041554;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 1010041568;
    new_Skin.M416_extendedMag = 1010041569;
    new_Skin.M416_quickNextended = 1010041567;
    new_Skin.M416_stock = 1010041579;
    new_Skin.M416_verical = 1010041578;
    new_Skin.M416_angle = 1010041576;
    new_Skin.M416_lightgrip = 20200400;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 1010041577;
    }
    if (preferences.Config.Skin.M416 == 9) {
    new_Skin.M4162 = 1101004201;
    new_Skin.M416_2 = 1010042011;
    new_Skin.M416_3 = 1010042012;
    new_Skin.M416_4 = 1010042013;
    new_Skin.M416_flash = 1010041956;
    new_Skin.M416_compe = 1010041957;
    new_Skin.M416_silent = 1010041958;
    new_Skin.M416_reddot = 1010041948;
    new_Skin.M416_holo = 1010041947;
    new_Skin.M416_x2 = 1010041946;
    new_Skin.M416_x3 = 1010041945;
    new_Skin.M416_x4 = 1010041944;
    new_Skin.M416_x6 = 1010041967;
    new_Skin.M416_quickMag = 1010041949;
    new_Skin.M416_extendedMag = 1010041950;
    new_Skin.M416_quickNextended = 1010041955;
    new_Skin.M416_stock = 1010041966;
    new_Skin.M416_verical = 1010041965;
    new_Skin.M416_angle = 1010041959;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 10) {
    new_Skin.M4162 = 1101004209;
    new_Skin.M416_2 = 1010042073;
    new_Skin.M416_3 = 1010042083;
    new_Skin.M416_4 = 1010042093;
    new_Skin.M416_flash = 20101000;
    new_Skin.M416_compe = 1010042037;
    new_Skin.M416_silent = 1010042039;
    new_Skin.M416_reddot = 1010042029;
    new_Skin.M416_holo = 1010042028;
    new_Skin.M416_x2 = 1010042027;
    new_Skin.M416_x3 = 1010042026;
    new_Skin.M416_x4 = 1010042025;
    new_Skin.M416_x6 = 1010042024;
    new_Skin.M416_quickMag = 1010042034;
    new_Skin.M416_extendedMag = 1010042035;
    new_Skin.M416_quickNextended = 1010042036;
    new_Skin.M416_stock = 1010042047;
    new_Skin.M416_verical = 1010042046;
    new_Skin.M416_angle = 1010042044;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 11) {
    new_Skin.M4162 = 1101004062;
    new_Skin.M416_2 = 1010040011;
    new_Skin.M416_3 = 1010040012;
    new_Skin.M416_4 = 1010040613;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;      
    }
    if (preferences.Config.Skin.M416 == 12) {
    new_Skin.M4162 = 1101004226;
    new_Skin.M416_2 = 1010042214;
    new_Skin.M416_3 = 1010042215;
    new_Skin.M416_4 = 1010042216;
    new_Skin.M416_flash = 1010042238;
    new_Skin.M416_compe = 1010042237;
    new_Skin.M416_silent = 1010042239;
    new_Skin.M416_reddot = 1010042233;
    new_Skin.M416_holo = 1010042232;
    new_Skin.M416_x2 = 1010042231;
    new_Skin.M416_x3 = 1010042219;
    new_Skin.M416_x4 = 1010042218;
    new_Skin.M416_x6 = 1010042217;
    new_Skin.M416_quickMag = 1010042235;
    new_Skin.M416_extendedMag = 1010042234;
    new_Skin.M416_quickNextended = 1010042236;
    new_Skin.M416_stock = 1010042244;
    new_Skin.M416_verical = 1010042243;
    new_Skin.M416_angle = 1010042241;
    new_Skin.M416_lightgrip = 1010042245;
    new_Skin.M416_pink = 1010042246;
    new_Skin.M416_lazer = 1010042247;
    new_Skin.M416_thumb = 1010042242;
    }
    if (preferences.Config.Skin.M416 == 13) {
    new_Skin.M4162 = 1101004151;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 14) {
    new_Skin.M4162 = 1101004089;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 15) {
    new_Skin.M4162 = 1101004034;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 16) {
    new_Skin.M4162 = 1101004002;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 17) {
    new_Skin.M4162 = 1101004227;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }

    if (preferences.Config.Skin.M416 == 18) {
    new_Skin.M4162 = 1101004154;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M416 == 0) {
    new_Skin.M4163 = 1010046;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 1) {
    new_Skin.M4163 = 1101004236;        // Skin chính
    new_Skin.M416_2 = 1010042271;        // Đạn
    new_Skin.M416_3 = 1010042272;        // Ống ngắm chính
    new_Skin.M416_4 = 1010042273;        // Báng súng

    // Nòng
    new_Skin.M416_flash = 1010042307;
    new_Skin.M416_compe = 1010042306;
    new_Skin.M416_silent = 1010042308;

    // Ống ngắm
    new_Skin.M416_reddot = 1010042299;
    new_Skin.M416_holo = 1010042298;
    new_Skin.M416_x2 = 1010042297;
    new_Skin.M416_x3 = 1010042296;
    new_Skin.M416_x4 = 1010042295;
    new_Skin.M416_x6 = 1010042294;

    // Băng đạn
    new_Skin.M416_quickMag = 1010042304;
    new_Skin.M416_extendedMag = 1010042300;
    new_Skin.M416_quickNextended = 1010042305;

    // Tay cầm
    new_Skin.M416_verical = 1010042314;
    new_Skin.M416_angle = 1010042309;
    new_Skin.M416_thumb = 1010042310;
    new_Skin.M416_lightgrip = 1010042316;
    new_Skin.M416_pink = 1010042317;

    // Khác
    new_Skin.M416_stock = 1010042315;    // Báng súng
    new_Skin.M416_lazer = 1010042318;    // Laser
    }

    if (preferences.Config.Skin.M416 == 2) {
    new_Skin.M4163 = 1101004046;
    new_Skin.M416_2 = 1010040461;
    new_Skin.M416_3 = 1010040462;
    new_Skin.M416_4 = 1010040463;
    new_Skin.M416_flash = 1010040474;
    new_Skin.M416_compe = 1010040475;
    new_Skin.M416_silent = 1010040476;
    new_Skin.M416_reddot = 1010040470;
    new_Skin.M416_holo = 1010040469;
    new_Skin.M416_x2 = 1010040468;
    new_Skin.M416_x3 = 1010040467;
    new_Skin.M416_x4 = 1010040466;
    new_Skin.M416_x6 = 1010040481;
    new_Skin.M416_quickMag = 1010040471;
    new_Skin.M416_extendedMag = 1010040472;
    new_Skin.M416_quickNextended = 1010040473;
    new_Skin.M416_stock = 1010040480;
    new_Skin.M416_verical = 1010040479;
    new_Skin.M416_thumb = 1010040478;
    new_Skin.M416_angle = 1010040477;
    new_Skin.M416_lightgrip = 1010040482;
    new_Skin.M416_pink = 1010040483;
    new_Skin.M416_lazer = 1010040484;
    }
    if (preferences.Config.Skin.M416 == 3) {
    new_Skin.M4163 = 1101004218;
    new_Skin.M416_2 = 1010042153;
    new_Skin.M416_3 = 1010042163;
    new_Skin.M416_4 = 1010042173;
    new_Skin.M416_flash = 1010042128;
    new_Skin.M416_compe = 1010042127;
    new_Skin.M416_silent = 1010042129;
    new_Skin.M416_reddot = 1010042119;
    new_Skin.M416_holo = 1010042118;
    new_Skin.M416_x2 = 1010042117;
    new_Skin.M416_x3 = 1010042116;
    new_Skin.M416_x4 = 1010042115;
    new_Skin.M416_x6 = 1010042114;
    new_Skin.M416_quickMag = 1010042124;
    new_Skin.M416_extendedMag = 1010042125;
    new_Skin.M416_quickNextended = 1010042126;
    new_Skin.M416_stock = 1010042137;
    new_Skin.M416_verical = 1010042136;
    new_Skin.M416_angle = 1010042134;
    new_Skin.M416_lightgrip = 1010042138;
    new_Skin.M416_pink = 1010042139;
    new_Skin.M416_lazer = 1010042144;
    new_Skin.M416_thumb = 1010042135;
    }
    if (preferences.Config.Skin.M416 == 4) {
    new_Skin.M4163 = 1101004078;
    new_Skin.M416_2 = 1010040781;
    new_Skin.M416_3 = 1010040782;
    new_Skin.M416_4 = 1010040783;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 5) {
    new_Skin.M4163 = 1101004086;
    new_Skin.M416_2 = 1010040861;
    new_Skin.M416_3 = 1010040862;
    new_Skin.M416_4 = 1010040863;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 6) {
    new_Skin.M4163 = 1101004098;
    new_Skin.M416_2 = 1010040981;
    new_Skin.M416_3 = 1010040982;
    new_Skin.M416_4 = 1010040983;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 7) {
    new_Skin.M4163 = 1101004138;
    new_Skin.M416_2 = 1010041381;
    new_Skin.M416_3 = 1010041382;
    new_Skin.M416_4 = 1010041383;
    new_Skin.M416_flash = 1010041136;
    new_Skin.M416_compe = 1010041137;
    new_Skin.M416_silent = 1010041138;
    new_Skin.M416_reddot = 1010041128;
    new_Skin.M416_holo = 1010041127;
    new_Skin.M416_x2 = 1010041126;
    new_Skin.M416_x3 = 1010041125;
    new_Skin.M416_x4 = 1010041124;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 1010041134;
    new_Skin.M416_extendedMag = 1010041129;
    new_Skin.M416_quickNextended = 1010041135;
    new_Skin.M416_stock = 1010041146;
    new_Skin.M416_verical = 1010041145;
    new_Skin.M416_angle = 1010041139;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 8) {
    new_Skin.M4163 = 1101004163;
    new_Skin.M416_2 = 1010041631;
    new_Skin.M416_3 = 1010041632;
    new_Skin.M416_4 = 1010041633;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 1010041574;
    new_Skin.M416_silent = 1010041575;
    new_Skin.M416_reddot = 1010041566;
    new_Skin.M416_holo = 1010041565;
    new_Skin.M416_x2 = 1010041564;
    new_Skin.M416_x3 = 1010041560;
    new_Skin.M416_x4 = 1010041554;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 1010041568;
    new_Skin.M416_extendedMag = 1010041569;
    new_Skin.M416_quickNextended = 1010041567;
    new_Skin.M416_stock = 1010041579;
    new_Skin.M416_verical = 1010041578;
    new_Skin.M416_angle = 1010041576;
    new_Skin.M416_lightgrip = 20200400;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 1010041577;
    }
    if (preferences.Config.Skin.M416 == 9) {
    new_Skin.M4163 = 1101004201;
    new_Skin.M416_2 = 1010042011;
    new_Skin.M416_3 = 1010042012;
    new_Skin.M416_4 = 1010042013;
    new_Skin.M416_flash = 1010041956;
    new_Skin.M416_compe = 1010041957;
    new_Skin.M416_silent = 1010041958;
    new_Skin.M416_reddot = 1010041948;
    new_Skin.M416_holo = 1010041947;
    new_Skin.M416_x2 = 1010041946;
    new_Skin.M416_x3 = 1010041945;
    new_Skin.M416_x4 = 1010041944;
    new_Skin.M416_x6 = 1010041967;
    new_Skin.M416_quickMag = 1010041949;
    new_Skin.M416_extendedMag = 1010041950;
    new_Skin.M416_quickNextended = 1010041955;
    new_Skin.M416_stock = 1010041966;
    new_Skin.M416_verical = 1010041965;
    new_Skin.M416_angle = 1010041959;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 10) {
    new_Skin.M4163 = 1101004209;
    new_Skin.M416_2 = 1010042073;
    new_Skin.M416_3 = 1010042083;
    new_Skin.M416_4 = 1010042093;
    new_Skin.M416_flash = 20101000;
    new_Skin.M416_compe = 1010042037;
    new_Skin.M416_silent = 1010042039;
    new_Skin.M416_reddot = 1010042029;
    new_Skin.M416_holo = 1010042028;
    new_Skin.M416_x2 = 1010042027;
    new_Skin.M416_x3 = 1010042026;
    new_Skin.M416_x4 = 1010042025;
    new_Skin.M416_x6 = 1010042024;
    new_Skin.M416_quickMag = 1010042034;
    new_Skin.M416_extendedMag = 1010042035;
    new_Skin.M416_quickNextended = 1010042036;
    new_Skin.M416_stock = 1010042047;
    new_Skin.M416_verical = 1010042046;
    new_Skin.M416_angle = 1010042044;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 11) {
    new_Skin.M4163 = 1101004062;
    new_Skin.M416_2 = 1010040011;
    new_Skin.M416_3 = 1010040012;
    new_Skin.M416_4 = 1010040613;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;      
    }
    if (preferences.Config.Skin.M416 == 12) {
    new_Skin.M4163 = 1101004226;
    new_Skin.M416_2 = 1010042214;
    new_Skin.M416_3 = 1010042215;
    new_Skin.M416_4 = 1010042216;
    new_Skin.M416_flash = 1010042238;
    new_Skin.M416_compe = 1010042237;
    new_Skin.M416_silent = 1010042239;
    new_Skin.M416_reddot = 1010042233;
    new_Skin.M416_holo = 1010042232;
    new_Skin.M416_x2 = 1010042231;
    new_Skin.M416_x3 = 1010042219;
    new_Skin.M416_x4 = 1010042218;
    new_Skin.M416_x6 = 1010042217;
    new_Skin.M416_quickMag = 1010042235;
    new_Skin.M416_extendedMag = 1010042234;
    new_Skin.M416_quickNextended = 1010042236;
    new_Skin.M416_stock = 1010042244;
    new_Skin.M416_verical = 1010042243;
    new_Skin.M416_angle = 1010042241;
    new_Skin.M416_lightgrip = 1010042245;
    new_Skin.M416_pink = 1010042246;
    new_Skin.M416_lazer = 1010042247;
    new_Skin.M416_thumb = 1010042242;
    }
    if (preferences.Config.Skin.M416 == 13) {
    new_Skin.M4163 = 1101004151;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 14) {
    new_Skin.M4163 = 1101004089;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 15) {
    new_Skin.M4163 = 1101004034;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 16) {
    new_Skin.M4163 = 1101004002;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 17) {
    new_Skin.M4163 = 1101004227;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }

    if (preferences.Config.Skin.M416 == 18) {
    new_Skin.M4163 = 1101004154;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M416 == 0) {
    new_Skin.M4164 = 1010047;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 1) {
    new_Skin.M4164 = 1101004236;        // Skin chính
    new_Skin.M416_2 = 1010042271;        // Đạn
    new_Skin.M416_3 = 1010042272;        // Ống ngắm chính
    new_Skin.M416_4 = 1010042273;        // Báng súng

    // Nòng
    new_Skin.M416_flash = 1010042307;
    new_Skin.M416_compe = 1010042306;
    new_Skin.M416_silent = 1010042308;

    // Ống ngắm
    new_Skin.M416_reddot = 1010042299;
    new_Skin.M416_holo = 1010042298;
    new_Skin.M416_x2 = 1010042297;
    new_Skin.M416_x3 = 1010042296;
    new_Skin.M416_x4 = 1010042295;
    new_Skin.M416_x6 = 1010042294;

    // Băng đạn
    new_Skin.M416_quickMag = 1010042304;
    new_Skin.M416_extendedMag = 1010042300;
    new_Skin.M416_quickNextended = 1010042305;

    // Tay cầm
    new_Skin.M416_verical = 1010042314;
    new_Skin.M416_angle = 1010042309;
    new_Skin.M416_thumb = 1010042310;
    new_Skin.M416_lightgrip = 1010042316;
    new_Skin.M416_pink = 1010042317;

    // Khác
    new_Skin.M416_stock = 1010042315;    // Báng súng
    new_Skin.M416_lazer = 1010042318;    // Laser
    }

    if (preferences.Config.Skin.M416 == 2) {
    new_Skin.M4164 = 1101004046;
    new_Skin.M416_2 = 1010040461;
    new_Skin.M416_3 = 1010040462;
    new_Skin.M416_4 = 1010040463;
    new_Skin.M416_flash = 1010040474;
    new_Skin.M416_compe = 1010040475;
    new_Skin.M416_silent = 1010040476;
    new_Skin.M416_reddot = 1010040470;
    new_Skin.M416_holo = 1010040469;
    new_Skin.M416_x2 = 1010040468;
    new_Skin.M416_x3 = 1010040467;
    new_Skin.M416_x4 = 1010040466;
    new_Skin.M416_x6 = 1010040481;
    new_Skin.M416_quickMag = 1010040471;
    new_Skin.M416_extendedMag = 1010040472;
    new_Skin.M416_quickNextended = 1010040473;
    new_Skin.M416_stock = 1010040480;
    new_Skin.M416_verical = 1010040479;
    new_Skin.M416_thumb = 1010040478;
    new_Skin.M416_angle = 1010040477;
    new_Skin.M416_lightgrip = 1010040482;
    new_Skin.M416_pink = 1010040483;
    new_Skin.M416_lazer = 1010040484;
    }
    if (preferences.Config.Skin.M416 == 3) {
    new_Skin.M4164 = 1101004218;
    new_Skin.M416_2 = 1010042153;
    new_Skin.M416_3 = 1010042163;
    new_Skin.M416_4 = 1010042173;
    new_Skin.M416_flash = 1010042128;
    new_Skin.M416_compe = 1010042127;
    new_Skin.M416_silent = 1010042129;
    new_Skin.M416_reddot = 1010042119;
    new_Skin.M416_holo = 1010042118;
    new_Skin.M416_x2 = 1010042117;
    new_Skin.M416_x3 = 1010042116;
    new_Skin.M416_x4 = 1010042115;
    new_Skin.M416_x6 = 1010042114;
    new_Skin.M416_quickMag = 1010042124;
    new_Skin.M416_extendedMag = 1010042125;
    new_Skin.M416_quickNextended = 1010042126;
    new_Skin.M416_stock = 1010042137;
    new_Skin.M416_verical = 1010042136;
    new_Skin.M416_angle = 1010042134;
    new_Skin.M416_lightgrip = 1010042138;
    new_Skin.M416_pink = 1010042139;
    new_Skin.M416_lazer = 1010042144;
    new_Skin.M416_thumb = 1010042135;
    }
    if (preferences.Config.Skin.M416 == 4) {
    new_Skin.M4164 = 1101004078;
    new_Skin.M416_2 = 1010040781;
    new_Skin.M416_3 = 1010040782;
    new_Skin.M416_4 = 1010040783;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 5) {
    new_Skin.M4164 = 1101004086;
    new_Skin.M416_2 = 1010040861;
    new_Skin.M416_3 = 1010040862;
    new_Skin.M416_4 = 1010040863;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 6) {
    new_Skin.M4164 = 1101004098;
    new_Skin.M416_2 = 1010040981;
    new_Skin.M416_3 = 1010040982;
    new_Skin.M416_4 = 1010040983;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 7) {
    new_Skin.M4164 = 1101004138;
    new_Skin.M416_2 = 1010041381;
    new_Skin.M416_3 = 1010041382;
    new_Skin.M416_4 = 1010041383;
    new_Skin.M416_flash = 1010041136;
    new_Skin.M416_compe = 1010041137;
    new_Skin.M416_silent = 1010041138;
    new_Skin.M416_reddot = 1010041128;
    new_Skin.M416_holo = 1010041127;
    new_Skin.M416_x2 = 1010041126;
    new_Skin.M416_x3 = 1010041125;
    new_Skin.M416_x4 = 1010041124;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 1010041134;
    new_Skin.M416_extendedMag = 1010041129;
    new_Skin.M416_quickNextended = 1010041135;
    new_Skin.M416_stock = 1010041146;
    new_Skin.M416_verical = 1010041145;
    new_Skin.M416_angle = 1010041139;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 8) {
    new_Skin.M4164 = 1101004163;
    new_Skin.M416_2 = 1010041631;
    new_Skin.M416_3 = 1010041632;
    new_Skin.M416_4 = 1010041633;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 1010041574;
    new_Skin.M416_silent = 1010041575;
    new_Skin.M416_reddot = 1010041566;
    new_Skin.M416_holo = 1010041565;
    new_Skin.M416_x2 = 1010041564;
    new_Skin.M416_x3 = 1010041560;
    new_Skin.M416_x4 = 1010041554;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 1010041568;
    new_Skin.M416_extendedMag = 1010041569;
    new_Skin.M416_quickNextended = 1010041567;
    new_Skin.M416_stock = 1010041579;
    new_Skin.M416_verical = 1010041578;
    new_Skin.M416_angle = 1010041576;
    new_Skin.M416_lightgrip = 20200400;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 1010041577;
    }
    if (preferences.Config.Skin.M416 == 9) {
    new_Skin.M4164 = 1101004201;
    new_Skin.M416_2 = 1010042011;
    new_Skin.M416_3 = 1010042012;
    new_Skin.M416_4 = 1010042013;
    new_Skin.M416_flash = 1010041956;
    new_Skin.M416_compe = 1010041957;
    new_Skin.M416_silent = 1010041958;
    new_Skin.M416_reddot = 1010041948;
    new_Skin.M416_holo = 1010041947;
    new_Skin.M416_x2 = 1010041946;
    new_Skin.M416_x3 = 1010041945;
    new_Skin.M416_x4 = 1010041944;
    new_Skin.M416_x6 = 1010041967;
    new_Skin.M416_quickMag = 1010041949;
    new_Skin.M416_extendedMag = 1010041950;
    new_Skin.M416_quickNextended = 1010041955;
    new_Skin.M416_stock = 1010041966;
    new_Skin.M416_verical = 1010041965;
    new_Skin.M416_angle = 1010041959;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 10) {
    new_Skin.M4164 = 1101004209;
    new_Skin.M416_2 = 1010042073;
    new_Skin.M416_3 = 1010042083;
    new_Skin.M416_4 = 1010042093;
    new_Skin.M416_flash = 20101000;
    new_Skin.M416_compe = 1010042037;
    new_Skin.M416_silent = 1010042039;
    new_Skin.M416_reddot = 1010042029;
    new_Skin.M416_holo = 1010042028;
    new_Skin.M416_x2 = 1010042027;
    new_Skin.M416_x3 = 1010042026;
    new_Skin.M416_x4 = 1010042025;
    new_Skin.M416_x6 = 1010042024;
    new_Skin.M416_quickMag = 1010042034;
    new_Skin.M416_extendedMag = 1010042035;
    new_Skin.M416_quickNextended = 1010042036;
    new_Skin.M416_stock = 1010042047;
    new_Skin.M416_verical = 1010042046;
    new_Skin.M416_angle = 1010042044;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 11) {
    new_Skin.M4164 = 1101004062;
    new_Skin.M416_2 = 1010040011;
    new_Skin.M416_3 = 1010040012;
    new_Skin.M416_4 = 1010040613;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 202002;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 202007;
    new_Skin.M416_thumb = 202006;      
    }
    if (preferences.Config.Skin.M416 == 12) {
    new_Skin.M4164 = 1101004226;
    new_Skin.M416_2 = 1010042214;
    new_Skin.M416_3 = 1010042215;
    new_Skin.M416_4 = 1010042216;
    new_Skin.M416_flash = 1010042238;
    new_Skin.M416_compe = 1010042237;
    new_Skin.M416_silent = 1010042239;
    new_Skin.M416_reddot = 1010042233;
    new_Skin.M416_holo = 1010042232;
    new_Skin.M416_x2 = 1010042231;
    new_Skin.M416_x3 = 1010042219;
    new_Skin.M416_x4 = 1010042218;
    new_Skin.M416_x6 = 1010042217;
    new_Skin.M416_quickMag = 1010042235;
    new_Skin.M416_extendedMag = 1010042234;
    new_Skin.M416_quickNextended = 1010042236;
    new_Skin.M416_stock = 1010042244;
    new_Skin.M416_verical = 1010042243;
    new_Skin.M416_angle = 1010042241;
    new_Skin.M416_lightgrip = 1010042245;
    new_Skin.M416_pink = 1010042246;
    new_Skin.M416_lazer = 1010042247;
    new_Skin.M416_thumb = 1010042242;
    }
    if (preferences.Config.Skin.M416 == 13) {
    new_Skin.M4164 = 1101004151;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 14) {
    new_Skin.M4164 = 1101004089;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 15) {
    new_Skin.M4164 = 1101004034;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 16) {
    new_Skin.M4164 = 1101004002;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
    if (preferences.Config.Skin.M416 == 17) {
    new_Skin.M4164 = 1101004227;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }

    if (preferences.Config.Skin.M416 == 18) {
    new_Skin.M4164 = 1101004154;
    new_Skin.M416_2 = 291004;
    new_Skin.M416_3 = 203008;
    new_Skin.M416_4 = 205005;
    new_Skin.M416_flash = 201010;
    new_Skin.M416_compe = 201009;
    new_Skin.M416_silent = 201011;
    new_Skin.M416_reddot = 203001;
    new_Skin.M416_holo = 203002;
    new_Skin.M416_x2 = 203003;
    new_Skin.M416_x3 = 203014;
    new_Skin.M416_x4 = 203004;
    new_Skin.M416_x6 = 203015;
    new_Skin.M416_quickMag = 204012;
    new_Skin.M416_extendedMag = 204011;
    new_Skin.M416_quickNextended = 204013;
    new_Skin.M416_stock = 205002;
    new_Skin.M416_verical = 203015;
    new_Skin.M416_angle = 202001;
    new_Skin.M416_lightgrip = 202004;
    new_Skin.M416_pink = 202005;
    new_Skin.M416_lazer = 203015;
    new_Skin.M416_thumb = 202006;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.Groza == 0) {
    new_Skin.Groza = 101005;
    new_Skin.Groza_2 = 291005;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 1) {
    new_Skin.Groza = 1101005098;

    // Băng đạn
    new_Skin.Groza_quickMag = 1010050930;
    new_Skin.Groza_extendedMag = 1010050929;
    new_Skin.Groza_quickNextended = 1010050932;

    // Ống ngắm
    new_Skin.Groza_reddot = 1010050927;
    new_Skin.Groza_holo = 1010050926;
    new_Skin.Groza_x2 = 1010050925;
    new_Skin.Groza_x3 = 1010050924;
    new_Skin.Groza_x4 = 1010050923;
    new_Skin.Groza_x6 = 1010050922;

    // Nòng
    new_Skin.Groza_silent = 1010050928;
    }

    if (preferences.Config.Skin.Groza == 2) {
    new_Skin.Groza = 1101005038;
    new_Skin.Groza_2 = 1010050381;
    new_Skin.Groza_silent = 1010050327;
    new_Skin.Groza_reddot = 1010050326;
    new_Skin.Groza_holo = 1010050325;
    new_Skin.Groza_x2 = 1010050324;
    new_Skin.Groza_x3 = 1010050323;
    new_Skin.Groza_x4 = 1010050322;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 1010050328;
    new_Skin.Groza_extendedMag = 1010050329;
    new_Skin.Groza_quickNextended = 1010050330;
    }
    if (preferences.Config.Skin.Groza == 3) {
    new_Skin.Groza = 1101005052;
    new_Skin.Groza_2 = 1010050521;
    new_Skin.Groza_silent = 1010050467;
    new_Skin.Groza_reddot = 1010050466;
    new_Skin.Groza_holo = 1010050465;
    new_Skin.Groza_x2 = 1010050464;
    new_Skin.Groza_x3 = 1010050463;
    new_Skin.Groza_x4 = 1010050462;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 1010050468;
    new_Skin.Groza_extendedMag = 1010050469;
    new_Skin.Groza_quickNextended = 1010050470;
    }
    if (preferences.Config.Skin.Groza == 4) {
    new_Skin.Groza = 1101005082;
    new_Skin.Groza_2 = 1010050821;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 5) {
    new_Skin.Groza = 1101005019;
    new_Skin.Groza_2 = 1010050191;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 6) {
    new_Skin.Groza = 1101005025;
    new_Skin.Groza_2 = 1010050251;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 7) {
    new_Skin.Groza = 1101005043;
    new_Skin.Groza_2 = 1010050431;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.Groza == 0) {
    new_Skin.Groza1 = 1010052;
  }
  if (preferences.Config.Skin.Groza == 1) {
    new_Skin.Groza1 = 1101005019;
  }
  if (preferences.Config.Skin.Groza == 2) {
    new_Skin.Groza1 = 1101005025;
  }
  if (preferences.Config.Skin.Groza == 3) {
    new_Skin.Groza1 = 1101005038;
  }
  if (preferences.Config.Skin.Groza == 4) {
    new_Skin.Groza1 = 1101005043;
  }
  if (preferences.Config.Skin.Groza == 5) {
    new_Skin.Groza1 = 1101005052;
  }
  if (preferences.Config.Skin.Groza == 6) {
    new_Skin.Groza1 = 1101005082;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.Groza == 0) {
    new_Skin.Groza2 = 1010053;
    new_Skin.Groza_2 = 291005;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 1) {
    new_Skin.Groza2 = 1101005098;

    // Băng đạn
    new_Skin.Groza_quickMag = 1010050930;
    new_Skin.Groza_extendedMag = 1010050929;
    new_Skin.Groza_quickNextended = 1010050932;

    // Ống ngắm
    new_Skin.Groza_reddot = 1010050927;
    new_Skin.Groza_holo = 1010050926;
    new_Skin.Groza_x2 = 1010050925;
    new_Skin.Groza_x3 = 1010050924;
    new_Skin.Groza_x4 = 1010050923;
    new_Skin.Groza_x6 = 1010050922;

    // Nòng
    new_Skin.Groza_silent = 1010050928;
    }

    if (preferences.Config.Skin.Groza == 2) {
    new_Skin.Groza2 = 1101005038;
    new_Skin.Groza_2 = 1010050381;
    new_Skin.Groza_silent = 1010050327;
    new_Skin.Groza_reddot = 1010050326;
    new_Skin.Groza_holo = 1010050325;
    new_Skin.Groza_x2 = 1010050324;
    new_Skin.Groza_x3 = 1010050323;
    new_Skin.Groza_x4 = 1010050322;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 1010050328;
    new_Skin.Groza_extendedMag = 1010050329;
    new_Skin.Groza_quickNextended = 1010050330;
    }
    if (preferences.Config.Skin.Groza == 3) {
    new_Skin.Groza2 = 1101005052;
    new_Skin.Groza_2 = 1010050521;
    new_Skin.Groza_silent = 1010050467;
    new_Skin.Groza_reddot = 1010050466;
    new_Skin.Groza_holo = 1010050465;
    new_Skin.Groza_x2 = 1010050464;
    new_Skin.Groza_x3 = 1010050463;
    new_Skin.Groza_x4 = 1010050462;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 1010050468;
    new_Skin.Groza_extendedMag = 1010050469;
    new_Skin.Groza_quickNextended = 1010050470;
    }
    if (preferences.Config.Skin.Groza == 4) {
    new_Skin.Groza2 = 1101005082;
    new_Skin.Groza_2 = 1010050821;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 5) {
    new_Skin.Groza2 = 1101005019;
    new_Skin.Groza_2 = 1010050191;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 6) {
    new_Skin.Groza2 = 1101005025;
    new_Skin.Groza_2 = 1010050251;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 7) {
    new_Skin.Groza2 = 1101005043;
    new_Skin.Groza_2 = 1010050431;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.Groza == 0) {
    new_Skin.Groza3 = 1010054;
    new_Skin.Groza_2 = 291005;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 1) {
    new_Skin.Groza3 = 1101005098;

    // Băng đạn
    new_Skin.Groza_quickMag = 1010050930;
    new_Skin.Groza_extendedMag = 1010050929;
    new_Skin.Groza_quickNextended = 1010050932;

    // Ống ngắm
    new_Skin.Groza_reddot = 1010050927;
    new_Skin.Groza_holo = 1010050926;
    new_Skin.Groza_x2 = 1010050925;
    new_Skin.Groza_x3 = 1010050924;
    new_Skin.Groza_x4 = 1010050923;
    new_Skin.Groza_x6 = 1010050922;

    // Nòng
    new_Skin.Groza_silent = 1010050928;
    }

    if (preferences.Config.Skin.Groza == 2) {
    new_Skin.Groza3 = 1101005038;
    new_Skin.Groza_2 = 1010050381;
    new_Skin.Groza_silent = 1010050327;
    new_Skin.Groza_reddot = 1010050326;
    new_Skin.Groza_holo = 1010050325;
    new_Skin.Groza_x2 = 1010050324;
    new_Skin.Groza_x3 = 1010050323;
    new_Skin.Groza_x4 = 1010050322;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 1010050328;
    new_Skin.Groza_extendedMag = 1010050329;
    new_Skin.Groza_quickNextended = 1010050330;
    }
    if (preferences.Config.Skin.Groza == 3) {
    new_Skin.Groza3 = 1101005052;
    new_Skin.Groza_2 = 1010050521;
    new_Skin.Groza_silent = 1010050467;
    new_Skin.Groza_reddot = 1010050466;
    new_Skin.Groza_holo = 1010050465;
    new_Skin.Groza_x2 = 1010050464;
    new_Skin.Groza_x3 = 1010050463;
    new_Skin.Groza_x4 = 1010050462;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 1010050468;
    new_Skin.Groza_extendedMag = 1010050469;
    new_Skin.Groza_quickNextended = 1010050470;
    }
    if (preferences.Config.Skin.Groza == 4) {
    new_Skin.Groza3 = 1101005082;
    new_Skin.Groza_2 = 1010050821;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 5) {
    new_Skin.Groza3 = 1101005019;
    new_Skin.Groza_2 = 1010050191;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 6) {
    new_Skin.Groza3 = 1101005025;
    new_Skin.Groza_2 = 1010050251;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 7) {
    new_Skin.Groza3 = 1101005043;
    new_Skin.Groza_2 = 1010050431;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.Groza == 0) {
    new_Skin.Groza4 = 1010055;
    new_Skin.Groza_2 = 291005;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 1) {
    new_Skin.Groza4 = 1101005098;

    // Băng đạn
    new_Skin.Groza_quickMag = 1010050930;
    new_Skin.Groza_extendedMag = 1010050929;
    new_Skin.Groza_quickNextended = 1010050932;

    // Ống ngắm
    new_Skin.Groza_reddot = 1010050927;
    new_Skin.Groza_holo = 1010050926;
    new_Skin.Groza_x2 = 1010050925;
    new_Skin.Groza_x3 = 1010050924;
    new_Skin.Groza_x4 = 1010050923;
    new_Skin.Groza_x6 = 1010050922;

    // Nòng
    new_Skin.Groza_silent = 1010050928;
    }

    if (preferences.Config.Skin.Groza == 2) {
    new_Skin.Groza4 = 1101005038;
    new_Skin.Groza_2 = 1010050381;
    new_Skin.Groza_silent = 1010050327;
    new_Skin.Groza_reddot = 1010050326;
    new_Skin.Groza_holo = 1010050325;
    new_Skin.Groza_x2 = 1010050324;
    new_Skin.Groza_x3 = 1010050323;
    new_Skin.Groza_x4 = 1010050322;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 1010050328;
    new_Skin.Groza_extendedMag = 1010050329;
    new_Skin.Groza_quickNextended = 1010050330;
    }
    if (preferences.Config.Skin.Groza == 3) {
    new_Skin.Groza4 = 1101005052;
    new_Skin.Groza_2 = 1010050521;
    new_Skin.Groza_silent = 1010050467;
    new_Skin.Groza_reddot = 1010050466;
    new_Skin.Groza_holo = 1010050465;
    new_Skin.Groza_x2 = 1010050464;
    new_Skin.Groza_x3 = 1010050463;
    new_Skin.Groza_x4 = 1010050462;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 1010050468;
    new_Skin.Groza_extendedMag = 1010050469;
    new_Skin.Groza_quickNextended = 1010050470;
    }
    if (preferences.Config.Skin.Groza == 4) {
    new_Skin.Groza4 = 1101005082;
    new_Skin.Groza_2 = 1010050821;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 5) {
    new_Skin.Groza4 = 1101005019;
    new_Skin.Groza_2 = 1010050191;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 6) {
    new_Skin.Groza4 = 1101005025;
    new_Skin.Groza_2 = 1010050251;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 7) {
    new_Skin.Groza4 = 1101005043;
    new_Skin.Groza_2 = 1010050431;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.Groza == 0) {
    new_Skin.Groza5 = 1010056;
    new_Skin.Groza_2 = 291005;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 1) {
    new_Skin.Groza5 = 1101005098;

    // Băng đạn
    new_Skin.Groza_quickMag = 1010050930;
    new_Skin.Groza_extendedMag = 1010050929;
    new_Skin.Groza_quickNextended = 1010050932;

    // Ống ngắm
    new_Skin.Groza_reddot = 1010050927;
    new_Skin.Groza_holo = 1010050926;
    new_Skin.Groza_x2 = 1010050925;
    new_Skin.Groza_x3 = 1010050924;
    new_Skin.Groza_x4 = 1010050923;
    new_Skin.Groza_x6 = 1010050922;

    // Nòng
    new_Skin.Groza_silent = 1010050928;
    }

    if (preferences.Config.Skin.Groza == 2) {
    new_Skin.Groza5 = 1101005038;
    new_Skin.Groza_2 = 1010050381;
    new_Skin.Groza_silent = 1010050327;
    new_Skin.Groza_reddot = 1010050326;
    new_Skin.Groza_holo = 1010050325;
    new_Skin.Groza_x2 = 1010050324;
    new_Skin.Groza_x3 = 1010050323;
    new_Skin.Groza_x4 = 1010050322;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 1010050328;
    new_Skin.Groza_extendedMag = 1010050329;
    new_Skin.Groza_quickNextended = 1010050330;
    }
    if (preferences.Config.Skin.Groza == 3) {
    new_Skin.Groza5 = 1101005052;
    new_Skin.Groza_2 = 1010050521;
    new_Skin.Groza_silent = 1010050467;
    new_Skin.Groza_reddot = 1010050466;
    new_Skin.Groza_holo = 1010050465;
    new_Skin.Groza_x2 = 1010050464;
    new_Skin.Groza_x3 = 1010050463;
    new_Skin.Groza_x4 = 1010050462;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 1010050468;
    new_Skin.Groza_extendedMag = 1010050469;
    new_Skin.Groza_quickNextended = 1010050470;
    }
    if (preferences.Config.Skin.Groza == 4) {
    new_Skin.Groza5 = 1101005082;
    new_Skin.Groza_2 = 1010050821;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 5) {
    new_Skin.Groza5 = 1101005019;
    new_Skin.Groza_2 = 1010050191;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 6) {
    new_Skin.Groza5 = 1101005025;
    new_Skin.Groza_2 = 1010050251;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 7) {
    new_Skin.Groza5 = 1101005043;
    new_Skin.Groza_2 = 1010050431;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.Groza == 0) {
    new_Skin.Groza6 = 1010057;
    new_Skin.Groza_2 = 291005;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 1) {
    new_Skin.Groza6 = 1101005098;

    // Băng đạn
    new_Skin.Groza_quickMag = 1010050930;
    new_Skin.Groza_extendedMag = 1010050929;
    new_Skin.Groza_quickNextended = 1010050932;

    // Ống ngắm
    new_Skin.Groza_reddot = 1010050927;
    new_Skin.Groza_holo = 1010050926;
    new_Skin.Groza_x2 = 1010050925;
    new_Skin.Groza_x3 = 1010050924;
    new_Skin.Groza_x4 = 1010050923;
    new_Skin.Groza_x6 = 1010050922;

    // Nòng
    new_Skin.Groza_silent = 1010050928;
    }

    if (preferences.Config.Skin.Groza == 2) {
    new_Skin.Groza6 = 1101005038;
    new_Skin.Groza_2 = 1010050381;
    new_Skin.Groza_silent = 1010050327;
    new_Skin.Groza_reddot = 1010050326;
    new_Skin.Groza_holo = 1010050325;
    new_Skin.Groza_x2 = 1010050324;
    new_Skin.Groza_x3 = 1010050323;
    new_Skin.Groza_x4 = 1010050322;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 1010050328;
    new_Skin.Groza_extendedMag = 1010050329;
    new_Skin.Groza_quickNextended = 1010050330;
    }
    if (preferences.Config.Skin.Groza == 3) {
    new_Skin.Groza6 = 1101005052;
    new_Skin.Groza_2 = 1010050521;
    new_Skin.Groza_silent = 1010050467;
    new_Skin.Groza_reddot = 1010050466;
    new_Skin.Groza_holo = 1010050465;
    new_Skin.Groza_x2 = 1010050464;
    new_Skin.Groza_x3 = 1010050463;
    new_Skin.Groza_x4 = 1010050462;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 1010050468;
    new_Skin.Groza_extendedMag = 1010050469;
    new_Skin.Groza_quickNextended = 1010050470;
    }
    if (preferences.Config.Skin.Groza == 4) {
    new_Skin.Groza6 = 1101005082;
    new_Skin.Groza_2 = 1010050821;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 5) {
    new_Skin.Groza6 = 1101005019;
    new_Skin.Groza_2 = 1010050191;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 6) {
    new_Skin.Groza6 = 1101005025;
    new_Skin.Groza_2 = 1010050251;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
    if (preferences.Config.Skin.Groza == 7) {
    new_Skin.Groza6 = 1101005043;
    new_Skin.Groza_2 = 1010050431;
    new_Skin.Groza_silent = 201011;
    new_Skin.Groza_reddot = 203001;
    new_Skin.Groza_holo = 203002;
    new_Skin.Groza_x2 = 203003;
    new_Skin.Groza_x3 = 203014;
    new_Skin.Groza_x4 = 203004;
    new_Skin.Groza_x6 = 203015;
    new_Skin.Groza_quickMag = 204012;
    new_Skin.Groza_extendedMag = 204011;
    new_Skin.Groza_quickNextended = 204013;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.AUG == 0){
    new_Skin.AUG = 101006;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    }

    if (preferences.Config.Skin.AUG == 1) {
        new_Skin.AUG = 1101006085;

        new_Skin.AUG_x6    = 1010060783;
        new_Skin.AUG_x4    = 1010060784;
        new_Skin.AUG_x3    = 1010060785;
        new_Skin.AUG_x2    = 1010060786;
        new_Skin.AUG_holo  = 1010060787;
        new_Skin.AUG_reddot= 1010060788;

        // Băng đạn
        new_Skin.AUG_extendedMag   = 1010060789;
        new_Skin.AUG_quickMag      = 1010060793;
        new_Skin.AUG_quickNextended= 1010060794;

        // Nòng
        new_Skin.AUG_compe  = 1010060795;
        new_Skin.AUG_flash  = 1010060796;
        new_Skin.AUG_silent = 1010060797;

        // Tay cầm
        new_Skin.AUG_angle     = 1010060798;
        new_Skin.AUG_thumb     = 1010060799;
        new_Skin.AUG_verical   = 1010060800;
        new_Skin.AUG_lightgrip = 1010060804;
        // Khác
        new_Skin.AUG_lazer = 1010060803;   // Laser
    }


    if (preferences.Config.Skin.AUG == 2){
    new_Skin.AUG = 1101006062;
    new_Skin.AUG_reddot = 1010060562;
    new_Skin.AUG_holo = 1010060561;
    new_Skin.AUG_x2 = 1010060554;
    new_Skin.AUG_x3 = 1010060553;
    new_Skin.AUG_x4 = 1010060552;
    new_Skin.AUG_x6 = 1010060551;
    new_Skin.AUG_lazer = 1010060574;
    new_Skin.AUG_flash = 1010060571;
    }



    if (preferences.Config.Skin.AUG == 3){
    new_Skin.AUG = 1101006044;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    }
    if (preferences.Config.Skin.AUG == 4){
    new_Skin.AUG = 1101006033;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    new_Skin.AUG_lazer = 202007;
    new_Skin.AUG_flash = 201010;
    }

    if (preferences.Config.Skin.AUG == 5){
    new_Skin.AUG = 1101006075;
    new_Skin.AUG_reddot = 1010060696;
    new_Skin.AUG_holo = 1010060695;
    new_Skin.AUG_x2 = 1010060694;
    new_Skin.AUG_x3 = 1010060693;
    new_Skin.AUG_x4 = 1010060692;
    new_Skin.AUG_x6 = 1010060691;
    new_Skin.AUG_lazer = 1010060707;
    new_Skin.AUG_flash = 1010060699;
    }
    if (preferences.Config.Skin.AUG == 6){
    new_Skin.AUG = 1101006067;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    new_Skin.AUG_lazer = 202007;
    new_Skin.AUG_flash = 201010;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AUG == 0) {
    new_Skin.AUG1 = 1010062;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    }

    if (preferences.Config.Skin.AUG == 1) {
        new_Skin.AUG1 = 1101006085;

        new_Skin.AUG_x6    = 1010060783;
        new_Skin.AUG_x4    = 1010060784;
        new_Skin.AUG_x3    = 1010060785;
        new_Skin.AUG_x2    = 1010060786;
        new_Skin.AUG_holo  = 1010060787;
        new_Skin.AUG_reddot= 1010060788;

        // Băng đạn
        new_Skin.AUG_extendedMag   = 1010060789;
        new_Skin.AUG_quickMag      = 1010060793;
        new_Skin.AUG_quickNextended= 1010060794;

        // Nòng
        new_Skin.AUG_compe  = 1010060795;
        new_Skin.AUG_flash  = 1010060796;
        new_Skin.AUG_silent = 1010060797;

        // Tay cầm
        new_Skin.AUG_angle     = 1010060798;
        new_Skin.AUG_thumb     = 1010060799;
        new_Skin.AUG_verical   = 1010060800;
        new_Skin.AUG_lightgrip = 1010060804;
        // Khác
        new_Skin.AUG_lazer = 1010060803;   // Laser
    }


    if (preferences.Config.Skin.AUG == 2){
    new_Skin.AUG1 = 1101006062;
    new_Skin.AUG_reddot = 1010060562;
    new_Skin.AUG_holo = 1010060561;
    new_Skin.AUG_x2 = 1010060554;
    new_Skin.AUG_x3 = 1010060553;
    new_Skin.AUG_x4 = 1010060552;
    new_Skin.AUG_x6 = 1010060551;
    new_Skin.AUG_lazer = 1010060574;
    new_Skin.AUG_flash = 1010060571;
    }



    if (preferences.Config.Skin.AUG == 3){
    new_Skin.AUG1 = 1101006044;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    }
    if (preferences.Config.Skin.AUG == 4){
    new_Skin.AUG1 = 1101006033;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    new_Skin.AUG_lazer = 202007;
    new_Skin.AUG_flash = 201010;
    }

    if (preferences.Config.Skin.AUG == 5){
    new_Skin.AUG1 = 1101006075;
    new_Skin.AUG_reddot = 1010060696;
    new_Skin.AUG_holo = 1010060695;
    new_Skin.AUG_x2 = 1010060694;
    new_Skin.AUG_x3 = 1010060693;
    new_Skin.AUG_x4 = 1010060692;
    new_Skin.AUG_x6 = 1010060691;
    new_Skin.AUG_lazer = 1010060707;
    new_Skin.AUG_flash = 1010060699;
    }
    if (preferences.Config.Skin.AUG == 6){
    new_Skin.AUG1 = 1101006067;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    new_Skin.AUG_lazer = 202007;
    new_Skin.AUG_flash = 201010;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AUG == 0) {
    new_Skin.AUG2 = 1010063;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    }

    if (preferences.Config.Skin.AUG == 1) {
        new_Skin.AUG2 = 1101006085;

        new_Skin.AUG_x6    = 1010060783;
        new_Skin.AUG_x4    = 1010060784;
        new_Skin.AUG_x3    = 1010060785;
        new_Skin.AUG_x2    = 1010060786;
        new_Skin.AUG_holo  = 1010060787;
        new_Skin.AUG_reddot= 1010060788;

        // Băng đạn
        new_Skin.AUG_extendedMag   = 1010060789;
        new_Skin.AUG_quickMag      = 1010060793;
        new_Skin.AUG_quickNextended= 1010060794;

        // Nòng
        new_Skin.AUG_compe  = 1010060795;
        new_Skin.AUG_flash  = 1010060796;
        new_Skin.AUG_silent = 1010060797;

        // Tay cầm
        new_Skin.AUG_angle     = 1010060798;
        new_Skin.AUG_thumb     = 1010060799;
        new_Skin.AUG_verical   = 1010060800;
        new_Skin.AUG_lightgrip = 1010060804;
        // Khác
        new_Skin.AUG_lazer = 1010060803;   // Laser
    }


    if (preferences.Config.Skin.AUG == 2){
    new_Skin.AUG2 = 1101006062;
    new_Skin.AUG_reddot = 1010060562;
    new_Skin.AUG_holo = 1010060561;
    new_Skin.AUG_x2 = 1010060554;
    new_Skin.AUG_x3 = 1010060553;
    new_Skin.AUG_x4 = 1010060552;
    new_Skin.AUG_x6 = 1010060551;
    new_Skin.AUG_lazer = 1010060574;
    new_Skin.AUG_flash = 1010060571;
    }



    if (preferences.Config.Skin.AUG == 3){
    new_Skin.AUG2 = 1101006044;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    }
    if (preferences.Config.Skin.AUG == 4){
    new_Skin.AUG2 = 1101006033;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    new_Skin.AUG_lazer = 202007;
    new_Skin.AUG_flash = 201010;
    }

    if (preferences.Config.Skin.AUG == 5){
    new_Skin.AUG2 = 1101006075;
    new_Skin.AUG_reddot = 1010060696;
    new_Skin.AUG_holo = 1010060695;
    new_Skin.AUG_x2 = 1010060694;
    new_Skin.AUG_x3 = 1010060693;
    new_Skin.AUG_x4 = 1010060692;
    new_Skin.AUG_x6 = 1010060691;
    new_Skin.AUG_lazer = 1010060707;
    new_Skin.AUG_flash = 1010060699;
    }
    if (preferences.Config.Skin.AUG == 6){
    new_Skin.AUG2 = 1101006067;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    new_Skin.AUG_lazer = 202007;
    new_Skin.AUG_flash = 201010;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AUG == 0) {
    new_Skin.AUG3 = 1010064;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    }

    if (preferences.Config.Skin.AUG == 1) {
        new_Skin.AUG3 = 1101006085;

        new_Skin.AUG_x6    = 1010060783;
        new_Skin.AUG_x4    = 1010060784;
        new_Skin.AUG_x3    = 1010060785;
        new_Skin.AUG_x2    = 1010060786;
        new_Skin.AUG_holo  = 1010060787;
        new_Skin.AUG_reddot= 1010060788;

        // Băng đạn
        new_Skin.AUG_extendedMag   = 1010060789;
        new_Skin.AUG_quickMag      = 1010060793;
        new_Skin.AUG_quickNextended= 1010060794;

        // Nòng
        new_Skin.AUG_compe  = 1010060795;
        new_Skin.AUG_flash  = 1010060796;
        new_Skin.AUG_silent = 1010060797;

        // Tay cầm
        new_Skin.AUG_angle     = 1010060798;
        new_Skin.AUG_thumb     = 1010060799;
        new_Skin.AUG_verical   = 1010060800;
        new_Skin.AUG_lightgrip = 1010060804;
        // Khác
        new_Skin.AUG_lazer = 1010060803;   // Laser
    }


    if (preferences.Config.Skin.AUG == 2){
    new_Skin.AUG3 = 1101006062;
    new_Skin.AUG_reddot = 1010060562;
    new_Skin.AUG_holo = 1010060561;
    new_Skin.AUG_x2 = 1010060554;
    new_Skin.AUG_x3 = 1010060553;
    new_Skin.AUG_x4 = 1010060552;
    new_Skin.AUG_x6 = 1010060551;
    new_Skin.AUG_lazer = 1010060574;
    new_Skin.AUG_flash = 1010060571;
    }



    if (preferences.Config.Skin.AUG == 3){
    new_Skin.AUG3 = 1101006044;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    }
    if (preferences.Config.Skin.AUG == 4){
    new_Skin.AUG3 = 1101006033;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    new_Skin.AUG_lazer = 202007;
    new_Skin.AUG_flash = 201010;
    }

    if (preferences.Config.Skin.AUG == 5){
    new_Skin.AUG3 = 1101006075;
    new_Skin.AUG_reddot = 1010060696;
    new_Skin.AUG_holo = 1010060695;
    new_Skin.AUG_x2 = 1010060694;
    new_Skin.AUG_x3 = 1010060693;
    new_Skin.AUG_x4 = 1010060692;
    new_Skin.AUG_x6 = 1010060691;
    new_Skin.AUG_lazer = 1010060707;
    new_Skin.AUG_flash = 1010060699;
    }
    if (preferences.Config.Skin.AUG == 6){
    new_Skin.AUG3 = 1101006067;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    new_Skin.AUG_lazer = 202007;
    new_Skin.AUG_flash = 201010;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AUG == 0) {
    new_Skin.AUG4 = 1010065;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    }

    if (preferences.Config.Skin.AUG == 1) {
        new_Skin.AUG4 = 1101006085;

        new_Skin.AUG_x6    = 1010060783;
        new_Skin.AUG_x4    = 1010060784;
        new_Skin.AUG_x3    = 1010060785;
        new_Skin.AUG_x2    = 1010060786;
        new_Skin.AUG_holo  = 1010060787;
        new_Skin.AUG_reddot= 1010060788;

        // Băng đạn
        new_Skin.AUG_extendedMag   = 1010060789;
        new_Skin.AUG_quickMag      = 1010060793;
        new_Skin.AUG_quickNextended= 1010060794;

        // Nòng
        new_Skin.AUG_compe  = 1010060795;
        new_Skin.AUG_flash  = 1010060796;
        new_Skin.AUG_silent = 1010060797;

        // Tay cầm
        new_Skin.AUG_angle     = 1010060798;
        new_Skin.AUG_thumb     = 1010060799;
        new_Skin.AUG_verical   = 1010060800;
        new_Skin.AUG_lightgrip = 1010060804;
        // Khác
        new_Skin.AUG_lazer = 1010060803;   // Laser
    }


    if (preferences.Config.Skin.AUG == 2){
    new_Skin.AUG4 = 1101006062;
    new_Skin.AUG_reddot = 1010060562;
    new_Skin.AUG_holo = 1010060561;
    new_Skin.AUG_x2 = 1010060554;
    new_Skin.AUG_x3 = 1010060553;
    new_Skin.AUG_x4 = 1010060552;
    new_Skin.AUG_x6 = 1010060551;
    new_Skin.AUG_lazer = 1010060574;
    new_Skin.AUG_flash = 1010060571;
    }



    if (preferences.Config.Skin.AUG == 3){
    new_Skin.AUG4 = 1101006044;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    }
    if (preferences.Config.Skin.AUG == 4){
    new_Skin.AUG4 = 1101006033;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    new_Skin.AUG_lazer = 202007;
    new_Skin.AUG_flash = 201010;
    }

    if (preferences.Config.Skin.AUG == 5){
    new_Skin.AUG4 = 1101006075;
    new_Skin.AUG_reddot = 1010060696;
    new_Skin.AUG_holo = 1010060695;
    new_Skin.AUG_x2 = 1010060694;
    new_Skin.AUG_x3 = 1010060693;
    new_Skin.AUG_x4 = 1010060692;
    new_Skin.AUG_x6 = 1010060691;
    new_Skin.AUG_lazer = 1010060707;
    new_Skin.AUG_flash = 1010060699;
    }
    if (preferences.Config.Skin.AUG == 6){
    new_Skin.AUG4 = 1101006067;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    new_Skin.AUG_lazer = 202007;
    new_Skin.AUG_flash = 201010;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AUG == 0) {
    new_Skin.AUG5 = 1010066;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    }

    if (preferences.Config.Skin.AUG == 1) {
        new_Skin.AUG5 = 1101006085;

        new_Skin.AUG_x6    = 1010060783;
        new_Skin.AUG_x4    = 1010060784;
        new_Skin.AUG_x3    = 1010060785;
        new_Skin.AUG_x2    = 1010060786;
        new_Skin.AUG_holo  = 1010060787;
        new_Skin.AUG_reddot= 1010060788;

        // Băng đạn
        new_Skin.AUG_extendedMag   = 1010060789;
        new_Skin.AUG_quickMag      = 1010060793;
        new_Skin.AUG_quickNextended= 1010060794;

        // Nòng
        new_Skin.AUG_compe  = 1010060795;
        new_Skin.AUG_flash  = 1010060796;
        new_Skin.AUG_silent = 1010060797;

        // Tay cầm
        new_Skin.AUG_angle     = 1010060798;
        new_Skin.AUG_thumb     = 1010060799;
        new_Skin.AUG_verical   = 1010060800;
        new_Skin.AUG_lightgrip = 1010060804;
        // Khác
        new_Skin.AUG_lazer = 1010060803;   // Laser
    }


    if (preferences.Config.Skin.AUG == 2){
    new_Skin.AUG5 = 1101006062;
    new_Skin.AUG_reddot = 1010060562;
    new_Skin.AUG_holo = 1010060561;
    new_Skin.AUG_x2 = 1010060554;
    new_Skin.AUG_x3 = 1010060553;
    new_Skin.AUG_x4 = 1010060552;
    new_Skin.AUG_x6 = 1010060551;
    new_Skin.AUG_lazer = 1010060574;
    new_Skin.AUG_flash = 1010060571;
    }



    if (preferences.Config.Skin.AUG == 3){
    new_Skin.AUG5 = 1101006044;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    }
    if (preferences.Config.Skin.AUG == 4){
    new_Skin.AUG5 = 1101006033;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    new_Skin.AUG_lazer = 202007;
    new_Skin.AUG_flash = 201010;
    }

    if (preferences.Config.Skin.AUG == 5){
    new_Skin.AUG5 = 1101006075;
    new_Skin.AUG_reddot = 1010060696;
    new_Skin.AUG_holo = 1010060695;
    new_Skin.AUG_x2 = 1010060694;
    new_Skin.AUG_x3 = 1010060693;
    new_Skin.AUG_x4 = 1010060692;
    new_Skin.AUG_x6 = 1010060691;
    new_Skin.AUG_lazer = 1010060707;
    new_Skin.AUG_flash = 1010060699;
    }
    if (preferences.Config.Skin.AUG == 6){
    new_Skin.AUG5 = 1101006067;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    new_Skin.AUG_lazer = 202007;
    new_Skin.AUG_flash = 201010;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AUG == 0) {
    new_Skin.AUG6 = 1010067;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    }

    if (preferences.Config.Skin.AUG == 1) {
        new_Skin.AUG6 = 1101006085;

        new_Skin.AUG_x6    = 1010060783;
        new_Skin.AUG_x4    = 1010060784;
        new_Skin.AUG_x3    = 1010060785;
        new_Skin.AUG_x2    = 1010060786;
        new_Skin.AUG_holo  = 1010060787;
        new_Skin.AUG_reddot= 1010060788;

        // Băng đạn
        new_Skin.AUG_extendedMag   = 1010060789;
        new_Skin.AUG_quickMag      = 1010060793;
        new_Skin.AUG_quickNextended= 1010060794;

        // Nòng
        new_Skin.AUG_compe  = 1010060795;
        new_Skin.AUG_flash  = 1010060796;
        new_Skin.AUG_silent = 1010060797;

        // Tay cầm
        new_Skin.AUG_angle     = 1010060798;
        new_Skin.AUG_thumb     = 1010060799;
        new_Skin.AUG_verical   = 1010060800;
        new_Skin.AUG_lightgrip = 1010060804;
        // Khác
        new_Skin.AUG_lazer = 1010060803;   // Laser
    }


    if (preferences.Config.Skin.AUG == 2){
    new_Skin.AUG6 = 1101006062;
    new_Skin.AUG_reddot = 1010060562;
    new_Skin.AUG_holo = 1010060561;
    new_Skin.AUG_x2 = 1010060554;
    new_Skin.AUG_x3 = 1010060553;
    new_Skin.AUG_x4 = 1010060552;
    new_Skin.AUG_x6 = 1010060551;
    new_Skin.AUG_lazer = 1010060574;
    new_Skin.AUG_flash = 1010060571;
    }



    if (preferences.Config.Skin.AUG == 3){
    new_Skin.AUG6 = 1101006044;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    }
    if (preferences.Config.Skin.AUG == 4){
    new_Skin.AUG6 = 1101006033;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    new_Skin.AUG_lazer = 202007;
    new_Skin.AUG_flash = 201010;
    }

    if (preferences.Config.Skin.AUG == 5){
    new_Skin.AUG6 = 1101006075;
    new_Skin.AUG_reddot = 1010060696;
    new_Skin.AUG_holo = 1010060695;
    new_Skin.AUG_x2 = 1010060694;
    new_Skin.AUG_x3 = 1010060693;
    new_Skin.AUG_x4 = 1010060692;
    new_Skin.AUG_x6 = 1010060691;
    new_Skin.AUG_lazer = 1010060707;
    new_Skin.AUG_flash = 1010060699;
    }
    if (preferences.Config.Skin.AUG == 6){
    new_Skin.AUG6 = 1101006067;
    new_Skin.AUG_reddot = 203001;
    new_Skin.AUG_holo = 203002;
    new_Skin.AUG_x2 = 203003;
    new_Skin.AUG_x3 = 203014;
    new_Skin.AUG_x4 = 203004;
    new_Skin.AUG_x6 = 203015;
    new_Skin.AUG_lazer = 202007;
    new_Skin.AUG_flash = 201010;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.QBZ == 0)
    new_Skin.QBZ = 101007;
    new_Skin.QBZ_reddot = 203001;
    new_Skin.QBZ_holo = 203002;
    new_Skin.QBZ_x2 = 203003;
    new_Skin.QBZ_x3 = 203014;
    new_Skin.QBZ_x4 = 203004;
    new_Skin.QBZ_x6 = 203015;
    new_Skin.QBZ_quickMag = 204012;
    new_Skin.QBZ_extendedMag = 204011;
    new_Skin.QBZ_quickNextended = 204013;
    new_Skin.QBZ_silent = 201011;
    new_Skin.QBZ_flash = 2010105;
    new_Skin.QBZ_compe = 201009;
    new_Skin.QBZ_thumb = 202006;
    new_Skin.QBZ_verical = 202002;
    new_Skin.QBZ_angle = 202001;
    if (preferences.Config.Skin.QBZ == 1) {
        new_Skin.QBZ = 1101007071;      // Skin chính

        // Scope
        new_Skin.QBZ_reddot   = 1010070406;
        new_Skin.QBZ_holo     = 1010070405;
        new_Skin.QBZ_x2       = 1010070404;
        new_Skin.QBZ_x3       = 1010070403;
        new_Skin.QBZ_x4       = 1010070402;
        new_Skin.QBZ_x6       = 1010070568;   // nâng cấp về sau

        // Mag
        new_Skin.QBZ_extendedMag    = 1010070407;
        new_Skin.QBZ_quickMag       = 1010070408;
        new_Skin.QBZ_quickNextended = 1010070409;

        // Muzzle
        new_Skin.QBZ_flash  = 1010070410;
        new_Skin.QBZ_compe  = 1010070413;
        new_Skin.QBZ_silent = 1010070414;

        // Grip
        new_Skin.QBZ_angle   = 1010070415;
        new_Skin.QBZ_thumb   = 1010070416;
        new_Skin.QBZ_verical = 1010070417;
    }

    if (preferences.Config.Skin.QBZ == 2)
    new_Skin.QBZ = 1101007036;
    if (preferences.Config.Skin.QBZ == 3)
    new_Skin.QBZ = 1101007046;
    if (preferences.Config.Skin.QBZ == 3)
    new_Skin.QBZ = 1101007025;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    if (preferences.Config.Skin.M762 == 0) {
    new_Skin.M762 = 101008;
    new_Skin.M762_Mag = 291008;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;

    }
    if (preferences.Config.Skin.M762 == 1) {
        new_Skin.M762 = 1101008163;   

        // Ống ngắm
        new_Skin.M762_reddot = 1010081577;
        new_Skin.M762_holo   = 1010081576;
        new_Skin.M762_x2     = 1010081575;
        new_Skin.M762_x3     = 1010081574;
        new_Skin.M762_x4     = 1010081573;
        new_Skin.M762_x6     = 1010081572;

        // Băng đạn
        new_Skin.M762_extendedMag    = 1010081578;
        new_Skin.M762_quickMag       = 1010081579;
        new_Skin.M762_quickNextended = 1010081580;

        // Nòng
        new_Skin.M762_flash  = 1010081582;
        new_Skin.M762_compe  = 1010081583;
        new_Skin.M762_silent = 1010081584;

        // Tay cầm
        new_Skin.M762_angle   = 1010081585; // tam giác
        new_Skin.M762_verical = 1010081586; // đứng
        new_Skin.M762_lightgrip = 1010081587; // nhẹ
        new_Skin.M762_pink      = 1010081588; // nửa
        new_Skin.M762_thumb     = 1010081589; // ngón cái

        // Khác
        new_Skin.M762_lazer   = 1010081590;
        // Có cả ống ngắm phụ (canted) nếu cần:
        // new_Skin.M762_canted = 1010081592;
    }

    if (preferences.Config.Skin.M762 == 2) {
    new_Skin.M762 = 1101008136;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 3) {
    new_Skin.M762 = 1101008051;
    new_Skin.M762_Mag = 1010080511;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 4) {
    new_Skin.M762 = 1101008061;
    new_Skin.M762_Mag = 1010080611;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 5) {
    new_Skin.M762 = 1101008026;
    new_Skin.M762_Mag = 1010080261;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 6) {
    new_Skin.M762 = 1101008104;
    new_Skin.M762_Mag = 1010081041;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 7) {
    new_Skin.M762 = 1101008116;
    new_Skin.M762_Mag = 1010081161;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 8) {
    new_Skin.M762 = 1101008126;
    new_Skin.M762_Mag = 1010081261;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 9) {
    new_Skin.M762 = 1101008081;
    new_Skin.M762_Mag = 1010080811;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 10) {
    new_Skin.M762 = 1101008070;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 11) {
    new_Skin.M762 = 1101008146;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 1010081396;
    new_Skin.M762_holo = 1010081395;
    new_Skin.M762_x2 = 1010081394;
    new_Skin.M762_x3 = 1010081393;
    new_Skin.M762_x4 = 1010081392;
    new_Skin.M762_x6 = 1010081391;
    new_Skin.M762_lazer = 1010081409;
    new_Skin.M762_flash = 1010081399;
    }
    if (preferences.Config.Skin.M762 == 12) {
    new_Skin.M762 = 1101008154;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 1010081396;
    new_Skin.M762_holo = 1010081395;
    new_Skin.M762_x2 = 1010081394;
    new_Skin.M762_x3 = 1010081393;
    new_Skin.M762_x4 = 1010081392;
    new_Skin.M762_x6 = 1010081391;
    new_Skin.M762_lazer = 1010081409;
    new_Skin.M762_flash = 1010081399;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M762 == 0) {
    new_Skin.M7621 = 1010082;
    new_Skin.M762_Mag = 291008;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;

    }
    if (preferences.Config.Skin.M762 == 1) {
        new_Skin.M7621 = 1101008163;   // Skin chính

        // Ống ngắm
        new_Skin.M762_reddot = 1010081577;
        new_Skin.M762_holo   = 1010081576;
        new_Skin.M762_x2     = 1010081575;
        new_Skin.M762_x3     = 1010081574;
        new_Skin.M762_x4     = 1010081573;
        new_Skin.M762_x6     = 1010081572;

        // Băng đạn
        new_Skin.M762_extendedMag    = 1010081578;
        new_Skin.M762_quickMag       = 1010081579;
        new_Skin.M762_quickNextended = 1010081580;

        // Nòng
        new_Skin.M762_flash  = 1010081582;
        new_Skin.M762_compe  = 1010081583;
        new_Skin.M762_silent = 1010081584;

        // Tay cầm
        new_Skin.M762_angle   = 1010081585; // tam giác
        new_Skin.M762_verical = 1010081586; // đứng
        new_Skin.M762_lightgrip = 1010081587; // nhẹ
        new_Skin.M762_pink      = 1010081588; // nửa
        new_Skin.M762_thumb     = 1010081589; // ngón cái

        // Khác
        new_Skin.M762_lazer   = 1010081590;
        // Có cả ống ngắm phụ (canted) nếu cần:
        // new_Skin.M762_canted = 1010081592;
    }

    if (preferences.Config.Skin.M762 == 2) {
    new_Skin.M7621 = 1101008136;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 3) {
    new_Skin.M7621 = 1101008051;
    new_Skin.M762_Mag = 1010080511;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 4) {
    new_Skin.M7621 = 1101008061;
    new_Skin.M762_Mag = 1010080611;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 5) {
    new_Skin.M7621 = 1101008026;
    new_Skin.M762_Mag = 1010080261;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 6) {
    new_Skin.M7621 = 1101008104;
    new_Skin.M762_Mag = 1010081041;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 7) {
    new_Skin.M7621 = 1101008116;
    new_Skin.M762_Mag = 1010081161;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 8) {
    new_Skin.M7621 = 1101008126;
    new_Skin.M762_Mag = 1010081261;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 9) {
    new_Skin.M7621 = 1101008081;
    new_Skin.M762_Mag = 1010080811;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 10) {
    new_Skin.M7621 = 1101008070;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 11) {
    new_Skin.M7621 = 1101008146;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 1010081396;
    new_Skin.M762_holo = 1010081395;
    new_Skin.M762_x2 = 1010081394;
    new_Skin.M762_x3 = 1010081393;
    new_Skin.M762_x4 = 1010081392;
    new_Skin.M762_x6 = 1010081391;
    new_Skin.M762_lazer = 1010081409;
    new_Skin.M762_flash = 1010081399;
    }
    if (preferences.Config.Skin.M762 == 12) {
    new_Skin.M7621 = 1101008154;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 1010081396;
    new_Skin.M762_holo = 1010081395;
    new_Skin.M762_x2 = 1010081394;
    new_Skin.M762_x3 = 1010081393;
    new_Skin.M762_x4 = 1010081392;
    new_Skin.M762_x6 = 1010081391;
    new_Skin.M762_lazer = 1010081409;
    new_Skin.M762_flash = 1010081399;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M762 == 0) {
    new_Skin.M7622 = 1010083;
    new_Skin.M762_Mag = 291008;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;

    }
    if (preferences.Config.Skin.M762 == 1) {
        new_Skin.M7622 = 1101008163;   // Skin chính

        // Ống ngắm
        new_Skin.M762_reddot = 1010081577;
        new_Skin.M762_holo   = 1010081576;
        new_Skin.M762_x2     = 1010081575;
        new_Skin.M762_x3     = 1010081574;
        new_Skin.M762_x4     = 1010081573;
        new_Skin.M762_x6     = 1010081572;

        // Băng đạn
        new_Skin.M762_extendedMag    = 1010081578;
        new_Skin.M762_quickMag       = 1010081579;
        new_Skin.M762_quickNextended = 1010081580;

        // Nòng
        new_Skin.M762_flash  = 1010081582;
        new_Skin.M762_compe  = 1010081583;
        new_Skin.M762_silent = 1010081584;

        // Tay cầm
        new_Skin.M762_angle   = 1010081585; // tam giác
        new_Skin.M762_verical = 1010081586; // đứng
        new_Skin.M762_lightgrip = 1010081587; // nhẹ
        new_Skin.M762_pink      = 1010081588; // nửa
        new_Skin.M762_thumb     = 1010081589; // ngón cái

        // Khác
        new_Skin.M762_lazer   = 1010081590;
        // Có cả ống ngắm phụ (canted) nếu cần:
        // new_Skin.M762_canted = 1010081592;
    }

    if (preferences.Config.Skin.M762 == 2) {
    new_Skin.M7622 = 1101008136;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 3) {
    new_Skin.M7622 = 1101008051;
    new_Skin.M762_Mag = 1010080511;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 4) {
    new_Skin.M7622 = 1101008061;
    new_Skin.M762_Mag = 1010080611;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 5) {
    new_Skin.M7622 = 1101008026;
    new_Skin.M762_Mag = 1010080261;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 6) {
    new_Skin.M7622 = 1101008104;
    new_Skin.M762_Mag = 1010081041;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 7) {
    new_Skin.M7622 = 1101008116;
    new_Skin.M762_Mag = 1010081161;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 8) {
    new_Skin.M7622 = 1101008126;
    new_Skin.M762_Mag = 1010081261;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 9) {
    new_Skin.M7622 = 1101008081;
    new_Skin.M762_Mag = 1010080811;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 10) {
    new_Skin.M7622 = 1101008070;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 11) {
    new_Skin.M7622 = 1101008146;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 1010081396;
    new_Skin.M762_holo = 1010081395;
    new_Skin.M762_x2 = 1010081394;
    new_Skin.M762_x3 = 1010081393;
    new_Skin.M762_x4 = 1010081392;
    new_Skin.M762_x6 = 1010081391;
    new_Skin.M762_lazer = 1010081409;
    new_Skin.M762_flash = 1010081399;
    }
    if (preferences.Config.Skin.M762 == 12) {
    new_Skin.M7622 = 1101008154;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 1010081396;
    new_Skin.M762_holo = 1010081395;
    new_Skin.M762_x2 = 1010081394;
    new_Skin.M762_x3 = 1010081393;
    new_Skin.M762_x4 = 1010081392;
    new_Skin.M762_x6 = 1010081391;
    new_Skin.M762_lazer = 1010081409;
    new_Skin.M762_flash = 1010081399;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M762 == 0) {
    new_Skin.M7623 = 1010084;
    new_Skin.M762_Mag = 291008;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;

    }
    if (preferences.Config.Skin.M762 == 1) {
        new_Skin.M7623 = 1101008163;   // Skin chính

        // Ống ngắm
        new_Skin.M762_reddot = 1010081577;
        new_Skin.M762_holo   = 1010081576;
        new_Skin.M762_x2     = 1010081575;
        new_Skin.M762_x3     = 1010081574;
        new_Skin.M762_x4     = 1010081573;
        new_Skin.M762_x6     = 1010081572;

        // Băng đạn
        new_Skin.M762_extendedMag    = 1010081578;
        new_Skin.M762_quickMag       = 1010081579;
        new_Skin.M762_quickNextended = 1010081580;

        // Nòng
        new_Skin.M762_flash  = 1010081582;
        new_Skin.M762_compe  = 1010081583;
        new_Skin.M762_silent = 1010081584;

        // Tay cầm
        new_Skin.M762_angle   = 1010081585; // tam giác
        new_Skin.M762_verical = 1010081586; // đứng
        new_Skin.M762_lightgrip = 1010081587; // nhẹ
        new_Skin.M762_pink      = 1010081588; // nửa
        new_Skin.M762_thumb     = 1010081589; // ngón cái

        // Khác
        new_Skin.M762_lazer   = 1010081590;
        // Có cả ống ngắm phụ (canted) nếu cần:
        // new_Skin.M762_canted = 1010081592;
    }

    if (preferences.Config.Skin.M762 == 2) {
    new_Skin.M7623 = 1101008136;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 3) {
    new_Skin.M7623 = 1101008051;
    new_Skin.M762_Mag = 1010080511;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 4) {
    new_Skin.M7623 = 1101008061;
    new_Skin.M762_Mag = 1010080611;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 5) {
    new_Skin.M7623 = 1101008026;
    new_Skin.M762_Mag = 1010080261;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 6) {
    new_Skin.M7623 = 1101008104;
    new_Skin.M762_Mag = 1010081041;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 7) {
    new_Skin.M7623 = 1101008116;
    new_Skin.M762_Mag = 1010081161;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 8) {
    new_Skin.M7623 = 1101008126;
    new_Skin.M762_Mag = 1010081261;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 9) {
    new_Skin.M7623 = 1101008081;
    new_Skin.M762_Mag = 1010080811;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 10) {
    new_Skin.M7623 = 1101008070;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 11) {
    new_Skin.M7623 = 1101008146;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 1010081396;
    new_Skin.M762_holo = 1010081395;
    new_Skin.M762_x2 = 1010081394;
    new_Skin.M762_x3 = 1010081393;
    new_Skin.M762_x4 = 1010081392;
    new_Skin.M762_x6 = 1010081391;
    new_Skin.M762_lazer = 1010081409;
    new_Skin.M762_flash = 1010081399;
    }
    if (preferences.Config.Skin.M762 == 12) {
    new_Skin.M7623 = 1101008154;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 1010081396;
    new_Skin.M762_holo = 1010081395;
    new_Skin.M762_x2 = 1010081394;
    new_Skin.M762_x3 = 1010081393;
    new_Skin.M762_x4 = 1010081392;
    new_Skin.M762_x6 = 1010081391;
    new_Skin.M762_lazer = 1010081409;
    new_Skin.M762_flash = 1010081399;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M762 == 0) {
    new_Skin.M7624 = 1010085;
    new_Skin.M762_Mag = 291008;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;

    }
    if (preferences.Config.Skin.M762 == 1) {
        new_Skin.M7624 = 1101008163;   // Skin chính

        // Ống ngắm
        new_Skin.M762_reddot = 1010081577;
        new_Skin.M762_holo   = 1010081576;
        new_Skin.M762_x2     = 1010081575;
        new_Skin.M762_x3     = 1010081574;
        new_Skin.M762_x4     = 1010081573;
        new_Skin.M762_x6     = 1010081572;

        // Băng đạn
        new_Skin.M762_extendedMag    = 1010081578;
        new_Skin.M762_quickMag       = 1010081579;
        new_Skin.M762_quickNextended = 1010081580;

        // Nòng
        new_Skin.M762_flash  = 1010081582;
        new_Skin.M762_compe  = 1010081583;
        new_Skin.M762_silent = 1010081584;

        // Tay cầm
        new_Skin.M762_angle   = 1010081585; // tam giác
        new_Skin.M762_verical = 1010081586; // đứng
        new_Skin.M762_lightgrip = 1010081587; // nhẹ
        new_Skin.M762_pink      = 1010081588; // nửa
        new_Skin.M762_thumb     = 1010081589; // ngón cái

        // Khác
        new_Skin.M762_lazer   = 1010081590;
        // Có cả ống ngắm phụ (canted) nếu cần:
        // new_Skin.M762_canted = 1010081592;
    }

    if (preferences.Config.Skin.M762 == 2) {
    new_Skin.M7624 = 1101008136;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 3) {
    new_Skin.M7624 = 1101008051;
    new_Skin.M762_Mag = 1010080511;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 4) {
    new_Skin.M7624 = 1101008061;
    new_Skin.M762_Mag = 1010080611;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 5) {
    new_Skin.M7624 = 1101008026;
    new_Skin.M762_Mag = 1010080261;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 6) {
    new_Skin.M7624 = 1101008104;
    new_Skin.M762_Mag = 1010081041;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 7) {
    new_Skin.M7624 = 1101008116;
    new_Skin.M762_Mag = 1010081161;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 8) {
    new_Skin.M7624 = 1101008126;
    new_Skin.M762_Mag = 1010081261;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 9) {
    new_Skin.M7624 = 1101008081;
    new_Skin.M762_Mag = 1010080811;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 10) {
    new_Skin.M7624 = 1101008070;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 11) {
    new_Skin.M7624 = 1101008146;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 1010081396;
    new_Skin.M762_holo = 1010081395;
    new_Skin.M762_x2 = 1010081394;
    new_Skin.M762_x3 = 1010081393;
    new_Skin.M762_x4 = 1010081392;
    new_Skin.M762_x6 = 1010081391;
    new_Skin.M762_lazer = 1010081409;
    new_Skin.M762_flash = 1010081399;
    }
    if (preferences.Config.Skin.M762 == 12) {
    new_Skin.M7624 = 1101008154;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 1010081396;
    new_Skin.M762_holo = 1010081395;
    new_Skin.M762_x2 = 1010081394;
    new_Skin.M762_x3 = 1010081393;
    new_Skin.M762_x4 = 1010081392;
    new_Skin.M762_x6 = 1010081391;
    new_Skin.M762_lazer = 1010081409;
    new_Skin.M762_flash = 1010081399;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M762 == 0) {
    new_Skin.M7625 = 1010086;
    new_Skin.M762_Mag = 291008;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;

    }
    if (preferences.Config.Skin.M762 == 1) {
        new_Skin.M7625 = 1101008163;   // Skin chính

        // Ống ngắm
        new_Skin.M762_reddot = 1010081577;
        new_Skin.M762_holo   = 1010081576;
        new_Skin.M762_x2     = 1010081575;
        new_Skin.M762_x3     = 1010081574;
        new_Skin.M762_x4     = 1010081573;
        new_Skin.M762_x6     = 1010081572;

        // Băng đạn
        new_Skin.M762_extendedMag    = 1010081578;
        new_Skin.M762_quickMag       = 1010081579;
        new_Skin.M762_quickNextended = 1010081580;

        // Nòng
        new_Skin.M762_flash  = 1010081582;
        new_Skin.M762_compe  = 1010081583;
        new_Skin.M762_silent = 1010081584;

        // Tay cầm
        new_Skin.M762_angle   = 1010081585; // tam giác
        new_Skin.M762_verical = 1010081586; // đứng
        new_Skin.M762_lightgrip = 1010081587; // nhẹ
        new_Skin.M762_pink      = 1010081588; // nửa
        new_Skin.M762_thumb     = 1010081589; // ngón cái

        // Khác
        new_Skin.M762_lazer   = 1010081590;
        // Có cả ống ngắm phụ (canted) nếu cần:
        // new_Skin.M762_canted = 1010081592;
    }

    if (preferences.Config.Skin.M762 == 2) {
    new_Skin.M7625 = 1101008136;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 3) {
    new_Skin.M7625 = 1101008051;
    new_Skin.M762_Mag = 1010080511;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 4) {
    new_Skin.M7625 = 1101008061;
    new_Skin.M762_Mag = 1010080611;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 5) {
    new_Skin.M7625 = 1101008026;
    new_Skin.M762_Mag = 1010080261;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 6) {
    new_Skin.M7625 = 1101008104;
    new_Skin.M762_Mag = 1010081041;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 7) {
    new_Skin.M7625 = 1101008116;
    new_Skin.M762_Mag = 1010081161;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 8) {
    new_Skin.M7625 = 1101008126;
    new_Skin.M762_Mag = 1010081261;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 9) {
    new_Skin.M7625 = 1101008081;
    new_Skin.M762_Mag = 1010080811;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 10) {
    new_Skin.M7625 = 1101008070;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 11) {
    new_Skin.M7625 = 1101008146;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 1010081396;
    new_Skin.M762_holo = 1010081395;
    new_Skin.M762_x2 = 1010081394;
    new_Skin.M762_x3 = 1010081393;
    new_Skin.M762_x4 = 1010081392;
    new_Skin.M762_x6 = 1010081391;
    new_Skin.M762_lazer = 1010081409;
    new_Skin.M762_flash = 1010081399;
    }
    if (preferences.Config.Skin.M762 == 12) {
    new_Skin.M7625 = 1101008154;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 1010081396;
    new_Skin.M762_holo = 1010081395;
    new_Skin.M762_x2 = 1010081394;
    new_Skin.M762_x3 = 1010081393;
    new_Skin.M762_x4 = 1010081392;
    new_Skin.M762_x6 = 1010081391;
    new_Skin.M762_lazer = 1010081409;
    new_Skin.M762_flash = 1010081399;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M762 == 0) {
    new_Skin.M7626 = 1010087;
    new_Skin.M762_Mag = 291008;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;

    }
    if (preferences.Config.Skin.M762 == 1) {
        new_Skin.M7626 = 1101008163;   // Skin chính

        // Ống ngắm
        new_Skin.M762_reddot = 1010081577;
        new_Skin.M762_holo   = 1010081576;
        new_Skin.M762_x2     = 1010081575;
        new_Skin.M762_x3     = 1010081574;
        new_Skin.M762_x4     = 1010081573;
        new_Skin.M762_x6     = 1010081572;

        // Băng đạn
        new_Skin.M762_extendedMag    = 1010081578;
        new_Skin.M762_quickMag       = 1010081579;
        new_Skin.M762_quickNextended = 1010081580;

        // Nòng
        new_Skin.M762_flash  = 1010081582;
        new_Skin.M762_compe  = 1010081583;
        new_Skin.M762_silent = 1010081584;

        // Tay cầm
        new_Skin.M762_angle   = 1010081585; // tam giác
        new_Skin.M762_verical = 1010081586; // đứng
        new_Skin.M762_lightgrip = 1010081587; // nhẹ
        new_Skin.M762_pink      = 1010081588; // nửa
        new_Skin.M762_thumb     = 1010081589; // ngón cái

        // Khác
        new_Skin.M762_lazer   = 1010081590;
        // Có cả ống ngắm phụ (canted) nếu cần:
        // new_Skin.M762_canted = 1010081592;
    }

    if (preferences.Config.Skin.M762 == 2) {
    new_Skin.M7626 = 1101008136;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 3) {
    new_Skin.M7626 = 1101008051;
    new_Skin.M762_Mag = 1010080511;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 4) {
    new_Skin.M7626 = 1101008061;
    new_Skin.M762_Mag = 1010080611;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 5) {
    new_Skin.M7626 = 1101008026;
    new_Skin.M762_Mag = 1010080261;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 6) {
    new_Skin.M7626 = 1101008104;
    new_Skin.M762_Mag = 1010081041;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 7) {
    new_Skin.M7626 = 1101008116;
    new_Skin.M762_Mag = 1010081161;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 8) {
    new_Skin.M7626 = 1101008126;
    new_Skin.M762_Mag = 1010081261;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 9) {
    new_Skin.M7626 = 1101008081;
    new_Skin.M762_Mag = 1010080811;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 10) {
    new_Skin.M7626 = 1101008070;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 203001;
    new_Skin.M762_holo = 203002;
    new_Skin.M762_x2 = 203003;
    new_Skin.M762_x3 = 203014;
    new_Skin.M762_x4 = 203004;
    new_Skin.M762_x6 = 203015;
    new_Skin.M762_lazer = 202007;
    new_Skin.M762_flash = 201010;
    }
    if (preferences.Config.Skin.M762 == 11) {
    new_Skin.M7626 = 1101008146;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 1010081396;
    new_Skin.M762_holo = 1010081395;
    new_Skin.M762_x2 = 1010081394;
    new_Skin.M762_x3 = 1010081393;
    new_Skin.M762_x4 = 1010081392;
    new_Skin.M762_x6 = 1010081391;
    new_Skin.M762_lazer = 1010081409;
    new_Skin.M762_flash = 1010081399;
    }
    if (preferences.Config.Skin.M762 == 12) {
    new_Skin.M7626 = 1101008154;
    new_Skin.M762_Mag = 1010081361;
    new_Skin.M762_reddot = 1010081396;
    new_Skin.M762_holo = 1010081395;
    new_Skin.M762_x2 = 1010081394;
    new_Skin.M762_x3 = 1010081393;
    new_Skin.M762_x4 = 1010081392;
    new_Skin.M762_x6 = 1010081391;
    new_Skin.M762_lazer = 1010081409;
    new_Skin.M762_flash = 1010081399;
    }

  
    /////////////// ACE32 ///////////////

    if (preferences.Config.Skin.ACE32 == 0)
    new_Skin.ACE32 = 101102;
    if (preferences.Config.Skin.ACE32 == 1) {

        new_Skin.ACE32 = 1101102041; 

        
        new_Skin.ACE32_x6    = 1011020424;
        new_Skin.ACE32_x4    = 1011020425;
        new_Skin.ACE32_x3    = 1011020426;
        new_Skin.ACE32_x2    = 1011020427;
        new_Skin.ACE32_holo  = 1011020428;
        new_Skin.ACE32_reddot= 1011020429;

        // ----- BĂNG ĐẠN -----
        new_Skin.ACE32_Mag             = 1011020423; // Mag cấp 1
        new_Skin.ACE32_extendedMag     = 1011020430;
        new_Skin.ACE32_quickMag        = 1011020434;
        new_Skin.ACE32_quickNextended  = 1011020435;

        // ----- NÒNG -----
        new_Skin.ACE32_flash  = 1011020436;
        new_Skin.ACE32_compe  = 1011020437;
        new_Skin.ACE32_silent = 1011020438;

        // ----- TAY CẦM -----
        new_Skin.ACE32_angle      = 1011020439; // Triangle
        new_Skin.ACE32_thumb      = 1011020440;
        new_Skin.ACE32_verical    = 1011020444;
        new_Skin.ACE32_lightgrip  = 1011020446;

        // ----- BÁNG SÚNG -----
        new_Skin.ACE32_stock      = 1011020445; // Tactical Stock
        new_Skin.ACE32_heavyStock = 1011020450; // Heavy Stock

        // ----- KHÁC -----
        new_Skin.ACE32_laser = 1011020448;
        new_Skin.ACE32_side  = 1011020449; // Ống ngắm phụ
    }
    if (preferences.Config.Skin.ACE32 == 2){
    new_Skin.ACE32 = 1101102007;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    if (preferences.Config.Skin.ACE32 == 3){
    new_Skin.ACE32 = 1101102017;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    if (preferences.Config.Skin.ACE32 == 4){
    new_Skin.ACE32 = 1101102025;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }

    /////////////// ACE32 ///////////////

    if (preferences.Config.Skin.ACE32 == 0)
    new_Skin.ACE321 = 1011022;
    if (preferences.Config.Skin.ACE32 == 1) {

        new_Skin.ACE321 = 1101102041; // Skin chính Tiên Tri Điềm Lành (Cấp 8)

        // ----- ỐNG NGẮM -----
        new_Skin.ACE32_x6    = 1011020424;
        new_Skin.ACE32_x4    = 1011020425;
        new_Skin.ACE32_x3    = 1011020426;
        new_Skin.ACE32_x2    = 1011020427;
        new_Skin.ACE32_holo  = 1011020428;
        new_Skin.ACE32_reddot= 1011020429;

        // ----- BĂNG ĐẠN -----
        new_Skin.ACE32_Mag             = 1011020423; // Mag cấp 1
        new_Skin.ACE32_extendedMag     = 1011020430;
        new_Skin.ACE32_quickMag        = 1011020434;
        new_Skin.ACE32_quickNextended  = 1011020435;

        // ----- NÒNG -----
        new_Skin.ACE32_flash  = 1011020436;
        new_Skin.ACE32_compe  = 1011020437;
        new_Skin.ACE32_silent = 1011020438;

        // ----- TAY CẦM -----
        new_Skin.ACE32_angle      = 1011020439; // Triangle
        new_Skin.ACE32_thumb      = 1011020440;
        new_Skin.ACE32_verical    = 1011020444;
        new_Skin.ACE32_lightgrip  = 1011020446;

        // ----- BÁNG SÚNG -----
        new_Skin.ACE32_stock      = 1011020445; // Tactical Stock
        new_Skin.ACE32_heavyStock = 1011020450; // Heavy Stock

        // ----- KHÁC -----
        new_Skin.ACE32_laser = 1011020448;
        new_Skin.ACE32_side  = 1011020449; // Ống ngắm phụ
    }
    if (preferences.Config.Skin.ACE32 == 2){
    new_Skin.ACE321 = 1101102007;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    if (preferences.Config.Skin.ACE32 == 3){
    new_Skin.ACE321 = 1101102017;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    if (preferences.Config.Skin.ACE32 == 4){
    new_Skin.ACE321 = 1101102025;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }

    /////////////// ACE32 ///////////////

    if (preferences.Config.Skin.ACE32 == 0)
    new_Skin.ACE322 = 1011023;
    if (preferences.Config.Skin.ACE32 == 1) {

        new_Skin.ACE322 = 1101102041; // Skin chính Tiên Tri Điềm Lành (Cấp 8)

        // ----- ỐNG NGẮM -----
        new_Skin.ACE32_x6    = 1011020424;
        new_Skin.ACE32_x4    = 1011020425;
        new_Skin.ACE32_x3    = 1011020426;
        new_Skin.ACE32_x2    = 1011020427;
        new_Skin.ACE32_holo  = 1011020428;
        new_Skin.ACE32_reddot= 1011020429;

        // ----- BĂNG ĐẠN -----
        new_Skin.ACE32_Mag             = 1011020423; // Mag cấp 1
        new_Skin.ACE32_extendedMag     = 1011020430;
        new_Skin.ACE32_quickMag        = 1011020434;
        new_Skin.ACE32_quickNextended  = 1011020435;

        // ----- NÒNG -----
        new_Skin.ACE32_flash  = 1011020436;
        new_Skin.ACE32_compe  = 1011020437;
        new_Skin.ACE32_silent = 1011020438;

        // ----- TAY CẦM -----
        new_Skin.ACE32_angle      = 1011020439; // Triangle
        new_Skin.ACE32_thumb      = 1011020440;
        new_Skin.ACE32_verical    = 1011020444;
        new_Skin.ACE32_lightgrip  = 1011020446;

        // ----- BÁNG SÚNG -----
        new_Skin.ACE32_stock      = 1011020445; // Tactical Stock
        new_Skin.ACE32_heavyStock = 1011020450; // Heavy Stock

        // ----- KHÁC -----
        new_Skin.ACE32_laser = 1011020448;
        new_Skin.ACE32_side  = 1011020449; // Ống ngắm phụ
    }
    if (preferences.Config.Skin.ACE32 == 2){
    new_Skin.ACE322 = 1101102007;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    if (preferences.Config.Skin.ACE32 == 3){
    new_Skin.ACE322 = 1101102017;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    if (preferences.Config.Skin.ACE32 == 4){
    new_Skin.ACE322 = 1101102025;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    
    /////////////// ACE32 ///////////////

    if (preferences.Config.Skin.ACE32 == 0)
    new_Skin.ACE323 = 1011024;
    if (preferences.Config.Skin.ACE32 == 1) {

        new_Skin.ACE323 = 1101102041; // Skin chính Tiên Tri Điềm Lành (Cấp 8)

        // ----- ỐNG NGẮM -----
        new_Skin.ACE32_x6    = 1011020424;
        new_Skin.ACE32_x4    = 1011020425;
        new_Skin.ACE32_x3    = 1011020426;
        new_Skin.ACE32_x2    = 1011020427;
        new_Skin.ACE32_holo  = 1011020428;
        new_Skin.ACE32_reddot= 1011020429;

        // ----- BĂNG ĐẠN -----
        new_Skin.ACE32_Mag             = 1011020423; // Mag cấp 1
        new_Skin.ACE32_extendedMag     = 1011020430;
        new_Skin.ACE32_quickMag        = 1011020434;
        new_Skin.ACE32_quickNextended  = 1011020435;

        // ----- NÒNG -----
        new_Skin.ACE32_flash  = 1011020436;
        new_Skin.ACE32_compe  = 1011020437;
        new_Skin.ACE32_silent = 1011020438;

        // ----- TAY CẦM -----
        new_Skin.ACE32_angle      = 1011020439; // Triangle
        new_Skin.ACE32_thumb      = 1011020440;
        new_Skin.ACE32_verical    = 1011020444;
        new_Skin.ACE32_lightgrip  = 1011020446;

        // ----- BÁNG SÚNG -----
        new_Skin.ACE32_stock      = 1011020445; // Tactical Stock
        new_Skin.ACE32_heavyStock = 1011020450; // Heavy Stock

        // ----- KHÁC -----
        new_Skin.ACE32_laser = 1011020448;
        new_Skin.ACE32_side  = 1011020449; // Ống ngắm phụ
    }
    if (preferences.Config.Skin.ACE32 == 2){
    new_Skin.ACE323 = 1101102007;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    if (preferences.Config.Skin.ACE32 == 3){
    new_Skin.ACE323 = 1101102017;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    if (preferences.Config.Skin.ACE32 == 4){
    new_Skin.ACE323 = 1101102025;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }

    /////////////// ACE32 ///////////////

    if (preferences.Config.Skin.ACE32 == 0)
    new_Skin.ACE324 = 1011025;
    if (preferences.Config.Skin.ACE32 == 1) {

        new_Skin.ACE324 = 1101102041; // Skin chính Tiên Tri Điềm Lành (Cấp 8)

        // ----- ỐNG NGẮM -----
        new_Skin.ACE32_x6    = 1011020424;
        new_Skin.ACE32_x4    = 1011020425;
        new_Skin.ACE32_x3    = 1011020426;
        new_Skin.ACE32_x2    = 1011020427;
        new_Skin.ACE32_holo  = 1011020428;
        new_Skin.ACE32_reddot= 1011020429;

        // ----- BĂNG ĐẠN -----
        new_Skin.ACE32_Mag             = 1011020423; // Mag cấp 1
        new_Skin.ACE32_extendedMag     = 1011020430;
        new_Skin.ACE32_quickMag        = 1011020434;
        new_Skin.ACE32_quickNextended  = 1011020435;

        // ----- NÒNG -----
        new_Skin.ACE32_flash  = 1011020436;
        new_Skin.ACE32_compe  = 1011020437;
        new_Skin.ACE32_silent = 1011020438;

        // ----- TAY CẦM -----
        new_Skin.ACE32_angle      = 1011020439; // Triangle
        new_Skin.ACE32_thumb      = 1011020440;
        new_Skin.ACE32_verical    = 1011020444;
        new_Skin.ACE32_lightgrip  = 1011020446;

        // ----- BÁNG SÚNG -----
        new_Skin.ACE32_stock      = 1011020445; // Tactical Stock
        new_Skin.ACE32_heavyStock = 1011020450; // Heavy Stock

        // ----- KHÁC -----
        new_Skin.ACE32_laser = 1011020448;
        new_Skin.ACE32_side  = 1011020449; // Ống ngắm phụ
    }
    if (preferences.Config.Skin.ACE32 == 2){
    new_Skin.ACE324 = 1101102007;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    if (preferences.Config.Skin.ACE32 == 3){
    new_Skin.ACE324 = 1101102017;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    if (preferences.Config.Skin.ACE32 == 4){
    new_Skin.ACE324 = 1101102025;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    
    /////////////// ACE32 ///////////////

    if (preferences.Config.Skin.ACE32 == 0)
    new_Skin.ACE325 = 1011026;
    if (preferences.Config.Skin.ACE32 == 1) {

        new_Skin.ACE325 = 1101102041; // Skin chính Tiên Tri Điềm Lành (Cấp 8)

        // ----- ỐNG NGẮM -----
        new_Skin.ACE32_x6    = 1011020424;
        new_Skin.ACE32_x4    = 1011020425;
        new_Skin.ACE32_x3    = 1011020426;
        new_Skin.ACE32_x2    = 1011020427;
        new_Skin.ACE32_holo  = 1011020428;
        new_Skin.ACE32_reddot= 1011020429;

        // ----- BĂNG ĐẠN -----
        new_Skin.ACE32_Mag             = 1011020423; // Mag cấp 1
        new_Skin.ACE32_extendedMag     = 1011020430;
        new_Skin.ACE32_quickMag        = 1011020434;
        new_Skin.ACE32_quickNextended  = 1011020435;

        // ----- NÒNG -----
        new_Skin.ACE32_flash  = 1011020436;
        new_Skin.ACE32_compe  = 1011020437;
        new_Skin.ACE32_silent = 1011020438;

        // ----- TAY CẦM -----
        new_Skin.ACE32_angle      = 1011020439; // Triangle
        new_Skin.ACE32_thumb      = 1011020440;
        new_Skin.ACE32_verical    = 1011020444;
        new_Skin.ACE32_lightgrip  = 1011020446;

        // ----- BÁNG SÚNG -----
        new_Skin.ACE32_stock      = 1011020445; // Tactical Stock
        new_Skin.ACE32_heavyStock = 1011020450; // Heavy Stock

        // ----- KHÁC -----
        new_Skin.ACE32_laser = 1011020448;
        new_Skin.ACE32_side  = 1011020449; // Ống ngắm phụ
    }
    if (preferences.Config.Skin.ACE32 == 2){
    new_Skin.ACE325 = 1101102007;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    if (preferences.Config.Skin.ACE32 == 3){
    new_Skin.ACE325 = 1101102017;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    if (preferences.Config.Skin.ACE32 == 4){
    new_Skin.ACE325 = 1101102025;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }

    /////////////// ACE32 ///////////////

    if (preferences.Config.Skin.ACE32 == 0)
    new_Skin.ACE326 = 1011027;
    if (preferences.Config.Skin.ACE32 == 1) {

        new_Skin.ACE326 = 1101102041; // Skin chính Tiên Tri Điềm Lành (Cấp 8)

        // ----- ỐNG NGẮM -----
        new_Skin.ACE32_x6    = 1011020424;
        new_Skin.ACE32_x4    = 1011020425;
        new_Skin.ACE32_x3    = 1011020426;
        new_Skin.ACE32_x2    = 1011020427;
        new_Skin.ACE32_holo  = 1011020428;
        new_Skin.ACE32_reddot= 1011020429;

        // ----- BĂNG ĐẠN -----
        new_Skin.ACE32_Mag             = 1011020423; // Mag cấp 1
        new_Skin.ACE32_extendedMag     = 1011020430;
        new_Skin.ACE32_quickMag        = 1011020434;
        new_Skin.ACE32_quickNextended  = 1011020435;

        // ----- NÒNG -----
        new_Skin.ACE32_flash  = 1011020436;
        new_Skin.ACE32_compe  = 1011020437;
        new_Skin.ACE32_silent = 1011020438;

        // ----- TAY CẦM -----
        new_Skin.ACE32_angle      = 1011020439; // Triangle
        new_Skin.ACE32_thumb      = 1011020440;
        new_Skin.ACE32_verical    = 1011020444;
        new_Skin.ACE32_lightgrip  = 1011020446;

        // ----- BÁNG SÚNG -----
        new_Skin.ACE32_stock      = 1011020445; // Tactical Stock
        new_Skin.ACE32_heavyStock = 1011020450; // Heavy Stock

        // ----- KHÁC -----
        new_Skin.ACE32_laser = 1011020448;
        new_Skin.ACE32_side  = 1011020449; // Ống ngắm phụ
    }
    if (preferences.Config.Skin.ACE32 == 2){
    new_Skin.ACE326 = 1101102007;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    if (preferences.Config.Skin.ACE32 == 3){
    new_Skin.ACE326 = 1101102017;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }
    if (preferences.Config.Skin.ACE32 == 4){
    new_Skin.ACE326 = 1101102025;
    new_Skin.ACE32_reddot = 1010081396;
    new_Skin.ACE32_holo = 1010081395;
    new_Skin.ACE32_x2 = 1010081394;
    new_Skin.ACE32_x3 = 1010081393;
    new_Skin.ACE32_x4 = 1010081392;
    new_Skin.ACE32_x6 = 1010081391;
    }

    /////////////// Honey ///////////////

    if (preferences.Config.Skin.Honey == 0)
    new_Skin.Honey = 101012;
    if (preferences.Config.Skin.Honey == 1)
    new_Skin.Honey = 1101012009;

    if (preferences.Config.Skin.S686 == 0)
    new_Skin.S686 = 104001;
    if (preferences.Config.Skin.S686 == 1)
    new_Skin.S686 = 1104001035;


    if (preferences.Config.Skin.S1897 == 0)
    new_Skin.S1897 = 104002;
    if (preferences.Config.Skin.S1897 == 1)
    new_Skin.S1897 = 1104002022;
    if (preferences.Config.Skin.S1897 == 2)
    new_Skin.S1897 = 1104002035;
    if (preferences.Config.Skin.S1897 == 3)
    new_Skin.S1897 = 1104002004;


    if (preferences.Config.Skin.DBS == 0)
    new_Skin.DBS = 104004;
    if (preferences.Config.Skin.DBS == 1)
    new_Skin.DBS = 1104004041;
    if (preferences.Config.Skin.DBS == 2)
    new_Skin.DBS = 1104004035;
    if (preferences.Config.Skin.DBS == 3)
    new_Skin.DBS = 1104004014;
    if (preferences.Config.Skin.DBS == 4)
    new_Skin.DBS = 1104004015;
    if (preferences.Config.Skin.DBS == 5)
    new_Skin.DBS = 1104004024;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if (preferences.Config.Skin.NS2000 == 0)
    new_Skin.NS2000 = 104102;
    if (preferences.Config.Skin.NS2000 == 1)
    new_Skin.NS2000 = 1104102004;
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.S12K == 0)
    new_Skin.S12K = 104003;
    if (preferences.Config.Skin.S12K == 1)
    new_Skin.S12K = 1104003037;
    if (preferences.Config.Skin.S12K == 2)
    new_Skin.S12K = 1104003038;
    if (preferences.Config.Skin.S12K == 3)
    new_Skin.S12K = 1104003026;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.UZI == 0) 
    new_Skin.UZI = 102001;
    if (preferences.Config.Skin.UZI == 1) {
        new_Skin.UZI = 1102001130;   // Skin chính

        // Ống ngắm
        new_Skin.UZI_reddot = 1020011243;
        new_Skin.UZI_holo   = 1020011242;

        // Băng đạn
        new_Skin.UZI_extendedMag    = 1020011244;
        new_Skin.UZI_quickMag       = 1020011245;
        new_Skin.UZI_quickNextended = 1020011246;

        // Nòng
        new_Skin.UZI_flash  = 1020011247;
        new_Skin.UZI_compe  = 1020011248;
        new_Skin.UZI_silent = 1020011249;

        // Báng súng
        new_Skin.UZI_stock = 1020011250;
    }

    if (preferences.Config.Skin.UZI == 2)
    new_Skin.UZI = 1102001120;
    if (preferences.Config.Skin.UZI == 3)
    new_Skin.UZI = 1102001036;
    if (preferences.Config.Skin.UZI == 4)
    new_Skin.UZI = 1102001058;
    if (preferences.Config.Skin.UZI == 5)
    new_Skin.UZI = 1102001069;
    if (preferences.Config.Skin.UZI == 6)
    new_Skin.UZI = 1102001089;
    if (preferences.Config.Skin.UZI == 7)
    new_Skin.UZI = 1102001024;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.UZI == 0)
    new_Skin.UZI1 = 1020012;
    if (preferences.Config.Skin.UZI == 1) {
        new_Skin.UZI1 = 1102001130;   // Skin chính

        // Ống ngắm
        new_Skin.UZI_reddot = 1020011243;
        new_Skin.UZI_holo   = 1020011242;

        // Băng đạn
        new_Skin.UZI_extendedMag    = 1020011244;
        new_Skin.UZI_quickMag       = 1020011245;
        new_Skin.UZI_quickNextended = 1020011246;

        // Nòng
        new_Skin.UZI_flash  = 1020011247;
        new_Skin.UZI_compe  = 1020011248;
        new_Skin.UZI_silent = 1020011249;

        // Báng súng
        new_Skin.UZI_stock = 1020011250;
    }

    if (preferences.Config.Skin.UZI == 2)
    new_Skin.UZI1 = 1102001120;
    if (preferences.Config.Skin.UZI == 3)
    new_Skin.UZI1 = 1102001036;
    if (preferences.Config.Skin.UZI == 4)
    new_Skin.UZI1 = 1102001058;
    if (preferences.Config.Skin.UZI == 5)
    new_Skin.UZI1 = 1102001069;
    if (preferences.Config.Skin.UZI == 6)
    new_Skin.UZI1 = 1102001089;
    if (preferences.Config.Skin.UZI == 7)
    new_Skin.UZI1 = 1102001024;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.UZI == 0)
    new_Skin.UZI2 = 1020013;
    if (preferences.Config.Skin.UZI == 1) {
        new_Skin.UZI2 = 1102001130;   // Skin chính

        // Ống ngắm
        new_Skin.UZI_reddot = 1020011243;
        new_Skin.UZI_holo   = 1020011242;

        // Băng đạn
        new_Skin.UZI_extendedMag    = 1020011244;
        new_Skin.UZI_quickMag       = 1020011245;
        new_Skin.UZI_quickNextended = 1020011246;

        // Nòng
        new_Skin.UZI_flash  = 1020011247;
        new_Skin.UZI_compe  = 1020011248;
        new_Skin.UZI_silent = 1020011249;

        // Báng súng
        new_Skin.UZI_stock = 1020011250;
    }

    if (preferences.Config.Skin.UZI == 2)
    new_Skin.UZI2 = 1102001120;
    if (preferences.Config.Skin.UZI == 3)
    new_Skin.UZI2 = 1102001036;
    if (preferences.Config.Skin.UZI == 4)
    new_Skin.UZI2 = 1102001058;
    if (preferences.Config.Skin.UZI == 5)
    new_Skin.UZI2 = 1102001069;
    if (preferences.Config.Skin.UZI == 6)
    new_Skin.UZI2 = 1102001089;
    if (preferences.Config.Skin.UZI == 7)
    new_Skin.UZI2 = 1102001024;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.UZI == 0)
    new_Skin.UZI4 = 1020014;
    if (preferences.Config.Skin.UZI == 1) {
        new_Skin.UZI4 = 1102001130;   // Skin chính

        // Ống ngắm
        new_Skin.UZI_reddot = 1020011243;
        new_Skin.UZI_holo   = 1020011242;

        // Băng đạn
        new_Skin.UZI_extendedMag    = 1020011244;
        new_Skin.UZI_quickMag       = 1020011245;
        new_Skin.UZI_quickNextended = 1020011246;

        // Nòng
        new_Skin.UZI_flash  = 1020011247;
        new_Skin.UZI_compe  = 1020011248;
        new_Skin.UZI_silent = 1020011249;

        // Báng súng
        new_Skin.UZI_stock = 1020011250;
    }

    if (preferences.Config.Skin.UZI == 2)
    new_Skin.UZI4 = 1102001120;
    if (preferences.Config.Skin.UZI == 3)
    new_Skin.UZI4 = 1102001036;
    if (preferences.Config.Skin.UZI == 4)
    new_Skin.UZI4 = 1102001058;
    if (preferences.Config.Skin.UZI == 5)
    new_Skin.UZI4 = 1102001069;
    if (preferences.Config.Skin.UZI == 6)
    new_Skin.UZI4 = 1102001089;
    if (preferences.Config.Skin.UZI == 7)
    new_Skin.UZI4 = 1102001024;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.UZI == 0)
    new_Skin.UZI5 = 1020016;
    if (preferences.Config.Skin.UZI == 1) {
        new_Skin.UZI5 = 1102001130;   // Skin chính

        // Ống ngắm
        new_Skin.UZI_reddot = 1020011243;
        new_Skin.UZI_holo   = 1020011242;

        // Băng đạn
        new_Skin.UZI_extendedMag    = 1020011244;
        new_Skin.UZI_quickMag       = 1020011245;
        new_Skin.UZI_quickNextended = 1020011246;

        // Nòng
        new_Skin.UZI_flash  = 1020011247;
        new_Skin.UZI_compe  = 1020011248;
        new_Skin.UZI_silent = 1020011249;

        // Báng súng
        new_Skin.UZI_stock = 1020011250;
    }

    if (preferences.Config.Skin.UZI == 2)
    new_Skin.UZI5 = 1102001120;
    if (preferences.Config.Skin.UZI == 3)
    new_Skin.UZI5 = 1102001036;
    if (preferences.Config.Skin.UZI == 4)
    new_Skin.UZI5 = 1102001058;
    if (preferences.Config.Skin.UZI == 5)
    new_Skin.UZI5 = 1102001069;
    if (preferences.Config.Skin.UZI == 6)
    new_Skin.UZI5 = 1102001089;
    if (preferences.Config.Skin.UZI == 7)
    new_Skin.UZI5 = 1102001024;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.UZI == 0)
    new_Skin.UZI6 = 1020017;
    if (preferences.Config.Skin.UZI == 1) {
        new_Skin.UZI6 = 1102001130;   // Skin chính

        // Ống ngắm
        new_Skin.UZI_reddot = 1020011243;
        new_Skin.UZI_holo   = 1020011242;

        // Băng đạn
        new_Skin.UZI_extendedMag    = 1020011244;
        new_Skin.UZI_quickMag       = 1020011245;
        new_Skin.UZI_quickNextended = 1020011246;

        // Nòng
        new_Skin.UZI_flash  = 1020011247;
        new_Skin.UZI_compe  = 1020011248;
        new_Skin.UZI_silent = 1020011249;

        // Báng súng
        new_Skin.UZI_stock = 1020011250;
    }

    if (preferences.Config.Skin.UZI == 2)
    new_Skin.UZI6 = 1102001120;
    if (preferences.Config.Skin.UZI == 3)
    new_Skin.UZI6 = 1102001036;
    if (preferences.Config.Skin.UZI == 4)
    new_Skin.UZI6 = 1102001058;
    if (preferences.Config.Skin.UZI == 5)
    new_Skin.UZI6 = 1102001069;
    if (preferences.Config.Skin.UZI == 6)
    new_Skin.UZI6 = 1102001089;
    if (preferences.Config.Skin.UZI == 7)
    new_Skin.UZI6 = 1102001024;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if (preferences.Config.Skin.UMP == 0){
    new_Skin.UMP = 102002;
    new_Skin.UMP_2 = 292002;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 1){
    new_Skin.UMP = 1102002424;
    new_Skin.UMP_2 = 1020020431;
    new_Skin.UMP_flash = 1020020372;
    new_Skin.UMP_compe = 1020020374;
    new_Skin.UMP_silent = 1020020373;
    new_Skin.UMP_reddot = 1020020379;
    new_Skin.UMP_holo = 1020020378;
    new_Skin.UMP_x2 = 1020020377;
    new_Skin.UMP_x3 = 1020020376;
    new_Skin.UMP_x4 = 1020020375;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020380;
    new_Skin.UMP_extendedMag = 1020020383;
    new_Skin.UMP_quickNextended = 1020020384;
    new_Skin.UMP_verical = 1020020385;
    new_Skin.UMP_angle = 1020020387;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020386;
    }
    if (preferences.Config.Skin.UMP == 2){
    new_Skin.UMP = 1102002136;
    new_Skin.UMP_2 = 1020021357;
    new_Skin.UMP_flash = 1020021314;
    new_Skin.UMP_compe = 1020021313;
    new_Skin.UMP_silent = 1020021315;
    new_Skin.UMP_reddot = 1020021307;
    new_Skin.UMP_holo = 1020021306;
    new_Skin.UMP_x2 = 1020021305;
    new_Skin.UMP_x3 = 1020021304;
    new_Skin.UMP_x4 = 1020021303;
    new_Skin.UMP_x6 = 1020021302;
    new_Skin.UMP_quickMag = 1020021308;
    new_Skin.UMP_extendedMag = 1020021309;
    new_Skin.UMP_quickNextended = 1020021312;
    new_Skin.UMP_verical = 1020021318;
    new_Skin.UMP_angle = 1020021316;
    new_Skin.UMP_lightgrip = 1020021323;
    new_Skin.UMP_pink = 1020021324;
    new_Skin.UMP_lazer = 1020021322;
    new_Skin.UMP_thumb = 1020021317;
    }
    if (preferences.Config.Skin.UMP == 3){
    new_Skin.UMP = 1102002061;
    new_Skin.UMP_2 = 1020020611;
    new_Skin.UMP_flash = 1020020552;
    new_Skin.UMP_compe = 1020020554;
    new_Skin.UMP_silent = 1020020553;
    new_Skin.UMP_reddot = 1020020559;
    new_Skin.UMP_holo = 1020020558;
    new_Skin.UMP_x2 = 1020020557;
    new_Skin.UMP_x3 = 1020020556;
    new_Skin.UMP_x4 = 1020020555;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020562;
    new_Skin.UMP_extendedMag = 1020020563;
    new_Skin.UMP_quickNextended = 1020020564;
    new_Skin.UMP_verical = 1020020565;
    new_Skin.UMP_angle = 1020020567;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020566;
    }
    if (preferences.Config.Skin.UMP == 4){
    new_Skin.UMP = 1102002090;
    new_Skin.UMP_2 = 1020020901;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 5){
    new_Skin.UMP = 1102002117;
    new_Skin.UMP_2 = 1020021171;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 6){
    new_Skin.UMP = 1102002124;
    new_Skin.UMP_2 = 1020021241;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 7){
    new_Skin.UMP = 1102002043;
    new_Skin.UMP_2 = 1020020431;
    new_Skin.UMP_flash = 1020020372;
    new_Skin.UMP_compe = 1020020374;
    new_Skin.UMP_silent = 1020020373;
    new_Skin.UMP_reddot = 1020020379;
    new_Skin.UMP_holo = 1020020378;
    new_Skin.UMP_x2 = 1020020377;
    new_Skin.UMP_x3 = 1020020376;
    new_Skin.UMP_x4 = 1020020375;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020380;
    new_Skin.UMP_extendedMag = 1020020383;
    new_Skin.UMP_quickNextended = 1020020384;
    new_Skin.UMP_verical = 1020020385;
    new_Skin.UMP_angle = 1020020387;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020386;
    }
    
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.UMP == 0) {
    new_Skin.UMP1 = 1020022;
    new_Skin.UMP_2 = 292002;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 1){
    new_Skin.UMP1 = 1102002424;
    new_Skin.UMP_2 = 1020020431;
    new_Skin.UMP_flash = 1020020372;
    new_Skin.UMP_compe = 1020020374;
    new_Skin.UMP_silent = 1020020373;
    new_Skin.UMP_reddot = 1020020379;
    new_Skin.UMP_holo = 1020020378;
    new_Skin.UMP_x2 = 1020020377;
    new_Skin.UMP_x3 = 1020020376;
    new_Skin.UMP_x4 = 1020020375;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020380;
    new_Skin.UMP_extendedMag = 1020020383;
    new_Skin.UMP_quickNextended = 1020020384;
    new_Skin.UMP_verical = 1020020385;
    new_Skin.UMP_angle = 1020020387;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020386;
    }
    if (preferences.Config.Skin.UMP == 2){
    new_Skin.UMP1 = 1102002136;
    new_Skin.UMP_2 = 1020021357;
    new_Skin.UMP_flash = 1020021314;
    new_Skin.UMP_compe = 1020021313;
    new_Skin.UMP_silent = 1020021315;
    new_Skin.UMP_reddot = 1020021307;
    new_Skin.UMP_holo = 1020021306;
    new_Skin.UMP_x2 = 1020021305;
    new_Skin.UMP_x3 = 1020021304;
    new_Skin.UMP_x4 = 1020021303;
    new_Skin.UMP_x6 = 1020021302;
    new_Skin.UMP_quickMag = 1020021308;
    new_Skin.UMP_extendedMag = 1020021309;
    new_Skin.UMP_quickNextended = 1020021312;
    new_Skin.UMP_verical = 1020021318;
    new_Skin.UMP_angle = 1020021316;
    new_Skin.UMP_lightgrip = 1020021323;
    new_Skin.UMP_pink = 1020021324;
    new_Skin.UMP_lazer = 1020021322;
    new_Skin.UMP_thumb = 1020021317;
    }
    if (preferences.Config.Skin.UMP == 3){
    new_Skin.UMP1 = 1102002061;
    new_Skin.UMP_2 = 1020020611;
    new_Skin.UMP_flash = 1020020552;
    new_Skin.UMP_compe = 1020020554;
    new_Skin.UMP_silent = 1020020553;
    new_Skin.UMP_reddot = 1020020559;
    new_Skin.UMP_holo = 1020020558;
    new_Skin.UMP_x2 = 1020020557;
    new_Skin.UMP_x3 = 1020020556;
    new_Skin.UMP_x4 = 1020020555;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020562;
    new_Skin.UMP_extendedMag = 1020020563;
    new_Skin.UMP_quickNextended = 1020020564;
    new_Skin.UMP_verical = 1020020565;
    new_Skin.UMP_angle = 1020020567;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020566;
    }
    if (preferences.Config.Skin.UMP == 4){
    new_Skin.UMP1 = 1102002090;
    new_Skin.UMP_2 = 1020020901;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 5){
    new_Skin.UMP1 = 1102002117;
    new_Skin.UMP_2 = 1020021171;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 6){
    new_Skin.UMP1 = 1102002124;
    new_Skin.UMP_2 = 1020021241;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 7){
    new_Skin.UMP1 = 1102002043;
    new_Skin.UMP_2 = 1020020431;
    new_Skin.UMP_flash = 1020020372;
    new_Skin.UMP_compe = 1020020374;
    new_Skin.UMP_silent = 1020020373;
    new_Skin.UMP_reddot = 1020020379;
    new_Skin.UMP_holo = 1020020378;
    new_Skin.UMP_x2 = 1020020377;
    new_Skin.UMP_x3 = 1020020376;
    new_Skin.UMP_x4 = 1020020375;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020380;
    new_Skin.UMP_extendedMag = 1020020383;
    new_Skin.UMP_quickNextended = 1020020384;
    new_Skin.UMP_verical = 1020020385;
    new_Skin.UMP_angle = 1020020387;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020386;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.UMP == 0) {
    new_Skin.UMP2 = 1020023;
    new_Skin.UMP_2 = 292002;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 1){
    new_Skin.UMP2 = 1102002424;
    new_Skin.UMP_2 = 1020020431;
    new_Skin.UMP_flash = 1020020372;
    new_Skin.UMP_compe = 1020020374;
    new_Skin.UMP_silent = 1020020373;
    new_Skin.UMP_reddot = 1020020379;
    new_Skin.UMP_holo = 1020020378;
    new_Skin.UMP_x2 = 1020020377;
    new_Skin.UMP_x3 = 1020020376;
    new_Skin.UMP_x4 = 1020020375;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020380;
    new_Skin.UMP_extendedMag = 1020020383;
    new_Skin.UMP_quickNextended = 1020020384;
    new_Skin.UMP_verical = 1020020385;
    new_Skin.UMP_angle = 1020020387;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020386;
    }
    if (preferences.Config.Skin.UMP == 2){
    new_Skin.UMP2 = 1102002136;
    new_Skin.UMP_2 = 1020021357;
    new_Skin.UMP_flash = 1020021314;
    new_Skin.UMP_compe = 1020021313;
    new_Skin.UMP_silent = 1020021315;
    new_Skin.UMP_reddot = 1020021307;
    new_Skin.UMP_holo = 1020021306;
    new_Skin.UMP_x2 = 1020021305;
    new_Skin.UMP_x3 = 1020021304;
    new_Skin.UMP_x4 = 1020021303;
    new_Skin.UMP_x6 = 1020021302;
    new_Skin.UMP_quickMag = 1020021308;
    new_Skin.UMP_extendedMag = 1020021309;
    new_Skin.UMP_quickNextended = 1020021312;
    new_Skin.UMP_verical = 1020021318;
    new_Skin.UMP_angle = 1020021316;
    new_Skin.UMP_lightgrip = 1020021323;
    new_Skin.UMP_pink = 1020021324;
    new_Skin.UMP_lazer = 1020021322;
    new_Skin.UMP_thumb = 1020021317;
    }
    if (preferences.Config.Skin.UMP == 3){
    new_Skin.UMP2 = 1102002061;
    new_Skin.UMP_2 = 1020020611;
    new_Skin.UMP_flash = 1020020552;
    new_Skin.UMP_compe = 1020020554;
    new_Skin.UMP_silent = 1020020553;
    new_Skin.UMP_reddot = 1020020559;
    new_Skin.UMP_holo = 1020020558;
    new_Skin.UMP_x2 = 1020020557;
    new_Skin.UMP_x3 = 1020020556;
    new_Skin.UMP_x4 = 1020020555;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020562;
    new_Skin.UMP_extendedMag = 1020020563;
    new_Skin.UMP_quickNextended = 1020020564;
    new_Skin.UMP_verical = 1020020565;
    new_Skin.UMP_angle = 1020020567;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020566;
    }
    if (preferences.Config.Skin.UMP == 4){
    new_Skin.UMP2 = 1102002090;
    new_Skin.UMP_2 = 1020020901;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 5){
    new_Skin.UMP2 = 1102002117;
    new_Skin.UMP_2 = 1020021171;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 6){
    new_Skin.UMP2 = 1102002124;
    new_Skin.UMP_2 = 1020021241;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 7){
    new_Skin.UMP2 = 1102002043;
    new_Skin.UMP_2 = 1020020431;
    new_Skin.UMP_flash = 1020020372;
    new_Skin.UMP_compe = 1020020374;
    new_Skin.UMP_silent = 1020020373;
    new_Skin.UMP_reddot = 1020020379;
    new_Skin.UMP_holo = 1020020378;
    new_Skin.UMP_x2 = 1020020377;
    new_Skin.UMP_x3 = 1020020376;
    new_Skin.UMP_x4 = 1020020375;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020380;
    new_Skin.UMP_extendedMag = 1020020383;
    new_Skin.UMP_quickNextended = 1020020384;
    new_Skin.UMP_verical = 1020020385;
    new_Skin.UMP_angle = 1020020387;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020386;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.UMP == 0) {
    new_Skin.UMP3 = 1020024;
    new_Skin.UMP_2 = 292002;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 1){
    new_Skin.UMP3 = 1102002424;
    new_Skin.UMP_2 = 1020020431;
    new_Skin.UMP_flash = 1020020372;
    new_Skin.UMP_compe = 1020020374;
    new_Skin.UMP_silent = 1020020373;
    new_Skin.UMP_reddot = 1020020379;
    new_Skin.UMP_holo = 1020020378;
    new_Skin.UMP_x2 = 1020020377;
    new_Skin.UMP_x3 = 1020020376;
    new_Skin.UMP_x4 = 1020020375;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020380;
    new_Skin.UMP_extendedMag = 1020020383;
    new_Skin.UMP_quickNextended = 1020020384;
    new_Skin.UMP_verical = 1020020385;
    new_Skin.UMP_angle = 1020020387;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020386;
    }
    if (preferences.Config.Skin.UMP == 2){
    new_Skin.UMP3 = 1102002136;
    new_Skin.UMP_2 = 1020021357;
    new_Skin.UMP_flash = 1020021314;
    new_Skin.UMP_compe = 1020021313;
    new_Skin.UMP_silent = 1020021315;
    new_Skin.UMP_reddot = 1020021307;
    new_Skin.UMP_holo = 1020021306;
    new_Skin.UMP_x2 = 1020021305;
    new_Skin.UMP_x3 = 1020021304;
    new_Skin.UMP_x4 = 1020021303;
    new_Skin.UMP_x6 = 1020021302;
    new_Skin.UMP_quickMag = 1020021308;
    new_Skin.UMP_extendedMag = 1020021309;
    new_Skin.UMP_quickNextended = 1020021312;
    new_Skin.UMP_verical = 1020021318;
    new_Skin.UMP_angle = 1020021316;
    new_Skin.UMP_lightgrip = 1020021323;
    new_Skin.UMP_pink = 1020021324;
    new_Skin.UMP_lazer = 1020021322;
    new_Skin.UMP_thumb = 1020021317;
    }
    if (preferences.Config.Skin.UMP == 3){
    new_Skin.UMP3 = 1102002061;
    new_Skin.UMP_2 = 1020020611;
    new_Skin.UMP_flash = 1020020552;
    new_Skin.UMP_compe = 1020020554;
    new_Skin.UMP_silent = 1020020553;
    new_Skin.UMP_reddot = 1020020559;
    new_Skin.UMP_holo = 1020020558;
    new_Skin.UMP_x2 = 1020020557;
    new_Skin.UMP_x3 = 1020020556;
    new_Skin.UMP_x4 = 1020020555;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020562;
    new_Skin.UMP_extendedMag = 1020020563;
    new_Skin.UMP_quickNextended = 1020020564;
    new_Skin.UMP_verical = 1020020565;
    new_Skin.UMP_angle = 1020020567;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020566;
    }
    if (preferences.Config.Skin.UMP == 4){
    new_Skin.UMP3 = 1102002090;
    new_Skin.UMP_2 = 1020020901;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 5){
    new_Skin.UMP3 = 1102002117;
    new_Skin.UMP_2 = 1020021171;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 6){
    new_Skin.UMP3 = 1102002124;
    new_Skin.UMP_2 = 1020021241;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 7){
    new_Skin.UMP3 = 1102002043;
    new_Skin.UMP_2 = 1020020431;
    new_Skin.UMP_flash = 1020020372;
    new_Skin.UMP_compe = 1020020374;
    new_Skin.UMP_silent = 1020020373;
    new_Skin.UMP_reddot = 1020020379;
    new_Skin.UMP_holo = 1020020378;
    new_Skin.UMP_x2 = 1020020377;
    new_Skin.UMP_x3 = 1020020376;
    new_Skin.UMP_x4 = 1020020375;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020380;
    new_Skin.UMP_extendedMag = 1020020383;
    new_Skin.UMP_quickNextended = 1020020384;
    new_Skin.UMP_verical = 1020020385;
    new_Skin.UMP_angle = 1020020387;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020386;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.UMP == 0) {
    new_Skin.UMP4 = 1020025;
    new_Skin.UMP_2 = 292002;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 1){
    new_Skin.UMP4 = 1102002424;
    new_Skin.UMP_2 = 1020020431;
    new_Skin.UMP_flash = 1020020372;
    new_Skin.UMP_compe = 1020020374;
    new_Skin.UMP_silent = 1020020373;
    new_Skin.UMP_reddot = 1020020379;
    new_Skin.UMP_holo = 1020020378;
    new_Skin.UMP_x2 = 1020020377;
    new_Skin.UMP_x3 = 1020020376;
    new_Skin.UMP_x4 = 1020020375;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020380;
    new_Skin.UMP_extendedMag = 1020020383;
    new_Skin.UMP_quickNextended = 1020020384;
    new_Skin.UMP_verical = 1020020385;
    new_Skin.UMP_angle = 1020020387;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020386;
    }
    if (preferences.Config.Skin.UMP == 2){
    new_Skin.UMP4 = 1102002136;
    new_Skin.UMP_2 = 1020021357;
    new_Skin.UMP_flash = 1020021314;
    new_Skin.UMP_compe = 1020021313;
    new_Skin.UMP_silent = 1020021315;
    new_Skin.UMP_reddot = 1020021307;
    new_Skin.UMP_holo = 1020021306;
    new_Skin.UMP_x2 = 1020021305;
    new_Skin.UMP_x3 = 1020021304;
    new_Skin.UMP_x4 = 1020021303;
    new_Skin.UMP_x6 = 1020021302;
    new_Skin.UMP_quickMag = 1020021308;
    new_Skin.UMP_extendedMag = 1020021309;
    new_Skin.UMP_quickNextended = 1020021312;
    new_Skin.UMP_verical = 1020021318;
    new_Skin.UMP_angle = 1020021316;
    new_Skin.UMP_lightgrip = 1020021323;
    new_Skin.UMP_pink = 1020021324;
    new_Skin.UMP_lazer = 1020021322;
    new_Skin.UMP_thumb = 1020021317;
    }
    if (preferences.Config.Skin.UMP == 3){
    new_Skin.UMP4 = 1102002061;
    new_Skin.UMP_2 = 1020020611;
    new_Skin.UMP_flash = 1020020552;
    new_Skin.UMP_compe = 1020020554;
    new_Skin.UMP_silent = 1020020553;
    new_Skin.UMP_reddot = 1020020559;
    new_Skin.UMP_holo = 1020020558;
    new_Skin.UMP_x2 = 1020020557;
    new_Skin.UMP_x3 = 1020020556;
    new_Skin.UMP_x4 = 1020020555;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020562;
    new_Skin.UMP_extendedMag = 1020020563;
    new_Skin.UMP_quickNextended = 1020020564;
    new_Skin.UMP_verical = 1020020565;
    new_Skin.UMP_angle = 1020020567;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020566;
    }
    if (preferences.Config.Skin.UMP == 4){
    new_Skin.UMP4 = 1102002090;
    new_Skin.UMP_2 = 1020020901;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 5){
    new_Skin.UMP4 = 1102002117;
    new_Skin.UMP_2 = 1020021171;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 6){
    new_Skin.UMP4 = 1102002124;
    new_Skin.UMP_2 = 1020021241;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 7){
    new_Skin.UMP4 = 1102002043;
    new_Skin.UMP_2 = 1020020431;
    new_Skin.UMP_flash = 1020020372;
    new_Skin.UMP_compe = 1020020374;
    new_Skin.UMP_silent = 1020020373;
    new_Skin.UMP_reddot = 1020020379;
    new_Skin.UMP_holo = 1020020378;
    new_Skin.UMP_x2 = 1020020377;
    new_Skin.UMP_x3 = 1020020376;
    new_Skin.UMP_x4 = 1020020375;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020380;
    new_Skin.UMP_extendedMag = 1020020383;
    new_Skin.UMP_quickNextended = 1020020384;
    new_Skin.UMP_verical = 1020020385;
    new_Skin.UMP_angle = 1020020387;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020386;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.UMP == 0) {
    new_Skin.UMP5 = 1020026;
    new_Skin.UMP_2 = 292002;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 1){
    new_Skin.UMP5 = 1102002424;
    new_Skin.UMP_2 = 1020020431;
    new_Skin.UMP_flash = 1020020372;
    new_Skin.UMP_compe = 1020020374;
    new_Skin.UMP_silent = 1020020373;
    new_Skin.UMP_reddot = 1020020379;
    new_Skin.UMP_holo = 1020020378;
    new_Skin.UMP_x2 = 1020020377;
    new_Skin.UMP_x3 = 1020020376;
    new_Skin.UMP_x4 = 1020020375;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020380;
    new_Skin.UMP_extendedMag = 1020020383;
    new_Skin.UMP_quickNextended = 1020020384;
    new_Skin.UMP_verical = 1020020385;
    new_Skin.UMP_angle = 1020020387;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020386;
    }
    if (preferences.Config.Skin.UMP == 2){
    new_Skin.UMP5 = 1102002136;
    new_Skin.UMP_2 = 1020021357;
    new_Skin.UMP_flash = 1020021314;
    new_Skin.UMP_compe = 1020021313;
    new_Skin.UMP_silent = 1020021315;
    new_Skin.UMP_reddot = 1020021307;
    new_Skin.UMP_holo = 1020021306;
    new_Skin.UMP_x2 = 1020021305;
    new_Skin.UMP_x3 = 1020021304;
    new_Skin.UMP_x4 = 1020021303;
    new_Skin.UMP_x6 = 1020021302;
    new_Skin.UMP_quickMag = 1020021308;
    new_Skin.UMP_extendedMag = 1020021309;
    new_Skin.UMP_quickNextended = 1020021312;
    new_Skin.UMP_verical = 1020021318;
    new_Skin.UMP_angle = 1020021316;
    new_Skin.UMP_lightgrip = 1020021323;
    new_Skin.UMP_pink = 1020021324;
    new_Skin.UMP_lazer = 1020021322;
    new_Skin.UMP_thumb = 1020021317;
    }
    if (preferences.Config.Skin.UMP == 3){
    new_Skin.UMP5 = 1102002061;
    new_Skin.UMP_2 = 1020020611;
    new_Skin.UMP_flash = 1020020552;
    new_Skin.UMP_compe = 1020020554;
    new_Skin.UMP_silent = 1020020553;
    new_Skin.UMP_reddot = 1020020559;
    new_Skin.UMP_holo = 1020020558;
    new_Skin.UMP_x2 = 1020020557;
    new_Skin.UMP_x3 = 1020020556;
    new_Skin.UMP_x4 = 1020020555;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020562;
    new_Skin.UMP_extendedMag = 1020020563;
    new_Skin.UMP_quickNextended = 1020020564;
    new_Skin.UMP_verical = 1020020565;
    new_Skin.UMP_angle = 1020020567;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020566;
    }
    if (preferences.Config.Skin.UMP == 4){
    new_Skin.UMP5 = 1102002090;
    new_Skin.UMP_2 = 1020020901;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 5){
    new_Skin.UMP5 = 1102002117;
    new_Skin.UMP_2 = 1020021171;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 6){
    new_Skin.UMP5 = 1102002124;
    new_Skin.UMP_2 = 1020021241;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 7){
    new_Skin.UMP5 = 1102002043;
    new_Skin.UMP_2 = 1020020431;
    new_Skin.UMP_flash = 1020020372;
    new_Skin.UMP_compe = 1020020374;
    new_Skin.UMP_silent = 1020020373;
    new_Skin.UMP_reddot = 1020020379;
    new_Skin.UMP_holo = 1020020378;
    new_Skin.UMP_x2 = 1020020377;
    new_Skin.UMP_x3 = 1020020376;
    new_Skin.UMP_x4 = 1020020375;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020380;
    new_Skin.UMP_extendedMag = 1020020383;
    new_Skin.UMP_quickNextended = 1020020384;
    new_Skin.UMP_verical = 1020020385;
    new_Skin.UMP_angle = 1020020387;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020386;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.UMP == 0) {
    new_Skin.UMP6 = 1020027;
    new_Skin.UMP_2 = 292002;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 1){
    new_Skin.UMP6 = 1102002424;
    new_Skin.UMP_2 = 1020020431;
    new_Skin.UMP_flash = 1020020372;
    new_Skin.UMP_compe = 1020020374;
    new_Skin.UMP_silent = 1020020373;
    new_Skin.UMP_reddot = 1020020379;
    new_Skin.UMP_holo = 1020020378;
    new_Skin.UMP_x2 = 1020020377;
    new_Skin.UMP_x3 = 1020020376;
    new_Skin.UMP_x4 = 1020020375;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020380;
    new_Skin.UMP_extendedMag = 1020020383;
    new_Skin.UMP_quickNextended = 1020020384;
    new_Skin.UMP_verical = 1020020385;
    new_Skin.UMP_angle = 1020020387;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020386;
    }
    if (preferences.Config.Skin.UMP == 2){
    new_Skin.UMP6 = 1102002136;
    new_Skin.UMP_2 = 1020021357;
    new_Skin.UMP_flash = 1020021314;
    new_Skin.UMP_compe = 1020021313;
    new_Skin.UMP_silent = 1020021315;
    new_Skin.UMP_reddot = 1020021307;
    new_Skin.UMP_holo = 1020021306;
    new_Skin.UMP_x2 = 1020021305;
    new_Skin.UMP_x3 = 1020021304;
    new_Skin.UMP_x4 = 1020021303;
    new_Skin.UMP_x6 = 1020021302;
    new_Skin.UMP_quickMag = 1020021308;
    new_Skin.UMP_extendedMag = 1020021309;
    new_Skin.UMP_quickNextended = 1020021312;
    new_Skin.UMP_verical = 1020021318;
    new_Skin.UMP_angle = 1020021316;
    new_Skin.UMP_lightgrip = 1020021323;
    new_Skin.UMP_pink = 1020021324;
    new_Skin.UMP_lazer = 1020021322;
    new_Skin.UMP_thumb = 1020021317;
    }
    if (preferences.Config.Skin.UMP == 3){
    new_Skin.UMP6 = 1102002061;
    new_Skin.UMP_2 = 1020020611;
    new_Skin.UMP_flash = 1020020552;
    new_Skin.UMP_compe = 1020020554;
    new_Skin.UMP_silent = 1020020553;
    new_Skin.UMP_reddot = 1020020559;
    new_Skin.UMP_holo = 1020020558;
    new_Skin.UMP_x2 = 1020020557;
    new_Skin.UMP_x3 = 1020020556;
    new_Skin.UMP_x4 = 1020020555;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020562;
    new_Skin.UMP_extendedMag = 1020020563;
    new_Skin.UMP_quickNextended = 1020020564;
    new_Skin.UMP_verical = 1020020565;
    new_Skin.UMP_angle = 1020020567;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020566;
    }
    if (preferences.Config.Skin.UMP == 4){
    new_Skin.UMP6 = 1102002090;
    new_Skin.UMP_2 = 1020020901;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 5){
    new_Skin.UMP6 = 1102002117;
    new_Skin.UMP_2 = 1020021171;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 6){
    new_Skin.UMP6 = 1102002124;
    new_Skin.UMP_2 = 1020021241;
    new_Skin.UMP_flash = 201004;
    new_Skin.UMP_compe = 201002;
    new_Skin.UMP_silent = 201006;
    new_Skin.UMP_reddot = 203001;
    new_Skin.UMP_holo = 203002;
    new_Skin.UMP_x2 = 203003;
    new_Skin.UMP_x3 = 203014;
    new_Skin.UMP_x4 = 203004;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 204005;
    new_Skin.UMP_extendedMag = 204004;
    new_Skin.UMP_quickNextended = 204006;
    new_Skin.UMP_verical = 202002;
    new_Skin.UMP_angle = 202001;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 202006;
    }
    if (preferences.Config.Skin.UMP == 7){
    new_Skin.UMP6 = 1102002043;
    new_Skin.UMP_2 = 1020020431;
    new_Skin.UMP_flash = 1020020372;
    new_Skin.UMP_compe = 1020020374;
    new_Skin.UMP_silent = 1020020373;
    new_Skin.UMP_reddot = 1020020379;
    new_Skin.UMP_holo = 1020020378;
    new_Skin.UMP_x2 = 1020020377;
    new_Skin.UMP_x3 = 1020020376;
    new_Skin.UMP_x4 = 1020020375;
    new_Skin.UMP_x6 = 203015;
    new_Skin.UMP_quickMag = 1020020380;
    new_Skin.UMP_extendedMag = 1020020383;
    new_Skin.UMP_quickNextended = 1020020384;
    new_Skin.UMP_verical = 1020020385;
    new_Skin.UMP_angle = 1020020387;
    new_Skin.UMP_lightgrip = 202004;
    new_Skin.UMP_pink = 202005;
    new_Skin.UMP_lazer = 202007;
    new_Skin.UMP_thumb = 1020020386;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.Vector == 0)
    new_Skin.Vector = 102003;
    if (preferences.Config.Skin.Vector == 1)
    new_Skin.Vector = 1102003100;
    if (preferences.Config.Skin.Vector == 2)
    new_Skin.Vector = 1102003080;
    if (preferences.Config.Skin.Vector == 3)
    new_Skin.Vector = 1102003020;
    if (preferences.Config.Skin.Vector == 4)
    new_Skin.Vector = 1102003065;
    if (preferences.Config.Skin.Vector == 5)
    new_Skin.Vector = 1102003031;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.Thompson == 0)
    new_Skin.Thompson = 102004;
  if (preferences.Config.Skin.Thompson == 1)
    new_Skin.Thompson = 1102004034;
  if (preferences.Config.Skin.Thompson == 2)
    new_Skin.Thompson = 1102004018;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.Bizon == 0)
    new_Skin.Bizon = 102005;
    if (preferences.Config.Skin.Bizon == 1)
    new_Skin.Bizon = 1102005064;
    if (preferences.Config.Skin.Bizon == 2)
    new_Skin.Bizon = 1102005007;
    if (preferences.Config.Skin.Bizon == 3)
    new_Skin.Bizon = 1102005020;
    if (preferences.Config.Skin.Bizon == 4)
    new_Skin.Bizon = 1102005041;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.K98 == 0) {
    new_Skin.K98 = 103001;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 1){
    new_Skin.K98 = 1103001179;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 2){
    new_Skin.K98 = 1103001079;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 3){
    new_Skin.K98 = 1103001101;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 4){
    new_Skin.K98 = 1103001146;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 5){
    new_Skin.K98 = 1103001160;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 6){
    new_Skin.K98 = 1103001060;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 7){
    new_Skin.K98 = 1103001191;
    new_Skin.K98_reddot = 1030011857;
    new_Skin.K98_holo = 1030011856;
    new_Skin.K98_x2 = 1030011855;
    new_Skin.K98_x3 = 1030011854;
    new_Skin.K98_x4 = 1030011853;
    new_Skin.K98_x6 = 1030011852;
    new_Skin.K98_x8 = 1030011851;
    }

    if (preferences.Config.Skin.K98 == 8){
    new_Skin.K98 = 1103001183;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.K98 == 0) {
    new_Skin.K981 = 1030012;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 1){
    new_Skin.K981 = 1103001179;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 2){
    new_Skin.K981 = 1103001079;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 3){
    new_Skin.K981 = 1103001101;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 4){
    new_Skin.K981 = 1103001145;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 5){
    new_Skin.K981 = 1103001160;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 6){
    new_Skin.K981 = 1103001060;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 7){
    new_Skin.K981 = 1103001191;
    new_Skin.K98_reddot = 1030011857;
    new_Skin.K98_holo = 1030011856;
    new_Skin.K98_x2 = 1030011855;
    new_Skin.K98_x3 = 1030011854;
    new_Skin.K98_x4 = 1030011853;
    new_Skin.K98_x6 = 1030011852;
    new_Skin.K98_x8 = 1030011851;
    }

    if (preferences.Config.Skin.K98 == 8){
    new_Skin.K981 = 1103001183;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.K98 == 0) {
    new_Skin.K982 = 1030013;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 1){
    new_Skin.K982 = 1103001179;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 2){
    new_Skin.K982 = 1103001079;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 3){
    new_Skin.K982 = 1103001101;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 4){
    new_Skin.K982 = 1103001145;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 5){
    new_Skin.K982 = 1103001160;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 6){
    new_Skin.K982 = 1103001060;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 7){
    new_Skin.K982 = 1103001191;
    new_Skin.K98_reddot = 1030011857;
    new_Skin.K98_holo = 1030011856;
    new_Skin.K98_x2 = 1030011855;
    new_Skin.K98_x3 = 1030011854;
    new_Skin.K98_x4 = 1030011853;
    new_Skin.K98_x6 = 1030011852;
    new_Skin.K98_x8 = 1030011851;
    }

    if (preferences.Config.Skin.K98 == 8){
    new_Skin.K982 = 1103001183;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.K98 == 0) {
    new_Skin.K983 = 1030014;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 1){
    new_Skin.K983 = 1103001179;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 2){
    new_Skin.K983 = 1103001079;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 3){
    new_Skin.K983 = 1103001101;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 4){
    new_Skin.K983 = 1103001145;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 5){
    new_Skin.K983 = 1103001160;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 6){
    new_Skin.K983 = 1103001060;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 7){
    new_Skin.K983 = 1103001191;
    new_Skin.K98_reddot = 1030011857;
    new_Skin.K98_holo = 1030011856;
    new_Skin.K98_x2 = 1030011855;
    new_Skin.K98_x3 = 1030011854;
    new_Skin.K98_x4 = 1030011853;
    new_Skin.K98_x6 = 1030011852;
    new_Skin.K98_x8 = 1030011851;
    }

    if (preferences.Config.Skin.K98 == 8){
    new_Skin.K983 = 1103001183;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.K98 == 0) {
    new_Skin.K984 = 1030015;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 1){
    new_Skin.K984 = 1103001179;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 2){
    new_Skin.K984 = 1103001079;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 3){
    new_Skin.K984 = 1103001101;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 4){
    new_Skin.K984 = 1103001145;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 5){
    new_Skin.K984 = 1103001160;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 6){
    new_Skin.K984 = 1103001060;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 7){
    new_Skin.K984 = 1103001191;
    new_Skin.K98_reddot = 1030011857;
    new_Skin.K98_holo = 1030011856;
    new_Skin.K98_x2 = 1030011855;
    new_Skin.K98_x3 = 1030011854;
    new_Skin.K98_x4 = 1030011853;
    new_Skin.K98_x6 = 1030011852;
    new_Skin.K98_x8 = 1030011851;
    }

    if (preferences.Config.Skin.K98 == 8){
    new_Skin.K984 = 1103001183;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.K98 == 0) {
    new_Skin.K985 = 1030016;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 1){
    new_Skin.K985 = 1103001179;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 2){
    new_Skin.K985 = 1103001079;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 3){
    new_Skin.K985 = 1103001101;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 4){
    new_Skin.K985 = 1103001145;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 5){
    new_Skin.K985 = 1103001160;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 6){
    new_Skin.K985 = 1103001060;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 7){
    new_Skin.K985 = 1103001191;
    new_Skin.K98_reddot = 1030011857;
    new_Skin.K98_holo = 1030011856;
    new_Skin.K98_x2 = 1030011855;
    new_Skin.K98_x3 = 1030011854;
    new_Skin.K98_x4 = 1030011853;
    new_Skin.K98_x6 = 1030011852;
    new_Skin.K98_x8 = 1030011851;
    }

    if (preferences.Config.Skin.K98 == 8){
    new_Skin.K985 = 1103001183;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.K98 == 0) {
    new_Skin.K986 = 1030017;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 1){
    new_Skin.K986 = 1103001179;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 2){
    new_Skin.K986 = 1103001079;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 3){
    new_Skin.K986 = 1103001101;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 4){
    new_Skin.K986 = 1103001145;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 5){
    new_Skin.K986 = 1103001160;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }

    if (preferences.Config.Skin.K98 == 6){
    new_Skin.K986 = 1103001060;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }


    if (preferences.Config.Skin.K98 == 7){
    new_Skin.K986 = 1103001191;
    new_Skin.K98_reddot = 1030011857;
    new_Skin.K98_holo = 1030011856;
    new_Skin.K98_x2 = 1030011855;
    new_Skin.K98_x3 = 1030011854;
    new_Skin.K98_x4 = 1030011853;
    new_Skin.K98_x6 = 1030011852;
    new_Skin.K98_x8 = 1030011851;
    }

    if (preferences.Config.Skin.K98 == 8){
    new_Skin.K986 = 1103001183;
    new_Skin.K98_reddot = 203001;
    new_Skin.K98_holo = 203002;
    new_Skin.K98_x2 = 203003;
    new_Skin.K98_x3 = 203014;
    new_Skin.K98_x4 = 203004;
    new_Skin.K98_x6 = 203015;
    new_Skin.K98_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.M24 == 0) {
    new_Skin.M24 = 103002;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 1) {
        new_Skin.M24 = 1103002106;   // Skin chính

        // Ống ngắm
        new_Skin.M24_reddot = 1030021008;
        new_Skin.M24_holo   = 1030021007;
        new_Skin.M24_x2     = 1030021006;
        new_Skin.M24_x3     = 1030021005;
        new_Skin.M24_x4     = 1030021004;
        new_Skin.M24_x6     = 1030021003;
        new_Skin.M24_x8     = 1030021002;

        // Băng đạn
        new_Skin.M24_extendedMag    = 1030021014;
        new_Skin.M24_quickMag       = 1030021015;
        new_Skin.M24_quickNextended = 1030021016;

        // Nòng
        new_Skin.M24_flash  = 1030021009;
        new_Skin.M24_compe  = 1030021010;
        new_Skin.M24_silent = 1030021012;

        // Khác
        new_Skin.M24_cheek = 1030021013;   // Miếng đệm má
    }

    if (preferences.Config.Skin.M24 == 2) {
    new_Skin.M24 = 1103002087;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 3) {
    new_Skin.M24 = 1103002030;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }

    if (preferences.Config.Skin.M24 == 4) {
    new_Skin.M24 = 1103002048;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 5) {
    new_Skin.M24 = 1103002059;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 6) {
    new_Skin.M24 = 1103002059;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.M24 == 0) {
    new_Skin.M241 = 1030022;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 1) {
        new_Skin.M241 = 1103002106;   // Skin chính

        // Ống ngắm
        new_Skin.M24_reddot = 1030021008;
        new_Skin.M24_holo   = 1030021007;
        new_Skin.M24_x2     = 1030021006;
        new_Skin.M24_x3     = 1030021005;
        new_Skin.M24_x4     = 1030021004;
        new_Skin.M24_x6     = 1030021003;
        new_Skin.M24_x8     = 1030021002;

        // Băng đạn
        new_Skin.M24_extendedMag    = 1030021014;
        new_Skin.M24_quickMag       = 1030021015;
        new_Skin.M24_quickNextended = 1030021016;

        // Nòng
        new_Skin.M24_flash  = 1030021009;
        new_Skin.M24_compe  = 1030021010;
        new_Skin.M24_silent = 1030021012;

        // Khác
        new_Skin.M24_cheek = 1030021013;   // Miếng đệm má
    }

    if (preferences.Config.Skin.M24 == 2) {
    new_Skin.M241 = 1103002087;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 3) {
    new_Skin.M241 = 1103002030;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }

    if (preferences.Config.Skin.M24 == 4) {
    new_Skin.M241 = 1103002048;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 5) {
    new_Skin.M241 = 1103002056;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 6) {
    new_Skin.M241 = 1103002059;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.M24 == 0) {
    new_Skin.M242 = 1030023;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 1) {
        new_Skin.M242 = 1103002106;   // Skin chính

        // Ống ngắm
        new_Skin.M24_reddot = 1030021008;
        new_Skin.M24_holo   = 1030021007;
        new_Skin.M24_x2     = 1030021006;
        new_Skin.M24_x3     = 1030021005;
        new_Skin.M24_x4     = 1030021004;
        new_Skin.M24_x6     = 1030021003;
        new_Skin.M24_x8     = 1030021002;

        // Băng đạn
        new_Skin.M24_extendedMag    = 1030021014;
        new_Skin.M24_quickMag       = 1030021015;
        new_Skin.M24_quickNextended = 1030021016;

        // Nòng
        new_Skin.M24_flash  = 1030021009;
        new_Skin.M24_compe  = 1030021010;
        new_Skin.M24_silent = 1030021012;

        // Khác
        new_Skin.M24_cheek = 1030021013;   // Miếng đệm má
    }

    if (preferences.Config.Skin.M24 == 2) {
    new_Skin.M242 = 1103002087;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 3) {
    new_Skin.M242 = 1103002030;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }

    if (preferences.Config.Skin.M24 == 4) {
    new_Skin.M242 = 1103002048;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 5) {
    new_Skin.M242 = 1103002056;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 6) {
    new_Skin.M242 = 1103002059;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.M24 == 0) {
    new_Skin.M243 = 1030024;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 1) {
        new_Skin.M243 = 1103002106;   // Skin chính

        // Ống ngắm
        new_Skin.M24_reddot = 1030021008;
        new_Skin.M24_holo   = 1030021007;
        new_Skin.M24_x2     = 1030021006;
        new_Skin.M24_x3     = 1030021005;
        new_Skin.M24_x4     = 1030021004;
        new_Skin.M24_x6     = 1030021003;
        new_Skin.M24_x8     = 1030021002;

        // Băng đạn
        new_Skin.M24_extendedMag    = 1030021014;
        new_Skin.M24_quickMag       = 1030021015;
        new_Skin.M24_quickNextended = 1030021016;

        // Nòng
        new_Skin.M24_flash  = 1030021009;
        new_Skin.M24_compe  = 1030021010;
        new_Skin.M24_silent = 1030021012;

        // Khác
        new_Skin.M24_cheek = 1030021013;   // Miếng đệm má
    }

    if (preferences.Config.Skin.M24 == 2) {
    new_Skin.M243 = 1103002087;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 3) {
    new_Skin.M243 = 1103002030;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }

    if (preferences.Config.Skin.M24 == 4) {
    new_Skin.M243 = 1103002048;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 5) {
    new_Skin.M243 = 1103002056;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 6) {
    new_Skin.M243 = 1103002059;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.M24 == 0) {
    new_Skin.M244 = 1030025;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 1) {
        new_Skin.M244 = 1103002106;   // Skin chính

        // Ống ngắm
        new_Skin.M24_reddot = 1030021008;
        new_Skin.M24_holo   = 1030021007;
        new_Skin.M24_x2     = 1030021006;
        new_Skin.M24_x3     = 1030021005;
        new_Skin.M24_x4     = 1030021004;
        new_Skin.M24_x6     = 1030021003;
        new_Skin.M24_x8     = 1030021002;

        // Băng đạn
        new_Skin.M24_extendedMag    = 1030021014;
        new_Skin.M24_quickMag       = 1030021015;
        new_Skin.M24_quickNextended = 1030021016;

        // Nòng
        new_Skin.M24_flash  = 1030021009;
        new_Skin.M24_compe  = 1030021010;
        new_Skin.M24_silent = 1030021012;

        // Khác
        new_Skin.M24_cheek = 1030021013;   // Miếng đệm má
    }

    if (preferences.Config.Skin.M24 == 2) {
    new_Skin.M244 = 1103002087;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 3) {
    new_Skin.M244 = 1103002030;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }

    if (preferences.Config.Skin.M24 == 4) {
    new_Skin.M244 = 1103002048;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 5) {
    new_Skin.M244 = 1103002056;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 6) {
    new_Skin.M244 = 1103002059;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.M24 == 0) {
    new_Skin.M245 = 1030026;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 1) {
        new_Skin.M245 = 1103002106;   // Skin chính

        // Ống ngắm
        new_Skin.M24_reddot = 1030021008;
        new_Skin.M24_holo   = 1030021007;
        new_Skin.M24_x2     = 1030021006;
        new_Skin.M24_x3     = 1030021005;
        new_Skin.M24_x4     = 1030021004;
        new_Skin.M24_x6     = 1030021003;
        new_Skin.M24_x8     = 1030021002;

        // Băng đạn
        new_Skin.M24_extendedMag    = 1030021014;
        new_Skin.M24_quickMag       = 1030021015;
        new_Skin.M24_quickNextended = 1030021016;

        // Nòng
        new_Skin.M24_flash  = 1030021009;
        new_Skin.M24_compe  = 1030021010;
        new_Skin.M24_silent = 1030021012;

        // Khác
        new_Skin.M24_cheek = 1030021013;   // Miếng đệm má
    }

    if (preferences.Config.Skin.M24 == 2) {
    new_Skin.M245 = 1103002087;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 3) {
    new_Skin.M245 = 1103002030;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }

    if (preferences.Config.Skin.M24 == 4) {
    new_Skin.M245 = 1103002048;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 5) {
    new_Skin.M245 = 1103002056;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 6) {
    new_Skin.M245 = 1103002059;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.M24 == 0) {
    new_Skin.M246 = 1030027;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 1) {
        new_Skin.M246 = 1103002106;   // Skin chính

        // Ống ngắm
        new_Skin.M24_reddot = 1030021008;
        new_Skin.M24_holo   = 1030021007;
        new_Skin.M24_x2     = 1030021006;
        new_Skin.M24_x3     = 1030021005;
        new_Skin.M24_x4     = 1030021004;
        new_Skin.M24_x6     = 1030021003;
        new_Skin.M24_x8     = 1030021002;

        // Băng đạn
        new_Skin.M24_extendedMag    = 1030021014;
        new_Skin.M24_quickMag       = 1030021015;
        new_Skin.M24_quickNextended = 1030021016;

        // Nòng
        new_Skin.M24_flash  = 1030021009;
        new_Skin.M24_compe  = 1030021010;
        new_Skin.M24_silent = 1030021012;

        // Khác
        new_Skin.M24_cheek = 1030021013;   // Miếng đệm má
    }

    if (preferences.Config.Skin.M24 == 2) {
    new_Skin.M246 = 1103002087;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 3) {
    new_Skin.M246 = 1103002030;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }

    if (preferences.Config.Skin.M24 == 4) {
    new_Skin.M246 = 1103002048;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 5) {
    new_Skin.M246 = 1103002056;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
    if (preferences.Config.Skin.M24 == 6) {
    new_Skin.M246 = 1103002059;
    new_Skin.M24_reddot = 203001;
    new_Skin.M24_holo = 203002;
    new_Skin.M24_x2 = 203003;
    new_Skin.M24_x3 = 203014;
    new_Skin.M24_x4 = 203004;
    new_Skin.M24_x6 = 203015;
    new_Skin.M24_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.AWM == 0) {
    new_Skin.AWM = 103003;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 1) {
        new_Skin.AWM = 1103003079;   // Skin chính

        // Ống ngắm
        new_Skin.AWM_reddot = 1030030738;
        new_Skin.AWM_holo   = 1030030737;
        new_Skin.AWM_x2     = 1030030736;
        new_Skin.AWM_x3     = 1030030735;
        new_Skin.AWM_x4     = 1030030734;
        new_Skin.AWM_x6     = 1030030733;
        new_Skin.AWM_x8     = 1030030732;

        // Băng đạn
        new_Skin.AWM_extendedMag    = 1030030740;
        new_Skin.AWM_quickMag       = 1030030742;
        new_Skin.AWM_quickNextended = 1030030743;

        // Nòng
        new_Skin.AWM_flash  = 1030030744;
        new_Skin.AWM_compe  = 1030030745;
        new_Skin.AWM_silent = 1030030746;

        // Khác
        new_Skin.AWM_cheek = 1030030747;    // Miếng đệm má
    }

    if (preferences.Config.Skin.AWM == 2) {
    new_Skin.AWM = 1103003062;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 3) {
    new_Skin.AWM = 1103003022;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 4) {
    new_Skin.AWM = 1103003042;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 5) {
    new_Skin.AWM = 1103003051;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 6) {
    new_Skin.AWM = 1103003087;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AWM == 0) {
    new_Skin.AWM1 = 1030032;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 1) {
        new_Skin.AWM1 = 1103003079;   // Skin chính

        // Ống ngắm
        new_Skin.AWM_reddot = 1030030738;
        new_Skin.AWM_holo   = 1030030737;
        new_Skin.AWM_x2     = 1030030736;
        new_Skin.AWM_x3     = 1030030735;
        new_Skin.AWM_x4     = 1030030734;
        new_Skin.AWM_x6     = 1030030733;
        new_Skin.AWM_x8     = 1030030732;

        // Băng đạn
        new_Skin.AWM_extendedMag    = 1030030740;
        new_Skin.AWM_quickMag       = 1030030742;
        new_Skin.AWM_quickNextended = 1030030743;

        // Nòng
        new_Skin.AWM_flash  = 1030030744;
        new_Skin.AWM_compe  = 1030030745;
        new_Skin.AWM_silent = 1030030746;

        // Khác
        new_Skin.AWM_cheek = 1030030747;    // Miếng đệm má
    }

    if (preferences.Config.Skin.AWM == 2) {
    new_Skin.AWM1 = 1103003062;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 3) {
    new_Skin.AWM1 = 1103003022;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 4) {
    new_Skin.AWM1 = 1103003042;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 5) {
    new_Skin.AWM1 = 1103003051;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 6) {
    new_Skin.AWM1 = 1103003087;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AWM == 0) {
    new_Skin.AWM2 = 1030033;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 1) {
        new_Skin.AWM2 = 1103003079;   // Skin chính

        // Ống ngắm
        new_Skin.AWM_reddot = 1030030738;
        new_Skin.AWM_holo   = 1030030737;
        new_Skin.AWM_x2     = 1030030736;
        new_Skin.AWM_x3     = 1030030735;
        new_Skin.AWM_x4     = 1030030734;
        new_Skin.AWM_x6     = 1030030733;
        new_Skin.AWM_x8     = 1030030732;

        // Băng đạn
        new_Skin.AWM_extendedMag    = 1030030740;
        new_Skin.AWM_quickMag       = 1030030742;
        new_Skin.AWM_quickNextended = 1030030743;

        // Nòng
        new_Skin.AWM_flash  = 1030030744;
        new_Skin.AWM_compe  = 1030030745;
        new_Skin.AWM_silent = 1030030746;

        // Khác
        new_Skin.AWM_cheek = 1030030747;    // Miếng đệm má
    }

    if (preferences.Config.Skin.AWM == 2) {
    new_Skin.AWM2 = 1103003062;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 3) {
    new_Skin.AWM2 = 1103003022;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 4) {
    new_Skin.AWM2 = 1103003042;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 5) {
    new_Skin.AWM2 = 1103003051;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 6) {
    new_Skin.AWM2 = 1103003087;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AWM == 0) {
    new_Skin.AWM3 = 1030034;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 1) {
        new_Skin.AWM3 = 1103003079;   // Skin chính

        // Ống ngắm
        new_Skin.AWM_reddot = 1030030738;
        new_Skin.AWM_holo   = 1030030737;
        new_Skin.AWM_x2     = 1030030736;
        new_Skin.AWM_x3     = 1030030735;
        new_Skin.AWM_x4     = 1030030734;
        new_Skin.AWM_x6     = 1030030733;
        new_Skin.AWM_x8     = 1030030732;

        // Băng đạn
        new_Skin.AWM_extendedMag    = 1030030740;
        new_Skin.AWM_quickMag       = 1030030742;
        new_Skin.AWM_quickNextended = 1030030743;

        // Nòng
        new_Skin.AWM_flash  = 1030030744;
        new_Skin.AWM_compe  = 1030030745;
        new_Skin.AWM_silent = 1030030746;

        // Khác
        new_Skin.AWM_cheek = 1030030747;    // Miếng đệm má
    }

    if (preferences.Config.Skin.AWM == 2) {
    new_Skin.AWM3 = 1103003062;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 3) {
    new_Skin.AWM3 = 1103003022;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 4) {
    new_Skin.AWM3 = 1103003042;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 5) {
    new_Skin.AWM3 = 1103003051;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 6) {
    new_Skin.AWM3 = 1103003087;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AWM == 0) {
    new_Skin.AWM4 = 1030035;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 1) {
        new_Skin.AWM4 = 1103003079;   // Skin chính

        // Ống ngắm
        new_Skin.AWM_reddot = 1030030738;
        new_Skin.AWM_holo   = 1030030737;
        new_Skin.AWM_x2     = 1030030736;
        new_Skin.AWM_x3     = 1030030735;
        new_Skin.AWM_x4     = 1030030734;
        new_Skin.AWM_x6     = 1030030733;
        new_Skin.AWM_x8     = 1030030732;

        // Băng đạn
        new_Skin.AWM_extendedMag    = 1030030740;
        new_Skin.AWM_quickMag       = 1030030742;
        new_Skin.AWM_quickNextended = 1030030743;

        // Nòng
        new_Skin.AWM_flash  = 1030030744;
        new_Skin.AWM_compe  = 1030030745;
        new_Skin.AWM_silent = 1030030746;

        // Khác
        new_Skin.AWM_cheek = 1030030747;    // Miếng đệm má
    }

    if (preferences.Config.Skin.AWM == 2) {
    new_Skin.AWM4 = 1103003062;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 3) {
    new_Skin.AWM4 = 1103003022;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 4) {
    new_Skin.AWM4 = 1103003042;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 5) {
    new_Skin.AWM4 = 1103003051;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 6) {
    new_Skin.AWM4 = 1103003087;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AWM == 0) {
    new_Skin.AWM5 = 1030036;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 1) {
        new_Skin.AWM5 = 1103003079;   // Skin chính

        // Ống ngắm
        new_Skin.AWM_reddot = 1030030738;
        new_Skin.AWM_holo   = 1030030737;
        new_Skin.AWM_x2     = 1030030736;
        new_Skin.AWM_x3     = 1030030735;
        new_Skin.AWM_x4     = 1030030734;
        new_Skin.AWM_x6     = 1030030733;
        new_Skin.AWM_x8     = 1030030732;

        // Băng đạn
        new_Skin.AWM_extendedMag    = 1030030740;
        new_Skin.AWM_quickMag       = 1030030742;
        new_Skin.AWM_quickNextended = 1030030743;

        // Nòng
        new_Skin.AWM_flash  = 1030030744;
        new_Skin.AWM_compe  = 1030030745;
        new_Skin.AWM_silent = 1030030746;

        // Khác
        new_Skin.AWM_cheek = 1030030747;    // Miếng đệm má
    }

    if (preferences.Config.Skin.AWM == 2) {
    new_Skin.AWM5 = 1103003062;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 3) {
    new_Skin.AWM5 = 1103003022;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 4) {
    new_Skin.AWM5 = 1103003042;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 5) {
    new_Skin.AWM5 = 1103003051;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 6) {
    new_Skin.AWM5 = 1103003087;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.AWM == 0) {
    new_Skin.AWM6 = 1030037;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 1) {
        new_Skin.AWM6 = 1103003079;   // Skin chính

        // Ống ngắm
        new_Skin.AWM_reddot = 1030030738;
        new_Skin.AWM_holo   = 1030030737;
        new_Skin.AWM_x2     = 1030030736;
        new_Skin.AWM_x3     = 1030030735;
        new_Skin.AWM_x4     = 1030030734;
        new_Skin.AWM_x6     = 1030030733;
        new_Skin.AWM_x8     = 1030030732;

        // Băng đạn
        new_Skin.AWM_extendedMag    = 1030030740;
        new_Skin.AWM_quickMag       = 1030030742;
        new_Skin.AWM_quickNextended = 1030030743;

        // Nòng
        new_Skin.AWM_flash  = 1030030744;
        new_Skin.AWM_compe  = 1030030745;
        new_Skin.AWM_silent = 1030030746;

        // Khác
        new_Skin.AWM_cheek = 1030030747;    // Miếng đệm má
    }

    if (preferences.Config.Skin.AWM == 2) {
    new_Skin.AWM6 = 1103003062;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 3) {
    new_Skin.AWM6 = 1103003022;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 4) {
    new_Skin.AWM6 = 1103003042;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 5) {
    new_Skin.AWM6 = 1103003051;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }
    if (preferences.Config.Skin.AWM == 6) {
    new_Skin.AWM6 = 1103003087;
    new_Skin.AWM_reddot = 203001;
    new_Skin.AWM_holo = 203002;
    new_Skin.AWM_x2 = 203003;
    new_Skin.AWM_x3 = 203014;
    new_Skin.AWM_x4 = 203004;
    new_Skin.AWM_x6 = 203015;
    new_Skin.AWM_x8 = 203005;
    }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.DP28 == 0)
    new_Skin.DP28 = 105002;
    if (preferences.Config.Skin.DP28 == 1)
    new_Skin.DP28 = 1105002091;
    if (preferences.Config.Skin.DP28 == 2)
    new_Skin.DP28 = 1105002018;
    if (preferences.Config.Skin.DP28 == 3)
    new_Skin.DP28 = 1105002035;
    if (preferences.Config.Skin.DP28 == 4)
    new_Skin.DP28 = 1105002058;
    if (preferences.Config.Skin.DP28 == 5)
    new_Skin.DP28 = 1105002063;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.DP28 == 0)
    new_Skin.DP282 = 105002;
    if (preferences.Config.Skin.DP28 == 1)
    new_Skin.DP282 = 1105002091;
    if (preferences.Config.Skin.DP28 == 2)
    new_Skin.DP282 = 1105002018;
    if (preferences.Config.Skin.DP28 == 3)
    new_Skin.DP282 = 1105002035;
    if (preferences.Config.Skin.DP28 == 4)
    new_Skin.DP282 = 1105002058;
    if (preferences.Config.Skin.DP28 == 5)
    new_Skin.DP282 = 1105002063;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.DP28 == 0)
    new_Skin.DP283 = 105002;
    if (preferences.Config.Skin.DP28 == 1)
    new_Skin.DP283 = 1105002091;
    if (preferences.Config.Skin.DP28 == 2)
    new_Skin.DP283 = 1105002018;
    if (preferences.Config.Skin.DP28 == 3)
    new_Skin.DP283 = 1105002035;
    if (preferences.Config.Skin.DP28 == 4)
    new_Skin.DP283 = 1105002058;
    if (preferences.Config.Skin.DP28 == 5)
    new_Skin.DP283 = 1105002063;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.DP28 == 0)
    new_Skin.DP284 = 105002;
    if (preferences.Config.Skin.DP28 == 1)
    new_Skin.DP284 = 1105002091;
    if (preferences.Config.Skin.DP28 == 2)
    new_Skin.DP284 = 1105002018;
    if (preferences.Config.Skin.DP28 == 3)
    new_Skin.DP284 = 1105002035;
    if (preferences.Config.Skin.DP28 == 4)
    new_Skin.DP284 = 1105002058;
    if (preferences.Config.Skin.DP28 == 5)
    new_Skin.DP284 = 1105002063;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.DP28 == 0)
    new_Skin.DP285 = 105002;
    if (preferences.Config.Skin.DP28 == 1)
    new_Skin.DP285 = 1105002091;
    if (preferences.Config.Skin.DP28 == 2)
    new_Skin.DP285 = 1105002018;
    if (preferences.Config.Skin.DP28 == 3)
    new_Skin.DP285 = 1105002035;
    if (preferences.Config.Skin.DP28 == 4)
    new_Skin.DP285 = 1105002058;
    if (preferences.Config.Skin.DP28 == 5)
    new_Skin.DP285 = 1105002063;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.DP28 == 0)
    new_Skin.DP286 = 105002;
    if (preferences.Config.Skin.DP28 == 1)
    new_Skin.DP286 = 1105002091;
    if (preferences.Config.Skin.DP28 == 2)
    new_Skin.DP286 = 1105002018;
    if (preferences.Config.Skin.DP28 == 3)
    new_Skin.DP286 = 1105002035;
    if (preferences.Config.Skin.DP28 == 4)
    new_Skin.DP286 = 1105002058;
    if (preferences.Config.Skin.DP28 == 5)
    new_Skin.DP286 = 1105002063;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (preferences.Config.Skin.M249 == 0)
    new_Skin.M249 = 105001;
    new_Skin.M249s = 205009;
    if (preferences.Config.Skin.M249 == 1)
    new_Skin.M249 = 1105001069;
    new_Skin.M249s = 1050010351;
    if (preferences.Config.Skin.M249 == 2)
    new_Skin.M249 = 1105001020;
    new_Skin.M249s = 1050010351;
    if (preferences.Config.Skin.M249 == 3)
    new_Skin.M249 = 1105001034;
    new_Skin.M249s = 1050010412;
    if (preferences.Config.Skin.M249 == 4)
    new_Skin.M249 = 1105001048;
    new_Skin.M249s = 1050010482;
    if (preferences.Config.Skin.M249 == 5)
    new_Skin.M249 = 1105001054;
    new_Skin.M249s = 1050010542;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M249 == 0)
    new_Skin.M2491 = 1050012;
    new_Skin.M249s = 205009;
    if (preferences.Config.Skin.M249 == 1)
    new_Skin.M2491 = 1105001069;
    new_Skin.M249s = 1050010351;
    if (preferences.Config.Skin.M249 == 2)
    new_Skin.M2491 = 1105001020;
    new_Skin.M249s = 1050010351;
    if (preferences.Config.Skin.M249 == 3)
    new_Skin.M2491 = 1105001034;
    new_Skin.M249s = 1050010412;
    if (preferences.Config.Skin.M249 == 4)
    new_Skin.M2491 = 1105001048;
    new_Skin.M249s = 1050010482;
    if (preferences.Config.Skin.M249 == 5)
    new_Skin.M2491 = 1105001054;
    new_Skin.M249s = 1050010542;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M249 == 0)
    new_Skin.M2492 = 1050013;
    new_Skin.M249s = 205009;
    if (preferences.Config.Skin.M249 == 1)
    new_Skin.M2492 = 1105001069;
    new_Skin.M249s = 1050010351;
    if (preferences.Config.Skin.M249 == 2)
    new_Skin.M2492 = 1105001020;
    new_Skin.M249s = 1050010351;
    if (preferences.Config.Skin.M249 == 3)
    new_Skin.M2492 = 1105001034;
    new_Skin.M249s = 1050010412;
    if (preferences.Config.Skin.M249 == 4)
    new_Skin.M2492 = 1105001048;
    new_Skin.M249s = 1050010482;
    if (preferences.Config.Skin.M249 == 5)
    new_Skin.M2492 = 1105001054;
    new_Skin.M249s = 1050010542;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M249 == 0)
    new_Skin.M2493 = 1050014;
    new_Skin.M249s = 205009;
    if (preferences.Config.Skin.M249 == 1)
    new_Skin.M2493 = 1105001069;
    new_Skin.M249s = 1050010351;
    if (preferences.Config.Skin.M249 == 2)
    new_Skin.M2493 = 1105001020;
    new_Skin.M249s = 1050010351;
    if (preferences.Config.Skin.M249 == 3)
    new_Skin.M2493 = 1105001034;
    new_Skin.M249s = 1050010412;
    if (preferences.Config.Skin.M249 == 4)
    new_Skin.M2493 = 1105001048;
    new_Skin.M249s = 1050010482;
    if (preferences.Config.Skin.M249 == 5)
    new_Skin.M2493 = 1105001054;
    new_Skin.M249s = 1050010542;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M249 == 0)
    new_Skin.M2494 = 1050015;
    new_Skin.M249s = 205009;
    if (preferences.Config.Skin.M249 == 1)
    new_Skin.M2494 = 1105001069;
    new_Skin.M249s = 1050010351;
    if (preferences.Config.Skin.M249 == 2)
    new_Skin.M2494 = 1105001020;
    new_Skin.M249s = 1050010351;
    if (preferences.Config.Skin.M249 == 3)
    new_Skin.M2494 = 1105001034;
    new_Skin.M249s = 1050010412;
    if (preferences.Config.Skin.M249 == 4)
    new_Skin.M2494 = 1105001048;
    new_Skin.M249s = 1050010482;
    if (preferences.Config.Skin.M249 == 5)
    new_Skin.M2494 = 1105001054;
    new_Skin.M249s = 1050010542;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M249 == 0)
    new_Skin.M2495 = 1050016;
    new_Skin.M249s = 205009;
    if (preferences.Config.Skin.M249 == 1)
    new_Skin.M2495 = 1105001069;
    new_Skin.M249s = 1050010351;
    if (preferences.Config.Skin.M249 == 2)
    new_Skin.M2495 = 1105001020;
    new_Skin.M249s = 1050010351;
    if (preferences.Config.Skin.M249 == 3)
    new_Skin.M2495 = 1105001034;
    new_Skin.M249s = 1050010412;
    if (preferences.Config.Skin.M249 == 4)
    new_Skin.M2495 = 1105001048;
    new_Skin.M249s = 1050010482;
    if (preferences.Config.Skin.M249 == 5)
    new_Skin.M2495 = 1105001054;
    new_Skin.M249s = 1050010542;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (preferences.Config.Skin.M249 == 0)
    new_Skin.M2496 = 1050017;
    new_Skin.M249s = 205009;
    if (preferences.Config.Skin.M249 == 1)
    new_Skin.M2496 = 1105001069;
    new_Skin.M249s = 1050010351;
    if (preferences.Config.Skin.M249 == 2)
    new_Skin.M2496 = 1105001020;
    new_Skin.M249s = 1050010351;
    if (preferences.Config.Skin.M249 == 3)
    new_Skin.M2496 = 1105001034;
    new_Skin.M249s = 1050010412;
    if (preferences.Config.Skin.M249 == 4)
    new_Skin.M2496 = 1105001048;
    new_Skin.M249s = 1050010482;
    if (preferences.Config.Skin.M249 == 5)
    new_Skin.M2496 = 1105001054;
    new_Skin.M249s = 1050010542;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if (preferences.Config.Skin.Bigfoot == 0)
    new_Skin.Bigfoot = 1953001;
    if (preferences.Config.Skin.Bigfoot == 1)
    new_Skin.Bigfoot = 1953004;
    if (preferences.Config.Skin.Bigfoot == 2)
    new_Skin.Bigfoot = 1953008;
    if (preferences.Config.Skin.Bigfoot == 3)
    new_Skin.Bigfoot = 1953011;
    if (preferences.Config.Skin.Bigfoot == 4)
    new_Skin.Bigfoot = 1953012;
    if (preferences.Config.Skin.Bigfoot == 5)
    new_Skin.Bigfoot = 1953010;
    if (preferences.Config.Skin.Bigfoot == 6)
    new_Skin.Bigfoot = 1908068;
    if (preferences.Config.Skin.Bigfoot == 7)
    new_Skin.Bigfoot = 1908069;
    if (preferences.Config.Skin.Bigfoot == 8)
    new_Skin.Bigfoot = 1908070;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if (preferences.Config.Skin.RZR == 0)
    new_Skin.RZR = 1966017;
    if (preferences.Config.Skin.RZR == 1)
    new_Skin.RZR = 1966017;
    if (preferences.Config.Skin.RZR == 2)
    new_Skin.RZR = 1966016;
    if (preferences.Config.Skin.RZR == 3)
    new_Skin.RZR = 1908068;
    if (preferences.Config.Skin.RZR == 4)
    new_Skin.RZR = 1908069;
    if (preferences.Config.Skin.RZR == 5)
    new_Skin.RZR = 1908070;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if (preferences.Config.Skin.Rony == 0)
    new_Skin.Rony = 1916001;
    if (preferences.Config.Skin.Rony == 1)
    new_Skin.Rony = 1916004;
    if (preferences.Config.Skin.Rony == 2)
    new_Skin.Rony = 1916005;
    if (preferences.Config.Skin.Rony == 3)
    new_Skin.Rony = 1916006;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (preferences.Config.Skin.OMirado == 0)
    new_Skin.OMirado = 1915001;
  if (preferences.Config.Skin.OMirado == 1)
    new_Skin.OMirado = 1915011;
  if (preferences.Config.Skin.OMirado == 2)
    new_Skin.OMirado = 1915099;
    
    if (preferences.Config.Skin.Mirado == 0)
    new_Skin.Mirado = 1914001;
    if (preferences.Config.Skin.Mirado == 1)
    new_Skin.Mirado = 19150051;
    if (preferences.Config.Skin.Mirado == 2)
    new_Skin.Mirado = 19150061;
    if (preferences.Config.Skin.Mirado == 3)
    new_Skin.Mirado = 19150071;
    if (preferences.Config.Skin.Mirado == 4)
    new_Skin.Mirado = 19150080;
    if (preferences.Config.Skin.Mirado == 5)
    new_Skin.Mirado = 19150090;
    if (preferences.Config.Skin.Mirado == 6)
    new_Skin.Mirado = 1915010;
    if (preferences.Config.Skin.Mirado == 7)
    new_Skin.Mirado = 1915012;
    if (preferences.Config.Skin.Mirado == 8)
    new_Skin.Mirado = 1915017;
    if (preferences.Config.Skin.Mirado == 9)
    new_Skin.Mirado = 19150180;

  if (preferences.Config.Skin.Moto == 0)
    new_Skin.Moto = 1901001;
  if (preferences.Config.Skin.Moto == 1)
    new_Skin.Moto = 1901073;
  if (preferences.Config.Skin.Moto == 2)
    new_Skin.Moto = 1901074;
  if (preferences.Config.Skin.Moto == 3)
    new_Skin.Moto = 1901075;
  if (preferences.Config.Skin.Moto == 4)
    new_Skin.Moto = 1901047;
  if (preferences.Config.Skin.Moto == 5)
    new_Skin.Moto = 1901085;
  if (preferences.Config.Skin.Moto == 6)
    new_Skin.Moto = 1901076;
  if (preferences.Config.Skin.Moto == 7)
    new_Skin.Moto = 1901027;
  if (preferences.Config.Skin.Moto == 8)
    new_Skin.Moto = 1901018;
  if (preferences.Config.Skin.Moto == 9)
    new_Skin.Moto = 1901085;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if (preferences.Config.Skin.Buggy == 0)
    new_Skin.Buggy = 1907001;
    if (preferences.Config.Skin.Buggy == 1)
    new_Skin.Buggy = 1907054;
    if (preferences.Config.Skin.Buggy == 2)
    new_Skin.Buggy = 1907058;
    if (preferences.Config.Skin.Buggy == 3)
    new_Skin.Buggy = 1907059;
    if (preferences.Config.Skin.Buggy == 4)
    new_Skin.Buggy = 1907047;
    if (preferences.Config.Skin.Buggy == 5)
    new_Skin.Buggy = 1907012;
    if (preferences.Config.Skin.Buggy == 6)
    new_Skin.Buggy = 1907013;
    if (preferences.Config.Skin.Buggy == 7)
    new_Skin.Buggy = 1907014;
    if (preferences.Config.Skin.Buggy == 8)
    new_Skin.Buggy = 1907015;
    if (preferences.Config.Skin.Buggy == 9)
    new_Skin.Buggy = 1907016;
    if (preferences.Config.Skin.Buggy == 10)
    new_Skin.Buggy = 1907017;
    if (preferences.Config.Skin.Buggy == 11)
    new_Skin.Buggy = 1907018;
    if (preferences.Config.Skin.Buggy == 12)
    new_Skin.Buggy = 1907019;
    if (preferences.Config.Skin.Buggy == 13)
    new_Skin.Buggy = 1907020;
    if (preferences.Config.Skin.Buggy == 14)
    new_Skin.Buggy = 1907021;
    if (preferences.Config.Skin.Buggy == 15)
    new_Skin.Buggy = 1907022;
    if (preferences.Config.Skin.Buggy == 16)
    new_Skin.Buggy = 1907023;
    if (preferences.Config.Skin.Buggy == 17)
    new_Skin.Buggy = 1907035;
    if (preferences.Config.Skin.Buggy == 18)
    new_Skin.Buggy = 1907025;
    if (preferences.Config.Skin.Buggy == 19)
    new_Skin.Buggy = 1907026;
    if (preferences.Config.Skin.Buggy == 20)
    new_Skin.Buggy = 1907027;
    if (preferences.Config.Skin.Buggy == 21)
    new_Skin.Buggy = 1907028;
    if (preferences.Config.Skin.Buggy == 22)
    new_Skin.Buggy = 1907029;
    if (preferences.Config.Skin.Buggy == 23)
    new_Skin.Buggy = 1907030;
    if (preferences.Config.Skin.Buggy == 24)
    new_Skin.Buggy = 1907053;
    if (preferences.Config.Skin.Buggy == 25)
    new_Skin.Buggy = 1907032;
    if (preferences.Config.Skin.Buggy == 26)
    new_Skin.Buggy = 1907033;
    if (preferences.Config.Skin.Buggy == 27)
    new_Skin.Buggy = 1907034;
    if (preferences.Config.Skin.Buggy == 28)
    new_Skin.Buggy = 1907055;
    if (preferences.Config.Skin.Buggy == 29)
    new_Skin.Buggy = 1907036;
    if (preferences.Config.Skin.Buggy == 30)
    new_Skin.Buggy = 1907037;
    if (preferences.Config.Skin.Buggy == 31)
    new_Skin.Buggy = 1907038;
    if (preferences.Config.Skin.Buggy == 32)
    new_Skin.Buggy = 1907048;
    if (preferences.Config.Skin.Buggy == 33)
    new_Skin.Buggy = 1907040;
    
    if (preferences.Config.Skin.Dacia == 0)
    new_Skin.Dacia = 1903001;
    if (preferences.Config.Skin.Dacia == 1)
    new_Skin.Dacia = 1903074;
    if (preferences.Config.Skin.Dacia == 2)
    new_Skin.Dacia = 1903075;
    if (preferences.Config.Skin.Dacia == 3)
    new_Skin.Dacia = 1903076;
    if (preferences.Config.Skin.Dacia == 4)
    new_Skin.Dacia = 1903088;
    if (preferences.Config.Skin.Dacia == 5)
    new_Skin.Dacia = 1903089;
    if (preferences.Config.Skin.Dacia == 6)
    new_Skin.Dacia = 1903090;
    if (preferences.Config.Skin.Dacia == 7)
    new_Skin.Dacia = 1903071;
    if (preferences.Config.Skin.Dacia == 8)
    new_Skin.Dacia = 1903072;
    if (preferences.Config.Skin.Dacia == 9)
    new_Skin.Dacia = 1903073;
    if (preferences.Config.Skin.Dacia == 10)
    new_Skin.Dacia = 1903079;
    if (preferences.Config.Skin.Dacia == 11)
    new_Skin.Dacia = 1903080;
    if (preferences.Config.Skin.Dacia == 12)
    new_Skin.Dacia = 1903189;
    if (preferences.Config.Skin.Dacia == 13)
    new_Skin.Dacia = 1903190;
    if (preferences.Config.Skin.Dacia == 14)
    new_Skin.Dacia = 1903191;
    if (preferences.Config.Skin.Dacia == 15)
    new_Skin.Dacia = 1903192;
    if (preferences.Config.Skin.Dacia == 16)
    new_Skin.Dacia = 1903193;
    if (preferences.Config.Skin.Dacia == 17)
    new_Skin.Dacia = 1903203;
    if (preferences.Config.Skin.Dacia == 18)
    new_Skin.Dacia = 1903204;
    if (preferences.Config.Skin.Dacia == 19)
    new_Skin.Dacia = 1903216;
    if (preferences.Config.Skin.Dacia == 20)
    new_Skin.Dacia = 1903217;
    if (preferences.Config.Skin.Dacia == 21)
    new_Skin.Dacia = 1903212;
    if (preferences.Config.Skin.Dacia == 22)
    new_Skin.Dacia = 1903213;
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  
if (preferences.Config.Skin.MiniBus == 0)
    new_Skin.MiniBus = 1904001;
  if (preferences.Config.Skin.MiniBus == 1)
    new_Skin.MiniBus = 1904005;
  if (preferences.Config.Skin.MiniBus == 2)
    new_Skin.MiniBus = 1904006;
if (preferences.Config.Skin.MiniBus == 3)
    new_Skin.MiniBus = 1904007;
if (preferences.Config.Skin.MiniBus == 4)
    new_Skin.MiniBus = 1904008;
if (preferences.Config.Skin.MiniBus == 5)
    new_Skin.MiniBus = 1904009;
if (preferences.Config.Skin.MiniBus == 6)
    new_Skin.MiniBus = 1904010;
if (preferences.Config.Skin.MiniBus == 7)
    new_Skin.MiniBus = 1904011;
if (preferences.Config.Skin.MiniBus == 8)
    new_Skin.MiniBus = 1904012;
if (preferences.Config.Skin.MiniBus == 9)
    new_Skin.MiniBus = 1904013;
if (preferences.Config.Skin.MiniBus == 10)
    new_Skin.MiniBus = 1904014;
if (preferences.Config.Skin.MiniBus == 11)
    new_Skin.MiniBus = 1904015;
if (preferences.Config.Skin.MiniBus == 12)
    new_Skin.MiniBus = 1904004;
  
    if (preferences.Config.Skin.CoupeRP == 0)
    new_Skin.CoupeRP = 1961001;
    if (preferences.Config.Skin.CoupeRP == 1)
    new_Skin.CoupeRP = 1961020;
    if (preferences.Config.Skin.CoupeRP == 2)
    new_Skin.CoupeRP = 1961021;
    if (preferences.Config.Skin.CoupeRP == 3)
    new_Skin.CoupeRP = 1961024;
    if (preferences.Config.Skin.CoupeRP == 4)
    new_Skin.CoupeRP = 1961025;
    if (preferences.Config.Skin.CoupeRP == 5)
    new_Skin.CoupeRP = 1961044;
    if (preferences.Config.Skin.CoupeRP == 6)
    new_Skin.CoupeRP = 1961041;
    if (preferences.Config.Skin.CoupeRP == 7)
    new_Skin.CoupeRP = 1961042;
    if (preferences.Config.Skin.CoupeRP == 8)
    new_Skin.CoupeRP = 1961043;
    if (preferences.Config.Skin.CoupeRP == 9)
    new_Skin.CoupeRP = 1961045;
    if (preferences.Config.Skin.CoupeRP == 10)
    new_Skin.CoupeRP = 1961046;
    if (preferences.Config.Skin.CoupeRP == 11)
    new_Skin.CoupeRP = 1961047;
    if (preferences.Config.Skin.CoupeRP == 12)
    new_Skin.CoupeRP = 1961033;
    if (preferences.Config.Skin.CoupeRP == 13)
    new_Skin.CoupeRP = 1961034;
    if (preferences.Config.Skin.CoupeRP == 14)
    new_Skin.CoupeRP = 1961035;
    if (preferences.Config.Skin.CoupeRP == 15)
    new_Skin.CoupeRP = 1961016;
    if (preferences.Config.Skin.CoupeRP == 16)
    new_Skin.CoupeRP = 1961017;
    if (preferences.Config.Skin.CoupeRP == 17)
    new_Skin.CoupeRP = 1961018;
    if (preferences.Config.Skin.CoupeRP == 18)
    new_Skin.CoupeRP = 1961007;
    if (preferences.Config.Skin.CoupeRP == 19)
    new_Skin.CoupeRP = 1961010;
    if (preferences.Config.Skin.CoupeRP == 20)
    new_Skin.CoupeRP = 1961012;
    if (preferences.Config.Skin.CoupeRP == 21)
    new_Skin.CoupeRP = 1961013;
    if (preferences.Config.Skin.CoupeRP == 22)
    new_Skin.CoupeRP = 1961014;
    if (preferences.Config.Skin.CoupeRP == 23)
    new_Skin.CoupeRP = 1961015;
    if (preferences.Config.Skin.CoupeRP == 24)
    new_Skin.CoupeRP = 1961147;
    if (preferences.Config.Skin.CoupeRP == 25)
    new_Skin.CoupeRP = 1961148;
    if (preferences.Config.Skin.CoupeRP == 26)
    new_Skin.CoupeRP = 1961149;
    if (preferences.Config.Skin.CoupeRP == 27)
    new_Skin.CoupeRP = 1961048;
    if (preferences.Config.Skin.CoupeRP == 28)
    new_Skin.CoupeRP = 1961049;
    if (preferences.Config.Skin.CoupeRP == 29)
    new_Skin.CoupeRP = 1961029;
    if (preferences.Config.Skin.CoupeRP == 30)
    new_Skin.CoupeRP = 1961030;
    if (preferences.Config.Skin.CoupeRP == 31)
    new_Skin.CoupeRP = 1961031;
    if (preferences.Config.Skin.CoupeRP == 32)
    new_Skin.CoupeRP = 1961032;
    if (preferences.Config.Skin.CoupeRP == 33)
    new_Skin.CoupeRP = 1961036;
    if (preferences.Config.Skin.CoupeRP == 34)
    new_Skin.CoupeRP = 1961037;
    if (preferences.Config.Skin.CoupeRP == 35)
    new_Skin.CoupeRP = 1961038;
    if (preferences.Config.Skin.CoupeRP == 36)
    new_Skin.CoupeRP = 1961039;
    if (preferences.Config.Skin.CoupeRP == 37)
    new_Skin.CoupeRP = 1961040;
    if (preferences.Config.Skin.CoupeRP == 38)
    new_Skin.CoupeRP = 1961050;
    if (preferences.Config.Skin.CoupeRP == 39)
    new_Skin.CoupeRP = 1961051;
    if (preferences.Config.Skin.CoupeRP == 40)
    new_Skin.CoupeRP = 1961052;
    if (preferences.Config.Skin.CoupeRP == 41)
    new_Skin.CoupeRP = 1961053;
    if (preferences.Config.Skin.CoupeRP == 42)
    new_Skin.CoupeRP = 1961054;
    if (preferences.Config.Skin.CoupeRP == 43)
    new_Skin.CoupeRP = 1961055;
    if (preferences.Config.Skin.CoupeRP == 44)
    new_Skin.CoupeRP = 1961056;
    if (preferences.Config.Skin.CoupeRP == 45)
    new_Skin.CoupeRP = 1961057;
    if (preferences.Config.Skin.CoupeRP == 46)
    new_Skin.CoupeRP = 1961144;
    if (preferences.Config.Skin.CoupeRP == 47)
    new_Skin.CoupeRP = 1961145;


  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if (preferences.Config.Skin.UAZ == 0)
    new_Skin.UAZ = 1908001;
    if (preferences.Config.Skin.UAZ == 1)
    new_Skin.UAZ = 1908067;
    if (preferences.Config.Skin.UAZ == 2)
    new_Skin.UAZ = 1908061;
    if (preferences.Config.Skin.UAZ == 3)
    new_Skin.UAZ = 1908032;
    if (preferences.Config.Skin.UAZ == 4)
    new_Skin.UAZ = 1908068;
    if (preferences.Config.Skin.UAZ == 5)
    new_Skin.UAZ = 1908069;
    if (preferences.Config.Skin.UAZ == 6)
    new_Skin.UAZ = 1908070;
    if (preferences.Config.Skin.UAZ == 7)
    new_Skin.UAZ = 1908066;
    if (preferences.Config.Skin.UAZ == 8)
    new_Skin.UAZ = 1908075;
    if (preferences.Config.Skin.UAZ == 9)
    new_Skin.UAZ = 1908076;
    if (preferences.Config.Skin.UAZ == 10)
    new_Skin.UAZ = 1908077;
    if (preferences.Config.Skin.UAZ == 11)
    new_Skin.UAZ = 1908078;
    if (preferences.Config.Skin.UAZ == 12)
    new_Skin.UAZ = 1908084;
    if (preferences.Config.Skin.UAZ == 13)
    new_Skin.UAZ = 1908085;
    if (preferences.Config.Skin.UAZ == 14)
    new_Skin.UAZ = 1908086;
    if (preferences.Config.Skin.UAZ == 15)
    new_Skin.UAZ = 1908088;
    if (preferences.Config.Skin.UAZ == 16)
    new_Skin.UAZ = 1908089;
    if (preferences.Config.Skin.UAZ == 17)
    new_Skin.UAZ = 1908188;
    if (preferences.Config.Skin.UAZ == 18)
    new_Skin.UAZ = 1908189;
    if (preferences.Config.Skin.UAZ == 19)
    new_Skin.UAZ = 1957001;
 
 if (preferences.Config.Skin.Boat == 0)
    new_Skin.Boat = 1911001;
  if (preferences.Config.Skin.Boat == 1)
    new_Skin.Boat = 1911013;
  if (preferences.Config.Skin.Boat == 2)
    new_Skin.Boat = 1911003;
if (preferences.Config.Skin.Boat == 3)
    new_Skin.Boat = 1911004;
if (preferences.Config.Skin.Boat == 4)
    new_Skin.Boat = 1911005;
if (preferences.Config.Skin.Boat == 5)
    new_Skin.Boat = 1911006;
if (preferences.Config.Skin.Boat == 6)
    new_Skin.Boat = 1911007;
if (preferences.Config.Skin.Boat == 7)
    new_Skin.Boat = 1911008;
if (preferences.Config.Skin.Boat == 8)
    new_Skin.Boat = 1911009;
if (preferences.Config.Skin.Boat == 9)
    new_Skin.Boat = 1911010;
if (preferences.Config.Skin.Boat == 10)
    new_Skin.Boat = 1911011;
if (preferences.Config.Skin.Boat == 11)
    new_Skin.Boat = 1911012;

}
///////////////////////////////////////////////M 4 1 6///////////////////////////////////////////////////////////////////
int m4v[] = {              101004,1101004046,1101004062,1101004218,1101004078,1101004086,1101004098,1101004138,1101004163,1101004201,1101004209};
int m4mag[] = { 291004,204013,204011,204012,1010040461,1010040611,1010040781,1010040861,1010040981,1010041381,1010041631,1010042011,1010042073,1010042153,1010042181,1010042214  };
int m4sight[] = { 203008,1010040462,1010040612,1010040782,1010040862,1010040982,1010041382,1010041632,1010042012,1010042083,1010042163,1010042182,1010042215  };
int m4stock[] = { 205005,1010040463,1010040613,1010040783,1010040863,1010040983,1010041383,1010041633,1010042013,1010042093,1010042173,1010042183,1010042216  };
int m4stock1[] = { 205002,1010040480,205002,205002,205002,205002,1010041146,1010041579,1010041966,1010042137,1010042173  };
int m4stock2[] = { 2050022,1010040480,205002,205002,205002,205002,1010041146,1010041579,1010041966,1010042137,1010042173  };
int m4stock3[] = { 2050023,1010040480,205002,205002,205002,205002,1010041146,1010041579,1010041966,1010042137,1010042173  };
int m4stock4[] = { 2050024,1010040480,205002,205002,205002,205002,1010041146,1010041579,1010041966,1010042137,1010042173  };
int m4stock5[] = { 2050025,1010040480,205002,205002,205002,205002,1010041146,1010041579,1010041966,1010042137,1010042173  };
int m4reddot[] = { 203001,1010040470,203001,203001,203001,203001,1010041128,1010041566,1010041948,1010042029,1010042119,1010042119  };
int m4flash[] = {          201010,1010040474,201010,    1010042128,201010,    201010,    201010,    1010041136,1010041570,1010041956,1010042038  };
int m4compe[] = {          201009,1010040475,201009,    1010042127,201009,    201009,    201009,    1010041137,1010041574,1010041957,1010042037  };
int m4silent[] = {         201011,1010040476,201011,    1010042129,201011,    201011,    201011,    1010041138,1010041575,1010041958,1010042039  };
int m4holo[] = { 203002,1010040469,203002,203002,203002,203002,1010041127,1010041565,1010041947,1010042028,1010042118,1010042232  };
int m4x2[] = { 203014,203014,1010040467,203014,203014,203014,1010041125,1010041560,1010041945,1010042026,1010042116,1010042219  };
int m4x3[] = { 203014,203014,1010040467,203014,203014,203014,1010041125,1010041560,1010041945,1010042026,1010042116,1010042219  };
int m4x4[] = { 203004,1010040466,203004,203004,203004,203004,1010041124,1010041554,1010041944,1010042025,1010042115,1010042218  };
int m4x6[] = { 203015,1010040481,203015,203015,203015,203015,203015,203015,1010041967,1010042024,1010042114,1010042217  };
int m4quickMag[] = {       204012,1010040471,204012,    1010042124,204012,    204012,    204012,    1010041134,1010041568,1010041949,1010042034  };
int m4extendedMag[] = {    204011,1010040472,204011,    1010042125,204011,    204011,    204011,    1010041129,1010041569,1010041950,1010042035  };
int m4quickNextended[] = { 204013,1010040473,204013,    1010042126,204013,    204013,    204013,    1010041135,1010041567,1010041955,1010042036  };
int m4verical[] = {        202002,1010040479,202002,    1010042136,202002,    202002,    202002,    1010041145,1010041578,1010041965,1010042046  };
int m4angle[] = {          202001,1010040477,202001,    1010042134,202001,    202001,    202001,    1010041139,1010041576,1010041959,1010042044  };
int m4lightgrip[] = {      202004,1010040482,202004,    1010042138,202004,    202004,    202004,    202004,    20200400,  202004,    202004  };
int m4pink[] = {           202005,1010040483,202005,    1010042139,202005,    202005,    202005,    202005,    202005,    202005,    202005  };
int m4lazer[] = {          202007,1010040484,202007,    1010042144,202007,    202007,    202007,    202007,    202007,    202007,    202007  };
int m4thumb[] = {          202006,1010040478,202006,    1010042135,202006,    202006,    202006,    202006,    1010041577,202006,    202006  };
int m4168[] = { 1010042, 1101004046, 1101004062, 1101004078, 1101004086, 1101004098, 1101004138, 1101004163,1101004201,1101004209,1101004218,1101004226 };
int m4169[] = { 1010043, 1101004046, 1101004062, 1101004078, 1101004086, 1101004098, 1101004138, 1101004163,1101004201,1101004209,1101004218,1101004226 };
int m4161[] = { 1010044, 1101004046, 1101004062, 1101004078, 1101004086, 1101004098, 1101004138, 1101004163,1101004201,1101004209,1101004218,1101004226 };
int m4162[] = { 1010045, 1101004046, 1101004062, 1101004078, 1101004086, 1101004098, 1101004138, 1101004163,1101004201,1101004209,1101004218,1101004226 };
int m4163[] = { 1010046, 1101004046, 1101004062, 1101004078, 1101004086, 1101004098, 1101004138, 1101004163,1101004201,1101004209,1101004218,1101004226 };
int m4164[] = { 1010047, 1101004046, 1101004062, 1101004078, 1101004086, 1101004098, 1101004138, 1101004163,1101004201,1101004209,1101004218,1101004226 };
///////////////////////////////////////////////S C A R///////////////////////////////////////////////////////////////////
int scar[] = {               101003,1101003181,1101003167,1101003119,1101003070,1101003057,1101003080  };
int scarmag[] = {            291003,1010031811,1010031671,1010031191,1010030701,1010030571,1010030801  };
int scarsight[] = {          203007,203007    ,1010031672,1010031192,1010030702,1010030572,1010030802      };
int scarreddot[] = {         203001,1010031757,1010031606,1010031136};
int scarflash[] = {          201010,1010031765,1010031609,1010031139};
int scarcompe[] = {          201009,1010031764,1010031610,1010031140};
int scarsilent[] = {         201011,1010031766,1010031613,1010031142};
int scarholo[] = {           203002,1010031756,1010031605,1010031135};
int scarx2[] = {             203003,1010031755,1010031604,1010031134};
int scarx3[] = {             203014,1010031754,1010031603,1010031133};
int scarx4[] = {             203004,1010031753,1010031602,1010031132};
int scarx6[] = {             203015,1010031752,203015    ,203015    };
int scarquickMag[] = {       204012,1010031758,1010031607,1010031137};
int scarextendedMag[] = {    204011,1010031759,1010031608,1010031138};
int scarquickNextended[] = { 204013,1010031763,1010031617,1010031146};
int scarverical[] = {        202002,1010031769,1010031615,1010031144};
int scarangle[] = {          202001,1010031767,1010031614,1010031143};
int scarlightgrip[] = {      202004,1010031773,202004    ,202004    };
int scarpink[] = {           202005,1010031774,202005    ,202005    };
int scarlazer[] = {          202007,1010031772,202007    ,202007    };
int scarthumb[] = {          202006,1010031768,1010031616,1010031145};
int scar1[] = { 1010032,1101003195, 1101003057, 1101003070, 1101003080, 1101003119, 1101003146, 1101003167, 1101003181};
int scar2[] = { 1010033,1101003195, 1101003057, 1101003070, 1101003080, 1101003119, 1101003146, 1101003167, 1101003181};
int scar3[] = { 1010034,1101003195, 1101003057, 1101003070, 1101003080, 1101003119, 1101003146, 1101003167, 1101003181};
int scar4[] = { 1010035,1101003195, 1101003057, 1101003070, 1101003080, 1101003119, 1101003146, 1101003167, 1101003181};
int scar5[] = { 1010036,1101003195, 1101003057, 1101003070, 1101003080, 1101003119, 1101003146, 1101003167, 1101003181};
int scar6[] = { 1010037,1101003195, 1101003057, 1101003070, 1101003080, 1101003119, 1101003146, 1101003167, 1101003181};
/////////////////////////////////////////////// M 7 6 2 ///////////////////////////////////////////////////////////////////
int m7[] = { 101008, 1101008026, 1101008051, 1101008061, 1101008081, 1101008104, 1101008116, 1101008126,1101008136,1101008070,1101008146,1101008154};
int m7reddot[] = {         203001,203001,203001,203001,203001,203001,203001,203001,203001,203001,1010081396,1010081396};
int m7holo[] = {           203002,203002,203002,203002,203002,203002,203002,203002,203002,203002,1010081395,1010081395};
int m7x2[] = {             203003,203003,203003,203003,203003,203003,203003,203003,203003,203003,1010081394,1010081394};
int m7x3[] = {             203014,203014,203014,203014,203014,203014,203014,203014,203014,203014,1010081393,1010081393};
int m7x4[] = {             203004,203004,203004,203004,203004,203004,203004,203004,203004,203004,1010081392,1010081392};
int m7x6[] = {             203015,203015,203015,203015,203015,203015,203015,203015,203015,203015,1010081391,1010081391};
int m7Lazer[] = {          202007,202007,202007,202007,202007,202007,202007,202007,202007,202007,1010081409,1010081409};
int m7Flash[] = {          201010,201010,201010,201010,201010,201010,201010,201010,201010,201010,1010081399,1010081399};
int m7mag[] = { 291008,204013,204011,204012,1010080261, 1010080511, 1010080611, 1010080811, 1010081041, 1010081161, 1010081261};
int m71[] = { 1010082, 1101008026, 1101008051, 1101008061, 1101008081, 1101008104, 1101008116, 1101008126};
int m72[] = { 1010083, 1101008026, 1101008051, 1101008061, 1101008081, 1101008104, 1101008116, 1101008126};
int m73[] = { 1010084, 1101008026, 1101008051, 1101008061, 1101008081, 1101008104, 1101008116, 1101008126};
int m74[] = { 1010085, 1101008026, 1101008051, 1101008061, 1101008081, 1101008104, 1101008116, 1101008126};
int m75[] = { 1010086, 1101008026, 1101008051, 1101008061, 1101008081, 1101008104, 1101008116, 1101008126};
int m76[] = { 1010087, 1101008026, 1101008051, 1101008061, 1101008081, 1101008104, 1101008116, 1101008126};
/////////////////////////////////////////////////// A M R ///////////////////////////////////////////////////////////////
int amr[] = { 103012, 1103012019, 1103012010,1030120101};
int amrreddot[] = {         203001,203001,203001,203001,};
int amrholo[] = {           203002,203002,203002,203002,};
int amrx2[] = {             203003,203003,203003,203003,};
int amrx3[] = {             203014,203014,203014,203014,};
int amrx4[] = {             203004,203004,203004,203004,};
int amrx6[] = {             203015,203015,203015,203015,};
int amrx8[] = {             203005,203005,203005,203005,};
////////////////////////////////////////////////// A W M /////////////////////////////////////////////////////////
int awm[] = { 103003, 1103003087, 1103003022, 1103003042, 1103003051, 1103003062};
int awmreddot[] = {         203001,203001,203001,203001,203001,203001,};
int awmholo[] = {           203002,203002,203002,203002,203002,203002,};
int awmx2[] = {             203003,203003,203003,203003,203003,203003,};
int awmx3[] = {             203014,203014,203014,203014,203014,203014,};
int awmx4[] = {             203004,203004,203004,203004,203004,203004,};
int awmx6[] = {             203015,203015,203015,203015,203015,203015,};
int awmx8[] = {             203005,203005,203005,203005,203005,203005,};
int awm1[] = { 1030032, 1103003022, 1103003030, 1103003042, 1103003051, 1103003062};
int awm2[] = { 1030033, 1103003022, 1103003030, 1103003042, 1103003051, 1103003062};
int awm3[] = { 1030034, 1103003022, 1103003030, 1103003042, 1103003051, 1103003062};
int awm4[] = { 1030035, 1103003022, 1103003030, 1103003042, 1103003051, 1103003062};
int awm5[] = { 1030036, 1103003022, 1103003030, 1103003042, 1103003051, 1103003062};
int awm6[] = { 1030037, 1103003022, 1103003030, 1103003042, 1103003051, 1103003062};
//////////////////////////////////////////// K 9 8 //////////////////////////////////////////////////////////////////////
int kar[] = { 103001, 1103001060, 1103001079, 1103001101, 1103001145, 1103001160, 1103001179,1103001191,1103001183};
int karreddot[] = {         203001,203001,203001,203001,203001,203001,203001,1030011857};
int karholo[] = {           203002,203002,203002,203002,203002,203002,203002,1030011856};
int karx2[] = {             203003,203003,203003,203003,203003,203003,203003,1030011855};
int karx3[] = {             203014,203014,203014,203014,203014,203014,203014,1030011854};
int karx4[] = {             203004,203004,203004,203004,203004,203004,203004,1030011853};
int karx6[] = {             203015,203015,203015,203015,203015,203015,203015,1030011852};
int karx8[] = {             203005,203005,203005,203005,203005,203005,203005,1030011851};
int kar1[] = { 1030012, 1103001060, 1103001079, 1103001101, 1103001145, 1103001160, 1103001179};
int kar2[] = { 1030013, 1103001060, 1103001079, 1103001101, 1103001145, 1103001160, 1103001179};
int kar3[] = { 1030014, 1103001060, 1103001079, 1103001101, 1103001145, 1103001160, 1103001179};
int kar4[] = { 1030015, 1103001060, 1103001079, 1103001101, 1103001145, 1103001160, 1103001179};
int kar5[] = { 1030016, 1103001060, 1103001079, 1103001101, 1103001145, 1103001160, 1103001179};
int kar6[] = { 1030017, 1103001060, 1103001079, 1103001101, 1103001145, 1103001160, 1103001179};
///////////////////////////////////////// M 2 4 /////////////////////////////////////////////////////////////////////////
int m24[] = { 103002, 1103002018, 1103002030, 1103002048, 1103002056, 1103002087};
int m24reddot[] = {         203001,203001,203001,203001,203001,203001,};
int m24holo[] = {           203002,203002,203002,203002,203002,203002,};
int m24x2[] = {             203003,203003,203003,203003,203003,203003,};
int m24x3[] = {             203014,203014,203014,203014,203014,203014,};
int m24x4[] = {             203004,203004,203004,203004,203004,203004,};
int m24x6[] = {             203015,203015,203015,203015,203015,203015,};
int m24x8[] = {             203005,203005,203005,203005,203005,203005,};
int m241[] = { 1030022, 1103002018, 1103002030, 1103002048, 1103002056, 1103002087};
int m242[] = { 1030023, 1103002018, 1103002030, 1103002048, 1103002056, 1103002087};
int m243[] = { 1030024, 1103002018, 1103002030, 1103002048, 1103002056, 1103002087};
int m244[] = { 1030025, 1103002018, 1103002030, 1103002048, 1103002056, 1103002087};
int m245[] = { 1030026, 1103002018, 1103002030, 1103002048, 1103002056, 1103002087};
int m246[] = { 1030027, 1103002018, 1103002030, 1103002048, 1103002056, 1103002087};

int dp[] = { 105002, 1105002018, 1105002035, 1105002058, 1105002063};
int dp1[] = { 1050022, 1105002018, 1105002035, 1105002058, 1105002063};
int dp2[] = { 1050023, 1105002018, 1105002035, 1105002058, 1105002063};
int dp3[] = { 1050024, 1105002018, 1105002035, 1105002058, 1105002063};
int dp4[] = { 1050025, 1105002018, 1105002035, 1105002058, 1105002063};
int dp5[] = { 1050026, 1105002018, 1105002035, 1105002058, 1105002063};
int dp6[] = { 1050027, 1105002018, 1105002035, 1105002058, 1105002063};
int m249[] = { 105001, 1105001020, 1105001034, 1105001048, 1105001054};
int m2491[] = { 1050012, 1105001020, 1105001034, 1105001048, 1105001054};
int m2492[] = { 1050013, 1105001020, 1105001034, 1105001048, 1105001054};
int m2493[] = { 1050014, 1105001020, 1105001034, 1105001048, 1105001054};
int m2494[] = { 1050015, 1105001020, 1105001034, 1105001048, 1105001054};
int m2495[] = { 1050016, 1105001020, 1105001034, 1105001048, 1105001054};
int m2496[] = { 1050017, 1105001020, 1105001034, 1105001048, 1105001054};
/////////////////////////////////////////////// G Z O R A ///////////////////////////////////////////////////////////////////
int groza[] = { 101005, 1101005019, 1101005025, 1101005038, 1101005043, 1101005052, 1101005082};
int Groza_2[] = {             291005,1010050381,1010050521,1010050821,1010050191,1010050251,1010050431};
int grozareddot[] = {         203001,1010050326,1010050466,203001,    203001,    203001,    203001};
int grozasilent[] = {         201011,1010050327,1010050467,201011,    201011,    201011,    201011}; 
int grozaholo[] = {           203002,1010050325,1010050465,203002,    203002,    203002,    203002};
int grozax2[] = {             203003,1010050324,1010050464,203003,    203003,    203003,    203003};
int grozax3[] = {             203014,1010050323,1010050463,203014,    203014,    203014,    203014};
int grozax4[] = {             203004,1010050322,1010050462,203004,    203004,    203004,    203004};
int grozax6[] = {             203015,203015,    203015,    203015,    203015,    203015,    203015};
int grozaquickMag[] = {       204012,1010050328,1010050468,204012,    204012,    204012,    204012}; 
int grozaextendedMag[] = {    204011,1010050329,1010050469,204011,    204011,    204011,    204011};
int grozaquickNextended[] = { 204013,1010050330,1010050470,204013,    204013,    204013,    204013};
int groza1[] = { 1010052, 1101005019, 1101005025, 1101005038, 1101005043, 1101005052, 1101005082};
int groza2[] = { 1010053, 1101005019, 1101005025, 1101005038, 1101005043, 1101005052, 1101005082};
int groza3[] = { 1010054, 1101005019, 1101005025, 1101005038, 1101005043, 1101005052, 1101005082};
int groza4[] = { 1010055, 1101005019, 1101005025, 1101005038, 1101005043, 1101005052, 1101005082};
int groza5[] = { 1010056, 1101005019, 1101005025, 1101005038, 1101005043, 1101005052, 1101005082};
int groza6[] = { 1010057, 1101005019, 1101005025, 1101005038, 1101005043, 1101005052, 1101005082};

/////////////////////////////////////////// A U G ///////////////////////////////////////////////////////////////////////
int aug[] = { 101006, 1101006033, 1101006044, 1101006062,1101006075,1101006067};
int augreddot[] = {         203001,1010060562,203001,203001,1010060696,};
int augholo[] = {           203002,1010060561,203002,203002,1010060695,};
int augx2[] = {             203003,1010060554,203003,203003,1010060694,};
int augx3[] = {             203014,1010060553,203014,203014,1010060693,};
int augx4[] = {             203004,1010060552,203004,203004,1010060692,};
int augx6[] = {             203015,1010060551,203015,203015,1010060691,};
int augLazer[] = {             202007,1010060574,202007,202007,1010060707,};
int augFlash[] = {            201010,1010060571,201010,201010,1010060699,};
int aug1[] = { 1010062, 1101006033, 1101006044, 1101006062};
int aug2[] = { 1010063, 1101006033, 1101006044, 1101006062};
int aug3[] = { 1010064, 1101006033, 1101006044, 1101006062};
int aug4[] = { 1010065, 1101006033, 1101006044, 1101006062};
int aug5[] = { 1010066, 1101006033, 1101006044, 1101006062};
int aug6[] = { 1010067, 1101006033, 1101006044, 1101006062};

int m16[] = { 101002, 1101002029, 1101002056, 1101002068, 1101002081, 1101002103};
int m161[] = { 1010022, 1101002029, 1101002056, 1101002068, 1101002081, 1101002103};
int m162[] = { 1010023, 1101002029, 1101002056, 1101002068, 1101002081, 1101002103};
int m163[] = { 1010024, 1101002029, 1101002056, 1101002068, 1101002081, 1101002103};
int m164[] = { 1010025, 1101002029, 1101002056, 1101002068, 1101002081, 1101002103};
int m165[] = { 1010026, 1101002029, 1101002056, 1101002068, 1101002081, 1101002103};
int m166[] = { 1010027, 1101002029, 1101002056, 1101002068, 1101002081, 1101002103};
int uzi[] = { 102001, 1102001024, 1102001036, 1102001058, 1102001069, 1102001089, 1102001102};
int uzi1[] = { 1020012, 1102001024, 1102001036, 1102001058, 1102001069, 1102001089, 1102001102};
int uzi2[] = { 1020013, 1102001024, 1102001036, 1102001058, 1102001069, 1102001089, 1102001102};
int uzi3[] = { 1020014, 1102001024, 1102001036, 1102001058, 1102001069, 1102001089, 1102001102};
int uzi4[] = { 1020015, 1102001024, 1102001036, 1102001058, 1102001069, 1102001089, 1102001102};
int uzi5[] = { 1020016, 1102001024, 1102001036, 1102001058, 1102001069, 1102001089, 1102001102};
int uzi6[] = { 1020017, 1102001024, 1102001036, 1102001058, 1102001069, 1102001089, 1102001102};
///////////////////////////////////////////////U M P 4 5///////////////////////////////////////////////////////////////////
int ump[] = {               102002,1102002136,1102002043,1102002061,1102002090,1102002117,1102002124};
int umpmag[] = {            292002,1020021357,1020020431,1020020611,1020020901,1020021171,1020021241};
int umpreddot[] = {         203001,1020021307,1020020379,1020020559,203001,    203001,    203001};
int umpflash[] = {          201004,1020021314,1020020372,1020020552,201010,    201010,    201010};
int umpcompe[] = {          201002,1020021313,1020020374,1020020554,201009,    201009,    201009};
int umpsilent[] = {         201006,1020021315,1020020373,1020020553,201011,    201011,    201011};
int umpholo[] = {           203002,1020021306,1020020378,1020020558,203002,    203002,    203002};
int umpx2[] = {             203003,1020021305,1020020377,1020020557,203003,    203003,    203003};
int umpx3[] = {             203014,1020021304,1020020376,1020020556,203014,    203014,    203014};
int umpx4[] = {             203004,1020021303,1020020375,1020020555,203004,    203004,    203004};
int umpx6[] = {             203015,1020021302,203015,    203015    ,203015,    203015,    203015};
int umpquickMag[] = {       204005,1020021308,1020020380,1020020562,204012,    204012,    204012};
int umpextendedMag[] = {    204004,1020021309,1020020383,1020020563,204011,    204011,    204011};
int umpquickNextended[] = { 204006,1020021312,1020020384,1020020564,204013,    204013,    204013};
int umpverical[] = {        202002,1020021318,1020020385,1020020565,202002,    202002,    202002};
int umpangle[] = {          202001,1020021316,1020020387,1020020567,202001,    202001,    202001};
int umplightgrip[] = {      202004,1020021323,202004,    202004    ,202004,    202004,    202004};
int umppink[] = {           202005,1020021324,202005,    202005    ,202005,    202005,    202005};
int umplazer[] = {          202007,1020021322,202007,    202007    ,202007,    202007,    202007};
int umpthumb[] = {          202006,1020021317,1020020386,1020020566,202006,    202006,    202006};
int ump1[] = { 1020022, 1102002043, 1102002061, 1102002090, 1102002117, 1102002124, 1102002129, 1102002136};
int ump2[] = { 1020023, 1102002043, 1102002061, 1102002090, 1102002117, 1102002124, 1102002129, 1102002136};
int ump3[] = { 1020024, 1102002043, 1102002061, 1102002090, 1102002117, 1102002124, 1102002129, 1102002136};
int ump4[] = { 1020025, 1102002043, 1102002061, 1102002090, 1102002117, 1102002124, 1102002129, 1102002136};
int ump5[] = { 1020026, 1102002043, 1102002061, 1102002090, 1102002117, 1102002124, 1102002129, 1102002136};
int ump6[] = { 1020027, 1102002043, 1102002061, 1102002090, 1102002117, 1102002124, 1102002129, 1102002136};

int vectorr[] = { 102003, 1102003020, 1102003031, 1102003065, 1102003080};
int tommy[] = { 102004, 1102004018, 1102004034};
int bizon[] = { 102005, 1102005007, 1102005020, 1102005041};
/////////////////////////////////////////////// A C E 3 2///////////////////////////////////////////////////////////////////
int ace32[] = { 101102, 1101102007, 1101102017,1101102025};
int ace32reddot[] = {         203001,203001,203001,203001};
int ace32holo[] = {           203002,203002,203002,203002};
int ace32x2[] = {             203003,203003,203003,203003};
int ace32x3[] = {             203014,203014,203014,203014};
int ace32x4[] = {             203004,203004,203004,203004};
int ace32x6[] = {             203015,203015,203015,203015};
int ace321[] = { 1011022, 1101102007, 1101102017};
int ace322[] = { 1011023, 1101102007, 1101102017};
int ace323[] = { 1011024, 1101102007, 1101102017};
int ace324[] = { 1011025, 1101102007, 1101102017};
int ace325[] = { 1011026, 1101102007, 1101102017};
int ace326[] = { 1011027, 1101102007, 1101102017};

int mk145[] = { 1030075,  1103007028};
int mk146[] = { 1030074,  1103007028};
int mk147[] = { 1030072,  1103007028};
int mk148[] = { 1030073,  1103007028};
int mk149[] = { 1030076,  1103007028};
int mk140[] = { 1030077,  1103007028};
int mk14[] = { 103007,  1103007028};
int MK14[] = { 1030075,113007028 };
int MK14_4[] = { 2040095,1030070227 };
int MK14_2[] = { 203005,1030070212 };
int MK14_5[] = { 2050035,1030070236 };
int MK14_6[] = { 2010035,1030070234 };
int MK14_10[] = { 203001,1030070218 };
int MK14_11[] = { 203015,1030070213};
int MK14_12[] = { 2040135,1030070224};
int MK14_13[] = { 2010095,1030070229};
int MK14_14[] = { 2010075,1030070235};
int MK14_15[] = { 2010115,1030070232};

int longyin1111[] = { 203001,  1030070218};
int longyin2222[] = { 203003,  1030070216};
int longyin3333[] = { 203014,  1030070215};
int longyin4444[] = { 203004,  1030070214};
int longyin6666[] = { 203015,  1030070213};
int longyin8888[] = { 203005,  1030070212};
int tuosb[] = { 205003,  1030070236};
int tuosb1[] = { 2050032,  1030070236};
int tuosb2[] = { 2050033,  1030070236};
int tuosb3[] = { 2050034,  1030070236};
int tuosb4[] = { 2050035,  1030070236};

int p90[] = { 102105,  1102105012};
int p901[] = { 1021052,  1102105012};
int p902[] = { 1021053,  1102105012};
int p903[] = { 1021054,  1102105012};
int p904[] = { 1021055,  1102105012};
int p905[] = { 1021056,  1102105012};
int p906[] = { 1021057,  1102105012};
int pan[] = { 108004, 1108004125, 1108004145, 1108004160, 1108004283, 1108004337, 1108004356, 1108004365, 1108004054, 1108004008};

int m249s[] = { 205009, 1050010351, 1050010412, 1050010482, 1050010542};
//////////////////////////////////////////// M G 3 //////////////////////////////////////////////////////////////////////
int mg3[] = { 105010, 1105010019,1105010008};
int mg3reddot[] = {         203001,203001,};
int mg3holo[] = {           203002,203002,};
int mg3x2[] = {             203003,203003,};
int mg3x3[] = {             203014,203014,};
int mg3x4[] = {             203004,203004,};
int mg3x6[] = {             203015,203015,};
int mg311[] = { 1050105,  1105010008,  1105010019};
int mg322[] = { 1050106,  1105010008,  1105010019};
int mg333[] = { 1050107,  1105010008,  1105010019};
int mg344[] = { 1050102,  1105010008,  1105010019};
int mg355[] = { 1050103,  1105010008,  1105010019};
int mg366[] = { 1050104,  1105010008,  1105010019};
///////////////////////////////////////////////A K 4 7///////////////////////////////////////////////////////////////////
int akmv[] = {             101001,1101001213,1101001089,1101001103,1101001116,1101001128,1101001143,1101001154,1101001174,1101001231,1101001242};
int akmmag[] = {           291001,1010012131,1010010891,1010011031,1010011161,1010011281,1010011431,1010011541,1010011741,1010012311, 1010012421};
int akreddot[] = {         203001,1010012066,203001,    203001,    1010011105,1010011226,203001,    1010011486,1010011666,203001,203001  };
int akflash[] = {          201010,1010012067,201010,    201010,    1010011106,1010011232,201010,    1010011487,1010011667,201010,201010  }; 
int akcompe[] = {          201009,1010012068,201009,    201009,    1010011107,1010011233,201009,    1010011488,1010011668,201009,201009  };
int aksilent[] = {         201011,1010012069,201011,    201011,    1010011108,1010011234,201011,    1010011489,1010011669,201011,201011  }; 
int akholo[] = {           203002,1010012065,203002,    203002,    1010011104,1010011225,203002,    1010011485,1010011665,203002,203002  };
int akx2[] = {             203003,1010012064,203003,    203003,    1010011103,1010011224,203003,    1010011484,1010011664,203003,203003  };
int akx3[] = {             203014,1010012063,203014,    203014,    203014,    1010011223,203014,    1010011483,1010011663,203014,203014  };
int akx4[] = {             203004,1010012062,203004,    203004,    1010011222,1010011222,203004,    1010011482,1010011662,203004,203004  };
int akx6[] = {             203015,203015,    203015,    203015,    203015,    203015,    203015,    203015,    203015,    203015,203015  };
int akquickMag[] = {       204012,1010012070,204012,    204012,    1010011109,1010011227,204012,    1010011490,1010011670,204012,204012  }; 
int akextendedMag[] = {    204011,1010012072,204011,    204011,    204011,    1010011228,204011,    1010011493,1010011673,204011,204011  };
int akquickNextended[] = { 204013,1010012073,204013,    204013,    1010011112,1010011229,204013,    1010011494,1010011674,204013,204013  };
int akm1[] = { 1010012,1101001089, 1101001103, 1101001116, 1101001128, 1101001143, 1101001154, 1101001174,1101001213,1101001231,1101001242 };
int akm2[] = { 1010013,1101001089, 1101001103, 1101001116, 1101001128, 1101001143, 1101001154, 1101001174,1101001213,1101001231,1101001242 };
int akm3[] = { 1010014,1101001089, 1101001103, 1101001116, 1101001128, 1101001143, 1101001154, 1101001174,1101001213,1101001231,1101001242 };
int akm4[] = { 1010015,1101001089, 1101001103, 1101001116, 1101001128, 1101001143, 1101001154, 1101001174,1101001213,1101001231,1101001242 };
int akm5[] = { 1010016,1101001089, 1101001103, 1101001116, 1101001128, 1101001143, 1101001154, 1101001174,1101001213,1101001231,1101001242 };
int akm6[] = { 1010017,1101001089, 1101001103, 1101001116, 1101001128, 1101001143, 1101001154, 1101001174,1101001213,1101001231,1101001242 };
/////////////////////////////////////// F A M A S ///////////////////////////////////////////////////////////////////////////
int famas[] ={ 101100,1101100012,1101100013};
int famasreddot[] = {         203001,203001,203001,};
int famasholo[] = {           203002,203002,203002,};
int famasx2[] = {             203003,203003,203003,};
int famasx3[] = {             203014,203014,203014,};
int famasx4[] = {             203004,203004,203004,};
int famasx6[] = {             203015,203015,203015,};

int m46666[] = { 203015,1010040481,203015,203015,203015,203015,203015,203015,1010041967,1010042024,1010042114  };

int m43444[] = { 203004,1010040466,203004,203004,203004,203004,1010041124,1010041554,1010041944,1010042025,1010042116  };

int m43333[] = { 203014,1010040467,203014,203014,203014,203014,1010041125,1010041560,1010041945,1010042026,1010042116  };

int m42222[] = { 203003,1010040468,203003,203003,203003,203003,1010041126,1010041564,1010041946,1010042027,1010042117  };

int m16s[] = { 205007, 1010020292, 1010020562, 1010020682, 1010020812, 1010021032};

int m16mag[] = { 291002,204013,204011,204012, 1010020291, 1010020561, 1010020681, 1010020811, 1010021031};

int honey[] = { 101012, 1101012009};

int qbz[] = { 101007, 1101007062, 1101007046, 1101007036, 1101007025};

int mini14[] = { 103006, 1103006030, 1103006058};

int s1897[] = { 104002, 1104002022,1104002035,1104002004};
int s686[] = { 104001, 1104001035 };
int s12k[] = { 104003, 1104003038,1104003037,1104003026};
int dbs[] = { 104004, 1104004035,1104004014,1104004015,1104004024};
int ns2000[] = {104102, 1104102004};
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int machete[] = { 108001, 1108001069, 1108001064};

int emote1[] = { 2200101,12220023,12219677,12219716,12209401,12220028,12209701,12209801,12209901 };
int emote2[] = { 2200201,12210201,12210601,12220028,12219819,12211801,12212001,12212201,12212401 };
int emote3[] = { 2200301,12212601,12213201,12219715,12219814,12213601,12213801,12214001,12214201 };

int SuitX[] = { 403003,1405628,1405870,1405983,1406152,1406311,1406475,1406638,1406872 };

int Bag[] = { 501006,501005,501004,501003,501002,501001,1501003550,1501003277,1501003321,1501003443,1501003265,1501003051,1501003220,1501003174 };

int Helmet[] = { 502001,502002,502003,1502003014,1502003028,1502003023,1501002443,1502003031,1502003033,1502003069,1502003261 };

static int prevXSuits = preferences.Config.Skin.XSuits;
static bool callFunction = false;
#pragma mark - MTKViewDelegate
namespace Variables {
    int ActiveTab = 1;
}

static const char* OutfitSkins[] = { "DEFAULT", // 0
    "Golden Pharaoh X-Suit (6 Stars)", // 1
    "Blood Raven X-Suit", // 2
    "Poseidon X-Suit", // 3
    "Avalanche X-Suit", // 4
    "Silvanus X-Suit", // 5
    "Iridescence X-Suit", // 6
    "Arcane Jester X-Suit", // 7
    "Stygian Liege X-Suit", // 8
    "Marmoris X-Suit", // 9
    "Fiore X-Suit", // 10
    "Vampyra Countess Set", // 11
    "Galadria X-Suit", // 12
    "Spectral Admiral Set", // 13
    "Serene Lumina Set", // 14
    "Devious Cybercat Set", // 15
    "Mercury Soldier Set", // 16
    "Inferno Fiend Set", // 17
    "The Lover's Grace Set", // 18
    "Temperance's Virtue Set", // 19
    "Luminous Muse Set", // 20
    "Origin Lumen Set", // 21
    "Biker Jacket", // 22 
    "City Defender", // 23
    "Serpengleam Set", // 24
    "Shinobi Spirit Set", // 25
    "Winter Highness Set", // 26
    "Foxy Flare Set", // 27
    "The Fool's Delight Set", // 28
    "Boxerbolt Set", // 29
    "Wrathful Neptune Set", // 30
    "Crew", // 31
    "Sweet Pineapple", // 32
    "BAPE MIX CAMO HOODIE", // 33
    "BAPE City Camo Hoodie", // 34
    "BAPE CAMO Shark Hoodie", // 35
    "Wanderer Outfit", // 36
    "Fireman Suit", // 37
    "Bonds of Blood Set", // 38
    "Mummy New Color", // 39
    "Mummy Set", // 40
    "Mummy Blue", // 41
    "Invader Set", // 42
    "Lonzo Ball Jersey", // 43
    "Ben Simmons Jersey", // 44
    "Isaiah Thomas Jersey", // 45
    "Marvin Costume", // 46
    "Ryan Set", // 47
    "Angel Set", // 48
    "Summer Breeze Suit", // 49
    "Paradise Bikini (White)", // 50
    "The Fool Set", // 51
    "Infected Patient Set", // 52
    "Horned Kingpin Set", // 53
    "Myriam Fares Festival Set", // 54
    "Myriam Fares Warrior Set", // 55
    "Restless Pocong Set", // 56
    "Nina Williams Set", // 57
    "Draco Disciple Set", // 58
    "Mission Impossible Shirt (B)", // 59
    "Commander Coat", // 60
    "Evangelion Asuka Plugsuit", // 61
    "Evangelion Rei Plugsuit", // 62
    "Evangelion Shinji Plugsuit", // 63
    "Jinx Suit", // 64
    "Glacier Set", // 65
    "Feral Ravager Set", // 66
    "Fallen Spirit Set", // 67
    "Swiftfoot Phantom Set", // 68
    "Suzaku Kururugi Set", // 69
    "Kallen Kozuki Set", // 70
    "C.C. Set", // 71
    "The Reaper's End Set", // 72
    "Batblitz Set" // 73
 };
static const char* FaceSkins[]   = { "Mặc Định", "Thánh Giáp Pharaoh Vàng", "Thánh Giáp Huyết Nha", "Thánh Giáp Poseidon", "Thánh Giáp Băng Giá", "Thánh Giáp Tinh Linh", "Thánh Giáp Cleopatra Vàng", "Thánh Giáp Chúa Hề Bí Ẩn", "Thánh Giáp Huyết Thần Tai Ương", "Thánh Giáp Thần Nữ Thủy Vực", "Thánh Giáp Hoa Linh Vĩnh Cửu", "Thánh Giáp Hỏa Linh Chí Tôn", "Thánh Giáp Phong Linh Thiên Nữ", "Thánh Giáp Anukhra", "Thánh Giáp Thiên Long Thượng Cổ", "Trang Phục Xác Ướp Y Tá", "Trang Phục Đường Đến Địa Ngục", "Trang Phục Linh Hồn Xác Ướp", "Trang Phục Hỏa Thần Cổ Ngữ", "Trang Phục Băng Thần ", "Trang Phục Tiên Linh Lưu Ly", "Trang Phục Đế Vương Thần Vực", "Trang phục Sát Thủ Khát Máu", "Trang Phục Thanh Hoa Xà", "Trang phục Nhẫn Giả Bóng Đêm", "Trang Phục Thủy Thủ Mùa Đông", "Trang Phục Hỏa Hồ Ly", "Trang Phục Nữ Hoàng Giải Trí", "Trang phục Thợ Săn Điện Quang", "Trang Phục Hải Vương Thịnh Nộ", "Trang Phục Vua Âm Nhạc", "Trang Phục Huyết Rồng", "Trang Phục Kỵ Binh Siêu Việt", "BAPE MIX CAMO HOODIE", "BAPE City Camo Hoodie", "Áo Hoodie cá mập BAPE X PUBGM CAMO", "Trang Phục Bá Vương Ngọc Lam", "Trang Phục Thần Nữ Quang Ảo", "Trang phục Huyền Thần", "Trang Phục Vệ Thần Tình Ái", "Trang phục Miêu Nữ Công Nghệ", "Trang Phục Ánh Dương", "Trang Phục Nguyệt Dạ", "Trang Phục Ngôi Sao Tuyết Tinh Tú", "Thánh Giáp Chúa Hề Bí Ẩn (Đen)", "Lonzo Ball Jersey", "Trang phục hủy diệt", "Trang phục Đội trưởng Ryan", "Huyền Thoại Godzilla", "Trang Phục Thánh Nữ Huyền Ảo", "Trang Phục Đô Đốc Huyễn Ảnh", "Trang phục chú hề", "Trang Phục Hồng Y Nữ Vương", "Trang Phục Dơi Ác Ma", "Trang Phục Tử Thần Ma Xà", "C.C. Set", "Trang Phục Pocong Tà Ác", "Trang Phục Nhân Vật Nina Williams", "Trang Phục Ác Quỷ Nổi Loạn", "Plugsuit Evangelion Kaworu", "Plugsuit Evangelion Mari", "Plugsuit Evangelion Asuka", "Plugsuit Evangelion Rei", "Plugsuit Evangelion Shinji", "Áo Giáp Jinx", "Trang phục băng tuyết", "Trang Phục Thủ Lĩnh Man Tộc", "Trang Phục Tinh Linh Sa Ngã", "Trang Phục Quỷ Diện", "Suzaku Kururugi Set", "Kallen Kozuki Set" };
static const char* ShortsSkins[] = { "Default", "Commander", "Bape Mix Shorts", "Bape City Pant", "Bape Shark Shorts" };
static const char* BagSkins[] = {
    "Default",
    "Pharaoh's Regalia Backpack",
    "Blood Raven Backpack",
    "Count Backpack",
    "Crystal Casket Backpack",
    "Stealth Agent Backpack",
    "Ancient Civilization Backpack",
    "Bramble Overlord Backpack",
    "Luminous Galaxy Backpack",
    "Mystique Splendor Backpack",
    "Butterfly Wings Backpack",
    "Ignis Backpack",
    "Galadria Backpack",
    "Feathered Nobility Backpack",
    "Silver Guru Backpack",
    "Bloodstained Nemesis",
    "Frosty Snowglobe Backpack",
    "Mech Soul Ninja Backpack",
    "BAPE X PUBGM CAMO Backpack",
    "Ryan Backpack",
    "The Fool Backpack",
    "Illusion Judge Backpack",
    "Invader Backpack",
    "Kiss emoji Backpack",
    "Night Fright Backpack",
    "Trickster Backpack",
    "Brimstone Demise Backpack",
    "Blackthorn Specter Backpack",
    "Godzilla Backpack",
    "Deadly Glare Backpack",
    "Bling Backpack",
    "Aquatic Fury Backpack",
    "Flamewraith Backpack",
    "Unknown Backpack",
    "Vampiric Compulsion",
    "Majestic Cavalry Backpack",
    "Aetherflare Essence"
};

static const char* HelmetSkins[] = {
    "Default",
    "Inferno Rider Helmet",
    "Crimson Ephialtes Helmet",
    "Galactic Helmet",
    "PUBLING Helmet",
    "Galadria Helmet",
    "Lover's Barrier Helmet",
    "Ignis Helmet",
    "Aurora Diva Helmet",
    "Noctum Sunder Helmet",
    "Moondrop Eterna Helmet",
    "Dragon Guard Helmet",
    "Auric Sentinel Helmet",
    "Magma Skull Helmet",
    "Tide Sentinel Helmet",
    "Supernova Helmet",
    "Nebula Trail Helmet",
    "Majestic Cavalry Helmet",
    "Masked Psychic Helmet",
    "Ryan Helmet",
    "Intergalactic Helmet",
    "Stegosaurus Helmet",
    "Mutated Helmet",
    "Glacier Helmet",
    "Angry Pumpkin Helmet",
    "Feral Ravager Helmet",
    "Piercing Fang Helmet",
    "Auric Reign Helmet"
};

static const char* EmoteSkins[] = {
    "Default",
    "Shinobi Spirit",
    "Zombie Dance",
    "Fortune's Keeper",
    "Joyful Twist",
    "Victory Dance",
    "Masked Psychic",
    "Masked Psychic",
    "Reaper's Touch"
};

static const char* ParaSkins[] = {
    "Default",
    "Pharaoh's Scarab Parachute",
    "Enigmatic Nomad Parachute",
    "Poseidon Parachute",
    "Paperfold Gambit Parachute",
    "Labyrinth Beast Parachute",
    "Flamewraith Parachute",
    "Mega Kitty Parachute",
    "Mega Yeti Parachute",
    "Endless Glory Parachute",
    "Magma Skull Parachute",
    "Aquatic Fury Parachute",
    "CyberGen: Zero Parachute",
    "Radiant Phoenix Adarna Parachute",
    "Will of Horus Parachute",
    "Anubian Magistrate Parachute"
};

static const char* FlyMachineSkins[] = { "Default", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" };
// Gun (mỗi súng 1 mảng riêng)
static const char* M416Skins[]     = { "Default", "Roaring Immolation", "Glacier", "Ghost", "Wanderer", "Lizard", "Wild ", "Technology Core", "The Royal Family", "Silver Guru", "Tidal Embrace(Water)", "The Fool(Clown)", "Sealed Nether(Mummy)", "Cosmic Inquisitor", "Anubis Acolyte(Blue)", "Golden Trigger", "Viper(Orange)", "Bellygom(Pink)", "Flamewraith" };

static const char* AKMSkins[] = {
    "Default",
    "Sandspring Dominion - AKM (Lv. 8)",
    "Starsea Admiral - AKM (Lv. 8)",
    "Desert Fossil - AKM (Lv. 7)",
    "Jack-o'-lantern - AKM (Lv. 7)",
    "Ghillie Dragon - AKM (Lv. 7)",
    "Gold Pirate - AKM (Lv. 7)",
    "Codebreaker - AKM (Lv. 7)",
    "Wandering Tyrant - AKM (Lv. 8)",
    "Bunny Munchkin - AKM (Lv. 7)",
    "Decisive Day - AKM (Lv. 8)",
    "Glacier - AKM (Lv. 7)"
};

static const char* M16A4Skins[] = {
    "Default",
    "Blood & Bones - M16A4 (Lv. 7)",
    "Aurora Pulse - M16A4 (Lv. 7)",
    "Radiant Edge - M16A4 (Lv. 5)",
    "Skeletal Core - M16A4 (Lv. 7)",
    "Dracoguard - M16A4 (Lv. 5)"
};

static const char* SCARLSkins[] = {
    "Default",
    "Soulbound Prism - SCAR-L (Lv. 7)",
    "Fantastical Realm - SCAR-L (Lv. 7)",
    "Folly's Clasp - SCAR-L (Lv. 7)",
    "Bloodstained Nemesis - SCAR-L (Lv. 8)",
    "Hextech Crystal - SCAR-L (Lv. 7)"
};

static const char* M762Skins[] = {
    "Default",
    "Soulspecter Shredder - M762 (Lv. 7)",
    "Luminous Muse - M762 (Lv. 7)",
    "Concerto of Love - M762 (Lv. 7)",
    "Deadly Precision - M762 (Lv. 7)",
    "8-bit Unicorn - M762 (Lv. 5)",
    "Starcore - M762 (Lv. 8)",
    "Messi Football Icon - M762 (Lv. 7)",
    "Noctum Sunder - M762 (Lv. 7)",
    "Stray Rebellion - M762 (Lv. 8)",
    "GACKT MOONSAGA - M762 (Lv. 7)",
    "Skeletal Carver - M762 (Lv. 8)",
    "Platinum Skeleton - M762 (Lv. 8)"
};

static const char* GrozaSkins[] = {
    "Default",
    "Burning Godzilla - Groza (Lv. 7)",
    "Ryomen Sukuna - Groza (Lv. 7)",
    "River Styx - Groza (Lv. 7)",
    "Pumpkin Carol - Groza (Lv. 5)",
    "Forest Raider - GROZA (Lv. 5)",
    "Eventide Aria - GROZA (Lv. 5)",
    "Splendid Battle - Groza (Lv. 5)"
};

static const char* AUGSkins[] = {
    "Default",
    "Nyxen Rose - AUG (Lv. 8)",
    "Forsaken Glace - AUG (Lv. 8)",
    "Evangelion 4th Angel - AUG (Lv. 5)",
    "Wandering Circus - AUG (Lv. 5)",
    "Abyssal Howl - AUG (Lv. 7)",
    "Deep Sea Terror - AUG (Lv. 5)"
};

static const char* FamasSkins[]    = { "Mặc Định", "Đế Vương Thần Vực", "2" };
static const char* QBZSkins[]      = { "Mặc Định", "Thiên Mệnh", "2", "3" };
static const char* ACE32Skins[] = {
    "Default",
    "Papillon Kiss - ACE32 (Lv. 8)",
    "Beam Blast - ACE32 (Lv. 7)",
    "Icicle Spike - ACE32 (Lv. 7)",
    "Mystic Kraken - ACE32 (Lv. 8)"
};

static const char* HoneySkins[]    = { "Default", "Vivid Glare - Honey Badger (Lv. 5)" };

static const char* S12KSkins[]     = { "Default", "Atomic Trigger - S12K (Lv. 5)", "Violet Thunder - S12K", "S12K(GACKT Lv. 7)" };
static const char* DBSSkins[] = {
    "Default",
    "Sandsinger - DBS (Lv. 5)",
    "Cosmic Beast - DBS (Lv. 5)",
    "Bramble Overlord - DBS",
    "Nebula Trail - DBS",
    "Panthera Prime - DBS (Lv. 3)"
};

static const char* NS2000Skins[]   = { "Default", "Rustborn Strider - NS2000 (Lv. 3)" };
static const char* S686Skins[]    = { "Default", "Lethal Venom - S686 (Lv. 5)" };
static const char* S1897Skins[] = {
    "Default",
    "Twilight Hunt - S1897 (Lv. 5)",
    "Ruby Blitz - S1897",
    "Golden Sand - S1897"
};


static const char* UziSkins[] = {
    "Default",
    "Chained Inferno - UZI (Lv. 7)",
    "Glacier Hammer - UZI (Lv. 8)",
    "Ethereal Emblem - UZI (Lv. 5)",
    "Romantic Moments - UZI (Lv. 5)",
    "Shimmer Power - UZI (Lv. 5)",
    "Mystech - UZI (Lv. 5)",
    "Savagery - UZI (Lv. 6)"
};

static const char* UMPSkins[] = {
    "Default",
    "Void Souleater - UMP45 (Lv. 7)",
    "Cryofrost Shard - UMP45 (Lv. 7)",
    "Outlawed Fantasy - UMP45 (Lv. 7)",
    "8-Bit Blast - UMP45 (Lv. 5)",
    "Rainbow Stinger - UMP45 (Lv. 5)",
    "Marine Evolution - UMP45 (Lv. 3)",
    "Dragonfire - UMP45 (Lv. 7)"
};

static const char* VectorSkins[] = {
    "Default",
    "Absolute Zero - Vector (Lv. 7)",
    "Mecha Drake - Vector (Lv. 7)",
    "Blood Tooth - Vector (Lv. 5)",
    "Gilded Reaper - Vector (Lv. 5)",
    "Midnight Rose - Vector (Lv. 5)"
};

static const char* ThompsonSkins[] = { "Default", "Steampunk - Thompson SMG (Lv. 5)", "Candy Cane - Thompson SMG (Lv. 5)" };
static const char* P90Skins[]      = { "Default", "Devious Cybercat - P90 (Lv. 7)", "Golden Talon - P90 (Lv. 5)" };
static const char* BizonSkins[] = {
    "Default",
    "Spectral Byte - PP-19 Bizon (Lv. 7)",
    "Blazing Chameleon - PP-19 Bizon (Lv. 5)",
    "Skullcrusher - PP-19 Bizon (Lv. 5)",
    "Soldier Soul - PP-19 Bizon (Lv. 5)"
};

static const char* MK14Skins[]     = { "Default", "Drakreign - Mk14 (Lv. 8)" };
static const char* Mini14Skins[]   = { "Default", "1" };
static const char* SKSSkins[]      = { "Default", "1", "2" };
static const char* SLRSkins[]      = { "Default", "Ngọn Lửa Ma Thuật" };
static const char* Kar98Skins[] = {
    "Default",
    "Violet Volt - Kar98K (Lv. 7)",
    "Kukulkan Fury - Kar98K (Lv. 7)",
    "Moonlit Grace - Kar98K (Lv. 7)",
    "Titanium Shark - Kar98K (Lv. 7)",
    "Nebula Hunter - Kar98K (Lv. 5)",
    "Terror Fang - Kar98K (Lv. 7)",
    "Thornmaker - Kar98K (Lv. 7)",
    "Kitty Kadence - Kar98K (Lv. 3)"
};

static const char* M24Skins[] = {
    "Default",
    "Voidwave Trigger - M24 (Lv. 7)",
    "Cadence Maestro - M24 (Lv. 7)",
    "Pharaoh's Might - M24 (Lv. 7)",
    "Lady Butterfly - M24 (Lv. 5)",
    "Circle of Life - M24 (Lv. 7)"
};

static const char* AWMSkins[] = {
    "Default",
    "Valor's Requiem - AWM (Lv. 7)",
    "Flamewave - AWM (Lv. 7)",
    "Mauve Avenger - AWM (Lv. 7)",
    "Godzilla - AWM (Lv. 7)",
    "Rainbow Drake - AWM (Lv. 7)",
    "Serpengleam - AWM (Lv. 7)"
};

static const char* AMRSkins[]      = { "Default", "Scorching Blessing (Lv. 7)", "2", "3" };

static const char* DP28Skins[] = {
    "Default",
    "Bloodbane Parasite - DP-28 (Lv. 8)",
    "Enigmatic Hunter - DP-28 (Lv. 5)",
    "Gilded Jade Dragon - DP-28 (Lv. 5)",
    "Nautical Warrior - DP-28 (Lv. 5)",
    "Shenron - DP-28 (Lv. 5)"
};

static const char* M249Skins[] = {
    "Default",
    "Malus Majesty - M249 (Lv. 7)",
    "Winter Queen M249 V",
    "Party Parcel - M249 (Lv. 7)",
    "Moondrop Eterna - M249 (Lv. 7)",
    "Stargaze Fury - M249 (Lv. 5)"
};

static const char* MG3Skins[]      = { "Default", "Sky Huntress - MG3 (Lv. 7)", "Soaring Dragon - MG3 (Lv. 5)" };

static const char* MacheteSkins[] = {
    "Default",
    "Ki Sword (Lv. 3)",
    "Burning Godzilla Tomahawk (Lv. 3)",
    "SPY×FAMILY Yor Stilettos (Lv. 3)"
};


static const char* PanSkins[] = {
    "Default",
    "Accolade - Pan (Lv. 6)",
    "Night of Rock - Pan (Lv. 5)",
    "Crocodile - Pan (Lv. 5)",
    "Honeypot - Pan (Lv. 5)",
    "Break Pad - Pan (Lv. 6)",
    "Chicken Hot - Pan (Lv. 3)",
    "Faerie Luster - Pan (Lv. 3)",
    "Anniversary - Pan",
    "Olive Branch - Pan"
};


// Vehicle Skins
static const char* DaciaSkins[] = {
    "Default",
    "Koenigsegg Gemera (Silver Gray)",
    "Koenigsegg Gemera (Rainbow)",
    "Koenigsegg Gemera (Dawn)",
    "Dodge Charger SRT Hellcat - Fuchsia",
    "Dodge Charger SRT Hellcat - Tuscan Torque",
    "Dodge Charger SRT Hellcat Jailbreak - Violet Venom",
    "Tesla Roadster (Diamond)",
    "Tesla Roadster (Amethyst)",
    "Tesla Roadster (Digital Water)",
    "Lamborghini Estoque Oro",
    "Lamborghini Estoque Metal Grey",
    "Dodge Charger SRT Hellcat - Tuscan Torque",
    "Dodge Charger SRT Hellcat Jailbreak - Violet Venom",
    "Ghost Rosa",
    "Xunling Purple Night - Box",
    "Xunling Light Dome - Box",
    "VW Käfer 1200L (Yellow)",
    "VW Käfer 1200L (Creatures)",
    "Lotus Emeya (Golden Sprint)",
    "Lotus Emeya (Purple Volt)",
    "Bee Violence Mang - Box",
    "Shadow Wasp - Box"
};

static const char* UAZSkins[]       = { "Default", "Lamborghini Urus Giallo Inti", "2", "3", "4", "Robust Night City", "Robust Universe", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19" };
static const char* MiradoSkins[] = {
    "Default",
    "Aston Martin DBS Volante Star Dome Galaxy - Box Battle",
    "Aston Martin DBS Volante Fantasy Pink Diamond - Box Battle",
    "Aston Martin DBS Volante Extreme Night Bronze - Box Battle",
    "Bentley Continental GT Convertible Mulliner（Linglong Dreamland) - Box",
    "Bentley Continental GT Convertible Mulliner（Nobleman in Purple) - Box",
    "VW New Beetle Convertible (Pink)",
    "VW New Beetle Convertible (Monster)",
    "Megatron Convertible"
};

static const char* OMiradoSkins[]   = { "Default", "Anniversary Mirado", "Golden Mirado (Open Top)" };
static const char* CoupeRBSkins[] = {
    "Default",
    "Lamborghini Aventador SVJ Verde Alceo",
    "Lamborghini Centenario Galassia",
    "Lamborghini Aventador SVJ Blue",
    "Lamborghini Centenario Carbon Fiber",
    "Bugatti La Voiture Noire",
    "Bugatti Veyron Dazzling Cloud Neon",
    "Bugatti Veyron 16.4 (Gold)",
    "Bugatti Veyron 16.4",
    "Bugatti La Voiture Noire (Alloy)",
    "Bugatti La Voiture Noire (Warrior)",
    "Bugatti La Voiture Noire (Nebula)",
    "Warp Green",
    "Warp Dawn",
    "Warp Universe",
    "Koenigsegg Jesko (Silver Gray)",
    "Koenigsegg Jesko (Rainbow)",
    "Koenigsegg Jesko (Dawn)",
    "McLaren 570S (Zenith Black)",
    "McLaren 570S (Lunar White)",
    "McLaren 570S (Raspberry)",
    "McLaren 570S (Glory White)",
    "McLaren 570S (Royal Black)",
    "McLaren 570S (Pearlescent)",
    "McLaren P1 (Starry Sky)",
    "McLaren P1 (Fantasy Pink)",
    "McLaren P1 (Volcano Yellow)",
    "Aston Martin Valkyrie (Luminous Diamond)",
    "Aston Martin Valkyrie (Racing Green)",
    "Koenigsegg One:1 Gilt",
    "Koenigsegg One:1 Cyber Nebula",
    "Koenigsegg One:1 Jade",
    "Koenigsegg One:1 Phoenix",
    "Dodge Challenger SRT Hellcat - Blaze",
    "Dodge Challenger SRT Hellcat - Lime",
    "Maserati MC20 Bianco Audace",
    "Maserati MC20 Rosso Vincente",
    "Maserati MC20 Sogni",
    "Dodge Challenger SRT Hellcat Jailbreak - Hellfire",
    "Pagani Zonda R (Tricolore Carbon)",
    "Pagani Zonda R (Bianco Benny)",
    "Pagani Zonda R (Melodic Midnight)",
    "Pagani Imola (Grigio Montecarlo)",
    "Pagani Imola (Crystal Clear Carbon)",
    "Pagani Imola (Nebula Dream)",
    "Pagani Imola (Arctic Aegis)",
    "Lamborghini Invencible Rosso Efesto",
    "Lamborghini Invencible Nebula Drift"
};

static const char* BigfootSkins[]   = { "Default", "Xe Tải Ma Quái", "2", "3", "4", "Xe Tải Quái Vật Thống Trị Bầu Trời", "Robust Wild", "Robust Night City", "Robust Universe" };
static const char* BuggySkins[] = {
    "Default",
    "McLaren Formula 1 Team Race Car (Digital)",
    "McLaren F1 Racing Car - Box",
    "McLaren F1 Racing Triumph - Box",
    "Ceratops Blitz Buggy (Lv. 4)",
    "Black Magma Buggy",
    "Naughty Christmas Buggy",
    "Off-road Buggy",
    "Unknown1 - Buggy",
    "Street Art Buggy",
    "Unknown2 - Buggy",
    "Bloodthirsty Fiend Buggy’s",
    "Ryan Buggy",
    "Unknown3 - Buggy",
    "Godzilla Buggy",
    "Enchantress Buggy",
    "Past Glory Buggy",
    "Ancient Guardian Buggy",
    "The Pummeler Buggy",
    "Anniversary Celebration Buggy",
    "Flamerider Buggy",
    "Alligator Buggy",
    "Pink & Blue Harmony Buggy",
    "Alan Walker 2021 Buggy",
    "Lightwing Odyssey Buggy",
    "Jade Palace Buggy",
    "Radiant Phoenix Adarna Buggy",
    "Butterfinger Buggy",
    "Swiftsoul Buggy",
    "Sapphire Surfer Buggy",
    "Rash Shark Buggy",
    "Football Ambassador Buggy",
    "Sweet Kiss Buggy",
    "Polaris Buggy - Desert Blast"
};

static const char* RZRSkins[]       = { "Default", "Polaris RZR Turbo R 4", "2", "3", "Robust Night City", "5" };
static const char* RonySkins[]      = { "Default", "Tesla Cybertruck (Trắng)", "Tesla Cybertruck (Xanh)", "Tesla Cybertruck (Đen)" };
static const char* MiniBusSkins[]   = { "Default", "Xe buýt gà chiến thắng", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12" };
static const char* MotoSkins[] = {
    "Default",
    "DUCATI Panigale V4S",
    "Ducati Panigale V4S Black Phantom",
    "Ducati Panigale V4S Crimson Storm",
    "Phantom Motorcycle (Lv. 7)",
    "LINE FRIENDS Lovey Dovey 2-Seat Motorcycle (Lv. 4)",
    "Ducati Panigale V4S Swift Mirage",
    "Roaring Tiger Motorcycle (Lv. 3)",
    "Skeleton Chariot (Lv. 3)",
    "LINE FRIENDS Lovey Dovey 2-Seat Motorcycle (Lv. 4)"
};

static const char* BoatSkins[]      = { "Default", "Xuồng Cao Tốc Hoa Văn Hoàng Gia", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11" };
static const char* BRDMSkins[]      = { "Default", "1", "2" };

bool callNotify = false;

- (void)drawInMTKView:(MTKView*)view
{
  
    [[HideFunsion sharedManager] addView:view
                         isStreaming:hideHacker
                      MenDeal:MenDeal];

    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;
    [self readIniConfig];
    
    
#if TARGET_OS_OSX
    CGFloat framebufferScale = view.window.screen.backingScaleFactor ?: NSScreen.mainScreen.backingScaleFactor;
#else
    CGFloat framebufferScale = view.window.screen.nativeScale;
#endif
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 60);
    
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    
if (MenDeal == true) {
    [self.view setUserInteractionEnabled:YES];
} else if (MenDeal == false) {
    [self.view setUserInteractionEnabled:NO];
}


    
    MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil)
    {
        id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder pushDebugGroup:@""];
        
        ImGui_ImplMetal_NewFrame(renderPassDescriptor);
        ImGui::NewFrame();
        //UpdateKeyValidFlag();
        if (imgui::ESP) {
            Drawesp();
               }

        CGFloat x = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width) - 360) / 2;
        CGFloat y = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height) - 360) /2;

        ImGuiIO& Io = ImGui::GetIO();
         ImVec2 scr = ImGui::GetIO().DisplaySize;
ImVec2 winSz = ImVec2(635, 300);

ImGui::SetNextWindowPos(
    ImVec2(
        scr.x * 0.5f - winSz.x * 0.5f,
        scr.y * 0.5f - winSz.y * 0.5f
    ),
    ImGuiCond_FirstUseEver
);

ImGui::SetNextWindowSize(winSz, ImGuiCond_FirstUseEver);
ImGui::GetStyle().WindowRounding = 3.5; 

/*if (!_x0x626)
{
    return;
}*/

if (MenDeal == true)
{
    bool StartGame = true;
    if (StartGame)
    {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *BundID = [infoDictionary objectForKey:@"CFBundleIdentifier"];

        ImGui::Begin(
SDKvaT(make_string("RVJST1JWSVAgRlVDS0VEIEJZIEtBSE4=")).c_str()
            &MenDeal,
            ImGuiWindowFlags_NoCollapse |
            ImGuiWindowFlags_NoMove |
            ImGuiWindowFlags_NoResize
        );

      /*if (!PlayerzSDK()) { RainbowV1(false); return; }*/

        

        float sidebarWidth = 120.0f;

ImGui::BeginChild("TabBar", ImVec2(sidebarWidth, 0), true,
    ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoScrollWithMouse);
{
    int totalTabs = 5;

    float childHeight = ImGui::GetContentRegionAvail().y;
    float spacing = ImGui::GetStyle().ItemSpacing.y;
    float totalSpacing = spacing * (totalTabs - 1);
    float buttonHeight = (childHeight - totalSpacing) / totalTabs;
    float buttonWidth = ImGui::GetContentRegionAvail().x;

    static float animScale[5] = {0};
    static float animAlpha[5] = {0};
    static float animText[5]  = {0};

    const char* icons[5] = {
        "\uf06e", // eye (Visual)
        "\uf140", // crosshair-ish
        "\uf538", // memory
        "\uf044", // mod
        "\uf013"  // settings
    };

    const char* names[5] = {
        "Visual",
        "Aim",
        "Memory",
        "Mod",
        "Settings"
    };

    float speed = 0.08f;
    ImDrawList* draw = ImGui::GetWindowDrawList();

    for (int i = 0; i < totalTabs; i++)
    {
        bool selected = (Settings::Tab == i);

        animScale[i] += ((selected ? 1.1f : 1.0f) - animScale[i]) * speed;
        animAlpha[i] += ((selected ? 1.0f : 0.45f) - animAlpha[i]) * speed;
        animText[i]  += ((selected ? 1.0f : 0.0f) - animText[i])  * speed;

        ImVec2 cursor = ImGui::GetCursorScreenPos();

        ImGui::InvisibleButton(
            ("##tab" + std::to_string(i)).c_str(),
            ImVec2(buttonWidth, buttonHeight)
        );

        if (ImGui::IsItemClicked())
            Settings::Tab = i;

        ImVec2 center(
            cursor.x + buttonWidth * 0.5f,
            cursor.y + buttonHeight * 0.5f
        );

        float iconSize = 18.0f * animScale[i];
        float iconX = center.x - animText[i] * 12.0f;
        float textX = center.x + animText[i] * 8.0f;
        float baselineY = center.y - iconSize * 0.5f;

        draw->AddText(
            ImGui::GetFont(),
            iconSize,
            ImVec2(iconX - iconSize * 0.5f, baselineY),
            ImColor(1.0f, 1.0f, 1.0f, animAlpha[i]),
            icons[i]
        );

        if (animText[i] > 0.01f)
        {

float textSize = 14.0f;  

draw->AddText(
    ImGui::GetFont(),
    textSize,
    ImVec2(textX, baselineY + 4.0f),
    ImColor(1.0f, 1.0f, 1.0f, animText[i]),
    names[i]
);
            
        }
    }
}}
ImGui::EndChild();


        ImGui::SameLine();


        
ImGui::BeginChild("TabContent", ImVec2(0, 0), true);

if (Settings::Tab == 0) 
{
    ImGuiColorEditFlags colFlags =
        ImGuiColorEditFlags_NoInputs |
        ImGuiColorEditFlags_AlphaBar |
        ImGuiColorEditFlags_NoSidePreview |
        ImGuiColorEditFlags_DisplayRGB;

    ImGuiWindowFlags flags = ImGuiWindowFlags_NoScrollbar;

    ImGui::BeginChild("##main", ImVec2(900, 350), true, flags);

    ImGui::BeginChild("###1", ImVec2(125, 400), true, flags);

    ImGui::Checkbox("ESP", &imgui::ESP);
    configManager::putBoolean(config, "ESP", "ESP", imgui::ESP);

    ImGui::Checkbox("Text Border", &textBorder);

    ImGui::Checkbox("Hide Bot", &imgui::HideBot);

    ImGui::Checkbox("Health", &imgui::Health);
    configManager::putBoolean(config, "ESP", "HEALTH", imgui::Health);

    ImGui::Checkbox("Name", &imgui::Name);
    configManager::putBoolean(config, "ESP", "NAME", imgui::Name);

    ImGui::Checkbox("Team ID", &imgui::TeamID);
    configManager::putBoolean(config, "ESP", "TEAM_ID", imgui::TeamID);

    ImGui::Checkbox("Weapon", &imgui::Weapon);
    configManager::putBoolean(config, "ESP", "WEAPON", imgui::Weapon);

    ImGui::Checkbox("Distance", &imgui::Distance);
    configManager::putBoolean(config, "ESP", "DISTANCE", imgui::Distance);

    ImGui::Checkbox("Bone", &imgui::Bone);
    configManager::putBoolean(config, "ESP", "BONE", imgui::Bone);

    ImGui::Checkbox("Line", &imgui::Line);
    configManager::putBoolean(config, "ESP", "LINE", imgui::Line);

    ImGui::Checkbox("Enemy Count", &imgui::EnemyCount);
    configManager::putBoolean(config, "ESP", "ENEMY_COUNT", imgui::EnemyCount);

    ImGui::Checkbox("Game Info", &imgui::GameInfo);
    configManager::putBoolean(config, "ESP", "GAME_INFO", imgui::GameInfo);

    ImGui::Checkbox("Enemy Aiming", &imgui::EnemyAiming);
    configManager::putBoolean(config, "ESP", "ENEMY_AIMING", imgui::EnemyAiming);

    ImGui::Checkbox("Alert 360 (Crash Issue)", &imgui::Alert360);
    configManager::putBoolean(config, "ESP", "ALERT_360", imgui::Alert360);

    ImGui::EndChild();

    ImGui::SameLine();

    ImGui::BeginChild("###2", ImVec2(0, 700), true, flags);

    DrawCustomSliderFloat("ESP Distance (m)", &ESPMaxDistance, 1.f, 450.f, "%.0f m");

DrawCustomSliderFloat("Health Alpha", &globalHpAlphaF, 0.5f, 5.0f, "%.1f");

DrawCustomSliderFloat("Alert Radius", &AlertRadius, 1.f, 200.f, "%.0f m");

DrawCustomSliderFloat("Stroke Intensity", &strokeIntensity, 0.5f, 5.0f, "%.1f");

    ImGui::ColorEdit4("Distance Text Colour", (float*)&COLOR_Distance, colFlags);
    ImGui::ColorEdit4("Text Border Colour", (float*)&bgColor, colFlags);

    ImGui::EndChild();

    ImGui::EndChild();
}

 else if (Settings::Tab == 1) {

    ImGuiWindowFlags flags = ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoScrollWithMouse;

ImGui::BeginChild("##2", ImVec2(1200, 330), true, flags);

						{
							ImGui::SetCursorPos(ImVec2(5, 5));
							ImGui::BeginChild("###1", ImVec2(100, 700), true, flags);
							{
								ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(255, 255, 255, 255));
								if (Settings::SettingsTab::BypassMode)
								{
									if (Settings::Aimbot::AimMethod == 0)
									{
										ImGui::Checkbox(" Aimbot", &Settings::Aimbot::Tick);
									}
									if (Settings::Aimbot::AimMethod == 1 || Settings::Aimbot::AimMethod == 2)
									{
										if (Settings::Aimbot::SilentAimSettings::BypassFOVLimit || Settings::Aimbot::MemoryAimbot)
										{
											ImGui::PushStyleColor(ImGuiCol_CheckMark, ImVec4(255, 0, 0, 255));
											ImGui::Checkbox(" Aimbot", &Settings::Aimbot::Tick);
											ImGui::PopStyleColor();
										}
										else
										{
											ImGui::PushStyleColor(ImGuiCol_CheckMark, ImVec4(255, 255, 0, 255));
											ImGui::Checkbox(" Aimbot", &Settings::Aimbot::Tick);
											ImGui::PopStyleColor();
										}
									}
									if (Settings::Aimbot::AimMethod == 3)
									{
										ImGui::PushStyleColor(ImGuiCol_CheckMark, ImVec4(255, 0, 0, 255));
										ImGui::Checkbox(" Aimbot", &Settings::Aimbot::Tick);
										ImGui::PopStyleColor();
									}
								}
								else
								{
									if (Settings::Aimbot::AimMethod == 0)
									{
										ImGui::Checkbox(" Aimbot", &Settings::Aimbot::Tick);
									}
									if (Settings::Aimbot::AimMethod == 1 || Settings::Aimbot::AimMethod == 2)
									{
										ImGui::PushStyleColor(ImGuiCol_CheckMark, ImVec4(255, 255, 0, 255));
										ImGui::Checkbox(" Aimbot", &Settings::Aimbot::Tick);
										ImGui::PopStyleColor();
									}
								}

								
ImGui::Checkbox(" Silent Aim", &Enable);

ImGui::Checkbox(" Macro", &IsAimBotRecc);
								ImGui::PopStyleColor();
							}
							ImGui::EndChild();
							ImGui::SetCursorPos(ImVec2(109, 9));


ImGuiWindowFlags flags11 = ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoScrollWithMouse;

							ImGui::BeginChild("###2", ImVec2(300, 1500), true, flags11);
							{
								if (Settings::Aimbot::Tick || Enable)
								{
									if (ImGui::BeginTabBar("Slient aim")) {
										if (ImGui::BeginTabItem("Aimbot")) {
											
											if (Settings::Aimbot::AimMethod != 2)
											{
												ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(255, 255, 255, 255));
												ImGui::Text("Aimbot bone");
												ImGui::PopStyleColor();
												ImGui::SameLine();
												const char* aimpositions[] = { ("Head"), ("Body") };//
												ImGui::Combo(("##aam"), &Settings::Aimbot::SilentAimSettings::Aimpositon, aimpositions, IM_ARRAYSIZE(aimpositions));
											}
											
											ImGui::Checkbox("Enable FOV", &Settings::Aimbot::SilentAimSettings::EnableFov); if (Settings::Aimbot::SilentAimSettings::EnableFov) { ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(255, 255, 255, 255)); ImGui::Text(" - Aim FOV"); ImGui::PopStyleColor(); ImGui::SameLine(); ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(255, 255, 255, 255)); ImGui::SliderFloat("Fov", &Cross, 1.0f, 1600.0f); configManager::putInteger(config, "AIMBOT", "FOV", (int)Cross); }
                      // ---- MAX DISTANCE SLIDER ----
                      ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(255, 255, 255, 255));
                      ImGui::Text(" - Max Distance");
                      ImGui::PopStyleColor();
                      ImGui::SameLine();
                      ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(255, 255, 255, 255));
                      ImGui::SliderFloat("Distance", &SilentAimMaxDistance, 10.f, 355.f, "%.0f m");
                      configManager::putFloat(config, "AIMBOT", "SILENT_DISTANCE", SilentAimMaxDistance);
                      ImGui::PopStyleColor();
                      // ----------------------------

ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1, 1, 1, 1));
    ImGui::Text(" - Aim Speed");
    ImGui::SameLine();

    ImGui::SliderFloat("Speed", &AimSmooth, 1.0f, 7.0f);
    ImGui::PopStyleColor();

    configManager::putFloat(config, "AIMBOT", "SPEED", AimSmooth);
											ImGui::Checkbox("Ignore knocked enemy", &Settings::Aimbot::SilentAimSettings::AimKnocked);

configManager::putBoolean(config, "AIMBOT", "IGNOREKNOCKED", Settings::Aimbot::SilentAimSettings::AimKnocked);

											ImGui::PopStyleColor();
					
											ImGui::Separator();
											ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(255, 255, 255, 255));
											ImGui::Checkbox("Aimbot prediction", &Settings::Aimbot::SilentAimSettings::Prediction);
											ImGui::Separator();
											ImGui::Checkbox("Visible check     ", &Settings::isVisibilityCheck);
							ImGui::Separator();
										    ImGui::Checkbox("Ignore Bots", &Settings::Aimbot::SilentAimSettings::Highprecisiontracking);

configManager::putBoolean(config, "AIMBOT", "IGNOREBOTS", Settings::Aimbot::SilentAimSettings::Highprecisiontracking);
											ImGui::Separator();
											ImGui::Checkbox("Draw Current Aim Line", &Settings::Aimbot::SilentAimSettings::AimingLine);

configManager::putBoolean(config, "AIMBOT", "AIM_LINE", Settings::Aimbot::SilentAimSettings::AimingLine);
											ImGui::Separator();
											ImGui::PopStyleColor();
											ImGui::EndTabItem();
										}
										if (Settings::Aimbot::AimMethod == 1)
										{
																	if (ImGui::BeginTabItem("Slient aim")) {
												ImGui::SetCursorPos(ImVec2(170, 200));
												ImGui::Text(" ");
											
												ImGui::EndTabItem();
											     }
									           }
										   
										if (Settings::Aimbot::AimMethod == 2)
										{
											if (ImGui::BeginTabItem("Legit track")) {

												ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(255, 255, 255, 255));
												ImGui::Text(("Switch rate : ")); ImGui::SameLine();
												ImGui::SliderInt(("##switchrateioxn"), &Settings::Aimbot::SilentAimSettings::LegitTrackSwitchrate, 6, 80);
												ImGui::PopStyleColor();

												ImGui::EndTabItem();
											}
										}
									}
									int marco = 0;
									if (IsAimBotRecc)
									{
										if (ImGui::BeginTabItem("Marco")) {
											ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(255, 255, 255, 255));
											ImGui::Text("Marco value");
											ImGui::PopStyleColor();
											ImGui::SameLine();
											ImGui::SliderFloat("###marco", &preferences.Config.SilentAim.Recc, 1.f, 15.f);

configManager::putFloat(config, "AIMBOT", "Recoil", preferences.Config.SilentAim.Recc);

ImGui::Text("Recc = %.2f", preferences.Config.SilentAim.Recc);


											ImGui::EndTabItem();
										}
									}
								}
if (MagicSDK) {
if (ImGui::BeginTabItem("Magic")) {
											ImGui::SliderFloat("Magic X", &magicX, 0.f, 500.f);
ImGui::TextColored(ImVec4(0.0f, 0.8f, 1.0f, 1.0f), "Current X: %.1f", magicX);

ImGui::SliderFloat("Magic Y", &magicY, 0.f, 500.f);
ImGui::TextColored(ImVec4(0.0f, 0.8f, 1.0f, 1.0f), "Current Y: %.1f", magicY);

ImGui::SliderFloat("Magic Z", &magicZ, 0.f, 500.f);
ImGui::TextColored(ImVec4(0.0f, 0.8f, 1.0f, 1.0f), "Current Z: %.1f", magicZ);


											ImGui::EndTabItem();
										}}
								
								
								if (Settings::Aimbot::Tick)
								{
									if (Settings::Aimbot::AimMethod == 1)
									{
										if (ifismembotenable)
										{
											Settings::Aimbot::MemoryAimbot = false;
											ifismembotenable = false;
										}
										Settings::Aimbot::SilentAim = true;
										Settings::Aimbot::SilentAimSettings::Highprecisiontracking = true;
									}
									else if (Settings::Aimbot::AimMethod == 2)
									{
										if (ifismembotenable)
										{
											Settings::Aimbot::MemoryAimbot = false;
											ifismembotenable = false;
										}
										Settings::Aimbot::SilentAim = true;
										Settings::Aimbot::SilentAimSettings::Highprecisiontracking = true;
									}
									else if (Settings::Aimbot::AimMethod == 3)
									{
										if (Settings::SettingsTab::BypassMode)
										{
											ifismembotenable = true;
											Settings::Aimbot::MemoryAimbot = true;
											Settings::Aimbot::SilentAim = false;
										}
										else
										{
											Settings::Aimbot::MemoryAimbot = false;
											Settings::Aimbot::SilentAim = false;
										}
									}
									else
									{
										Settings::Aimbot::SilentAim = false;
									}
								}
								else
								{
									Settings::Aimbot::SilentAim = false;
								}
								ImGui::EndTabBar();
							}
							ImGui::EndChild();
						}
						ImGui::EndChild();
					}

else if (Settings::Tab == 2) { //Settingstab 2 (memory)
    
    ImGui::BeginChild("MemoryTabs", ImVec2(0, 30), false);
    {
        if (ImGui::Button("Player", ImVec2(100, 25))) Settings::Tabmod = 0;
        ImGui::SameLine();
        if (ImGui::Button("Gun", ImVec2(100, 25))) Settings::Tabmod = 1;
        ImGui::SameLine();
        if (ImGui::Button("Vehicle", ImVec2(100, 25))) Settings::Tabmod = 2;
    }
    ImGui::EndChild();
    
    ImGui::Separator();
    
    ImGui::BeginChild("MemoryContent", ImVec2(0, 0), true);
    {
        if (Settings::Tabmod == 0)  // Вкладка PLAYER
        {
            ImGui::TextColored(ImVec4(0, 255, 255, 255), "Player Settings");
            ImGui::Separator();
            
            ImGui::Checkbox("Fast Switch", &IsFastSwitch);
            ImGui::Checkbox("Fast Drop (Parachute)", &IsFastDrop);
            ImGui::Checkbox("Super Run", &chaynhanhv2);
            // здесь можно добавить другие настройки игрока
        }
        else if (Settings::Tabmod == 1)  // Вкладка GUN
        {
            ImGui::TextColored(ImVec4(0, 255, 255, 255), "Weapon Settings");
            ImGui::Separator();
            
            ImGui::Checkbox("No Shake", &IsNocamerashake);
            ImGui::Checkbox("No Recoil", &IsNorecoil2);
            ImGui::Checkbox("Fast Shoot", &IsFastshoot);
            ImGui::Checkbox("Small cross", &IsCrossHair);
            // здесь можно добавить другие настройки оружия
        }
        else if (Settings::Tabmod == 2)  // VEHICLE
        {

            ImGui::TextColored(ImVec4(0,255,255,255), "Vehicle Settings");
            ImGui::Separator();
 //         ImGui::Checkbox("Car Fly", &CarFly); 
        }
    }
    ImGui::EndChild();
}

else if (Settings::Tab == 3) {
                
                ImGui::TextColored(ImColor(255, 0, 0, 255), "Turn Off Everything In ModSkinn While You Are Entering Match - In Match Turn them On Again");
                if (ImGui::Checkbox("MOD SKIN", &ModSkinn)) {
                    //configManager::putBoolean(config, "modSwitch", "SKIN", ModSkinn);
                }
                ImGui::SameLine();
                if (ImGui::Checkbox("DEAD BOX", &DeadBox)) {
                    configManager::putBoolean(config, "modSwitch", "DEADBOX", DeadBox);
                }
                ImGui::SameLine();
                if (ImGui::Checkbox("KILL MESSAGE", &KillMessage)) {
                    
                }
                ImGui::Separator();
                if (ImGui::Checkbox("MOD LOBBY", &ModSkinnLobby)) {
                    configManager::putBoolean(config, "modSwitch", "MODLOBBY", ModSkinnLobby);
                }
                ImGui::SameLine();
                if (ImGui::Checkbox("GUN BAG (CRASH)", &BagGun)) {
                    configManager::putBoolean(config, "modSwitch", "GUNBAG", BagGun);
                }
                if (ImGui::Checkbox("Accessories Gun", &AccessoriesGun)) {
                    configManager::putBoolean(config, "modSwitch", "Accessories", AccessoriesGun);
                }
                if (ModSkinn) {
                    const float buttonWidth = (ImGui::GetContentRegionAvail().x - ImGui::GetStyle().ItemSpacing.x * 2) / 3.0f;
                    ImGui::BeginGroup();
                    if (ImGui::Button("PLAYER", ImVec2(buttonWidth, 0)))
                        Settings::Tabmod = 0;
                    ImGui::SameLine();

                    if (ImGui::Button("WEAPON", ImVec2(buttonWidth, 0)))
                        Settings::Tabmod = 1;
                    ImGui::SameLine();

                    if (ImGui::Button("VEHICLE", ImVec2(buttonWidth, 0)))
                        Settings::Tabmod = 2;
                    auto DrawSkinCombo = [&](const char* label, int* value, const char* configKey, const char* const items[], int itemCount, bool special = false) {
                        int currentIndex = *value;
                        if (currentIndex < 0 || currentIndex >= itemCount) currentIndex = 0;
                        const char* preview = items[currentIndex];

                        if (ImGui::BeginCombo(label, preview)) {
                            for (int n = 0; n < itemCount; n++) {
                                bool isSelected = (currentIndex == n);
                                if (ImGui::Selectable(items[n], isSelected)) {
                                    *value = n;
                                    configManager::putInteger(config, "modSkin", configKey, *value);

                                    // Nếu là outfit (special) → gọi hàm riêng
                                    if (special) {
                                        if (prevXSuits != preferences.Config.Skin.XSuits) {
                                            start = std::chrono::high_resolution_clock::now();
                                            callFunction = true;
                                            prevXSuits = preferences.Config.Skin.XSuits;
                                        }
                                    }
                                }
                                if (isSelected) ImGui::SetItemDefaultFocus();
                            }
                            ImGui::EndCombo();
                        }
                    };

                    if (Settings::Tabmod == 0) {
                        if (ImGui::BeginTable("##ModPlayer", 3, ImGuiTableFlags_BordersOuter | ImGuiTableFlags_BordersInner)) {
                            ImGui::TableSetupColumn("SELECT", 0, 20);
                            ImGui::TableSetupColumn("NAME", 0, 30);
                            ImGui::TableSetupColumn("SKIN", 0, 60);
                            ImGui::TableHeadersRow();

                            static int ui_Outfit = configManager::readInteger(config, "modSkin", "OUTFIT", 0);
                            static int ui_Face   = configManager::readInteger(config, "modSkin", "FACE", 0);


                            struct PlayerItem {
                                const char* name;
                                bool* selected;
                                int* skin;
                                const char* configKey;
                                const char* const* skinList;
                                int skinCount;
                                bool special;
                            } playerItems[] = {
                                {"OUTFIT",    &preferences.Outfit,     &ui_Outfit,                         "OUTFIT",    OutfitSkins,    IM_ARRAYSIZE(OutfitSkins), true},
       
{"SHORT",       &preferences.Shortsx,       &preferences.Config.Skin.Short,                   "SHORT",       ShortsSkins,       IM_ARRAYSIZE(ShortsSkins)},                      
                                {"BAG",       &preferences.Bagg,       &preferences.bag,                   "BAG",       BagSkins,       IM_ARRAYSIZE(BagSkins)},
                                {"HELMET",    &preferences.Helmett,    &preferences.helmet,                "HELMET",    HelmetSkins,    IM_ARRAYSIZE(HelmetSkins)},
                                {"PARACHUTE", &preferences.Parachute,  &preferences.Config.Skin.Parachute, "PARACHUTE", ParaSkins,      IM_ARRAYSIZE(ParaSkins)},
                                {"EFFECTFLY", &preferences.FlyMachine, &preferences.Config.Skin.FlyMachine,"EFFECTFLY", FlyMachineSkins,IM_ARRAYSIZE(FlyMachineSkins)},
                                {"EMOTE",     &preferences.Emote,      &ModEmote1,                         "EMOTE",     EmoteSkins,     IM_ARRAYSIZE(EmoteSkins)},
                            };

                            for (auto& item : playerItems) {
                                ImGui::TableNextRow();
                                ImGui::TableNextColumn();
                                
                                if (ImGui::Checkbox(("###" + std::string(item.name)).c_str(), item.selected)) {
                                    configManager::putBoolean(config, "modSkin", item.configKey, *item.selected);
                                    if (*item.selected) {
                                        if (std::string(item.name) == "OUTFIT") preferences.Config.Skin.XSuits = ui_Outfit;
                                        if (std::string(item.name) == "FACE")   preferences.Config.Skin.XSuits = ui_Face;
                                    }
                                }

                                ImGui::TableNextColumn();
                                ImGui::Text("%s", item.name);

                                ImGui::TableNextColumn();
                                
                                int oldVal = *item.skin; 
                                DrawSkinCombo(("##" + std::string(item.name)).c_str(), item.skin, item.configKey, item.skinList, item.skinCount, item.special);
                                
                                if (*item.skin != oldVal) {
                                    configManager::putInteger(config, "modSkin", item.configKey, *item.skin);
                                    
                                    if (std::string(item.name) == "OUTFIT") {
                                        preferences.Config.Skin.XSuits = *item.skin;
                                    }
                                    else if (std::string(item.name) == "FACE") {
                                        preferences.Config.Skin.XSuits = *item.skin;
                                    }
                                }
                            }
                        }
                        ImGui::EndTable();
                    }

                    if (Settings::Tabmod == 1) {
                        if (ImGui::BeginTable("##ModGun", 3, ImGuiTableFlags_BordersOuter | ImGuiTableFlags_BordersInner)) {
                            ImGui::TableSetupColumn("SELECT", 0, 20);
                            ImGui::TableSetupColumn("NAME", 0, 30);
                            ImGui::TableSetupColumn("SKIN", 0, 60);
                            ImGui::TableHeadersRow();

                            struct GunItem {
                                const char* name;
                                bool* selected;
                                int* skin;
                                const char* configKey;
                                const char* const* skinList;
                                int skinCount;
                            } guns[] = {
                                {"M416",     &preferences.M416,     &preferences.Config.Skin.M416,     "M416",     M416Skins,     IM_ARRAYSIZE(M416Skins)},
                                {"AKM",      &preferences.AKM,      &preferences.Config.Skin.AKM,      "AKM",      AKMSkins,      IM_ARRAYSIZE(AKMSkins)},
                                {"M16A4",    &preferences.M16,    &preferences.Config.Skin.M16A4,    "M16A4",    M16A4Skins,    IM_ARRAYSIZE(M16A4Skins)},
                                {"SCAR-L",   &preferences.SCARL,    &preferences.Config.Skin.Scar,    "SCAR-L",   SCARLSkins,    IM_ARRAYSIZE(SCARLSkins)},
                                {"M762",     &preferences.M762,     &preferences.Config.Skin.M762,     "M762",     M762Skins,     IM_ARRAYSIZE(M762Skins)},
                                {"GROZA",    &preferences.GROZA,    &preferences.Config.Skin.Groza,    "GROZA",    GrozaSkins,    IM_ARRAYSIZE(GrozaSkins)},
                                {"AUG",      &preferences.AUG,      &preferences.Config.Skin.AUG,      "AUG",      AUGSkins,      IM_ARRAYSIZE(AUGSkins)},
                                {"FAMAS",    &preferences.FAMAS,    &preferences.Config.Skin.Famas,    "FAMAS",    FamasSkins,    IM_ARRAYSIZE(FamasSkins)},
                                {"QBZ",      &preferences.QBZ,      &preferences.Config.Skin.QBZ,      "QBZ",      QBZSkins,      IM_ARRAYSIZE(QBZSkins)},
                                {"ACE32",    &preferences.ACE32,    &preferences.Config.Skin.ACE32,    "ACE32",    ACE32Skins,    IM_ARRAYSIZE(ACE32Skins)},
                                {"HONEY",    &preferences.Honey,    &preferences.Config.Skin.Honey,    "HONEY",    HoneySkins,    IM_ARRAYSIZE(HoneySkins)},
                                {"S12K",     &preferences.S12K,     &preferences.Config.Skin.S12K,     "S12K",     S12KSkins,     IM_ARRAYSIZE(S12KSkins)},
                                {"DBS",      &preferences.DBS,      &preferences.Config.Skin.DBS,      "DBS",      DBSSkins,      IM_ARRAYSIZE(DBSSkins)},
                                {"NS2000",   &preferences.NS2000,   &preferences.Config.Skin.NS2000,   "NS2000",   NS2000Skins,   IM_ARRAYSIZE(NS2000Skins)},
                                {"S686",     &preferences.S686,     &preferences.Config.Skin.S686,     "S686",     S686Skins,     IM_ARRAYSIZE(S686Skins)},
                                {"S1897",    &preferences.S1897,    &preferences.Config.Skin.S1897,    "S1897",    S1897Skins,    IM_ARRAYSIZE(S1897Skins)},
                                {"UZI",      &preferences.UZI,      &preferences.Config.Skin.UZI,      "UZI",      UziSkins,      IM_ARRAYSIZE(UziSkins)},
                                {"UMP",      &preferences.UMP,      &preferences.Config.Skin.UMP,      "UMP",      UMPSkins,      IM_ARRAYSIZE(UMPSkins)},
                                {"VECTOR",   &preferences.VECTOR,   &preferences.Config.Skin.Vector,   "VECTOR",   VectorSkins,   IM_ARRAYSIZE(VectorSkins)},
                                {"THOMPSON", &preferences.TOMMY, &preferences.Config.Skin.Thompson, "THOMPSON", ThompsonSkins, IM_ARRAYSIZE(ThompsonSkins)},
                                {"P90",      &preferences.P90,      &preferences.Config.Skin.P90,      "P90",      P90Skins,      IM_ARRAYSIZE(P90Skins)},
                                {"BIZON",    &preferences.BIZON,    &preferences.Config.Skin.Bizon,    "BIZON",    BizonSkins,    IM_ARRAYSIZE(BizonSkins)},
                                {"MK14",     &preferences.MK14,     &preferences.Config.Skin.MK14,     "MK14",     MK14Skins,     IM_ARRAYSIZE(MK14Skins)},
                                {"MINI14",   &preferences.MINI14,   &preferences.Config.Skin.Mini14,   "MINI14",   Mini14Skins,   IM_ARRAYSIZE(Mini14Skins)},
                                {"SKS",      &preferences.SKS,      &preferences.Config.Skin.SKS,      "SKS",      SKSSkins,      IM_ARRAYSIZE(SKSSkins)},
                                {"SLR",      &preferences.SLR,      &preferences.Config.Skin.SLR,      "SLR",      SLRSkins,      IM_ARRAYSIZE(SLRSkins)},
                                {"KAR98",    &preferences.KAR98,    &preferences.Config.Skin.K98,    "KAR98",    Kar98Skins,    IM_ARRAYSIZE(Kar98Skins)},
                                {"M24",      &preferences.M24,      &preferences.Config.Skin.M24,      "M24",      M24Skins,      IM_ARRAYSIZE(M24Skins)},
                                {"AWM",      &preferences.AWM,      &preferences.Config.Skin.AWM,      "AWM",      AWMSkins,      IM_ARRAYSIZE(AWMSkins)},
                                {"AMR",      &preferences.AMR,      &preferences.Config.Skin.AMR,      "AMR",      AMRSkins,      IM_ARRAYSIZE(AMRSkins)},
                                {"DP28",     &preferences.DP28,     &preferences.Config.Skin.DP28,     "DP28",     DP28Skins,     IM_ARRAYSIZE(DP28Skins)},
                                {"M249",     &preferences.M249,     &preferences.Config.Skin.M249,     "M249",     M249Skins,     IM_ARRAYSIZE(M249Skins)},
                                {"MG3",      &preferences.MG3,      &preferences.Config.Skin.MG3,      "MG3",      MG3Skins,      IM_ARRAYSIZE(MG3Skins)},
                                {"MACHETE",  &preferences.Machete,  &preferences.Config.Skin.Machete,  "MACHETE",  MacheteSkins,  IM_ARRAYSIZE(MacheteSkins)},
                                {"PAN",      &preferences.PAN,      &preferences.Config.Skin.Pan,      "PAN",      PanSkins,      IM_ARRAYSIZE(PanSkins)}
                            };


                            for (auto& gun : guns) {
                                ImGui::TableNextRow();
                                ImGui::TableNextColumn();
                                if (ImGui::Checkbox(("###" + std::string(gun.name)).c_str(), gun.selected)) {
                                    configManager::putBoolean(config, "modSkin", gun.configKey, *gun.selected);
                                }
                                ImGui::TableNextColumn();
                                ImGui::Text("%s", gun.name);
                                ImGui::TableNextColumn();
                                DrawSkinCombo(("##" + std::string(gun.name)).c_str(), gun.skin, gun.configKey, gun.skinList, gun.skinCount);
                            }
                        }
                        ImGui::EndTable();
                    }

                    if (Settings::Tabmod == 2) {
                        if (ImGui::BeginTable("##ModCar", 3, ImGuiTableFlags_BordersOuter | ImGuiTableFlags_BordersInner)) {
                                ImGui::TableSetupColumn("SELECT", 0, 20);
                                ImGui::TableSetupColumn("NAME", 0, 30);
                                ImGui::TableSetupColumn("SKIN", 0, 60);
                            ImGui::TableHeadersRow();

                            struct VehicleItem {
                                const char* name;
                                bool* selected;
                                int* skin;
                                const char* configKey;
                                const char* const* skinList;
                                int skinCount;
                            } vehicles[] = {
                                {"Dacia",      &preferences.Dacia,    &preferences.Config.Skin.Dacia,    "DACIA",     DaciaSkins,     IM_ARRAYSIZE(DaciaSkins)},
                                {"UAZ",        &preferences.UAZ,      &preferences.Config.Skin.UAZ,      "UAZ",       UAZSkins,       IM_ARRAYSIZE(UAZSkins)},
                                {"Mirado",     &preferences.Mirado,   &preferences.Config.Skin.Mirado,   "MIRADO",    MiradoSkins,    IM_ARRAYSIZE(MiradoSkins)},
                                {"Open Mirado",&preferences.OMirado,  &preferences.Config.Skin.OMirado,  "OMIRADO",   OMiradoSkins,   IM_ARRAYSIZE(OMiradoSkins)},
                                {"Coupe RB",   &preferences.CoupeRB,  &preferences.Config.Skin.CoupeRP,  "COUPERB",   CoupeRBSkins,   IM_ARRAYSIZE(CoupeRBSkins)},
                                {"Bigfoot",    &preferences.BigFoot,  &preferences.Config.Skin.Bigfoot,  "BIGFOOT",   BigfootSkins,   IM_ARRAYSIZE(BigfootSkins)},
                                {"Buggy",      &preferences.Buggy,    &preferences.Config.Skin.Buggy,    "BUGGY",     BuggySkins,     IM_ARRAYSIZE(BuggySkins)},
                                {"RZR",        &preferences.RZR,      &preferences.Config.Skin.RZR,      "RZR",       RZRSkins,       IM_ARRAYSIZE(RZRSkins)},
                                {"Rony",       &preferences.Rony,     &preferences.Config.Skin.Rony,     "RONY",      RonySkins,      IM_ARRAYSIZE(RonySkins)},
                                {"MiniBus",    &preferences.MiniBus,  &preferences.Config.Skin.MiniBus,  "MINIBUS",   MiniBusSkins,   IM_ARRAYSIZE(MiniBusSkins)},
                                {"Motorbike",  &preferences.Moto,     &preferences.Config.Skin.Moto,     "MOTO",      MotoSkins,      IM_ARRAYSIZE(MotoSkins)},
                                {"Boat",       &preferences.Boat,     &preferences.Config.Skin.Boat,     "BOAT",     BoatSkins,      IM_ARRAYSIZE(BoatSkins)}
                            };


                            for (auto& vehicle : vehicles) {
                                ImGui::TableNextRow();
                                ImGui::TableNextColumn();
                                if (ImGui::Checkbox(("###" + std::string(vehicle.name)).c_str(), vehicle.selected)) {
                                    configManager::putBoolean(config, "modSkin", vehicle.configKey, *vehicle.selected);
                                }
                                ImGui::TableNextColumn();
                                ImGui::Text("%s", vehicle.name);
                                ImGui::TableNextColumn();
                                DrawSkinCombo(("##" + std::string(vehicle.name)).c_str(), vehicle.skin, vehicle.configKey, vehicle.skinList, vehicle.skinCount);
                            }
                        }
                        ImGui::EndTable();
                    }
                }
            } else if (Settings::Tab == 4) {
                
/*PPAPIKey *api = [PPAPIKey sharedInstance];
if (!api) {
    api = [[PPAPIKey alloc] init];
}

if (ImGui::CollapsingHeader(make_string("API Info").c_str())) 
{
    ImGui::Columns(2, make_string("APIColumns").c_str(), true);

    ImGui::TextColored(ImColor(0, 200, 255), "%s", make_string("Property").c_str());
    ImGui::NextColumn();
    ImGui::TextColored(ImColor(0, 200, 255), "%s", make_string("Value").c_str());
    ImGui::NextColumn();
    ImGui::Separator();

    auto DrawRow = [&](const char* label, NSString *value) {
        ImGui::Text("%s", label);
        ImGui::NextColumn();
        ImGui::Text("%s", value.UTF8String);
        ImGui::NextColumn();
    };

    DrawRow(make_string("API Key").c_str(), [api getKey]);
    DrawRow(make_string("Key Expire").c_str(), [api getKeyExpire]);
    DrawRow(make_string("Key Amount").c_str(), [api getKeyAmount]);
    DrawRow(make_string("UDID").c_str(), [api getUDID]);
    DrawRow(make_string("Device").c_str(), [api getDeviceName]);
    DrawRow(make_string("iOS Version").c_str(), [api getiOSVersion]);
    DrawRow(make_string("App Version").c_str(), [api getAppVersion]);
    DrawRow(make_string("App Name").c_str(), [api getAppName]);
    DrawRow(make_string("Bundle ID").c_str(), [api getAppBundle]);
    DrawRow(make_string("Jailbreak").c_str(), [api getJailbreakStatus]);

    ImGui::Separator();
    ImGui::Columns(1);

    ImGui::BeginGroup();
    {
        if (ImGui::Button(make_string("Copy API Key").c_str())) 
        {
            [api copyKey];
        }

        ImGui::SameLine(ImGui::GetWindowWidth() - 120); // Right-aligned

        if (ImGui::Button(make_string("Logout Key").c_str())) 
        {
            [api exitKey];
        }
    }
    ImGui::EndGroup();*/


              
                ImGui::Separator();


                
                    if (ImGui::Button("RESET GUEST ACCOUNT")) {
                        ResetGuestAccount();
                    }

                    //ImGui::Unindent(16.0f);
                

                ImGui::Separator();
                if  (ImGui::Checkbox("HIDE RECORD", &hideHacker)) {
                    configManager::putBoolean(config, "SYSTEM", "HIDERECORD", hideHacker);
                }
ImGui::Checkbox("ModSkin Ban 1s (TEST)", &CoronaLab1S);

    if (CoronaLab1S && !last)
        HookCoronaLab(localPlayerController);

    if (!CoronaLab1S && last)
        UnHookCoronaLab(localPlayerController);

    last = CoronaLab1S;



ImGui::PushStyleColor(ImGuiCol_Text, IM_COL32(0,255,0,255));

{
    NSString *a = [NSString stringWithUTF8String: make_string("U3RhdHVzOiBGVUxMIFNBRkU=").c_str()]; // Status: FULL SAFE
    std::string b = a ? std::string([a UTF8String]) : std::string();
    std::string s = SDKvaT(b);
    ImGui::Text("%s", s.c_str());
}

struct utsname systemInfo;
uname(&systemInfo);
NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
NSString *iosVersion = [[UIDevice currentDevice] systemVersion];

{
    NSString *a = [NSString stringWithUTF8String: make_string("RGV2aWNlIE1vZGVsOiA=").c_str()];
    std::string b = a ? std::string([a UTF8String]) : std::string();
    std::string prefix = SDKvaT(b);
    std::string value = deviceModel ? std::string([deviceModel UTF8String]) : std::string();
    ImGui::Text("%s%s", prefix.c_str(), value.c_str());
}
{
    NSString *a = [NSString stringWithUTF8String: make_string("aU9TOiA=").c_str()];
    std::string b = a ? std::string([a UTF8String]) : std::string();
    std::string prefix = SDKvaT(b);
    std::string value = iosVersion ? std::string([iosVersion UTF8String]) : std::string();
    ImGui::Text("%s%s", prefix.c_str(), value.c_str());
}
{
    NSString *a = [NSString stringWithUTF8String: make_string("RlBTOiA=").c_str()];
    std::string b = a ? std::string([a UTF8String]) : std::string();
    std::string prefix = SDKvaT(b);
    ImGui::Text("%s%.0f", prefix.c_str(), ImGui::GetIO().Framerate);
}

ImGui::PopStyleColor();

            }

 



            ImGui::End();
            ImGui::RenderNotifications();
                
        }
        
            
        ImGui::Render();
        ImDrawData* draw_data = ImGui::GetDrawData();
        ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);
        
        
        [renderEncoder popDebugGroup];
        [renderEncoder endEncoding];
        
        [commandBuffer presentDrawable:view.currentDrawable];
            
        }
        
        
        
        
        
        [commandBuffer commit];
        
        
        
        
    }
    
-(void) readIniConfig {
    imgui::ESP         = configManager::readBoolean(config, "ESP", "ESP", false);
    imgui::Health      = configManager::readBoolean(config, "ESP", "HEALTH", false);
    imgui::Line        = configManager::readBoolean(config, "ESP", "LINE", false);
    imgui::Name        = configManager::readBoolean(config, "ESP", "NAME", false);
    imgui::TeamID      = configManager::readBoolean(config, "ESP", "TEAM_ID", false);
    imgui::Distance    = configManager::readBoolean(config, "ESP", "DISTANCE", false);
    imgui::EnemyCount  = configManager::readBoolean(config, "ESP", "ENEMY_COUNT", false);
    imgui::Weapon      = configManager::readBoolean(config, "ESP", "WEAPON", false);
    imgui::Bone        = configManager::readBoolean(config, "ESP", "BONE", false);
    imgui::GameInfo    = configManager::readBoolean(config, "ESP", "GAME_INFO", false);
    imgui::EnemyAiming    = configManager::readBoolean(config, "ESP", "ENEMY_AIMING", false);
    imgui::Alert360    = configManager::readBoolean(config, "ESP", "ALERT_360", false);

    瞄准线        = configManager::readBoolean(config, "AIMBOT", "AIMLINE", false);
    Settings::Aimbot::SilentAimSettings::AimingLine        = configManager::readBoolean(config, "AIMBOT", "AIM_LINE", false);
    ShowFov        = configManager::readBoolean(config, "AIMBOT", "SHOWFOV", false);
    AimSmooth         = configManager::readInteger(config, "AIMBOT", "SPEED", 1.5f);
    FixShoot      = configManager::readBoolean(config, "AIMBOT", "FIXSHOOT", false);
    自动开火       = configManager::readBoolean(config, "AIMBOT", "AUTOFIRE", false);
    VisCheck      = configManager::readBoolean(config, "AIMBOT", "VISCHECK", true);

Settings::Aimbot::SilentAimSettings::AimKnocked = 
    configManager::readBoolean(config, "AIMBOT", "IGNOREKNOCKED", false);
    
    打击圈        = configManager::readInteger(config, "AIMBOT", "FOVSTYLE", 0);
    CL            = configManager::readInteger(config, "AIMBOT", "CIRCLECOLOR", 1);
    追踪概率       = configManager::readFloat(config, "AIMBOT", "HITPROB", 50.0f);
    AimF          = configManager::readInteger(config, "AIMBOT", "ATTACKMETHOD", 1);
    Cross         = configManager::readInteger(config, "AIMBOT", "FOV", 200);
    g_disstance   = configManager::readFloat(config, "AIMBOT", "DISTANCE", 300.0f);
    preferences.Config.SilentAim.Recc = configManager::readFloat(config, "AIMBOT", "Recoil", 1.0f);
    SilentAimMaxDistance = configManager::readFloat(config, "AIMBOT", "SILENT_DISTANCE", 150.f);

    WideView = configManager::readBoolean(config, "SETTINGS", "IPADVIEW", false);
    WideValue = configManager::readInteger(config, "SETTINGS", "TPP", 100);
    IsFastSwitch = configManager::readBoolean(config, "MEMORY", "FASTSWITCH", false);
    IsNocamerashake = configManager::readBoolean(config, "MEMORY", "NOCAMERASHAKE", false);
    IsNorecoil2 = configManager::readBoolean(config, "MEMORY", "NORECOIL2", false);
    IsFastshoot = configManager::readBoolean(config, "MEMORY", "FASTSHOOT", false);  //MEMORY ReadIniConfig()

    AccessoriesGun = configManager::readBoolean(config,"modSwitch", "Accessories", false);
    DeadBox = configManager::readBoolean(config,"modSwitch", "DEADBOX", false);
    
    ModSkinnLobby = configManager::readBoolean(config,"modSwitch", "MODLOBBY", false);
    BagGun = configManager::readBoolean(config,"modSwitch", "GUNBAG", false);
    preferences.Outfit     = configManager::readBoolean(config, "modSkin", "OUTFIT", false);
    preferences.Face       = configManager::readBoolean(config, "modSkin", "FACE", false);
    preferences.Shortsx       = configManager::readBoolean(config, "modSkin", "SHORT", false);
    preferences.Bagg       = configManager::readBoolean(config, "modSkin", "BAG", false);
    preferences.Helmett    = configManager::readBoolean(config, "modSkin", "HELMET", false);
    preferences.Parachute  = configManager::readBoolean(config, "modSkin", "PARACHUTE", false);
    preferences.FlyMachine = configManager::readBoolean(config, "modSkin", "EFFECTFLY", false);
    preferences.Emote      = configManager::readBoolean(config, "modSkin", "EMOTE", false);
    preferences.M416    = configManager::readBoolean(config, "modSkin", "M416", false);
    preferences.AKM     = configManager::readBoolean(config, "modSkin", "AKM", false);
    preferences.M16     = configManager::readBoolean(config, "modSkin", "M16A4", false);
    preferences.SCARL   = configManager::readBoolean(config, "modSkin", "SCAR-L", false);
    preferences.M762    = configManager::readBoolean(config, "modSkin", "M762", false);
    preferences.GROZA   = configManager::readBoolean(config, "modSkin", "GROZA", false);
    preferences.AUG     = configManager::readBoolean(config, "modSkin", "AUG", false);
    preferences.FAMAS   = configManager::readBoolean(config, "modSkin", "FAMAS", false);
    preferences.QBZ     = configManager::readBoolean(config, "modSkin", "QBZ", false);
    preferences.ACE32   = configManager::readBoolean(config, "modSkin", "ACE32", false);
    preferences.Honey   = configManager::readBoolean(config, "modSkin", "HONEY", false);
    preferences.S12K    = configManager::readBoolean(config, "modSkin", "S12K", false);
    preferences.DBS     = configManager::readBoolean(config, "modSkin", "DBS", false);
    preferences.NS2000  = configManager::readBoolean(config, "modSkin", "NS2000", false);
    preferences.S686    = configManager::readBoolean(config, "modSkin", "S686", false);
    preferences.S1897   = configManager::readBoolean(config, "modSkin", "S1897", false);
    preferences.UZI     = configManager::readBoolean(config, "modSkin", "UZI", false);
    preferences.UMP     = configManager::readBoolean(config, "modSkin", "UMP", false);
    preferences.VECTOR  = configManager::readBoolean(config, "modSkin", "VECTOR", false);
    preferences.TOMMY   = configManager::readBoolean(config, "modSkin", "THOMPSON", false);
    preferences.P90     = configManager::readBoolean(config, "modSkin", "P90", false);
    preferences.BIZON   = configManager::readBoolean(config, "modSkin", "BIZON", false);
    preferences.MK14    = configManager::readBoolean(config, "modSkin", "MK14", false);
    preferences.MINI14  = configManager::readBoolean(config, "modSkin", "MINI14", false);
    preferences.SKS     = configManager::readBoolean(config, "modSkin", "SKS", false);
    preferences.SLR     = configManager::readBoolean(config, "modSkin", "SLR", false);
    preferences.KAR98   = configManager::readBoolean(config, "modSkin", "KAR98", false);
    preferences.M24     = configManager::readBoolean(config, "modSkin", "M24", false);
    preferences.AWM     = configManager::readBoolean(config, "modSkin", "AWM", false);
    preferences.AMR     = configManager::readBoolean(config, "modSkin", "AMR", false);
    preferences.DP28    = configManager::readBoolean(config, "modSkin", "DP28", false);
    preferences.M249    = configManager::readBoolean(config, "modSkin", "M249", false);
    preferences.MG3     = configManager::readBoolean(config, "modSkin", "MG3", false);
    preferences.Machete = configManager::readBoolean(config, "modSkin", "MACHETE", false);
    preferences.PAN     = configManager::readBoolean(config, "modSkin", "PAN", false);
    preferences.Dacia   = configManager::readBoolean(config, "modSkin", "DACIA", false);
    preferences.UAZ     = configManager::readBoolean(config, "modSkin", "UAZ", false);
    preferences.Mirado  = configManager::readBoolean(config, "modSkin", "MIRADO", false);
    preferences.OMirado = configManager::readBoolean(config, "modSkin", "OMIRADO", false);
    preferences.CoupeRB = configManager::readBoolean(config, "modSkin", "COUPERB", false);
    preferences.BigFoot = configManager::readBoolean(config, "modSkin", "BIGFOOT", false);
    preferences.Buggy   = configManager::readBoolean(config, "modSkin", "BUGGY", false);
    preferences.RZR     = configManager::readBoolean(config, "modSkin", "RZR", false);
    preferences.Rony    = configManager::readBoolean(config, "modSkin", "RONY", false);
    preferences.MiniBus = configManager::readBoolean(config, "modSkin", "MINIBUS", false);
    preferences.Moto    = configManager::readBoolean(config, "modSkin", "MOTO", false);
    preferences.Boat    = configManager::readBoolean(config, "modSkin", "BOAT", false);
    int savedOutfit = configManager::readInteger(config, "modSkin", "OUTFIT", 0);
    int savedFace   = configManager::readInteger(config, "modSkin", "FACE", 0);
    int savedPant = configManager::readInteger(config, "modSkin", "PANT", 0);
    if (preferences.Face) {
        preferences.Config.Skin.XSuits = savedFace;
    } 
    else if (preferences.Outfit) {
        preferences.Config.Skin.XSuits = savedOutfit;
    }
    else if (preferences.Shortsx) {
        preferences.Config.Skin.Short = savedPant;
    }
    preferences.bag                    = configManager::readInteger(config, "modSkin", "BAG", 0);
    preferences.helmet                 = configManager::readInteger(config, "modSkin", "HELMET", 0);
    preferences.Config.Skin.Parachute  = configManager::readInteger(config, "modSkin", "PARACHUTE", 0);
    preferences.Config.Skin.FlyMachine = configManager::readInteger(config, "modSkin", "EFFECTFLY", 0);
    ModEmote1                          = configManager::readInteger(config, "modSkin", "EMOTE", 0);
    preferences.Config.Skin.M416 = configManager::readInteger(config, "modSkin", "M416", 0);
    preferences.Config.Skin.AKM = configManager::readInteger(config, "modSkin", "AKM", 0);
    preferences.Config.Skin.M16A4 = configManager::readInteger(config, "modSkin", "M16A4", 0);
    preferences.Config.Skin.Scar = configManager::readInteger(config, "modSkin", "SCAR-L", 0);
    preferences.Config.Skin.M762 = configManager::readInteger(config, "modSkin", "M762", 0);
    preferences.Config.Skin.Groza = configManager::readInteger(config, "modSkin", "GROZA", 0);
    preferences.Config.Skin.AUG = configManager::readInteger(config, "modSkin", "AUG", 0);
    preferences.Config.Skin.Famas = configManager::readInteger(config, "modSkin", "FAMAS", 0);
    preferences.Config.Skin.QBZ = configManager::readInteger(config, "modSkin", "QBZ", 0);
    preferences.Config.Skin.ACE32 = configManager::readInteger(config, "modSkin", "ACE32", 0);
    preferences.Config.Skin.Honey = configManager::readInteger(config, "modSkin", "HONEY", 0);
    preferences.Config.Skin.K98 = configManager::readInteger(config, "modSkin", "KAR98", 0);
    preferences.Config.Skin.AWM = configManager::readInteger(config, "modSkin", "AWM", 0);
    preferences.Config.Skin.M24 = configManager::readInteger(config, "modSkin", "M24", 0);
    preferences.Config.Skin.AMR = configManager::readInteger(config, "modSkin", "AMR", 0);
    preferences.Config.Skin.Mini14 = configManager::readInteger(config, "modSkin", "MINI14", 0);
    preferences.Config.Skin.MK14 = configManager::readInteger(config, "modSkin", "MK14", 0);
    preferences.Config.Skin.DP28 = configManager::readInteger(config, "modSkin", "DP28", 0);
    preferences.Config.Skin.MG3 = configManager::readInteger(config, "modSkin", "MG3", 0);
    preferences.Config.Skin.M249 = configManager::readInteger(config, "modSkin", "M249", 0);
    preferences.Config.Skin.UZI = configManager::readInteger(config, "modSkin", "UZI", 0);
    preferences.Config.Skin.UMP = configManager::readInteger(config, "modSkin", "UMP", 0);
    preferences.Config.Skin.Vector = configManager::readInteger(config, "modSkin", "VECTOR", 0);
    preferences.Config.Skin.Bizon = configManager::readInteger(config, "modSkin", "BIZON", 0);
    preferences.Config.Skin.P90 = configManager::readInteger(config, "modSkin", "P90", 0);
    preferences.Config.Skin.Thompson = configManager::readInteger(config, "modSkin", "THOMPSON", 0);
    preferences.Config.Skin.S686 = configManager::readInteger(config, "modSkin", "S686", 0);
    preferences.Config.Skin.S1897 = configManager::readInteger(config, "modSkin", "S1897", 0);
    preferences.Config.Skin.S12K = configManager::readInteger(config, "modSkin", "S12K", 0);
    preferences.Config.Skin.DBS = configManager::readInteger(config, "modSkin", "DBS", 0);
    preferences.Config.Skin.NS2000 = configManager::readInteger(config, "modSkin", "NS2000", 0);
    preferences.Config.Skin.SKS = configManager::readInteger(config, "modSkin", "SKS", 0);
    preferences.Config.Skin.SLR = configManager::readInteger(config, "modSkin", "SLR", 0);
    preferences.Config.Skin.Machete = configManager::readInteger(config, "modSkin", "MACHETE", 0);
    preferences.Config.Skin.Pan = configManager::readInteger(config, "modSkin", "PAN", 0);
    preferences.Config.Skin.Dacia = configManager::readInteger(config, "modSkin", "DACIA", 0);
    preferences.Config.Skin.UAZ = configManager::readInteger(config, "modSkin", "UAZ", 0);
    preferences.Config.Skin.Mirado = configManager::readInteger(config, "modSkin", "MIRADO", 0);
    preferences.Config.Skin.OMirado = configManager::readInteger(config, "modSkin", "OMIRADO", 0);
    preferences.Config.Skin.CoupeRP = configManager::readInteger(config, "modSkin", "COUPERB", 0);
    preferences.Config.Skin.Bigfoot = configManager::readInteger(config, "modSkin", "BIGFOOT", 0);
    preferences.Config.Skin.Buggy = configManager::readInteger(config, "modSkin", "BUGGY", 0);
    preferences.Config.Skin.RZR = configManager::readInteger(config, "modSkin", "RZR", 0);
    preferences.Config.Skin.Rony = configManager::readInteger(config, "modSkin", "RONY", 0);
    preferences.Config.Skin.MiniBus = configManager::readInteger(config, "modSkin", "MINIBUS", 0);
    preferences.Config.Skin.Moto = configManager::readInteger(config, "modSkin", "MOTO", 0);
    preferences.Config.Skin.Boat = configManager::readInteger(config, "modSkin", "BOAT", 0);

    hideHacker = configManager::readBoolean(config, "SYSTEM", "HIDERECORD", false);
    imgui::WeaponBackground = configManager::readBoolean(config, "SYSTEM", "BACKGROUNDWEAPON", false);




}


- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size
{
    
}



#pragma mark - Interaction

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);
    
    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

#pragma esp method ------------------------------------------------------------------------------------


typedef uintptr_t kaddr;
using namespace std;
using namespace SDK;

struct sRegion {
    uintptr_t start, end;
};
std::vector<sRegion> trapRegions;
bool isObjectPlayer(UObject *Object) {
    if (!Tools::IsPtrValid(Object)) {
        return false;
    }
    for (auto super = Object->ClassPrivate; Tools::IsPtrValid(super); super = (UClass *) super->SuperStruct) {
        if (super == ASTExtraPlayerCharacter::StaticClass()) {
            return true;
        }
    }
    return false;
}
string encryptDecrypt(string toEncrypt) {
    char key[3] = {'K', 'C', 'Q'}; //Any chars will work, in an array of any size
    string output = toEncrypt;
    for (int i = 0; i < toEncrypt.size(); i++)
        output[i] = toEncrypt[i] ^ key[i % (sizeof(key) / sizeof(char))];
    return output;
}
bool isObjectController(UObject *Object) {
    if (!Tools::IsPtrValid(Object)) {
        return false;
    }
    for (auto super = Object->ClassPrivate; Tools::IsPtrValid(super); super = (UClass *) super->SuperStruct) {
        if (super == ASTExtraPlayerController::StaticClass()) {
            return true;
        }
    }
    return false;
}

bool isObjectInvalid(UObject *obj) {
    if (!Tools::IsPtrValid(obj)) {
        return true;
    }

    if (!Tools::IsPtrValid(obj->ClassPrivate)) {
        return true;
    }

    if (obj->InternalIndex <= 0) {
        return true;
    }

    if (obj->NamePrivate.ComparisonIndex <= 0) {
        return true;
    }

    if ((uintptr_t)(obj) % sizeof(uintptr_t) != 0x0 && (uintptr_t)(obj) % sizeof(uintptr_t) != 0x4) {
        return true;
    }

    if (std::any_of(trapRegions.begin(), trapRegions.end(), [obj](sRegion region) { return ((uintptr_t) obj) >= region.start && ((uintptr_t) obj) <= region.end; }) ||
        std::any_of(trapRegions.begin(), trapRegions.end(), [obj](sRegion region) { return ((uintptr_t) obj->ClassPrivate) >= region.start && ((uintptr_t) obj->ClassPrivate) <= region.end; })) {
        return true;
    }

    return false;
}

kaddr getRealOffset(kaddr offset){
    return (unsigned long)Get_module_base()+offset;
}

long obbbbl() { //GUObjectArray 
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *BundID = [infoDictionary objectForKey:@"CFBundleIdentifier"];
  if([BundID containsString:@"com.tencent.ig"]){
      return getRealOffset(0x10A88BA60); //Обновлено на 4.3.0 (gl)
  }
  if([BundID containsString:@"kr"]){
      return getRealOffset(0x10A7F93E0); //Обновлено на 4.3.0 (kr)
  }
  if([BundID containsString:@"rekoo"]){
      return getRealOffset(0x10A88BA60); //Обновлено на 4.3.0 (TW)
  }
  if([BundID containsString:@"vn.vng.pubgmobile"]){ //Обновлено на 4.3.0 (VNG)
      return getRealOffset(0x10A3B9060);
  }
  if([BundID containsString:@"imobile"]){
      return getRealOffset(0x1098bac80);
  }
       return false;
   };
UWorld *GEWorld;
int GWorldNum = 0;
TUObjectArray gobjects;
UWorld *GetFullWorld()
{
    if(GWorldNum == 0) {
        gobjects = UObject::GUObjectArray->ObjObjects;
        for (int i=0; i< gobjects.Num(); i++)
            if (auto obj = gobjects.GetByIndex(i)) {
                if(obj->IsA(UEngine::StaticClass())) {
                    auto GEngine = (UEngine *) obj;
                    if(GEngine) {
                        tslFont = GEngine->MediumFont;
            robotoTinyFont = GEngine->MediumFont;
            robotoFont = GEngine->MediumFont;
                        auto ViewPort = GEngine->GameViewport;
                        if (ViewPort)
                        {
                            GEWorld = ViewPort->World;
                            GWorldNum = i;
                            return ViewPort->World;
                        }
                    }
                }
            }
    }else {
        auto GEngine = (UEngine *) (gobjects.GetByIndex(GWorldNum));
        if(GEngine) {
           tslFont = GEngine->MediumFont;
            robotoTinyFont = GEngine->MediumFont;
            robotoFont = GEngine->MediumFont;
            auto ViewPort = GEngine->GameViewport;
            if(ViewPort) {
                GEWorld = ViewPort->World;
                return ViewPort->World;
            }
        }
    }
    return 0;
}

TNameEntryArray *GetGNames() { //GnameFunction
   NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *BundID = [infoDictionary objectForKey:@"CFBundleIdentifier"];
      if([BundID containsString:@"ig"]){
          return ((TNameEntryArray *(*)()) ((unsigned long)Get_module_base() +0x105014128))(); //Обновлено на 4.3.0 (GL)
      }
      if([BundID containsString:@"kr"]){
          return ((TNameEntryArray *(*)()) ((unsigned long)Get_module_base()+0x1050EBA24))(); //Обновлено на 4.3.0 (KR)
      }
      if([BundID containsString:@"rekoo"]){
          return ((TNameEntryArray *(*)()) ((unsigned long)Get_module_base()+0x1050C4AB4))(); //Обновлено на 4.3.0 (tw)
      }
      if([BundID containsString:@"vn"]){
          return ((TNameEntryArray *(*)()) ((unsigned long)Get_module_base()+0x104DBE0DC))(); //Обновлено на 4.3.0 (VNG)
      }
      if([BundID containsString:@"imobile"]){
          return ((TNameEntryArray *(*)()) ((unsigned long)Get_module_base()+0x10454d2a4))();
      }
        return 0;
    }


std::vector<AActor *> getActors() {
auto World = GetFullWorld();
if (!World)
return std::vector<AActor *>();

auto PersistentLevel = World->PersistentLevel;
if (!PersistentLevel)
return std::vector<AActor *>();

auto Actors = *(TArray<AActor *> *)((uintptr_t) PersistentLevel + 0xa0);

std::vector<AActor *> actors;
for (int i = 0; i < Actors.Num(); i++) {
auto Actor = Actors[i];
if (Actor) {
actors.push_back(Actor);
}
}
return actors;
}

template <class T>
inline void GetAllActors(std::vector<T*>& outActors) {
    outActors.clear();
UKismetMathLibrary* UMC = (UKismetMathLibrary*)UKismetMathLibrary::StaticClass();
    auto GWorld = GetFullWorld();
    if (!GWorld || !GWorld->PersistentLevel) return;

    UGameplayStatics* gGameplayStatics = (UGameplayStatics*)UGameplayStatics::StaticClass();
    if (!gGameplayStatics) return;

    TArray<AActor*> found;
    gGameplayStatics->GetAllActorsOfClass((UObject*)GWorld, T::StaticClass(), &found);

    outActors.reserve(found.Num());
    for (int i = 0; i < found.Num(); i++) {
        AActor* a = found[i];
        if (!a) continue;
        if (!a->RootComponent) continue;
        if ((uintptr_t)a < 0x10000) continue;                
        if ((uintptr_t)a > 0xFFFFFFFFFFFF) continue;         
        if (a == nullptr) continue;
        outActors.push_back((T*)a);
    }
}

std::vector<AActor *> getActorsSafe(UWorld* World)
{
    if (!World)
    {
        return {};
    }
    ULevel* PersistentLevel = World->PersistentLevel;
    if (!PersistentLevel)
    {
        return {};
    }

    const TArray<AActor *>& Actors = *(const TArray<AActor *> *)((uintptr_t)PersistentLevel + 0xa0);

    std::vector<AActor *> ValidActors;
    ValidActors.reserve(Actors.Num());
    for (int i = 0; i < Actors.Num(); i++) 
    {
  auto* Actor = Actors[i];
        if (!isObjectInvalid(Actor) && !Actor->IsChildActor())
        {
            ValidActors.push_back(Actor);
        }
    }
    return ValidActors;
}

std::vector<AActor *> getActors1()
{
    UWorld* World = GetFullWorld(); 
    return getActorsSafe(World);
}

FVector RotateCorner(FVector origin, FVector corner, float theta)
{
    float x = corner.X - origin.X;
    float y = corner.Y - origin.Y;
    return {
        origin.X + (x * cos(theta) - y * sin(theta)),
        origin.Y + (x * sin(theta) + y * cos(theta)),
        corner.Z
    };
}



FVector GetBoneLocationByName(ASTExtraPlayerCharacter *Actor, const char *BoneName) {
    return Actor->GetBonePos(BoneName, FVector());
}
bool WriteAddr(void *addr, void *buffer, size_t length) {
    unsigned long page_size = sysconf(_SC_PAGESIZE);
    unsigned long size = page_size * sizeof(kaddr);
    return mprotect((void *) ((kaddr) addr - ((kaddr) addr % page_size) - page_size), (size_t) size, PROT_EXEC | PROT_READ | PROT_WRITE) == 0 && memcpy(addr, buffer, length) != 0;
}
template<typename T>
void Write(kaddr addr, T value) {
    WriteAddr((void *) addr, &value, sizeof(T));
}

class Rect2 {
public:
    float x;
    float y;
    float width;
    float height;

    Rect2() {
        this->x = 0;
        this->y = 0;
        this->width = 0;
        this->height = 0;
    }

    Rect2(float x, float y, float width, float height) {
        this->x = x;
        this->y = y;
        this->width = width;
        this->height = height;
    }

    bool operator==(const Rect2 &src) const {
        return (src.x == this->x && src.y == this->y && src.height == this->height &&
                src.width == this->width);
    }

    bool operator!=(const Rect2 &src) const {
        return (src.x != this->x && src.y != this->y && src.height != this->height &&
                src.width != this->width);
    }
};
struct FLinearColor visCol;
ASTExtraPlayerCharacter *g_LocalPlayer;
ASTExtraPlayerController *g_PlayerController;
#define COLOR_BLACK FLinearColor(0, 0, 0, 1.f)
#define COLOR_WHITE FLinearColor(1.f, 1.f, 1.f, 1.f)
#define COLOR_RED   FLinearColor(1.f, 0, 0, 1.f)
#define COLOR_LIME  FLinearColor(0, 1.f, 0, 1.f)
#define COLOR_BLUE  FLinearColor(0, 0, 1.f, 1.f)
#define COLOR_CAR   FLinearColor(1.f, 0.5f, 1.f, 1.f)
#define GREEN       FLinearColor(0 / 255.f, 153 / 255.f, 0 / 255.f, 1.f)
#define ABU         FLinearColor(0 / 255.f, 204 / 255.f, 204 / 255.f, 1.f)
#define COLOR_GREEN FLinearColor(0, 0.5f, 0, 1.f)
#define COLOR_PLAYER FLinearColor(1.000f, 0.620f, 0.150f, 1.000f)
#define COLOR_YELLOW FLinearColor(1.000f, 1.000f, 0.000f, 1.000f)
#define 黑色 FLinearColor(0, 0, 0, 1.f)
#define 白色 FLinearColor(1.f, 1.f, 1.f, 1.f)
//#define 红色   FLinearColor(1.f, 0, 0, 1.f)
#define 灰色  FLinearColor(0, 1.f, 0, 1.f)
//#define 蓝色  FLinearColor(0, 0, 1.f, 1.f)
//#define 粉色   FLinearColor(1.f, 0.5f, 1.f, 1.f)
#define 红色 FLinearColor(1.f, 0, 0, 0.7f)
#define 绿色 FLinearColor(0, 0.5f, 0, 1.f)
//#define 橙色 FLinearColor(1.f, 0.4f, 0, 1.f)
//#define 黄色 FLinearColor(1.f, 1.f, 0, 1.f)
#define 黄色 FLinearColor(1.00f, 1.00f, 0.0f, 1.0f)//黑色
#define 青色 FLinearColor(0.0f, 1.00f, 1.00f, 1.0f)//白色
#define 橄榄绿 FLinearColor(0.5f, 0.5f, 0.0f, 1.0f)//红色
#define 棕色 FLinearColor(0.6f, 0.3f, 0.1f, 1.0f)//红色/
#define 紫色 FLinearColor(0.894f, 0.0f, 0.671f, 1.0f)//绿色
#define 橙色 FLinearColor(1.00f, 0.45f, 0.0f, 1.0f)//绿色
#define 粉色 FLinearColor(1.00f, 0.39f, 0.78f, 1.0f)//绿色
#define 蓝色 FLinearColor(0, 2, 2.f, 0.f)//绿色  
//绘制引擎矩形
UGameplayStatics* iosde = (UGameplayStatics*)UGameplayStatics::StaticClass();

#define W2S(w, s) iosde->ProjectWorldToScreen(localPlayerController, w, true, s)



static float VectorLength(const FVector &Vec) {
    return sqrtf(Vec.X * Vec.X + Vec.Y * Vec.Y + Vec.Z * Vec.Z);
}

static FVector NormalizeVector(const FVector &Vec) {
    float Length = VectorLength(Vec);
    if (Length == 0.0f)
        return FVector{0, 0, 0};

    return FVector{
        Vec.X / Length,
        Vec.Y / Length,
        Vec.Z / Length
    };
}

static float DotProduct(const FVector &Vec1, const FVector &Vec2) {
    return (Vec1.X * Vec2.X + Vec1.Y * Vec2.Y + Vec1.Z * Vec2.Z);
}

bool bIsAimingAtLocalPlayer(ASTExtraPlayerCharacter* Player) {
    if (!Player || !g_LocalPlayer)
        return false;

    static float AngleSensitivity = 20.f;

    FVector localHead = GetBoneLocationByName(g_LocalPlayer, "Head");
    FVector enemyHead = GetBoneLocationByName(Player, "Head");

    FVector Direction = localHead - enemyHead;
    FVector Forward = Player->GetActorForwardVector();

    float Angle = acosf(
        DotProduct(Forward, NormalizeVector(Direction))
    ) * (180.0f / M_PI);

    return Angle <= AngleSensitivity;
}

ImVec2 DrawHealthVnHax(ASTExtraPlayerCharacter* p, ImDrawList* draw)
{
    if (!p || !p->RootComponent)
        return ImVec2{0,0};

    FVector root = p->RootComponent->K2_GetComponentLocation();
    FVector head = root;
    head.Z += 90.0f;

    FVector2D headScreen;
    if (!WorldToScreenBone(head, &headScreen))
        return ImVec2{0,0};

    headScreen.X *= 0.5f;
    headScreen.Y *= 0.5f;

    FVector foot = root;
    foot.Z -= 90.0f;

    FVector2D footScreen;
    if (!WorldToScreenBone(foot, &footScreen))
        return ImVec2{0,0};

    footScreen.X *= 0.5f;
    footScreen.Y *= 0.5f;

    float boxHeight = fabsf(headScreen.Y - footScreen.Y);
    float boxWidth  = boxHeight * 0.5f;

    ImVec2 Playersize = ImVec2(boxWidth * 0.5f, boxHeight * 0.5f);
    ImVec2 LocationScreen = ImVec2(headScreen.X, headScreen.Y + boxHeight * 0.5f);

    float Health = p->Health;
    float NearDeathBreath = p->NearDeathBreath;

    float barHeight = boxHeight * 0.99f;
float barWidth  = 3.0f;

float barX = headScreen.X - boxWidth * 0.5f - barWidth - 4.0f;

float bottomY = footScreen.Y;
float barY = bottomY - barHeight;

    float maxHp = fmaxf(p->HealthMax, 1.f);
float currentHp = (Health > 0 ? Health : NearDeathBreath);
float filledHeight = (currentHp / maxHp) * barHeight;

    ImColor bgColor = ImColor(0, 0, 0, 175);
    ImColor fillColor = (Health > 0) ? ImColor(0,255,0,255)
                                     : ImColor(255,0,0,255);

    draw->AddRectFilled(
        ImVec2(barX, barY),
        ImVec2(barX + barWidth, barY + barHeight),
        bgColor,
        1.0f
    );

    draw->AddRectFilled(
        ImVec2(barX, barY + (barHeight - filledHeight)),
        ImVec2(barX + barWidth, barY + barHeight),
        fillColor,
        1.0f
    );

    ImVec2 center;
    center.x = barX + barWidth * 0.5f;
    center.y = barY + barHeight * 0.5f;

    return center;
}


ImVec2 DrawHealth(ASTExtraPlayerCharacter* p, ImU32 espColor, ImDrawList* d, float thick = 1.0f)
{
    
    if (!p || !p->RootComponent)
        return ImVec2{0,0};

    FVector root = p->RootComponent->K2_GetComponentLocation();
    FVector headPos = root;
    headPos.Z += 90.0f;

    FVector2D headScreen;
    if (!WorldToScreenBone(headPos, &headScreen))
        return ImVec2{0,0};

    headScreen.X *= 0.5f;
    headScreen.Y *= 0.5f;

    const float moveRight = 40.5f;

    float barWidth  = 55.0f;
    float barHeight = 6.0f;
    const float hpWidth  = 22.0f;
    const float hpHeight = 6.0f;

    float hp = fmaxf(p->Health, 0.f);
    float maxHp = fmaxf(p->HealthMax, 1.f);
    float hpPercentage = ImClamp(hp / maxHp, 0.f, 1.f);

    float baseX = headScreen.X - 45.0f;
    float baseY = headScreen.Y - 10.0f;

    ImVec2 points[6];
    points[0] = { baseX - 4 - hpWidth + moveRight + 10, baseY - hpHeight };
    points[1] = { baseX - 4 - hpWidth + barWidth + moveRight + 10, baseY - hpHeight };
    points[2] = { baseX - 4 - hpWidth + barWidth + barHeight / 2 + moveRight + 13, baseY };
    points[3] = { baseX - 4 - hpWidth + barWidth + moveRight + 10, baseY + barHeight };
    points[4] = { baseX - 4 - hpWidth + moveRight + 10, baseY + barHeight };
    points[5] = { baseX - 4 - hpWidth - barHeight / 2 + moveRight + 7, baseY };

    float clipStartX = points[5].x;
    float clipEndX   = points[2].x;
    float clippedX   = clipStartX + (clipEndX - clipStartX) * hpPercentage;

    Color255 c;
c.r = (uint8_t)(realAliveVisibleColorF[0] * 255.0f);
c.g = (uint8_t)(realAliveVisibleColorF[1] * 255.0f);
c.b = (uint8_t)(realAliveVisibleColorF[2] * 255.0f);
c.a = (uint8_t)(realAliveVisibleColorF[3] * 255.0f);


    uint8_t finalA = (uint8_t)(c.a * globalHpAlphaF);

    ImColor fillColor   = ImColor(c.r, c.g, c.b, finalA);
    ImColor borderColor = fillColor;

    d->PushClipRect(ImVec2(clipStartX, points[0].y), ImVec2(clippedX, points[3].y), true);
    d->AddConvexPolyFilled(points, 6, fillColor);
    d->PopClipRect();
    d->AddPolyline(points, 6, borderColor, true, 1.6f);

    float hexLeft   = points[5].x;
    float hexRight  = points[2].x;
    float hexTop    = points[0].y;
    float hexBottom = points[3].y;

    ImVec2 hexCenter;
    hexCenter.x = (hexLeft + hexRight) * 0.5f;
    hexCenter.y = (hexTop + hexBottom) * 0.5f;

    return hexCenter;
}

void DrawPlayerName(ASTExtraPlayerCharacter* p, ImDrawList* d, bool textBorder)
{
    if (!p || !p->RootComponent)
        return;

    FVector root = p->RootComponent->K2_GetComponentLocation();

    FVector feetPos = root;
    feetPos.Z -= 100.0f;

    FVector2D screenPos;
    if (!WorldToScreenBone(feetPos, &screenPos))
        return;

    screenPos.X *= 0.5f;
    screenPos.Y *= 0.5f;

    std::wstring wnm = p->PlayerName.ToWString();
    std::string playerName(wnm.begin(), wnm.end());
    if (playerName.empty())
        playerName = "BOT";

    float nameFontSize = 8.0f;

    ImVec2 nameSize = mainFont->CalcTextSizeA(
        nameFontSize,
        FLT_MAX,
        0.0f,
        playerName.c_str()
    );

    ImVec2 namePos;

    namePos.x = screenPos.X - nameSize.x * 0.5f;

    namePos.y = screenPos.Y + 10.0f - nameSize.y - 2.0f;

    if (textBorder)
        d->AddTextStroke(
            mainFont,
            nameFontSize,
            namePos,
            IM_COL32(0, 0, 0, 200),
            playerName.c_str()
        );

    d->AddText(
        mainFont,
        nameFontSize,
        namePos,
        IM_COL32(255, 255, 255, 255),
        playerName.c_str()
    );
}

void DrawTeamID(ASTExtraPlayerCharacter* p, ImDrawList* d, ImVec2 healthPos, bool textBorder)
{
    if (!p) return;

    std::string teamStr = "Team " + std::to_string(p->TeamID);
    float teamFontSize = 10.0f;

    ImVec2 textSize = mainFont->CalcTextSizeA(teamFontSize, FLT_MAX, 0.0f, teamStr.c_str());

    ImVec2 textPos;
    textPos.x = healthPos.x - textSize.x * 0.5f;
    textPos.y = healthPos.y - textSize.y - 11; 

    if (textBorder)
        d->AddTextStroke(mainFont, teamFontSize, textPos, IM_COL32(0,0,0,200), teamStr.c_str());

    d->AddText(mainFont, teamFontSize, textPos, IM_COL32(255,255,0,255), teamStr.c_str());
}


void DrawWeaponName(ASTExtraPlayerCharacter* p, ImDrawList* d, bool textBorder)
{
    if (!p || !p->RootComponent)
        return;

    FVector root = p->RootComponent->K2_GetComponentLocation();

    FVector headPos = root;
    headPos.Z += 90.0f;

    FVector2D screenHead;
    if (!WorldToScreenBone(headPos, &screenHead))
        return;

    screenHead.X *= 0.5f;
    screenHead.Y *= 0.5f;

    std::string weaponName = "Fist";
    if (auto wm = p->WeaponManagerComponent)
    {
        auto slot = wm->GetCurrentUsingPropSlot();
        if ((int)slot.GetValue() >= 1 && (int)slot.GetValue() <= 3)
        {
            if (auto cw = wm->CurrentWeaponReplicated)
                weaponName = cw->GetWeaponName().ToString();
        }
    }

    float weaponFontSize = 9.5f;

    ImVec2 weaponSize = mainFont->CalcTextSizeA(
        weaponFontSize,
        FLT_MAX,
        0.0f,
        weaponName.c_str()
    );

    ImVec2 textPos;

    textPos.x = screenHead.X - weaponSize.x * 0.5f;
    textPos.y = screenHead.Y - weaponSize.y - 5.0f;

    if (textBorder)
        d->AddTextStroke(
            mainFont,
            weaponFontSize,
            textPos,
            IM_COL32(0,0,0,200),
            weaponName.c_str()
        );

    d->AddText(
        mainFont,
        weaponFontSize,
        textPos,
        IM_COL32(255,255,255,255),
        weaponName.c_str()
    );
}


void DrawDistance(ASTExtraPlayerCharacter* p, ImDrawList* d, bool textBorder, ImVec2& outDistPos, ImVec2& outDistSize)
{
    FVector root = p->RootComponent->K2_GetComponentLocation();
    FVector lpPos = g_LocalPlayer->RootComponent->K2_GetComponentLocation();

    FVector delta = lpPos - root;
    float dist = sqrtf(delta.X*delta.X + delta.Y*delta.Y + delta.Z*delta.Z) / 100.0f;

    if (dist <= 0.5f || dist >= 9999.0f)
        return;

    FVector feetPos = root;
    feetPos.Z -= 100.0f;

    FVector2D screenPosF;
    if (!WorldToScreenBone(feetPos, &screenPosF))
        return;

    screenPosF.X *= 0.5f;
    screenPosF.Y *= 0.5f;

    char distText[32];
    snprintf(distText, sizeof(distText), "%.0fm", dist);

    float distFontSize = 9.0f;
    ImVec2 distSize = mainFont->CalcTextSizeA(distFontSize, FLT_MAX, 0.0f, distText);

    ImVec2 distPos;
    distPos.x = screenPosF.X - distSize.x * 0.5f;
    distPos.y = screenPosF.Y + 10.0f; // down

    ImVec2 shadowOffset = ImVec2(1.0f, 1.0f);
    ImU32 shadowColor = IM_COL32(0, 0, 0, 100);

    d->AddText(mainFont, distFontSize, ImVec2(distPos.x + shadowOffset.x, distPos.y + shadowOffset.y), shadowColor, distText);

    if (textBorder)
        d->AddTextStroke(mainFont, distFontSize, distPos, COLOR_Distance, distText);

    d->AddText(mainFont, distFontSize, distPos, COLOR_Distance, distText);

    outDistPos = distPos;
    outDistSize = distSize;
}


void DrawSkeletonAdvanced(ASTExtraPlayerCharacter* Player, bool isBot, bool isVisible) {
    if (!Player || !Player->RootComponent) return;
    
    auto d = ImGui::GetBackgroundDrawList();
    
    // Структура для хранения пары костей
    struct BonePair {
        const char* name;
        ImColor color;
    };
    
    // Все кости, которые будем рисовать
    const char* bones[] = {
        "Head", "neck_01", "upperarm_r", "lowerarm_r", "hand_r",
        "upperarm_l", "lowerarm_l", "hand_l", "pelvis",
        "thigh_r", "calf_r", "foot_r", "thigh_l", "calf_l", "foot_l"
    };
    
    // Получаем позиции всех костей
    FVector positions[15];
    bool valid[15] = {false};
    
    for (int i = 0; i < 15; i++) {
        positions[i] = Player->GetBonePos(bones[i], {});
        valid[i] = (positions[i].X != 0 || positions[i].Y != 0 || positions[i].Z != 0);
    }
    
    ImColor boneColor;
    if (isBot) {
        boneColor = isVisible ? ImColor(botVisibleColor.r, botVisibleColor.g, botVisibleColor.b, botVisibleColor.a) : ImColor(botInvisibleColor.r, botInvisibleColor.g, botInvisibleColor.b, botInvisibleColor.a);
    } else {
        boneColor = isVisible ? ImColor(realVisibleColor.r, realVisibleColor.g, realVisibleColor.b, realVisibleColor.a) : ImColor(realInvisibleColor.r, realInvisibleColor.g, realInvisibleColor.b, realInvisibleColor.a);
    }
    
    // Рисуем линии между костями
    float thick = 1.0f;
    
    // Шея -> голова
    if (valid[1] && valid[0]) {
        FVector2D neckSc, headSc;
        if (WorldToScreenBone(positions[1], &neckSc) && WorldToScreenBone(positions[0], &headSc)) {
            neckSc.X *= 0.5f; neckSc.Y *= 0.5f;
            headSc.X *= 0.5f; headSc.Y *= 0.5f;
            d->AddLine(ImVec2(neckSc.X, neckSc.Y), ImVec2(headSc.X, headSc.Y), boneColor, thick);
        }
    }
    
    // Шея -> правое плечо
    if (valid[1] && valid[2]) {
        FVector2D neckSc, upperRSc;
        if (WorldToScreenBone(positions[1], &neckSc) && WorldToScreenBone(positions[2], &upperRSc)) {
            neckSc.X *= 0.5f; neckSc.Y *= 0.5f;
            upperRSc.X *= 0.5f; upperRSc.Y *= 0.5f;
            d->AddLine(ImVec2(neckSc.X, neckSc.Y), ImVec2(upperRSc.X, upperRSc.Y), boneColor, thick);
        }
    }
    
    // Правое плечо -> правое предплечье
    if (valid[2] && valid[3]) {
        FVector2D upperRSc, lowerRSc;
        if (WorldToScreenBone(positions[2], &upperRSc) && WorldToScreenBone(positions[3], &lowerRSc)) {
            upperRSc.X *= 0.5f; upperRSc.Y *= 0.5f;
            lowerRSc.X *= 0.5f; lowerRSc.Y *= 0.5f;
            d->AddLine(ImVec2(upperRSc.X, upperRSc.Y), ImVec2(lowerRSc.X, lowerRSc.Y), boneColor, thick);
        }
    }
    
    // Правое предплечье -> правая кисть
    if (valid[3] && valid[4]) {
        FVector2D lowerRSc, handRSc;
        if (WorldToScreenBone(positions[3], &lowerRSc) && WorldToScreenBone(positions[4], &handRSc)) {
            lowerRSc.X *= 0.5f; lowerRSc.Y *= 0.5f;
            handRSc.X *= 0.5f; handRSc.Y *= 0.5f;
            d->AddLine(ImVec2(lowerRSc.X, lowerRSc.Y), ImVec2(handRSc.X, handRSc.Y), boneColor, thick);
        }
    }
    
    // Шея -> левое плечо
    if (valid[1] && valid[5]) {
        FVector2D neckSc, upperLSc;
        if (WorldToScreenBone(positions[1], &neckSc) && WorldToScreenBone(positions[5], &upperLSc)) {
            neckSc.X *= 0.5f; neckSc.Y *= 0.5f;
            upperLSc.X *= 0.5f; upperLSc.Y *= 0.5f;
            d->AddLine(ImVec2(neckSc.X, neckSc.Y), ImVec2(upperLSc.X, upperLSc.Y), boneColor, thick);
        }
    }
    
    // Левое плечо -> левое предплечье
    if (valid[5] && valid[6]) {
        FVector2D upperLSc, lowerLSc;
        if (WorldToScreenBone(positions[5], &upperLSc) && WorldToScreenBone(positions[6], &lowerLSc)) {
            upperLSc.X *= 0.5f; upperLSc.Y *= 0.5f;
            lowerLSc.X *= 0.5f; lowerLSc.Y *= 0.5f;
            d->AddLine(ImVec2(upperLSc.X, upperLSc.Y), ImVec2(lowerLSc.X, lowerLSc.Y), boneColor, thick);
        }
    }
    
    // Левое предплечье -> левая кисть
    if (valid[6] && valid[7]) {
        FVector2D lowerLSc, handLSc;
        if (WorldToScreenBone(positions[6], &lowerLSc) && WorldToScreenBone(positions[7], &handLSc)) {
            lowerLSc.X *= 0.5f; lowerLSc.Y *= 0.5f;
            handLSc.X *= 0.5f; handLSc.Y *= 0.5f;
            d->AddLine(ImVec2(lowerLSc.X, lowerLSc.Y), ImVec2(handLSc.X, handLSc.Y), boneColor, thick);
        }
    }
    
    // Шея -> таз
    if (valid[1] && valid[8]) {
        FVector2D neckSc, pelvisSc;
        if (WorldToScreenBone(positions[1], &neckSc) && WorldToScreenBone(positions[8], &pelvisSc)) {
            neckSc.X *= 0.5f; neckSc.Y *= 0.5f;
            pelvisSc.X *= 0.5f; pelvisSc.Y *= 0.5f;
            d->AddLine(ImVec2(neckSc.X, neckSc.Y), ImVec2(pelvisSc.X, pelvisSc.Y), boneColor, thick);
        }
    }
    
    // Таз -> правое бедро
    if (valid[8] && valid[9]) {
        FVector2D pelvisSc, thighRSc;
        if (WorldToScreenBone(positions[8], &pelvisSc) && WorldToScreenBone(positions[9], &thighRSc)) {
            pelvisSc.X *= 0.5f; pelvisSc.Y *= 0.5f;
            thighRSc.X *= 0.5f; thighRSc.Y *= 0.5f;
            d->AddLine(ImVec2(pelvisSc.X, pelvisSc.Y), ImVec2(thighRSc.X, thighRSc.Y), boneColor, thick);
        }
    }
    
    // Правое бедро -> правая голень
    if (valid[9] && valid[10]) {
        FVector2D thighRSc, calfRSc;
        if (WorldToScreenBone(positions[9], &thighRSc) && WorldToScreenBone(positions[10], &calfRSc)) {
            thighRSc.X *= 0.5f; thighRSc.Y *= 0.5f;
            calfRSc.X *= 0.5f; calfRSc.Y *= 0.5f;
            d->AddLine(ImVec2(thighRSc.X, thighRSc.Y), ImVec2(calfRSc.X, calfRSc.Y), boneColor, thick);
        }
    }
    
    // Правая голень -> правая стопа
    if (valid[10] && valid[11]) {
        FVector2D calfRSc, footRSc;
        if (WorldToScreenBone(positions[10], &calfRSc) && WorldToScreenBone(positions[11], &footRSc)) {
            calfRSc.X *= 0.5f; calfRSc.Y *= 0.5f;
            footRSc.X *= 0.5f; footRSc.Y *= 0.5f;
            d->AddLine(ImVec2(calfRSc.X, calfRSc.Y), ImVec2(footRSc.X, footRSc.Y), boneColor, thick);
        }
    }
    
    // Таз -> левое бедро
    if (valid[8] && valid[12]) {
        FVector2D pelvisSc, thighLSc;
        if (WorldToScreenBone(positions[8], &pelvisSc) && WorldToScreenBone(positions[12], &thighLSc)) {
            pelvisSc.X *= 0.5f; pelvisSc.Y *= 0.5f;
            thighLSc.X *= 0.5f; thighLSc.Y *= 0.5f;
            d->AddLine(ImVec2(pelvisSc.X, pelvisSc.Y), ImVec2(thighLSc.X, thighLSc.Y), boneColor, thick);
        }
    }
    
    // Левое бедро -> левая голень
    if (valid[12] && valid[13]) {
        FVector2D thighLSc, calfLSc;
        if (WorldToScreenBone(positions[12], &thighLSc) && WorldToScreenBone(positions[13], &calfLSc)) {
            thighLSc.X *= 0.5f; thighLSc.Y *= 0.5f;
            calfLSc.X *= 0.5f; calfLSc.Y *= 0.5f;
            d->AddLine(ImVec2(thighLSc.X, thighLSc.Y), ImVec2(calfLSc.X, calfLSc.Y), boneColor, thick);
        }
    }
    
    // Левая голень -> левая стопа
    if (valid[13] && valid[14]) {
        FVector2D calfLSc, footLSc;
        if (WorldToScreenBone(positions[13], &calfLSc) && WorldToScreenBone(positions[14], &footLSc)) {
            calfLSc.X *= 0.5f; calfLSc.Y *= 0.5f;
            footLSc.X *= 0.5f; footLSc.Y *= 0.5f;
            d->AddLine(ImVec2(calfLSc.X, calfLSc.Y), ImVec2(footLSc.X, footLSc.Y), boneColor, thick);
        }
    }
}
void DrawEnemyAimingAlert(ASTExtraPlayerCharacter* p, ImDrawList* d, bool textBorder, ImVec2 distPos, ImVec2 distSize)
{
    if (!p) 
        return;

    if (!bIsAimingAtLocalPlayer(p))
        return;

    ImGuiIO& io = ImGui::GetIO();
    ImVec2 disp = io.DisplaySize;

    float fontSize = 16.0f;
    float t = ImGui::GetTime();
    bool redPhase = ((int)(t * 4.0f) & 1);

    ImU32 warnColor = redPhase
        ? IM_COL32(255, 0, 0, 255)
        : IM_COL32(255, 255, 0, 255);

    std::string warnText =
        std::string(ICON_FA_EXCLAMATION_TRIANGLE)
        + "  ENEMY IS AIMING AT YOU  "
        + ICON_FA_EXCLAMATION_TRIANGLE;

    ImVec2 textSize = mainFont->CalcTextSizeA(fontSize, FLT_MAX, 0.0f, warnText.c_str());

    ImVec2 pos;
    pos.x = floorf(disp.x * 0.5f - textSize.x * 0.5f);
    pos.y = floorf(112.0f);

    if (textBorder)
        d->AddTextStroke(mainFont, fontSize, pos, IM_COL32(0, 0, 0, 220), warnText.c_str());

    d->AddText(mainFont, fontSize, pos, warnColor, warnText.c_str());

    const char* aimText = "AIMING";
    float aimFontSize = 9.0f;
    ImVec2 aimSize = mainFont->CalcTextSizeA(aimFontSize, FLT_MAX, 0.0f, aimText);

    ImVec2 aimPos;
    aimPos.x = distPos.x + distSize.x * 0.5f - aimSize.x * 0.5f; 
    aimPos.y = distPos.y + distSize.y + 6.0f; 

    if (textBorder)
        d->AddTextStroke(mainFont, aimFontSize, aimPos, IM_COL32(0, 0, 0, 220), aimText);

    d->AddText(mainFont, aimFontSize, aimPos, IM_COL32(255, 0, 0, 255), aimText);
}

float GetYawAngleToEnemy(FVector playerForward, FVector toEnemy)
{
    FVector dir = toEnemy; 
    dir.Z = 0; 
    dir = NormalizeVector(dir);

    playerForward.Z = 0;
    playerForward = NormalizeVector(playerForward);

    float dot = playerForward.X * dir.X + playerForward.Y * dir.Y; 
    float det = playerForward.X * dir.Y - playerForward.Y * dir.X; 
    float angle = atan2f(det, dot); 
    return angle; 
}

void Draw360Alert(std::vector<ASTExtraPlayerCharacter*> enemies)
{
    if (!g_LocalPlayer) return;

    ImDrawList* d = ImGui::GetForegroundDrawList();
    ImGuiIO& io = ImGui::GetIO();
    ImVec2 center(io.DisplaySize.x * 0.5f, io.DisplaySize.y * 0.5f);

    FVector playerPos = g_LocalPlayer->RootComponent->K2_GetComponentLocation();
    FVector playerForward = g_LocalPlayer->GetActorForwardVector();

    float circleThickness = 2.5f;
    float dotSize = 5.0f;
    float maxDotOffset = AlertRadius - 14.0f;

    ImU32 colors[] = {
    IM_COL32(0, 255, 0, 255),
    IM_COL32(255, 0, 0, 255),
    IM_COL32(255, 0, 255, 255),
    IM_COL32(0, 128, 255, 255),
    IM_COL32(255, 255, 0, 255),
    IM_COL32(0, 255, 255, 255),
    IM_COL32(255, 128, 0, 255),
    IM_COL32(128, 0, 255, 255),
    IM_COL32(255, 0, 128, 255),
    IM_COL32(0, 255, 128, 255),
    IM_COL32(128, 255, 0, 255),
    IM_COL32(0, 128, 128, 255),
    IM_COL32(128, 128, 0, 255),
    IM_COL32(128, 0, 128, 255),
    IM_COL32(0, 128, 255, 255),
    IM_COL32(255, 128, 128, 255),
    IM_COL32(128, 255, 128, 255),
    IM_COL32(128, 128, 255, 255),
    IM_COL32(255, 0, 64, 255),
    IM_COL32(0, 64, 255, 255),
    IM_COL32(64, 255, 0, 255),
    IM_COL32(255, 255, 128, 255),
    IM_COL32(255, 128, 255, 255),
    IM_COL32(128, 255, 255, 255),
    IM_COL32(64, 64, 64, 255)
};

    int colorCount = sizeof(colors)/sizeof(colors[0]);
    int enemyIndex = 0;

    for (auto* p : enemies)
    {
        if (!p || p->bDead) continue;

        FVector enemyPos = p->RootComponent->K2_GetComponentLocation();
        FVector toEnemy = enemyPos - playerPos;

        float dist = sqrtf(toEnemy.X*toEnemy.X + toEnemy.Y*toEnemy.Y + toEnemy.Z*toEnemy.Z) / 100.f;
        

if (dist < 0.5f || dist > ESPMaxDistance) 
    continue;


        FVector forward2D = playerForward;
        forward2D.Z = 0;
        forward2D = NormalizeVector(forward2D);

        FVector enemy2D = toEnemy;
        enemy2D.Z = 0;
        enemy2D = NormalizeVector(enemy2D);

        float dot = forward2D.X * enemy2D.X + forward2D.Y * enemy2D.Y;
        float det = forward2D.X * enemy2D.Y - forward2D.Y * enemy2D.X;
        float angle = atan2f(det, dot);

        float distanceFactor = 1.0f - fminf(dist / 500.f, 1.0f);
        float dotRadius = maxDotOffset * distanceFactor;

        float x = center.x + sinf(angle) * dotRadius;
        float y = center.y - cosf(angle) * dotRadius;

        ImU32 color = colors[enemyIndex % colorCount];

        d->AddCircleFilled(ImVec2(x, y), dotSize, color);

        enemyIndex++;
    }
}


void DrawEnemyCount()
{
    static std::vector<ASTExtraPlayerCharacter*> enemyCache;
    float now = ImGui::GetTime();
    static float lastUpdate = 0.f;

    if (now - lastUpdate > 0.7f)
    {
        std::vector<ASTExtraPlayerCharacter*> tmp;
        GetAllActors(tmp);
        enemyCache.clear();

        auto lp = g_LocalPlayer;
        if (!lp || !lp->RootComponent) return;

        int localTeamID = lp->TeamID;

        for (auto* p : tmp)
        {
            if (!p || !p->RootComponent) continue;
            if (p == lp) continue;
            if (p->bDead) continue;
            if (p->TeamID == localTeamID) continue;

            enemyCache.push_back(p);
        }

        lastUpdate = now;
    }

    int enemiesCount = 0;
    int botsCount = 0;

    for (auto* p : enemyCache)
{
    if (!p || !p->RootComponent) continue;
    if (!imgui::ESP) continue;

    // ✅ Добавляем проверку HideBot
    if (imgui::HideBot && (p->bIsAI || p->bEnsure))
        continue;  // не считаем ботов, если HideBot включён

    if (p->bIsAI || p->bEnsure)
        ++botsCount;
    else
        ++enemiesCount;
}

    int totalCount = enemiesCount + botsCount;

    std::string text = "Enemy Count: " + std::to_string(totalCount);

    ImDrawList* draw = ImGui::GetForegroundDrawList();

    ImVec2 center = ImGui::GetMainViewport()->GetCenter();
    ImVec2 textSize = ImGui::CalcTextSize(text.c_str());

    ImVec2 pos;
//   float leftOffset = 6.f; 
pos.x = center.x - textSize.x * 0.5f;
pos.y = 50.f;
    pos.y = 50.f;

    draw->AddText(
    mainFont,           
    20.0f,           
    pos,
    IM_COL32(255, 0, 0, 255),
    text.c_str()
);
}

void DrawGameInfo()
{
    if (!imgui::GameInfo)
        return;

    ImGui::SetNextWindowPos(ImVec2(20, 325), ImGuiCond_Always);
    ImGuiWindowFlags flags = ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize |
                             ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoCollapse |
                             ImGuiWindowFlags_NoScrollWithMouse | ImGuiWindowFlags_AlwaysAutoResize | 
                             ImGuiWindowFlags_NoBackground;
 //   ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 6.0f);
 //   ImGui::PushStyleVar(ImGuiStyleVar_Alpha, 0.85f);
 //   ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(6, 4));

    if (ImGui::Begin("Game Information", nullptr, flags)) {
        ImGui::SetWindowFontScale(0.8f);  // 0.8 = 80% от обычного
        static ASTExtraGameStateBase* cachedGameState = nullptr;
        static float lastUpdate = 0.f;
        float now = ImGui::GetTime();
        if (!cachedGameState || now - lastUpdate > 5.f) {
            cachedGameState = nullptr;
            std::vector<ASTExtraGameStateBase*> actors;
            GetAllActors<ASTExtraGameStateBase>(actors);
            if (!actors.empty()) cachedGameState = actors[0];
            lastUpdate = now;
        }
        ASTExtraGameStateBase* InGame = cachedGameState;
        if (InGame) {
            static bool blink = true;
            static float blinkTimer = 0.0f;
            blinkTimer += ImGui::GetIO().DeltaTime;
            if (blinkTimer > 0.5f) { blink = !blink; blinkTimer = 0.0f; }
            ImVec4 ballColor = blink ? ImVec4(1, 0, 0, 1) : ImVec4(0, 0, 0, 0);
            ImGui::TextColored(ballColor, ICON_FA_CIRCLE);
            ImGui::SameLine();
            ImGui::Text("Game Information");
            if (InGame->AliveTeamNum == 1) ImGui::Text("WINNER WINNER CHICKEN DINNER");
            ImGui::Text("%d Players alive, %d Teams, %d Eliminated", (int)InGame->AlivePlayerNum, (int)InGame->AliveTeamNum, (int)(InGame->PlayerNum - InGame->AlivePlayerNum));
            const char* TEAMTYPE = (InGame->PlayerNumPerTeam == 1) ? "Solo" : (InGame->PlayerNumPerTeam == 2) ? "Duo" : (InGame->PlayerNumPerTeam == 4) ? "Squad" : "Detecting Mode";
            ImGui::Text("Team Type: %s", TEAMTYPE);
            ImGui::Text("Match ID: %d, Match Time: %ds | %dm", (int)InGame->GameID, (int)InGame->ElapsedTime, (int)InGame->ElapsedTime / 60);
            ImGui::Text("In Match (%ds)", (int)InGame->ElapsedTime);
        }
    }

    ImGui::End();
}

void DrawFOVCircle(float Cross)
{
    if (!Settings::Aimbot::SilentAimSettings::EnableFov)
        return;
    if (Cross <= 0.0f) return; //ЗАЩИТА

    ImDrawList* d = ImGui::GetBackgroundDrawList();
    ImVec2 displaySize = ImGui::GetIO().DisplaySize;
    ImVec2 center = ImVec2(displaySize.x / 2.0f, displaySize.y / 2.0f);

    float radius = Cross;

    d->AddCircle(
        center,
        radius,
        IM_COL32(255, 255, 255, 255),
        100,
        1.0f
    );
}

void DrawItemsESP()
{
    if (!g_LocalPlayer || !mainFont)
        return;

    auto localPlayer = g_LocalPlayer;
    ImDrawList* draw = ImGui::GetForegroundDrawList();
    float density = ImGui::GetIO().DisplaySize.x;

    ImU32 ColorsESPVehicle = IM_COL32(0, 255, 0, 255);

    std::vector<AActor*> allActors;
    GetAllActors(allActors);

    for (auto* i : allActors)
    {
        if (!i)
            continue;

        if (i->IsA(ASTExtraVehicleBase::StaticClass()))
        {
            auto Vehicle = (ASTExtraVehicleBase*)i;
            if (!Vehicle || !Vehicle->Mesh)
                continue;

            float Distance = Vehicle->GetDistanceTo(localPlayer) / 100.f;

            FVector loc = Vehicle->K2_GetActorLocation();
            FVector2D screenPos;
            if (!W2S(loc, &screenPos))
                continue;

            screenPos.X *= 0.5f;
            screenPos.Y *= 0.5f;

            std::string s = "[";
            s += GetVehicleName(Vehicle);
            s += "-";
            s += std::to_string((int)Distance);
            s += "M]";

            draw->AddText(mainFont, density / 20.0f, ImVec2(screenPos.X, screenPos.Y), ColorsESPVehicle, s.c_str());
        }
    }
}



void DrawRectangle(AHUD *HUD, FVector2D Pos, float Width, float Height, float Thickness, FLinearColor Color) {
    HUD->DrawLine(Pos.X, Pos.Y, Pos.X + Width, Pos.Y, Color, Thickness);
    HUD->DrawLine(Pos.X, Pos.Y, Pos.X, Pos.Y + Height, Color, Thickness);
    HUD->DrawLine(Pos.X + Width, Pos.Y, Pos.X + Width, Pos.Y + Height, Color, Thickness);
    HUD->DrawLine(Pos.X, Pos.Y + Height, Pos.X + Width, Pos.Y + Height, Color, Thickness);
}

bool WorldToScreenBone(const FVector& WorldLocation, FVector2D* Out)
{
    if (!g_PlayerController || !Out)
        return false;
    
    return UGameplayStatics::ProjectWorldToScreen(g_PlayerController, WorldLocation, false, Out);
}


bool WorldToScreenPlayer(const FVector& worldPos, FVector& outScreen, int* distanceX)
{
    if (!g_PlayerController) return false;

    FVector2D screen2D;
    bool success = g_PlayerController->ProjectWorldLocationToScreen(worldPos, false, &screen2D);
    if (success)
    {
        outScreen.X = screen2D.X;
        outScreen.Y = screen2D.Y;
        outScreen.Z = 0.f; // optional depth placeholder
        if (distanceX) *distanceX = (int)screen2D.X;
        return true;
    }
    return false;
}


void DrawRectangle1(AHUD * HUD, FVector2D Pos, float Width, float Height, float Thickness,
                   FLinearColor Color)
{
    HUD->DrawLine(Pos.X, Pos.Y, Pos.X + Width, Pos.Y, Color, Thickness);
    HUD->DrawLine(Pos.X, Pos.Y, Pos.X, Pos.Y + Height, Color, Thickness);
    HUD->DrawLine(Pos.X + Width, Pos.Y, Pos.X + Width, Pos.Y + Height, Color, Thickness);
    HUD->DrawLine(Pos.X, Pos.Y + Height, Pos.X + Width, Pos.Y + Height, Color, Thickness);
}
FVector2D WorldToRadar(float Yaw, FVector Origin, FVector LocalOrigin, float PosX, float PosY,
                       FVector Size, bool & outbuff)
{
    bool flag = false;
    double num = (double)Yaw;
    double num2 = num * 0.017453292519943295;
    float num3 = (float)std::cos(num2);
    float num4 = (float)std::sin(num2);
    float num5 = Origin.X - LocalOrigin.X;
    float num6 = Origin.Y - LocalOrigin.Y;
    FVector2D vector;
    vector.X = (num6 * num3 - num5 * num4) / 150.f;
    vector.Y = (num5 * num3 + num6 * num4) / 150.f;
    FVector2D vector2;
    vector2.X = vector.X + PosX + Size.X / 2.f;
    vector2.Y = -vector.Y + PosY + Size.Y / 2.f;
    bool flag2 = vector2.X > PosX + Size.X;
    if (flag2)
    {
        vector2.X = PosX + Size.X;
    }
    else
    {
        bool flag3 = vector2.X < PosX;
        if (flag3)
        {
            vector2.X = PosX;
        }
    }
    bool flag4 = vector2.Y > PosY + Size.Y;
    if (flag4)
    {
        vector2.Y = PosY + Size.Y;
    }
    else
    {
        bool flag5 = vector2.Y < PosY;
        if (flag5)
        {
            vector2.Y = PosY;
        }
    }
    bool flag6 = vector2.Y == PosY || vector2.X == PosX;
    if (flag6)
    {
        flag = true;
    }
    outbuff = flag;
    return vector2;
}

FVector2D rotateCoord(float angle, FVector2D coord) {
    float s = sin(angle * M_PI / 180);
    float c = cos(angle * M_PI / 180);
    
    return {coord.X * c + coord.Y * s, -coord.X * s + coord.Y * c};
}

float DegreeToRadian(float degree){

    return degree * (M_PI / 180);
}
FVector FRotatorToVector(FRotator Rotator)
{
    float radPitch = DegreeToRadian(Rotator.Pitch);
    float radYaw = DegreeToRadian(Rotator.Yaw);

    float X = cosf(radYaw) * cosf(radPitch);
    float Y = sinf(radYaw) * cosf(radPitch);
    float Z = sinf(radPitch);

    return FVector(X, Y, Z);
}
FRotator ToRotatorAIMBOT(FVector local, FVector &target) {
    FVector rotation;
    rotation.X = local.X - target.X;
    rotation.Y = local.Y - target.Y;
    rotation.Z = local.Z - target.Z;
    
    FRotator newViewAngle = {0};
    float hyp = sqrt(rotation.X * rotation.X + rotation.Y * rotation.Y);
    
    newViewAngle.Pitch = atan(rotation.Z / hyp) * (180.f / PI);
    newViewAngle.Yaw = atan2(rotation.Y, rotation.X) * (180.f / PI);
    newViewAngle.Roll = 0.f;
    
    return newViewAngle;
}

int GetDeviceMaxFPSByDeviceLevel(int a1, int a2, Byte *a3)
{
    int result;
    result = 240;
    *a3 = result;
    return result;
}




void VectorAnglesRadar(Vector3 & forward, FVector & angles) {
 if (forward.X == 0.f && forward.Y == 0.f) {
  angles.X = forward.Z > 0.f ? -90.f : 90.f;
  angles.Y = 0.f;
 } else {
  angles.X = RAD2DEG(atan2(-forward.Z, forward.Magnitude(forward)));
  angles.Y = RAD2DEG(atan2(forward.Y, forward.X));
 }
 angles.Z = 0.f;
}
FRotator ToRotator(FVector local, FVector target) {
    FVector rotation;
    rotation.X = local.X - target.X;
    rotation.Y = local.Y - target.Y;
    rotation.Z = local.Z - target.Z;

    FRotator newViewAngle = {0};

    float hyp = sqrt(rotation.X * rotation.X + rotation.Y * rotation.Y);

    newViewAngle.Pitch = -atan(rotation.Z / hyp) * (180.f / (float) 3.14159265358979323846);
    newViewAngle.Yaw = atan(rotation.Y / rotation.X) * (180.f / (float) 3.14159265358979323846);
    newViewAngle.Roll = (float) 0.f;

    if (rotation.X >= 0.f)
        newViewAngle.Yaw += 180.0f;

    return newViewAngle;
}

//预警箭头
void DrawArrows(AHUD * hud,std::array < FVector2D, 39 > Loc, float thickness, FLinearColor color) {

    DrawLine(hud,Loc.at(0), Loc.at(1), thickness * 1.f, color);
    DrawLine(hud,Loc.at(1), Loc.at(2), thickness * 1.f, color);
    DrawLine(hud,Loc.at(2), Loc.at(6), thickness * 1.f, color);
    DrawLine(hud,Loc.at(6), Loc.at(5), thickness * 1.f, color);
    DrawLine(hud,Loc.at(5), Loc.at(4), thickness * 1.f, color);
    DrawLine(hud,Loc.at(4), Loc.at(3), thickness * 1.f, color);
    DrawLine(hud,Loc.at(3), Loc.at(0), thickness * 1.f, color);
}
void DrawFilledRect1(AHUD *HUD, FVector2D initial_pos, float w, float h)
{
	int Count = 0;
	FVector2D V[128];
    static float cnt = 0.0f;
    const float rainbowSpeed = 1;
    FLinearColor rainbowColors[] = {
    FLinearColor(1.0f, 0.0f, 0.0f, 1.0f), // A: Red
    FLinearColor(1.0f, 0.5f, 0.0f, 1.0f), // B: Orange
    FLinearColor(1.0f, 1.0f, 0.0f, 1.0f), // C: Yellow
    FLinearColor(0.0f, 1.0f, 0.0f, 1.0f), // D: Green
    FLinearColor(0.0f, 0.0f, 1.0f, 1.0f), // E: Blue
    FLinearColor(0.5f, 0.0f, 1.0f, 1.0f), // F: Indigo
    FLinearColor(1.0f, 0.0f, 1.0f, 1.0f), // G: Violet
    FLinearColor(1.0f, 0.0f, 0.5f, 1.0f), // H: Purple
    FLinearColor(0.5f, 0.0f, 0.5f, 1.0f), // I: Mauve
    FLinearColor(0.0f, 0.5f, 0.5f, 1.0f), // J: Teal
    FLinearColor(0.5f, 0.5f, 0.5f, 1.0f), // K: Gray
    FLinearColor(0.5f, 0.0f, 0.0f, 1.0f), // L: Maroon
    FLinearColor(0.0f, 0.5f, 0.0f, 1.0f), // M: Lime
    FLinearColor(0.0f, 0.5f, 0.5f, 1.0f), // N: Aqua
    FLinearColor(0.5f, 0.5f, 0.0f, 1.0f), // O: Olive
    FLinearColor(0.0f, 0.0f, 0.5f, 1.0f), // P: Navy
    FLinearColor(0.5f, 0.0f, 0.5f, 1.0f), // Q: Fuchsia
    FLinearColor(0.5f, 1.0f, 0.0f, 1.0f), // R: Chartreuse
    FLinearColor(0.0f, 0.5f, 1.0f, 1.0f), // S: Sky Blue
    FLinearColor(1.0f, 0.5f, 0.5f, 1.0f), // T: Salmon
    FLinearColor(0.5f, 0.0f, 0.0f, 1.0f), // U: Burgundy
    FLinearColor(0.0f, 0.0f, 0.0f, 1.0f), // V: Black
    FLinearColor(1.0f, 1.0f, 1.0f, 1.0f), // W: White
    FLinearColor(0.0f, 1.0f, 1.0f, 1.0f), // X: Cyan
    FLinearColor(0.5f, 0.5f, 1.0f, 1.0f), // Y: Lavender
    FLinearColor(0.75f, 0.75f, 0.0f, 1.0f) // Z: Gold
    };
    int rainbowColorIndex = static_cast<int>(fmod(cnt * rainbowSpeed, 7.0f));

    FLinearColor color1 = rainbowColors[rainbowColorIndex];
    FLinearColor color2 = rainbowColors[(rainbowColorIndex + 1) % 7]; 
    float t = fmod(cnt * rainbowSpeed, 1.0f); 
    FLinearColor rainbowColor = FLinearColor(
            color1.R + (color2.R - color1.R) * t,
            color1.G + (color2.G - color1.G) * t,
            color1.B + (color2.B - color1.B) * t,
            1.0f
    );
    for (float i = 0.f; i < h; i += 1.f)
    DrawLine(HUD, FVector2D(initial_pos.X, initial_pos.Y - i), FVector2D(initial_pos.X + w, initial_pos.Y - i), 1.f, rainbowColor);
     if (cnt >= 360.0f) {
        cnt = 0.0f;
    }
    else {
        cnt += 0.02f;
    }        
}
//绘制填充矩形
void DrawFilledRectangle(AHUD *HUD, FVector2D Pos, float Width, float Height, FLinearColor Color) {
    HUD->DrawRect(Color, Pos.X, Pos.Y, Width, Height);
}

//绘制引擎射线
void DrawLine(AHUD *HUD, FVector2D posFrom, FVector2D posTo, float Thickness, FLinearColor Color) {
    HUD->DrawLine(posFrom.X, posFrom.Y, posTo.X, posTo.Y, Color, Thickness);
}
void drawVerticalHealthBar(AHUD *HUD, Vector2 screenPos, float height, float maxHealth, float currentHealth) {
    // Add the offset to screenPos by creating a new FVector2D
    screenPos += Vector2(8.0f, 0.0f);

    // Draw the background rectangle
    HUD->DrawRect(FLinearColor(0.08f, 0.08f, 0.08f, 0.78f), screenPos.X, screenPos.Y, 5.0f, height + 2);

    // Add the offset to screenPos by creating a new FVector2D
    screenPos += Vector2(1.0f, 1.0f);
    FLinearColor clr = FLinearColor(0.0f, 1.0f, 0.0f, 0.5f); // Green color

    float barHeight = (currentHealth / maxHealth) * height;

    // Change color based on health percentage
    if (currentHealth <= (maxHealth * 0.6)) {
        clr = FLinearColor(1.0f, 0.0f, 1.0f, 0.5f); // Magenta color
    }

    if (currentHealth < (maxHealth * 0.3)) {
        clr = FLinearColor(1.0f, 0.0f, 0.0f, 0.5f); // Red color
    }

    // Draw the health bar rectangle
    HUD->DrawRect(clr, screenPos.X, screenPos.Y, 3.0f, barHeight);
}
void Draw_Rect(AHUD *HUD, FVector2D Pos, float W, float H,FLinearColor RectColor){
    HUD->DrawRect(RectColor, Pos.X, Pos.Y, W, H);
}
void Box4Line(AHUD *HUD, float thicc, int x, int y, int w, int h, FLinearColor color) {
    int iw = w / 4;
    int ih = h / 4;

    // Convert color from int to FLinearColor if necessary
    // FLinearColor color = IntToColor(colorInt);

    // top
    HUD->DrawLine(x, y, x + iw, y, color, thicc);
    HUD->DrawLine(x + w - iw, y, x + w, y, color, thicc);
    HUD->DrawLine(x, y, x, y + ih, color, thicc);
    HUD->DrawLine(x + w - 1, y, x + w - 1, y + ih, color, thicc);

    // bottom
    HUD->DrawLine(x, y + h, x + iw, y + h, color, thicc);
    HUD->DrawLine(x + w - iw, y + h, x + w, y + h, color, thicc);
    HUD->DrawLine(x, y + h - ih, x, y + h, color, thicc);
    HUD->DrawLine(x + w - 1, y + h - ih, x + w - 1, y + h, color, thicc);
}
//字体定义
#define TSL_FONT_DEFAULT_SIZE 26
static UFont *robotoFont = 0, *robotoTinyFont = 0,*tslFont = 0;
//绘制引擎描边文字
void DrawOutlinedText(AHUD *HUD, FString Text, FVector2D Pos, FLinearColor Color, FLinearColor OutlineColor, bool isCenter = false) {
    UCanvas *Canvas = HUD->Canvas;
    Canvas->K2_DrawText(robotoFont, Text, Pos, Color, 1.f, {}, {}, isCenter, isCenter, true, OutlineColor);
}
//绘制引擎文字
void DrawText(AHUD *HUD, FString Text, FVector2D Pos, FLinearColor Color, bool isCenter = false) {
    UCanvas *Canvas = HUD->Canvas;
    Canvas->K2_DrawText(robotoFont, Text, Pos, Color, 1.f, {}, {}, isCenter, isCenter, false, {});
}
//绘制引擎物资描边文字
void DrawSmallOutlinedText(AHUD *HUD, FString Text, FVector2D Pos, FLinearColor Color, FLinearColor OutlineColor, bool isCenter = false) {
    UCanvas *Canvas = HUD->Canvas;
    Canvas->K2_DrawText(robotoTinyFont, Text, Pos, Color, 1.f, {}, {}, isCenter, isCenter, true,OutlineColor);
}

void DrawSmallOutlined(AHUD *HUD, FString Text, FVector2D Pos, FLinearColor Color, FLinearColor OutlineColor, bool isCenter = false) {
    UCanvas *Canvas = HUD->Canvas;
    Canvas->K2_DrawText(tslFont, Text, Pos, Color, 1.f, {}, {}, isCenter, isCenter, true, OutlineColor);
}
//绘制引擎物资文字
void DrawSmallText(AHUD *HUD, FString Text, FVector2D Pos, FLinearColor Color, bool isCenter = false) {
    UCanvas *Canvas = HUD->Canvas;
    Canvas->K2_DrawText(robotoTinyFont, Text, Pos, Color, 1.f, {}, {}, isCenter, isCenter, false, {});
}
void DrawTextcan(AHUD *HUD, FString Text, FVector2D Pos, FLinearColor Color, FLinearColor OutlineColor, bool isCenter = true) {
 UCanvas *Canvas = HUD->Canvas;
 Canvas->K2_DrawText(tslFont, Text, Pos, Color, 1.f, {}, {}, isCenter, isCenter, true, OutlineColor);
}
//引擎绘制圆圈
void DrawCircle(AHUD *HUD, int x, int y, int radius, int numsides, FLinearColor OutlineColor){
    float Step = M_PI * 2.0 / numsides;
    int Count = 0;
    FVector2D V[128];
    for (float a = 0; a < M_PI * 2.0; a += Step)
    {
        float X1 = radius * cos(a) + x;
        float Y1 = radius * sin(a) + y;
        float X2 = radius * cos(a + Step) + x;
        float Y2 = radius * sin(a + Step) + y;
        V[Count].X = X1;
        V[Count].Y = Y1;
        V[Count + 1].X = X2;
        V[Count + 1].Y = Y2;
        HUD->Canvas->K2_DrawLine(FVector2D({ V[Count].X, V[Count].Y }), FVector2D({ X2, Y2 }), 1.f, OutlineColor);
    }
}
void DrawCircle(UCanvas *Canvas, int x, int y, int radius, int numsides, FLinearColor OutlineColor){
    float Step = M_PI * 2.0 / numsides;
    int Count = 0;
    FVector2D V[128];
    for (float a = 0; a < M_PI * 2.0; a += Step)
    {
        float X1 = radius * cos(a) + x;
        float Y1 = radius * sin(a) + y;
        float X2 = radius * cos(a + Step) + x;
        float Y2 = radius * sin(a + Step) + y;
        V[Count].X = X1;
        V[Count].Y = Y1;
        V[Count + 1].X = X2;
        V[Count + 1].Y = Y2;
        Canvas->K2_DrawLine(FVector2D({ V[Count].X, V[Count].Y }), FVector2D({ X2, Y2 }), 1.f, OutlineColor);
    }
}
void DrawFilledCircle(AHUD *HUD, int x, int y, int radius, int numsides, FLinearColor OutlineColor, FLinearColor FillColor){
    float Step = M_PI * 2.0 / numsides;
    FVector2D Center(x, y);
    FVector2D V[128];
    for (int i = 0; i < numsides; ++i)
    {
        // Calculate vertices for the i-th triangle
        float Angle = Step * i;
        V[i].X = Center.X + radius * cos(Angle);
        V[i].Y = Center.Y + radius * sin(Angle);

        // Draw lines from the center to the vertices
        HUD->Canvas->K2_DrawLine(Center, V[i], 1.f, FillColor);
    }

    // Optionally, draw the outline by connecting the vertices
    for (int i = 0; i < numsides; ++i)
    {
        HUD->Canvas->K2_DrawLine(V[i], V[(i+1) % numsides], 1.f, OutlineColor);
    }
}

void RotateTriangle(std::array < FVector2D, 39 > &points, float rotation)
{
    const auto points_center = (points.at(0) + points.at(1) + points.at(2) + points.at(3) + points.at(4) + points.at(5) + points.at(6)
                                + points.at(7) + points.at(8) + points.at(9) + points.at(10) + points.at(11) + points.at(12) + points.at(13)
                                + points.at(14) + points.at(15) + points.at(16) + points.at(17) + points.at(18) + points.at(19) + points.at(20)
                                + points.at(21) + points.at(22) + points.at(23) + points.at(24) + points.at(25) + points.at(26) + points.at(27)
                                + points.at(28) + points.at(29) + points.at(30) + points.at(31) + points.at(32) + points.at(33) + points.at(34)
                                + points.at(35) + points.at(36) + points.at(37) + points.at(38)) / 39;
    for (auto & point:points) {
        point = point - points_center;
        const auto temp_x = point.X;
        const auto temp_y = point.Y;
        const auto theta = DEG2RAD(rotation);
        const auto c = cosf(theta);
        const auto s = sinf(theta);
        point.X = temp_x * c - temp_y * s;
        point.Y = temp_x * s + temp_y * c;
        point = point + points_center;
    }
}
//字体加载---------
void *LoadFont() {
    while (!robotoFont || !robotoTinyFont || !tslFont) {
        tslFont = UObject::FindObject<UFont>("Font TSLFont.TSLFont");
        robotoFont = UObject::FindObject<UFont>("Font Roboto.Roboto");
        robotoTinyFont = UObject::FindObject<UFont>("Font RobotoTiny.RobotoTiny");
        sleep(1);
    }
    return 0;
}


bool _read(kaddr addr, void *buffer, int len)
{
    if (!IsValidAddress(addr)) return false;
    vm_size_t size = 0;
    kern_return_t error = vm_read_overwrite(mach_task_self(), (vm_address_t)addr, len, (vm_address_t)buffer, &size);
    if(error != KERN_SUCCESS || size != len)
    {
        return false;
    }
    return true;
}

bool _write(kaddr addr, void *buffer, int len)
{
    if (!IsValidAddress(addr)) return false;
    kern_return_t error = vm_write(mach_task_self(), (vm_address_t)addr, (vm_offset_t)buffer, (mach_msg_type_number_t)len);
    if(error != KERN_SUCCESS)
    {
        return false;
    }
    return true;
}
kaddr GetRealOffset(kaddr offset) {
    if (module == 0) {
        return 0;
    }
    return (module + offset);
}
template<typename T> T Read(kaddr addr) {
    T data;
    _read(addr, reinterpret_cast<void *>(&data), sizeof(T));
    return data;
}
//对局信息



#define W2S(w, s) UGameplayStatics::ProjectWorldToScreen(g_PlayerController, w, false, s)
 
FVector WorldToRadar(float Yaw, FVector Origin, FVector LocalOrigin, float PosX, float PosY, Vector3 Size, bool &outbuff) {
 bool flag = false;
 double num = (double)Yaw;
 double num2 = num * 0.017453292519943295;
 float num3 = (float)std::cos(num2);
 float num4 = (float)std::sin(num2);
 float num5 = Origin.X - LocalOrigin.X;
 float num6 = Origin.Y - LocalOrigin.Y;
 struct FVector Xector;
 Xector.X = (num6 * num3 - num5 * num4) / 150.f;
 Xector.Y = (num5 * num3 + num6 * num4) / 150.f;
 struct FVector Xector2;
 Xector2.X = Xector.X + PosX + Size.X / 2.f;
 Xector2.Y = -Xector.Y + PosY + Size.Y / 2.f;
 bool flag2 = Xector2.X > PosX + Size.X;
 if (flag2) {
  Xector2.X = PosX + Size.X;
 }else{
  bool flag3 = Xector2.X < PosX;
  if (flag3) {
   Xector2.X = PosX;
  }
 }
 bool flag4 = Xector2.Y > PosY + Size.Y;
 if (flag4) {
  Xector2.Y = PosY + Size.Y;
 }else{
  bool flag5 = Xector2.Y < PosY;
  if (flag5){
   Xector2.Y = PosY;
  }
 }
 bool flag6 = Xector2.Y == PosY || Xector2.X == PosX;
 if (flag6){
  flag = true;
 }
 outbuff = flag;
 return Xector2;
}
void FixTriangle(float& XPos, float& YPos, int screenDist){
    //
    // —————————Triangle X Pos—————————————
    if(XPos > (screenWidth - 16)) {
        XPos = screenWidth;
        XPos -= screenDist;
    }
    // ——————————————————————
    if(XPos < 16) {
        XPos = 16;
        XPos += screenDist;
    }
    // ————————— Triangle Y Pos —————————————
    if(YPos > (screenHeight - 16)) {
        YPos = screenHeight;
        YPos -= screenDist;
    }
    if(YPos < 16) {
        YPos = 16;
        YPos += screenDist;
    }
}
void VectorAnglesRadar(FVector& forward, FVector& angles)
{
    if (forward.X == 0.f && forward.Y == 0.f)
    {
        angles.X = forward.Z > 0.f ? -90.f : 90.f;
        angles.Y = 0.f;
    }
    else
    {
        angles.X = RAD2DEG(atan2(-forward.Z, forward.Size()));
        angles.Y = RAD2DEG(atan2(forward.Y, forward.X));
    }
    angles.Z = 0.f;
}
void RotateTriangle(std::array<Vector3, 3> & points, float rotation) {
 const auto points_center = (points.at(0) + points.at(1) + points.at(2)) / 3;
 for (auto & point : points) {
  point = point - points_center;
  const auto temp_x = point.X;
  const auto temp_y = point.Y;
  const auto theta = DEG2RAD(rotation);
  const auto c = cosf(theta);
  const auto s = sinf(theta);
  point.X = temp_x * c - temp_y * s;
  point.Y = temp_x * s + temp_y * c;
  point = point + points_center;
 }
 }


static std::unordered_set<uint32_t> AlreadyChangedSet;
static std::mutex AlreadyChangedSetMutex;

uintptr_t GetVirtualFunctionAddress(uintptr_t clazz, uintptr_t index) {
    if (!clazz) {
        return 0;
    }
    uintptr_t vtablePtr = *reinterpret_cast<uintptr_t*>(clazz);
    if (!vtablePtr) {
        return 0;
    }

    return *(reinterpret_cast<uintptr_t*>(vtablePtr) + index);
}


using PrechangeItemAvatarFunc = void(*)(uintptr_t, int, bool);
void ChangeItemAVc(uintptr_t thiz, int InItemID) {
    if (!thiz) {
        return;
    }

    constexpr uintptr_t VIRTUAL_FUNCTION_INDEX = 185;
    uintptr_t funcAddr = GetVirtualFunctionAddress(thiz, VIRTUAL_FUNCTION_INDEX);

    if (!funcAddr) {
        return;
    }

    auto pFunc = reinterpret_cast<PrechangeItemAvatarFunc>(funcAddr);
    pFunc(thiz, InItemID, true);
}
void (*orig_Broadcast)(ASTExtraPlayerController* thiz, FFatalDamageParameter* FatalDamageParameter);

void hk_Broadcast(ASTExtraPlayerController* thiz, FFatalDamageParameter* FatalDamageParameter)
{
    if (!thiz || !FatalDamageParameter)
        return orig_Broadcast(thiz, FatalDamageParameter);

    if (!g_PlayerController)
        return orig_Broadcast(thiz, FatalDamageParameter);

    if (!g_LocalPlayer)
        return orig_Broadcast(thiz, FatalDamageParameter);

    if (g_PlayerController->PlayerKey == 0)
        return orig_Broadcast(thiz, FatalDamageParameter);


    if (ModSkinn && KillMessage)
    {
        if (g_PlayerController->PlayerKey == FatalDamageParameter->CauserKey)
        {
            FatalDamageParameter->CauserClothAvatarID = new_Skin.XSuits;

            if (!g_LocalPlayer->CurrentVehicle)
            {
                auto WeaponManagerComponent = g_LocalPlayer->WeaponManagerComponent;
                if (WeaponManagerComponent)
                {
                    auto CurrentWeaponReplicated =
                        (ASTExtraShootWeapon*)WeaponManagerComponent->CurrentWeaponReplicated;

                    if (CurrentWeaponReplicated)
                    {
                        auto ShootWeaponComponent =
                            CurrentWeaponReplicated->ShootWeaponComponent;

                        if (ShootWeaponComponent)
                        {
                            int weaponID =
                                WeaponManagerComponent->CurrentWeaponReplicated->GetWeaponID();

                            switch (weaponID) {
                                case 101001: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.AKM; break;
                                case 101002: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.M16A4; break;
                                case 101003: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.Scar; break;
                                case 101004: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.M416_1; break;
                                case 101005: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.Groza; break;
                                case 101006: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.AUG; break;
                                case 101007: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.QBZ; break;
                                case 101008: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.M762; break;

                                case 105001: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.M249; break;
                                case 105002: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.DP28; break;
                                case 105010: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.MG3; break;

                                case 102001: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.UZI; break;
                                case 102002: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.UMP; break;
                                case 102003: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.Vector; break;
                                case 102004: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.Thompson; break;
                                case 102005: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.Bizon; break;
                                case 102105: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.P90; break;

                                case 103001: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.K98; break;
                                case 103002: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.M24; break;
                                case 103003: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.AWM; break;
                                case 103012: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.AMR; break;
                                case 103004: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.SKS; break;
                                case 103006: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.Mini14; break;
                                case 103009: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.SLR; break;
                                case 1030075: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.MK14; break;

                                case 104001: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.S686; break;
                                case 104002: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.S1897; break;
                                case 104003: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.S12K; break;
                                case 104004: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.DBS; break;
                                case 104102: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.NS2000; break;

                                case 108001: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.Machete; break;

                                case 1914001: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.Mirado; break;
                                case 1907001: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.Buggy; break;
                                case 1903001: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.Dacia; break;
                                case 1961001: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.CoupeRP; break;
                                case 1908001: FatalDamageParameter->CauserWeaponAvatarID = new_Skin.UAZ; break;
                            }
                        }
                    }
                }
            }
        }
    }

    return orig_Broadcast(thiz, FatalDamageParameter);
}



int glWidth, glHeight;
bool isInsideFOV(int x, int y) {
    if (!Cross && IsLogin)
        return true;
    int circle_x = screenWidth / 2;
    int circle_y = screenHeight / 2;
    int rad = (int) Cross;
    return (x - circle_x) * (x - circle_x) + (y - circle_y) * (y - circle_y) <= rad * rad;
}




auto GetTargetForAimBotByDistance() {
    ASTExtraPlayerCharacter *result = 0;
    float max = std::numeric_limits<float>::infinity();
    
    ASTExtraPlayerController *localPlayerController = 0;
    auto GWorld = GetFullWorld();
    if (GWorld) {
        UNetDriver *NetDriver = GWorld->NetDriver;
        if (NetDriver) {
            UNetConnection *ServerConnection = NetDriver->ServerConnection;
            if (ServerConnection) {
                localPlayerController = (ASTExtraPlayerController *) ServerConnection->PlayerController;

            }
        }
        if (localPlayerController) {
            std::vector<ASTExtraPlayerCharacter*> PlayerCharacter;
            GetAllActors(PlayerCharacter);
            for (auto actor = PlayerCharacter.begin(); actor != PlayerCharacter.end(); actor++) {
                auto Actor = *actor;
                if (Actor->PlayerKey == ((ASTExtraPlayerController *) localPlayerController)->PlayerKey) {
                    localPlayer = Actor;
                    break;
                }
            }
            std::vector<ASTExtraPlayerCharacter*> PlayerCharacter2;
            GetAllActors(PlayerCharacter2);
            for (auto actor = PlayerCharacter2.begin(); actor != PlayerCharacter2.end();
                 actor++)
            {
                auto Player = *actor;



                if (Player->PlayerKey == localPlayer->PlayerKey)
                    continue;
                if (Player->TeamID == localPlayer->TeamID)
                    continue;
                if (Player->bDead)
                    continue;
                if (Player->bHidden )
                    continue;
                if (!Player->Mesh)
                    continue;
                if (!Player->RootComponent)
                    continue;
                if (preferences.Config.SilentAim.IgnoreKnocked) {
                    if (Player->Health == 0.0f)
                        continue;
                }
                if(!preferences.Config.SilentAim.VisCheck){
                    if (!localPlayerController->LineOfSightTo(Player, {0, 0, 0}, true))
                        continue;
                }
                if (preferences.Config.SilentAim.IgnoreBot) {
                    if (Player->bEnsure)
                        continue;
                }
                float dist = Player->GetDistanceTo(localPlayer);
                if (dist < max) {
                    max = dist;
                    result = Player;
                }
            } PlayerCharacter2.clear();
        }
    }
    return result;
}

auto GetTargetForAimbot() {
    ASTExtraPlayerCharacter *result = 0;
    float max = std::numeric_limits<float>::infinity();

    auto Actors = getActors();

    auto localPlayer = g_LocalPlayer;
    auto localController = g_LocalController;
                        FVector ViewPosY{0, 0, 0};
                        if (localPlayer) {                   
                        ViewPosY = localPlayer->GetBonePos("Head", {});
                        ViewPosY.Z += 10.f;
                         }  
    if (localPlayer) {
        for (int i = 0; i < Actors.size(); i++) {
            auto Actor = Actors[i];
            

            if (Actor->IsA(ASTExtraPlayerCharacter::StaticClass())) {
                auto Player = (ASTExtraPlayerCharacter *) Actor;
				
                if (Player->PlayerKey == localPlayer->PlayerKey)
                    continue;

                if (Player->TeamID == localPlayer->TeamID)
                    continue;

                if (Player->bDead)
                    continue;

                if (Settings::Aimbot::SilentAimSettings::AimKnocked) {
                    if (Player->Health == 0.0f)
                        continue;
                }
					
                if (Settings::isVisibilityCheck) {
                    if (!localController->LineOfSightTo(Player, ViewPosY, true))
                        continue;
                }
                if (Settings::Aimbot::SilentAimSettings::Highprecisiontracking) {
                    if (Player->bEnsure)
                        continue;
                }

                auto Root = Player->GetBonePos("Root", {});
                auto Head = Player->GetBonePos("Head", {});

                FVector2D RootSc, HeadSc;
                if (W2S(Root, &RootSc) && W2S(Head, &HeadSc)) {
                    float height = abs(HeadSc.Y - RootSc.Y);
                    float width = height * 0.65f;

                    FVector middlePoint = {HeadSc.X + (width / 2), HeadSc.Y + (height / 2), 0};
                    if ((middlePoint.X >= 0 && middlePoint.X <= glWidth) && (middlePoint.Y >= 0 && middlePoint.Y <= glHeight)) {
                        FVector2D v2Middle = FVector2D((float) (glWidth / 2), (float) (glHeight / 2));
                        FVector2D v2Loc = FVector2D(middlePoint.X, middlePoint.Y);
if(isInsideFOV((int)middlePoint.X, (int)middlePoint.Y)) {
                        float dist = FVector2D::Distance(v2Middle, v2Loc);

                        if (dist < max) {
                            max = dist;
                            result = Player;
                        }
                    }
                   }
                }
            }
        }
    }

    return result;
}

auto VIP_Fov_Based() -> ASTExtraPlayerCharacter* {
    ASTExtraPlayerController* PC = nullptr;
    ASTExtraPlayerCharacter*  me = nullptr;
    ASTExtraPlayerCharacter*  best = nullptr;
    float bestDist = Cross;

    if (auto* GWorld = GetFullWorld()) {
        if (GWorld->NetDriver && GWorld->NetDriver->ServerConnection)
            PC = (ASTExtraPlayerController*)GWorld->NetDriver->ServerConnection->PlayerController;
    }
    if (!PC) return nullptr;

    std::vector<ASTExtraPlayerCharacter*> players;
    GetAllActors(players);

    for (auto* A : players) { if (A && A->PlayerKey == PC->PlayerKey) { me = A; break; } }
    if (!me) return nullptr;

    const float cx = screenWidth * 0.5f, cy = screenHeight * 0.5f;

    for (auto* P : players) {
        if (!P || P == me)                        continue;
        if (P->TeamID == me->TeamID)              continue;
        if (P->bDead || P->bHidden)               continue;
        if (!P->Mesh || !P->RootComponent)        continue;
        if (Settings::Aimbot::SilentAimSettings::AimKnocked && P->Health == 0.0f) continue;
        if (Settings::Aimbot::SilentAimSettings::Highprecisiontracking && P->bEnsure)            continue;

        const FVector HeadPos    = P->GetBonePos("Head", {});
        const FVector neck_01    = P->GetBonePos("neck_01", {});
        const FVector spine_03   = P->GetBonePos("spine_03", {});
        const FVector spine_02   = P->GetBonePos("spine_02", {});
        const FVector hand_r     = P->GetBonePos("hand_r", {});
        const FVector hand_l     = P->GetBonePos("hand_l", {});
        const FVector lowerarm_r = P->GetBonePos("lowerarm_r", {});
        const FVector lowerarm_l = P->GetBonePos("lowerarm_l", {});
        const FVector upperarm_r = P->GetBonePos("upperarm_r", {});
        const FVector upperarm_l = P->GetBonePos("upperarm_l", {});
        const FVector foot_r     = P->GetBonePos("foot_r", {});
        const FVector foot_l     = P->GetBonePos("foot_l", {});
        const FVector calf_r     = P->GetBonePos("calf_r", {});
        const FVector calf_l     = P->GetBonePos("calf_l", {});
        const FVector thigh_r    = P->GetBonePos("thigh_r", {});
        const FVector thigh_l    = P->GetBonePos("thigh_l", {});
        const FVector spine_01   = P->GetBonePos("spine_01", {});
        const FVector pelvis     = P->GetBonePos("pelvis", {});

        const FVector bones[] = {
            HeadPos, neck_01, spine_03, spine_02,
            hand_r, hand_l, lowerarm_r, lowerarm_l, upperarm_r, upperarm_l,
            foot_r, foot_l, calf_r, calf_l, thigh_r, thigh_l,
            spine_01, pelvis
        };

        float bestBoneDist = 1e9f;
        bool  anyBoneOk = false;

        for (const FVector& w : bones) {
            if (!(w.X || w.Y || w.Z)) continue;
            if (Settings::isVisibilityCheck && !PC->LineOfSightTo(P, w, true)) continue;

            FVector2D s;
            if (!UGameplayStatics::ProjectWorldToScreen(PC, w, true, &s)) continue;

            const float dx = s.X - cx, dy = s.Y - cy;
            const float pd = sqrtf(dx * dx + dy * dy);

            if (pd < bestBoneDist) { bestBoneDist = pd; anyBoneOk = true; }
        }

        if (anyBoneOk && bestBoneDist <= bestDist) {
            bestDist = bestBoneDist;
            best = P;
        }
    }

        
    /*if (best && PC->PlayerCameraManager) {
        auto CameraCache = PC->PlayerCameraManager->CameraCache;
        FVector camLoc = CameraCache.POV.Location;
        FRotator camRot = CameraCache.POV.Rotation;

        
        if (camLoc.X == 0 && camLoc.Y == 0 && camLoc.Z == 0) {
            
            camLoc = PC->PlayerCameraManager->K2_GetActorLocation();
            camRot = PC->PlayerCameraManager->K2_GetActorRotation();
        }

        FVector target = best->GetBonePos("Head", {});

        FVector dir;
        dir.X = target.X - camLoc.X;
        dir.Y = target.Y - camLoc.Y;
        dir.Z = target.Z - camLoc.Z;

        float mag = sqrtf(dir.X * dir.X + dir.Y * dir.Y + dir.Z * dir.Z);
        if (mag > 0.0001f) {
            dir.X /= mag;
            dir.Y /= mag;
            dir.Z /= mag;
        }

        PC->ControlRotation = UKismetMathLibrary::MakeRotFromX(dir);
    }*/

    return best;
}

auto GetTargetByCrossDist() {
    ASTExtraPlayerCharacter *result = 0;
    float max = std::numeric_limits<float>::infinity();

auto localPlayer = g_LocalPlayer;
    auto localController = g_PlayerController;

    if (localPlayer && localController) {
        std::vector<ASTExtraPlayerCharacter *> PlayerCharacter;
        GetAllActors(PlayerCharacter);
        for (auto actor = PlayerCharacter.begin(); actor != PlayerCharacter.end(); actor++) {
            auto Player = *actor;

            if (Player->PlayerKey == localPlayer->PlayerKey)
                continue;

            if (Player->TeamID == localPlayer->TeamID)
                continue;

            if (Player->bDead)
                continue;

            if (Player->bHidden) //
                continue;

            if (!Player->Mesh) //
                continue;

            if (!Player->RootComponent) //
                continue;

            if (Settings::Aimbot::SilentAimSettings::AimKnocked  && IsLogin) {
                if (Player->Health == 0.0f)
                    continue;
            }

            if (Settings::Aimbot::SilentAimSettings::Highprecisiontracking  && IsLogin) {
                if (Player->bEnsure)
                    continue;
            }
            
            float dist = localPlayer->GetDistanceTo(Player) / 100.0f;
                if (dist > SilentAimMaxDistance) // тут было g_disstance
                continue;
            
            if (Settings::isVisibilityCheck  && IsLogin) {
                if (!localController->LineOfSightTo(Player, {0, 0, 0}, true))
                    continue;
            }


            auto Root = Player->GetBonePos("Root", {});
            auto Head = Player->GetBonePos("Head", {});

            FVector2D RootSc, HeadSc;
            if (W2S(Root, &RootSc) && W2S(Head, &HeadSc)) {
                float height = abs(HeadSc.Y - RootSc.Y);
                float width = height * 0.65f;

                FVector middlePoint = {HeadSc.X + (width / 2), HeadSc.Y + (height / 2), 0};
                if ((middlePoint.X >= 0 && middlePoint.X <= (float) glWidth) &&
                    (middlePoint.Y >= 0 && middlePoint.Y <= (float) glHeight)) {
                    FVector2D v2Middle = FVector2D((float) (glWidth / 2), (float) (glHeight / 2));
                    FVector2D v2Loc = FVector2D(middlePoint.X, middlePoint.Y);
                    if(isInsideFOV((int)middlePoint.X, (int)middlePoint.Y )) {
                    float distance = FVector2D::Distance(v2Middle, v2Loc);
float radius = Cross;


                                                               if (distance < radius) {
                                if (distance < max) {
                                    max = dist;
                                    result = Player;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            return result;
        }





auto GetCurrentWeaponReplicated(ASTExtraPlayerCharacter * mode) {
    auto WeaponManagerComponent = mode->WeaponManagerComponent;
    if (WeaponManagerComponent) {
        auto propSlot = WeaponManagerComponent->GetCurrentUsingPropSlot();
        if ((int)propSlot.GetValue() >= 1 && (int)propSlot.GetValue() <= 3) {
            return (ASTExtraShootWeapon *)WeaponManagerComponent->CurrentWeaponReplicated;
        }
    }
} 

void DrawAimingLine()
{
    if (!Settings::Aimbot::SilentAimSettings::AimingLine || Enable || !g_PlayerController)
        return;

    ImDrawList* d = ImGui::GetBackgroundDrawList();

    ASTExtraPlayerCharacter* Target = GetTargetByCrossDist();
    if (!Target) return;

    FVector headPos = Target->GetBonePos("Head", {});
    FVector2D hs;

    if (!g_PlayerController->ProjectWorldLocationToScreen(headPos, false, &hs))
        return;

    ImVec2 screenCenter = ImVec2(ImGui::GetIO().DisplaySize.x * 0.5f,
                                 ImGui::GetIO().DisplaySize.y * 0.5f);

    ImColor lineColor = g_PlayerController->LineOfSightTo(
        g_PlayerController->PlayerCameraManager,
        Target->GetBonePos("Head", {}),
        true
    ) ? ImColor(255, 255, 255, 255)
      : ImColor(255, 255, 255, 255);

    hs.X *= 0.5f;
    hs.Y *= 0.5f;

    if (hs.X > 0.f && hs.Y > 0.f && hs.Y < ImGui::GetIO().DisplaySize.y)
        d->AddLine(screenCenter, ImVec2(hs.X, hs.Y), lineColor, 1.0f);
}

bool  VehicleAimNearCrosshair = false;
bool  VehicleVisCheck         = false;

float VehicleAimConeDeg   = 8.0f;
float VehicleAimHeightZ   = 50.0f;
float SilentAimPingMs     = 0.0f;

static inline float Dot3(const FVector& a, const FVector& b){ return a.X*b.X + a.Y*b.Y + a.Z*b.Z; }
static inline float Len (const FVector& v){ return sqrtf(v.X*v.X + v.Y*v.Y + v.Z*v.Z); }
static inline float DegToRad(float d){ return d * 0.017453292519943295f; } // PI/180

static float GetPingSeconds(APlayerController* /*PC*/) {
    float ms = SilentAimPingMs;
    if (ms < 0.f)   ms = 0.f;
    if (ms > 400.f) ms = 400.f;
    return ms * 0.001f;
}


static bool IsPartiallyVisible(APlayerController* PC, AActor* Other, const FVector& viewLoc){
    if (!PC || !Other) return false;
    if (PC->LineOfSightTo(Other, viewLoc, true)) return true;

    FVector to = UKismetMathLibrary::Subtract_VectorVector(Other->K2_GetActorLocation(), viewLoc);
    float   d  = Len(to);
    if (d <= 12000.f) {
        FRotator rot = PC->GetControlRotation();
        FVector fwd  = UKismetMathLibrary::GetForwardVector(rot);
        FVector dir  = { to.X/d, to.Y/d, to.Z/d };
        float   cosT = Dot3(fwd, dir);
        if (cosT > cosf(DegToRad(6.0f))) return true;
    }
    return false;
}


static bool IsVisiblePoint(APlayerController* PC, AActor* Target, const FVector& from, const FVector& to) {
    if (!PC || !Target) return false;
    // PUBG SDK me 'LineOfSightTo' ek location leta hai — hum 'to' pass karenge.
    return PC->LineOfSightTo(Target, to, true);
}

static FVector GetBestBonePosVisible(ASTExtraPlayerCharacter* P, APlayerController* PC, const FVector& viewLoc){
    if (!P) return FVector{0,0,0};

    // order tuned for peek/cover cases
    static const char* bones[] = {
        "Head","neck_01","spine_03","spine_02",
        "hand_r","hand_l","lowerarm_r","lowerarm_l","upperarm_r","upperarm_l",
        "foot_r","foot_l","calf_r","calf_l","thigh_r","thigh_l",
        "spine_01","pelvis"
    };

    FVector fallback{0,0,0};
    for (int i=0;i<(int)(sizeof(bones)/sizeof(bones[0])); ++i) {
        FVector p = P->GetBonePos(bones[i], {});
        if (!(p.X||p.Y||p.Z)) continue;
        if (IsVisiblePoint(PC, (AActor*)P, viewLoc, p)) {
            return p; // first visible bone wins
        }
        if (!(fallback.X||fallback.Y||fallback.Z)) fallback = p;
    }
    if (fallback.X||fallback.Y||fallback.Z) return fallback;
    FVector h = P->GetBonePos("Head", {}); if (h.X||h.Y||h.Z) return h;
    return P->GetBonePos("pelvis", {});
}

// ====== vehicle helpers (unchanged except visibility call) ======
static ASTExtraVehicleBase* PickVehicleNearCrosshair(
    APlayerController* PC, const FVector& start, const FRotator& shotRot, float coneDeg, bool doVis)
{
    if (!PC || !g_LocalPlayer) return nullptr;

    TArray<AActor*> all;
    UGameplayStatics::GetAllActorsOfClass((UObject*)PC, AActor::StaticClass(), &all);

    FVector aimDir = UKismetMathLibrary::GetForwardVector(shotRot);
    float l2 = aimDir.X*aimDir.X + aimDir.Y*aimDir.Y + aimDir.Z*aimDir.Z;
    if (l2 < 0.5f && PC->PlayerCameraManager)
        aimDir = UKismetMathLibrary::GetForwardVector(PC->PlayerCameraManager->GetCameraRotation());

    const float coneCos = cosf(DegToRad(coneDeg>0.f?coneDeg:10.f));
    FVector viewLoc = g_LocalPlayer->GetBonePos("Head", {}); viewLoc.Z += 10.f;

    float best = 1e9f;
    ASTExtraVehicleBase* bestVeh = nullptr;

    for (int i=0;i<all.Num();++i){
        AActor* a = all[i];
        if (!a || !a->IsA(ASTExtraVehicleBase::StaticClass())) continue;

        auto* V = (ASTExtraVehicleBase*)a;
        if (!V->RootComponent) continue;
        if (doVis && !IsPartiallyVisible(PC, V, viewLoc)) continue;

        FVector to = UKismetMathLibrary::Subtract_VectorVector(V->K2_GetActorLocation(), start);
        float d = Len(to); if (d < 1.f) continue;

        FVector dir = { to.X/d, to.Y/d, to.Z/d };
        float dot = Dot3(aimDir, dir);
        if (dot < coneCos) continue;

        float score = (1.f - dot)*1000.f + (d * 0.001f);
        if (score < best){ best = score; bestVeh = V; }
    }
    return bestVeh;
}

static ASTExtraPlayerCharacter* FindVehicleOccupant(ASTExtraVehicleBase* Veh){
    if (!Veh) return nullptr;

    TArray<AActor*> allP;
    UGameplayStatics::GetAllActorsOfClass((UObject*)Veh, ASTExtraPlayerCharacter::StaticClass(), &allP);

    ASTExtraPlayerCharacter* best = nullptr;
    float bestD = 1e9f;

    FVector cam = g_LocalPlayer ? g_LocalPlayer->GetBonePos("Head", {}) : FVector();
    cam.Z += 10.f;

    for (int i=0;i<allP.Num();++i){
        auto* P = (ASTExtraPlayerCharacter*)allP[i];
        if (!P || P==g_LocalPlayer) continue;
        if (P->bDead) continue;
        if (P->CurrentVehicle != Veh) continue;

        float d = Len(UKismetMathLibrary::Subtract_VectorVector(P->K2_GetActorLocation(), cam));
        if (d < bestD){ bestD = d; best = P; }
    }
    return best;
}

static ASTExtraPlayerCharacter* PickAirborneOrPeekNearCrosshair(
    APlayerController* PC, const FVector& start, const FRotator& shotRot, float coneDeg)
{
    if (!PC || !g_LocalPlayer) return nullptr;

    TArray<AActor*> allP;
    UGameplayStatics::GetAllActorsOfClass((UObject*)PC, ASTExtraPlayerCharacter::StaticClass(), &allP);

    FVector aimDir = UKismetMathLibrary::GetForwardVector(shotRot);
    float l2 = aimDir.X*aimDir.X + aimDir.Y*aimDir.Y + aimDir.Z*aimDir.Z;
    if (l2 < 0.5f && PC->PlayerCameraManager)
        aimDir = UKismetMathLibrary::GetForwardVector(PC->PlayerCameraManager->GetCameraRotation());

    const float coneCos = cosf(DegToRad(coneDeg>0.f?coneDeg:8.f));
    FVector viewLoc = g_LocalPlayer->GetBonePos("Head", {}); viewLoc.Z += 10.f;

    ASTExtraPlayerCharacter* best = nullptr;
    float bestScore = 1e9f;

    for (int i=0;i<allP.Num();++i){
        auto* P = (ASTExtraPlayerCharacter*)allP[i];
        if (!P || P==g_LocalPlayer) continue;
        if (P->bDead) continue;

        FVector v = P->GetVelocity();
        bool airborneish = (fabsf(v.Z) > 120.f);

        if (!airborneish && !IsPartiallyVisible(PC, (AActor*)P, viewLoc)) continue;

        FVector to = UKismetMathLibrary::Subtract_VectorVector(P->K2_GetActorLocation(), start);
        float d = Len(to); if (d < 1.f) continue;

        FVector dir = { to.X/d, to.Y/d, to.Z/d };
        float dot = Dot3(aimDir, dir);
        if (dot < coneCos) continue;

        float score = (1.f - dot)*1000.f + (d * 0.001f);
        if (score < bestScore){ bestScore = score; best = P; }
    }
    return best;
}

// ====== hook ======
void (*orig_shoot_event)(USTExtraShootWeaponComponent *thiz, FVector start, FRotator rot, void *unk1, int unk2) = 0;
void shoot_event(USTExtraShootWeaponComponent *thiz, FVector start, FRotator rot, ASTExtraShootWeapon *weapon, int unk1) {
    UKismetMathLibrary* UMC = (UKismetMathLibrary*)UKismetMathLibrary::StaticClass();

    ASTExtraPlayerCharacter* Target = nullptr;

// ===== ПОЛУЧАЕМ ЦЕЛЬ =====
    if (Enable) { if (auto v2 = VIP_Fov_Based()) Target = v2; }
    if (!Target && Enable) { if (auto v1 = VIP_Fov_Based()) Target = v1; }
    
    // ===== ПРОВЕРКА ДИСТАНЦИИ =====
    if (Target && g_LocalPlayer) {
        float dist = g_LocalPlayer->GetDistanceTo(Target) / 100.0f;
        if (dist > SilentAimMaxDistance) {
            Target = nullptr;  // сбрасываем, если далеко
        }
    }
    
    ASTExtraVehicleBase* VehicleChosen = nullptr;
    if (!Target && VehicleAimNearCrosshair && g_LocalController) {
        float cone = (VehicleAimConeDeg>0.f?VehicleAimConeDeg:8.f);
        VehicleChosen = PickVehicleNearCrosshair(g_LocalController, start, rot, cone, VehicleVisCheck);
        if (VehicleChosen) {
            if (ASTExtraPlayerCharacter* occ = FindVehicleOccupant(VehicleChosen)) {
                Target = occ;             
                VehicleChosen = nullptr;  
            }
        }
    }

    if (!Target && (Enable || Enable) && g_LocalController) {
        Target = PickAirborneOrPeekNearCrosshair(g_LocalController, start, rot, 8.0f);
    }
    // ===== ЕДИНАЯ ПРОВЕРКА ДИСТАНЦИИ ДЛЯ ЛЮБОЙ ЦЕЛИ =====
if (Target && g_LocalPlayer) {
    float dist = g_LocalPlayer->GetDistanceTo(Target) / 100.0f;
    if (dist > SilentAimMaxDistance) {
        Target = nullptr;
    }
}

    if (Target || VehicleChosen) {
        bool triggerOk = false;

    triggerOk = g_LocalPlayer->bIsWeaponFiring || g_LocalPlayer->bIsGunADS;

        if (triggerOk) {
            FVector targetAimPos{};

            if (Target) {
                FVector viewLoc = g_LocalPlayer->GetBonePos("Head", {}); 
                viewLoc.Z += 10.f;

                
                FVector bonePos = GetBestBonePosVisible(Target, g_LocalController, viewLoc);
                // ===== ВСТАВЬ СЮДА =====
float dist = g_LocalPlayer->GetDistanceTo(Target) / 100.0f;
if (dist > 40.0f && Settings::Aimbot::SilentAimSettings::Aimpositon == 1) {
    bonePos.Z -= dist * 0.5f;
}
// =======================
                // Проверяем, видна ли эта кость
    if (!g_PlayerController->LineOfSightTo(Target, bonePos, true)) {
        Target = nullptr; // не видна — не стреляем
        return orig_shoot_event(thiz, start, rot, weapon, unk1);
    }

                if (auto SW = thiz->ShootWeaponEntityComponent) {
                    float spd = SW->BulletFireSpeed;
                    if (spd > 1.f) {
                        ASTExtraVehicleBase* curVeh = Target->CurrentVehicle;
                        FVector tgtVel = curVeh ? curVeh->ReplicatedMovement.LinearVelocity
                                                : Target->GetVelocity();

                        // airborne/paras chute friendly lead
                        const bool airborneish = fabsf(tgtVel.Z) > 120.f;

                        float dist = Len(UMC->Subtract_VectorVector(bonePos, start));
                        float t = dist/spd + GetPingSeconds(g_LocalController);
                        if (airborneish) t += 0.05f;  // small extra lead for chute/fall

                        targetAimPos = UMC->Add_VectorVector(bonePos, UMC->Multiply_VectorFloat(tgtVel, t));
                        targetAimPos.Z += 0.5f * 980.f * t * t; // bullet drop comp

                        if (airborneish && (bonePos.Z - start.Z) > 600.f) {
                            targetAimPos.Z += 15.f; // tiny offset for high-altitude anim mismatch
                        }
                    } else {
                        targetAimPos = bonePos;
                    }
                } else {
                    targetAimPos = bonePos;
                }
            }
            else if (VehicleChosen) {
                targetAimPos = VehicleChosen->K2_GetActorLocation();
                targetAimPos.Z += (VehicleAimHeightZ != 0.f ? VehicleAimHeightZ : 50.f);

                if (auto SW = thiz->ShootWeaponEntityComponent) {
                    float spd = SW->BulletFireSpeed;
                    if (spd > 1.f) {
                        FVector vel = VehicleChosen->ReplicatedMovement.LinearVelocity;
                        float dist = g_LocalPlayer->GetDistanceTo(VehicleChosen);
                        float t = dist/spd + GetPingSeconds(g_LocalController);

                        targetAimPos = UMC->Add_VectorVector(targetAimPos, UMC->Multiply_VectorFloat(vel, t));
                        targetAimPos.Z += 0.5f * 980.f * t * t;
                    }
                }
            }

            FVector fDir = UMC->Subtract_VectorVector(targetAimPos, start);
            rot = UMC->Conv_VectorToRotator(fDir);
        }
    }

    return orig_shoot_event(thiz, start, rot, weapon, unk1);
}
const char *GetVehicleName(ASTExtraVehicleBase *Vehicle)
{
switch (Vehicle->VehicleShapeType)
{
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_Motorbike:
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_Motorbike_SideCart:
return "Motorbike";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_Dacia:
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_HeavyDacia:
return "Dacia";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_MiniBus:
return "Mini Bus";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_PickUp:
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_PickUp01:
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_HeavyPickup:
return "Pick Up";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_Buggy:
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_HeavyBuggy:
return "Buggy";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_UAZ:
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_UAZ01:
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_UAZ02:
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_UAZ03:
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_HeavyUAZ:
return "UAZ";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_PG117:
return "PG117";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_Aquarail:
return "Aquarail";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_Mirado:
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_Mirado01:
return "Mirado";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_Rony:
return "Rony";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_Scooter:
return "Scooter";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_SnowMobile:
return "Snow Mobile";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_TukTukTuk:
return "Tuk Tuk";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_SnowBike:
return "Snow Bike";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_Surfboard:
return "Surf Board";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_Snowboard:
return "Snow Board";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_Amphibious:
return "Amphibious";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_LadaNiva:
return "Lada Niva";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_UAV:
return "UAV";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_MegaDrop:
return "Mega Drop";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_Lamborghini:
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_Lamborghini01:
return "Lamborghini";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_GoldMirado:
return "Gold Mirado";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_BigFoot:
return "Big Foot";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_HeavyUH60:
return "UH60";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_CoupeRB:
return "CoupeRB";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_UTV:
return "UTV";
break;
case ESTExtraVehicleShapeType::ESTExtraVehicleShapeType__VST_WingMan:
return "Helicopter";
break;
default:
return "Vehicle";
break;
}
return "Vehicle";
}
void ResetGuestAccount() {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/ano_tmp", NSHomeDirectory()] error:nil];
    [fm removeItemAtPath:[NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()] error:nil];
    [fm removeItemAtPath:[NSString stringWithFormat:@"%@/Library", NSHomeDirectory()] error:nil];
    [fm removeItemAtPath:[NSString stringWithFormat:@"%@/tmp", NSHomeDirectory()] error:nil];

    NSString *prefsPath = [NSString stringWithFormat:@"%@/Library/Preferences", NSHomeDirectory()];
    NSArray *prefsFiles = [fm contentsOfDirectoryAtPath:prefsPath error:nil];

    NSArray *bundleIdentifiersToRemove = @[
        @"tencent",  // existing
        @"ig",       // existing
        @"rekoo",    // TW
        @"vn",       // VNG
        @"imobile",  // BGMI
        @"korean"    // Korean placeholder
    ];

    for (NSString *file in prefsFiles) {
        for (NSString *bundleId in bundleIdentifiersToRemove) {
            if ([file containsString:bundleId] || [file hasSuffix:@".plist"]) {
                [fm removeItemAtPath:[prefsPath stringByAppendingPathComponent:file] error:nil];
                break;
            }
        }
    }







UIWindow *window= nil;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (!window) window = [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic pop

    UIViewController *rootVC = window.rootViewController;
    UIAlertController *done = [UIAlertController alertControllerWithTitle:@"Guest reset complete. Game will exit in 5s."
                                                                  message:nil
                                                           preferredStyle:UIAlertControllerStyleAlert];
    [rootVC presentViewController:done animated:YES completion:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        exit(0);
    });
}

void Drawesp() {
    ImGuiWindowFlags f = ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoResize |
                         ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoCollapse |
                         ImGuiWindowFlags_NoBringToFrontOnFocus | ImGuiWindowFlags_NoInputs |
                         ImGuiWindowFlags_NoBackground;

    ImGui::SetNextWindowPos(ImVec2(0, 0));
    ImGui::SetNextWindowSize(ImGui::GetIO().DisplaySize);
    ImGui::PushStyleVar(ImGuiStyleVar_Alpha, 1.f);

    if (!ImGui::Begin("ESPOverlay", nullptr, f)) { ImGui::PopStyleVar(); return; }

    ImDrawList* d = ImGui::GetWindowDrawList();
    ImDrawList* bg = d;

    auto lp = g_LocalPlayer;

    if (!lp || !lp->RootComponent || !mainFont) {
        ImGui::End(); ImGui::PopStyleVar(); return;
    }

    int localTeamID = lp->TeamID;
    static std::vector<ASTExtraPlayerCharacter*> cache;
    static float lastUpdate = 0.f;
    float now = ImGui::GetTime();
    std::vector<ASTExtraPlayerCharacter*> tmp;

    if (now - lastUpdate > 0.7f) { GetAllActors(tmp); cache.clear(); for (auto* a : tmp) { if (!a || !a->RootComponent) continue; if (a == lp) continue; if (a->bDead) continue; if (a->TeamID == localTeamID) continue; cache.push_back(a); }

        lastUpdate = now;
    }
    bool isVisible = false;
    UGameplayStatics *gGameplayStatics = (UGameplayStatics *) UGameplayStatics::StaticClass();

    FVector lpPos = lp->RootComponent->K2_GetComponentLocation();
    ImVec2 screenCenter(ImGui::GetIO().DisplaySize.x * 0.5f, ImGui::GetIO().DisplaySize.y * 0.5f);
    int totalEnemies1 = 0;
    int totalBots1 = 0;

    for (auto* p : cache) {
    if (!p || !p->RootComponent) continue;
    if (p->bDead) continue;
    if (!imgui::ESP) continue;

    bool isBot = (p->bIsAI || p->bEnsure);

    if (imgui::HideBot && isBot)
        continue;

    if (isBot)
        ++totalBots1;
    else
        ++totalEnemies1;

        FVector head = p->GetBonePos(("Head"), FVector());
        FVector root = p->RootComponent->K2_GetComponentLocation();
        FVector2D hs, fs;

        bool headOk = W2S(head, &hs);
        bool rootOk = W2S(root, &fs);
        if (!headOk && !rootOk) continue;
        if (!headOk) hs = fs;
        if (!rootOk) fs = hs;

        hs.X *= 0.5f; hs.Y *= 0.5f;
        fs.X *= 0.5f; fs.Y *= 0.5f;

        FVector diff = lp->RootComponent->K2_GetComponentLocation() - root;
        float distVal = sqrtf(diff.X*diff.X + diff.Y*diff.Y + diff.Z*diff.Z) / 100.f;

if (ESPMaxDistance > 0.f && distVal > ESPMaxDistance)
    continue;

        float asize = 80.0f / (distVal > 0 ? distVal : 1.0f);
        if (asize > 1.0f) asize = 1.0f;
        if (asize < 0.3f) asize = 0.3f;

        float totalWidthHalf = 45.0f * asize;
        float barHeight = 12.0f * asize;
        float weaponHeight = 12.0f * asize;
        float hpHeight = 2.0f * asize;
        float smallBoxW = 16.0f * asize;

        teamColor(p->TeamID, 200.0f, 160.0f);

// Проверка видимости через несколько костей
isVisible = false;
const char* checkBones[] = {"Head", "neck_01", "pelvis", "spine_03"};
for (const char* bone : checkBones) {
    FVector bonePos = p->GetBonePos(bone, {});
    if (bonePos.X == 0 && bonePos.Y == 0 && bonePos.Z == 0) continue;
    
    if (g_PlayerController->LineOfSightTo(p, bonePos, true)) {
        isVisible = true;
        break;
    }
}
    
ImColor espColor; if (p->bIsAI || p->bEnsure) { if (isVisible) espColor = ImColor(0, 255, 0); else espColor = ImColor(255, 255, 255); } else { if (isVisible) espColor = ImColor(0, 255, 0); else espColor = ImColor(255, 0, 0); }

        float headX = hs.X;
        float headY = hs.Y;

        float nameBoxTop = headY - (35.0f * asize);
        float startX = headX - totalWidthHalf;
        float endX = headX + totalWidthHalf;
        float nameBoxBottom = nameBoxTop + barHeight;
        float hpBottomY = nameBoxBottom + hpHeight;
        float highestY = nameBoxTop;

if (imgui::Line && hs.X > 0.f && hs.Y > 0.f && hs.Y < ImGui::GetIO().DisplaySize.y) { ImVec2 screenCenter = ImVec2(ImGui::GetIO().DisplaySize.x * 0.5f, 0.0f); bool isVisible = g_PlayerController->LineOfSightTo( g_PlayerController->PlayerCameraManager, p->GetBonePos("Head", {}), true ); ImU32 lineColorU32 = ImGui::GetColorU32(isVisible ? visibleColor : unvisibleColor); d->AddLine( screenCenter, ImVec2(hs.X, hs.Y), lineColorU32, lineThickness ); }

ImVec2 hexCenter{};

if (imgui::Health) {
    hexCenter = DrawHealthVnHax(p, d);
}

if (imgui::Name) {
    DrawPlayerName(p, d, textBorder);
}


if (imgui::TeamID) {
    DrawTeamID(p, d, hexCenter, textBorder); 
}

if (imgui::Weapon) {
    DrawWeaponName(p, d, textBorder);
}



if (imgui::Distance) {
    ImVec2 distPos{}, distSize{};
    DrawDistance(p, d, textBorder, distPos, distSize);

    if (imgui::EnemyAiming) {
        DrawEnemyAimingAlert(p, d, textBorder, distPos, distSize);
    }
}


        if (imgui::Bone) {
            bool isBot = (p->bIsAI || p->bEnsure);
            DrawSkeletonAdvanced(p, isBot, isVisible);
    }}

if (imgui::EnemyCount) {
    DrawEnemyCount();
}


if (imgui::GameInfo) {
    DrawGameInfo(); 
                                    }
if (imgui::Alert360)
{
    Draw360Alert(cache); 
}

ImDrawList* draw = ImGui::GetForegroundDrawList();

ImVec2 displaySize = ImGui::GetIO().DisplaySize;
ImVec2 center(displaySize.x * 0.5f, displaySize.y * 0.5f);

bool textBorder = false;

NSString *o1 = [NSString stringWithUTF8String:
make_string("RVJST1JWSVAgRlVDS0VEIEJZIEtBSE4=").c_str()
];

std::string s1 = o1 ? std::string([o1 UTF8String]) : std::string();
std::string s2 = SDKvaT(s1);

float fontSize = 21.0f;

ImVec2 textSize = mainFont->CalcTextSizeA(fontSize, FLT_MAX, 0.0f, s2.c_str());

ImVec2 pos(
    center.x - textSize.x * 0.5f,
    center.y - textSize.y * 0.5f - 90.0f
);

ImU32 textColor = IM_COL32(255, 255, 255, 255);

if (textBorder)
{
    draw->AddTextStroke(
        mainFont,
        fontSize,
        pos,
        IM_COL32(0, 0, 0, 180), // ТЕНЬ/ОБВОДКА
        s2.c_str()
    );
}
else
{
    draw->AddText(
        mainFont,
        fontSize,
        pos,
        textColor,
        s2.c_str()
    );
}

if (Settings::Aimbot::Tick || Enable) {
if (Settings::Aimbot::SilentAimSettings::EnableFov && Cross > 0.0f) {
    DrawFOVCircle(Cross);
}}
if (Settings::Aimbot::Tick || Enable) {
if (Settings::Aimbot::SilentAimSettings::AimingLine) {
    DrawAimingLine();
}}

    ImGui::End();
    ImGui::PopStyleVar();
}

void RenderESP(AHUD *HUD, int ScreenWidth, int ScreenHeight) {
                     
    
    updateSkin();
UBulletHitInfoUploadComponent *bEnableTssSdkAntiData = 0;//追踪sdk
ASTExtraPlayerCharacter *localPlayer = 0;
    ASTExtraPlayerController *localPlayerController = 0;
    USTExtraGameInstance *playerChar = 0;
    screenWidth = ScreenWidth;
    screenHeight = ScreenHeight;
    ASTExtraBaseCharacter *STExtraBaseCharacter = 0;
    ASTExtraCharacter *Charac = 0;
    FVerifySwitch *VerifySwitch = 0;
    FDistanceContinueHitCheck *DistanceContinueHitCheck = 0;
    FAntiCheatDetailData *AntiCheatDetailData = 0;
    UWeaponAntiCheatComp *WeaponAntiCheatComp = 0;
    AGameNetworkManager *GameNetworkManager = 0;
    UCheatManager *CheatManager = 0;
    UPlayerAntiCheatManager *PlayerAntiCheatManager = 0;
    USTExtraFloatingVehicleMovementComponent *STExtraFloatingVehicleMovementComponent = 0;
    USTExtraHelicopterVehicleMovementComponent *Helicopter = 0;
    ASTExtraShootWeapon *STExtraShootWeapon = 0;
    USceneComponent *SceneComponent = 0;
    UAntiCheatUtils *AntiCheatUtils = 0;
    UGMCheatManager *GMCheatManager = 0;
    UActorComponent* VACTask_AccelerationControl = nullptr;
UActorComponent* VACTask_FlyingVehicle = nullptr;
UActorComponent* VACTask_FlyingVehicleVelocity = nullptr;
UActorComponent* VACTask_FlyingVehicleVelocityChange = nullptr;
UActorComponent* VACTask_FlyingVehicleZ = nullptr;
UActorComponent* VACTask_SuperSpeed = nullptr;
UActorComponent* VACTask_SuperSpeedAllDir = nullptr;
UActorComponent* VACTask_ClientAbsSpeed = nullptr;

    UActorComponent *ActorComponent = 0;
    //VACTask_ClientAbsSpeed *VACTask_ClientAbsSpeed = nullptr;
    FMoveCheatAntiStrategy *MoveCheatAntiStrategy = 0;
    UAssetUserData *AssetUserData = 0;
    USTBuildSystemComponent *STBuildSystemComponent = 0;
    UDefaultAntiCheatComponent *DefaultAntiCheatComponent = 0;
    //FCharacterZMoveDistanceCheck *CharacterZMoveDistanceCheck = 0;
    FClientTimeSpeedCheck *ClientTimeSpeedCheck = 0;
    FRealtimeMoveSpeedCheck *RealtimeMoveSpeedCheck = 0;
    FShovelAntiCheat *ShovelAntiCheat = 0;
        glWidth = ScreenWidth;
        glHeight = ScreenHeight;
        UCanvas *Canvas = HUD->Canvas;
        if (Canvas && IsLogin) {

            static bool loadFont = false;
        if (!loadFont && IsLogin) {
            LoadFont();
            loadFont = true;
        }

if (!tslFont)
return;


           
UKismetMathLibrary* UMC = (UKismetMathLibrary*)UKismetMathLibrary::StaticClass();
UGameplayStatics *gGameplayStatics = (UGameplayStatics *) UGameplayStatics::StaticClass();
auto Actors = getActors();

            auto GWorld = GetFullWorld();
        uintptr_t AvatarComponent = 0xbb0;
        uintptr_t AvatarSyncData = 0x3e8;
        uintptOffset = 1000;
        if (ModSkinn) {
            if (ModSkinnLobby) {
                if (!GWorld || !GWorld->PersistentLevel) return;

                auto Actors = *(TArray<AActor*>*)((uintptr_t)GWorld->PersistentLevel + 0xA0);
                for (int i = 0; i < Actors.Num(); ++i) {
                    AActor* object = Actors[i];
                    if (!object) continue;

                    if (object->IsA(ASTExtraLobbyCharacter::StaticClass())) {
                        auto *LobbyCharacter = (ASTExtraLobbyCharacter *)(object);
                        if (LobbyCharacter) {
                            auto AvatarComponent2 = (UCharacterAvatarComponent2 *)*(uintptr_t *)((uintptr_t)LobbyCharacter + AvatarComponent);
                            if (AvatarComponent2) {
                                FNetAvatarSyncData *NetAvatarComp =
                                (FNetAvatarSyncData *)((uintptr_t)AvatarComponent2 + AvatarSyncData);
                                if (!NetAvatarComp || NetAvatarComp->SlotSyncData.Num() <= 2) {
                                    continue;
                                }
                                updateSkin();

                                auto Slotsybc = NetAvatarComp->SlotSyncData;
                                for (int i = 0; i < Slotsybc.Num(); i++) {
                                    auto Slottype = Slotsybc[i].SlotID;
                                    auto &Slotitem = Slotsybc[i].ItemId;
                                    if (preferences.Outfit) {
                                        if (Slottype == 5) {
                                            if (Slotitem != new_Skin.XSuits) {
                                                Slotitem = new_Skin.XSuits;
                                                callFunction = true;
                                            }
                                        }
                                    }
                                    if (preferences.Gloves) {
                                        if (Slottype == 16) {
                                            Slotitem = new_Skin.Gloves;
                                        }
                                    }
                                    if (preferences.Shortsx) {
                                        if (Slottype == 6) {
                                            if (Slotitem != new_Skin.Shortss) {
                                                Slotitem = new_Skin.Shortss;
                                                callFunction = true;
                                            }
                                        }
                                    }
                                    if (preferences.Shoes) {
                                        if (Slottype == 7) {
                                            if (Slotitem != new_Skin.Shoes) {
                                                Slotitem = new_Skin.Shoes;
                                                callFunction = true;
                                            }
                                        }
                                    }
                                    if (preferences.Bagg) {
                                        if (Slottype == 8) {
                                            if ((1501003000 <= Slotitem && Slotitem <= 1501003999) || Slotitem == 501003 || Slotitem == 501006 || Slotitem == 501009 || Slotitem == 501012 || Slotitem == 501103 || Slotitem == 501104 || Slotitem == 501105 || Slotitem == 501106) {
                                                if (Slotitem != bag3) {
                                                    Slotitem = bag3;
                                                    callFunction = true;
                                                }
                                            } else if ((1501002000 <= Slotitem && Slotitem <= 1501002999) || Slotitem == 501002 || Slotitem == 501005 || Slotitem == 501008 || Slotitem == 501011 || Slotitem == 501102) {
                                                if (Slotitem != bag2) {
                                                    Slotitem = bag2;
                                                    callFunction = true;
                                                }
                                            } else if ((1501001000 <= Slotitem && Slotitem <= 1501001999) || Slotitem == 501001 || Slotitem == 501004 || Slotitem == 501007 || Slotitem == 501010 || Slotitem == 501101) {
                                                if (Slotitem != bag1) {
                                                    Slotitem = bag1;
                                                    callFunction = true;
                                                }
                                            }
                                        }
                                    }
                                    if (preferences.Helmett) {
                                        if (Slottype == 9) {
                                            if ((1502003000 <= Slotitem && Slotitem <= 1502003999) || Slotitem == 502003 || Slotitem == 502101 || Slotitem == 502104 || Slotitem == 502105 || Slotitem == 502106 || Slotitem == 502107 || Slotitem == 502108 || Slotitem == 502109 || Slotitem == 502110 || Slotitem == 502111 || Slotitem == 502112) {
                                                if (Slotitem != helmett3) {
                                                    Slotitem = helmett3;
                                                    callFunction = true;
                                                }
                                            } else if ((1502002000 <= Slotitem && Slotitem <= 1502002999) || Slotitem == 502002 || Slotitem == 502005 || Slotitem == 502102) {
                                                if (Slotitem != helmett2) {
                                                    Slotitem = helmett2;
                                                    callFunction = true;
                                                }
                                            } else if ((1502001000 <= Slotitem && Slotitem <= 1502001999) || Slotitem == 502001 || Slotitem == 502004) {
                                                if (Slotitem != helmett1) {
                                                    Slotitem = helmett1;
                                                    callFunction = true;
                                                }
                                            }
                                        }
                                    }
                                }
                                if (callFunction && AvatarComponent2) {
                                  AvatarComponent2->OnRep_BodySlotStateChanged();
                                  callFunction = false;
                                }
                            }
                        }
                        auto LobbyEmote = (ASTExtraLobbyCharacter*)object;
                        if (LobbyEmote) {
                            auto LobbyPlayEmote = *(ULobbyPlayEmoteComponent**)((uintptr_t)LobbyEmote + 0xbc0);
                            if (LobbyPlayEmote) {
                                int oldEmoteID = LobbyPlayEmote->GetCurrentEmoteID();
                                if (preferences.Emote) {
                                    if (oldEmoteID == 2200101) {
                                        FString extraInfo;
                                        LobbyPlayEmote->OnPlayEmote(sEmote1, 0, extraInfo);
                                    }
                                    if (preferences.Emote) {
                                        if (oldEmoteID == 2200201) {
                                            FString extraInfo;
                                            LobbyPlayEmote->OnPlayEmote(sEmote2, 0, extraInfo);
                                        }
                                        if (preferences.Emote) {
                                            if (oldEmoteID == 2200301) {
                                                FString extraInfo;
                                                LobbyPlayEmote->OnPlayEmote(sEmote3, 0, extraInfo);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if (object->IsA(ASTExtraLobbyVehicle::StaticClass())) {
                        auto LobbyVehicle = (ASTExtraLobbyVehicle*)object;
                        if (!LobbyVehicle) continue;

                        auto VehicleAvatar = LobbyVehicle->VehicleAvatar;
                        if (!VehicleAvatar) continue;

                        int defaultSkin = VehicleAvatar->GetDefaultAvatarID();
                        Active::SkinCarDefault = defaultSkin;

                        std::string SkinIDStr = std::to_string(defaultSkin);
                        Active::SkinCarNew = false;

                        if (preferences.Moto && SkinIDStr.find("1901") != std::string::npos) {
                            Active::SkinCarMod = new_Skin.Moto;
                            Active::SkinCarNew = true;
                        } else if (preferences.Dacia && SkinIDStr.find("1903") != std::string::npos) {
                            Active::SkinCarMod = new_Skin.Dacia;
                            Active::SkinCarNew = true;
                        } else if (preferences.Boat && SkinIDStr.find("1911") != std::string::npos) {
                            Active::SkinCarMod = new_Skin.Boat;
                            Active::SkinCarNew = true;
                        } else if (preferences.MiniBus && SkinIDStr.find("1904") != std::string::npos) {
                            Active::SkinCarMod = new_Skin.MiniBus;
                            Active::SkinCarNew = true;
                        } else if (preferences.Mirado && SkinIDStr.find("1914") != std::string::npos) {
                            Active::SkinCarMod = new_Skin.Mirado;
                            Active::SkinCarNew = true;
                        } else if (preferences.Mirado && SkinIDStr.find("1915") != std::string::npos) {
                            Active::SkinCarMod = new_Skin.Mirado;
                            Active::SkinCarNew = true;
                        } else if (preferences.Buggy && SkinIDStr.find("1907") != std::string::npos) {
                            Active::SkinCarMod = new_Skin.Buggy;
                            Active::SkinCarNew = true;
                        } else if (preferences.CoupeRB && SkinIDStr.find("1961") != std::string::npos) {
                            Active::SkinCarMod = new_Skin.CoupeRP;
                            Active::SkinCarNew = true;
                        } else if (preferences.BigFoot && SkinIDStr.find("1953") != std::string::npos) {
                            Active::SkinCarMod = new_Skin.Bigfoot;
                            Active::SkinCarNew = true;
                        } else if (preferences.RZR && SkinIDStr.find("1966") != std::string::npos) {
                            Active::SkinCarMod = new_Skin.RZR;
                            Active::SkinCarNew = true;
                        } else if (preferences.Rony && SkinIDStr.find("1916") != std::string::npos) {
                            Active::SkinCarMod = new_Skin.Rony;
                            Active::SkinCarNew = true;
                        } else if (preferences.UAZ && SkinIDStr.find("1908") != std::string::npos) {
                            Active::SkinCarMod = new_Skin.UAZ;
                            Active::SkinCarNew = true;
                        }

                        if (Active::SkinCarNew && Active::SkinCarMod != Active::SkinCarDefault) {
                            VehicleAvatar->ChangeItemAvatar(Active::SkinCarMod, true);
                            Active::SkinCarDefault = Active::SkinCarMod;
                        }
                    }
                }
            }
        }
         if (GWorld   && IsLogin) {
                UNetDriver *NetDriver = GWorld->NetDriver;
                if (NetDriver) {
                    UNetConnection *ServerConnection = NetDriver->ServerConnection;
                    if (ServerConnection) {
                        localPlayerController = (ASTExtraPlayerController *) ServerConnection->PlayerController;
                    }
                }








                            


                if (localPlayerController) {


                    
                    std::vector<ASTExtraPlayerCharacter *> PlayerCharacter;
                    GetAllActors(PlayerCharacter);
                int IntCount = 0;
                    for (auto actor = PlayerCharacter.begin();
                         actor != PlayerCharacter.end(); actor++) {
                        auto Actor = *actor;

                        if (Actor->PlayerKey ==
                            ((ASTExtraPlayerController *) localPlayerController)->PlayerKey) {
                            localPlayer = Actor;
                            break;
                        }
                    }



            

{
                    
                        if (localPlayer) {
 

                        if (WideView) {
                            auto ThirdPersonCameraComponent = localPlayer->ThirdPersonCameraComponent;
                            if (ThirdPersonCameraComponent) {
                                *(float *) ((uintptr_t) &ThirdPersonCameraComponent->OrthoWidth - sizeof(float)) = WideValue;
                            }
                        }

if(g_LocalPlayer){
                            
 if (Blacksky) {
    g_LocalPlayer->SetWeaponShootType(ESTEWeaponShootType::ESTEWeaponShootType__Auto);
}
}
                if (localPlayer)
                {
                                     
                                                            if (localPlayer->bIsGunADS){
                                localPlayer->MeshContainer->RelativeRotation = { 0,360,0 };
                            }else{
                                if (!localPlayer->bIsWeaponFiring){
                                    localPlayer->MeshContainer->RelativeRotation = { 0,360,0 };
                                }else{
                            if (isSpinning) {
                                if (localPlayer->bIsWeaponFiring){
                            localPlayer->MeshContainer->RelativeRotation = { 0,DanceValue ,0 };
                              DanceValue += DancerValue;
                             if (DanceValue >= 360.0f)
                              DanceValue = 0.0f;
                             DanceValue += tocdoquay;
}
}}}
} 


if(下雨){
g_LocalPlayer->STPlayerController->SetIsRainy(true);

                                                    }

if (下雪特效){

                                                        g_LocalPlayer->STPlayerController->SetIsSnowy(true);

                                                    }

            
//
if (人物自杀 && IsLogin){
                                                        g_LocalPlayer->STPlayerController->RPC_GiveUpGame();//自杀
                                                    }
if(重置游客){
    ResetGuestAccount();
}
if(ResetGuest){
ResetGuestAccount();
                        
}





if (人物变大) {
USceneComponent* MeshContainer = g_LocalPlayer->MeshContainer;
MeshContainer->SetWorldScale3D({巨人, 巨人, 巨人});
}





                         




                         
                                                 if (Settings::Aimbot::Tick) {
                                                            ASTExtraPlayerCharacter *Target = GetTargetByCrossDist();
                                                            
                                                            if (Target && Target->RootComponent) {
                                                            
                                                              
                                                                
bool triggerOk = false;

if (Settings::Aimbot::SilentAimSettings::Prediction) {

triggerOk = localPlayer->bIsWeaponFiring;
} else {
    
    triggerOk = localPlayer->bIsWeaponFiring;
}


if (triggerOk) {
    FVector targetAimPos;

    if (Settings::Aimbot::SilentAimSettings::Aimpositon == 0) {
        targetAimPos = Target->GetBonePos("Head", {});
        targetAimPos.Z -= 12.f;
    } 
    else if (Settings::Aimbot::SilentAimSettings::Aimpositon == 1) {
        targetAimPos = Target->GetBonePos("pelvis", {});
    }
    // ===== ВСТАВЬ СЮДА =====
            float dist = g_LocalPlayer->GetDistanceTo(Target) / 100.0f;
            if (dist > 40.0f && Settings::Aimbot::SilentAimSettings::Aimpositon == 1) {
                targetAimPos.Z -= dist * 0.5f;
            }
                                    if (IsAimBotRecc) {
                                                                                if (g_LocalPlayer->bIsGunADS) {
                                                                                    if (g_LocalPlayer->bIsWeaponFiring) {
                                                                                        float dist = g_LocalPlayer->GetDistanceTo(Target) / 100.f;
                                                                                        targetAimPos.Z -= dist * preferences.Config.SilentAim.Recc;
                                                                                    }
                                                                                }
                                                                            }
                                                                    auto WeaponManagerComponent = localPlayer->WeaponManagerComponent;
                                                                                    if (WeaponManagerComponent)
                                                                                    {
                                                                                        auto propSlot = WeaponManagerComponent->GetCurrentUsingPropSlot();
                                                                                        if ((int)propSlot.GetValue() >= 1 && (int)propSlot.GetValue() <= 3)
                                                                                        {
                                                                                            auto CurrentWeaponReplicated = (ASTExtraShootWeapon *)WeaponManagerComponent->CurrentWeaponReplicated;
                                                                                            if (CurrentWeaponReplicated)
                                                                                            {
                                                                                                auto ShootWeaponComponent = CurrentWeaponReplicated->ShootWeaponComponent;
                                                                                                if (ShootWeaponComponent)
                                                                                                {
                                                                                                    UShootWeaponEntity *ShootWeaponEntityComponent = ShootWeaponComponent->ShootWeaponEntityComponent;
                                                                                                    
                                                                                                    if (ShootWeaponEntityComponent) {
                                                                                                        ASTExtraVehicleBase *CurrentVehicle = Target->CurrentVehicle;
                                                                                                        if (CurrentVehicle) {
                                                                                                            FVector LinearVelocity = CurrentVehicle->ReplicatedMovement.LinearVelocity;
                                                                                                            float dist = g_LocalPlayer->GetDistanceTo(Target);
                                                                                                            auto timeToTravel = dist / ShootWeaponEntityComponent->BulletFireSpeed;
                                                                                                            targetAimPos = UMC->Add_VectorVector(targetAimPos, UMC->Multiply_VectorFloat(LinearVelocity, timeToTravel));
                                                                                                        } else {
                                                                                                            FVector Velocity = Target->GetVelocity();
                                                                                                            float dist = g_LocalPlayer->GetDistanceTo(Target);
                                                                                                            auto timeToTravel = dist / ShootWeaponEntityComponent->BulletFireSpeed;
                                                                                                            targetAimPos =UMC->Add_VectorVector(targetAimPos, UMC->Multiply_VectorFloat(Velocity, timeToTravel));
                                                                                                        }
                                                                                                        
                                                                                 }
                                                                                                    
                                                FVector fDir = UKismetMathLibrary::Subtract_VectorVector(
    targetAimPos,
    localPlayerController->PlayerCameraManager->CameraCache.POV.Location
);

FRotator Yaptr = UKismetMathLibrary::Conv_VectorToRotator(fDir);
FRotator CpYaT = localPlayerController->PlayerCameraManager->CameraCache.POV.Rotation;

Yaptr.Yaw -= CpYaT.Yaw;
Yaptr.Pitch -= CpYaT.Pitch;
Yaptr.Roll = 0.f;

localPlayer->AddControllerYawInput(Yaptr.Yaw / AimSmooth);
localPlayer->AddControllerPitchInput(Yaptr.Pitch / AimSmooth);

                                                                                    
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }



            
            if (IsLaunch = true)
            {
                   if (Enable  && IsLogin || 坐标追 && IsLogin) {//追
                    auto WeaponManagerComponent = localPlayer->WeaponManagerComponent;
                    if (WeaponManagerComponent) {
                        auto propSlot = WeaponManagerComponent->GetCurrentUsingPropSlot();
                        if ((int) propSlot.GetValue() >= 1 && (int) propSlot.GetValue() <= 3) {
                            auto CurrentWeaponReplicated = (ASTExtraShootWeapon *) WeaponManagerComponent->CurrentWeaponReplicated;
                            if (CurrentWeaponReplicated) {
                                auto ShootWeaponComponent = CurrentWeaponReplicated->ShootWeaponComponent;
                                if (ShootWeaponComponent) {
                                    int shoot_event_idx = 174;
                                    auto VTable = (void **) ShootWeaponComponent->VTable;
                if (!initialized) {
                    InitializeMemoryProtection();
                }
                                    if (VTable && (VTable[shoot_event_idx] != shoot_event)) {
                                        orig_shoot_event = decltype(orig_shoot_event)(
                                                VTable[shoot_event_idx]);
                                        VTable[shoot_event_idx] = (void *) shoot_event;
                                    }
                                }
                            }
                        }
                    }
                }
              IsLaunch = false;
              }

                            if(!localPlayer->IsUsingGrenade()) {
                                    auto WeaponManagerComponent = localPlayer->WeaponManagerComponent;
                                    if (WeaponManagerComponent) {
                                        auto propSlot = WeaponManagerComponent->GetCurrentUsingPropSlot();
                                        if ((int) propSlot.GetValue() >= 1 &&
                                            (int) propSlot.GetValue() <= 3) {
                                            auto CurrentWeaponReplicated = (ASTExtraShootWeapon *) WeaponManagerComponent->CurrentWeaponReplicated;
                                            if (CurrentWeaponReplicated) {
                                                auto ShootWeaponEntityComp = CurrentWeaponReplicated->ShootWeaponEntityComp;
                                                auto ShootWeaponEffectComp = CurrentWeaponReplicated->ShootWeaponEffectComp;
                                                
                                                
                                                auto ID = CurrentWeaponReplicated->GetWeaponID();
                                                if(ID != 108004 && ID != 108003 && ID != 108002 && ID != 108001 && ID != 108000 && ID != 108005 && ID != 108006 && ID != 108007)
                                                    if (ShootWeaponEntityComp && ShootWeaponEffectComp)
                                                    {
                                                      if (IsFastSwitch)
{
ShootWeaponEntityComp->SwitchFromBackpackToIdleTime = 0.0f;
 ShootWeaponEntityComp->SwitchFromIdleToBackpackTime = 0.0f;
                                }
                                            
                                            if(IsCrossHair){ //RENDERESP MEMORY FUNCTION
                                                memset(&ShootWeaponEntityComp->DeviationInfo, 0, sizeof(FSDeviation));
                                                ShootWeaponEntityComp->ShotGunCenterPerc = 0.0f;
                                                ShootWeaponEntityComp->ShotGunVerticalSpread = 0.0f;
                                                ShootWeaponEntityComp->ShotGunHorizontalSpread = 0.0f;
                                                ShootWeaponEntityComp->GameDeviationFactor = 0.0f;
                                                ShootWeaponEntityComp->GameDeviationAccuracy = 0.0f;
                                                ShootWeaponEntityComp->CrossHairInitialSize = 0.0f;
                                                ShootWeaponEntityComp->CrossHairBurstSpeed = 0.0f;
                                                ShootWeaponEntityComp->CrossHairBurstIncreaseSpeed = 0.0f;
                                                ShootWeaponEntityComp->VehicleWeaponDeviationAngle = 0.0f;
                                            }
                                            if (IsFastshoot) {
                                                ShootWeaponEntityComp->ShootInterval = 0.02f; //регулировка скорости пуль
                                            }
                                            if(IsNocamerashake) {
                                                ShootWeaponEffectComp->CameraShakeInnerRadius = 0.0f;
                                                ShootWeaponEffectComp->CameraShakeOuterRadius = 0.0f;
                                                ShootWeaponEffectComp->CameraShakFalloff = 0.0f;
                                                ShootWeaponEntityComp->AnimationKick = 0;
                                            }
                                            if(IsNorecoil2){
                                                            ShootWeaponEntityComp->RecoilKickADS = 0.0f;
                                                        }
                                                        
if(HitX){
                                                            ShootWeaponEntityComp->ExtraHitPerformScale = 100;
                                                            ShootWeaponEntityComp->HUDAlphaDecreaseSpeedScale = 1.f;
                                                        }
                                                        if(ReCo && IsLogin){
                                                            {
                                                                ShootWeaponEntityComp->AccessoriesVRecoilFactor = 0.0f;
                                                                ShootWeaponEntityComp->AccessoriesHRecoilFactor = 0.0f;
                                                                ShootWeaponEntityComp->AccessoriesRecoveryFactor = 0.0f;
                                                            }
                                                        }

if (自动开火) {
if ((g_LocalPlayer && g_LocalPlayer->RootComponent) &&
localPlayerController) {
ASTExtraPlayerCharacter *Target;
Target = GetTargetByCrossDist();
auto WeaponManagerComponent = g_LocalPlayer->WeaponManagerComponent;
if (WeaponManagerComponent) {
auto propSlot = WeaponManagerComponent->GetCurrentUsingPropSlot();
if ((int) propSlot.GetValue() >= 1 &&
(int) propSlot.GetValue() <= 3) {
auto CurrentWeaponReplicated = (ASTExtraShootWeapon *) WeaponManagerComponent->CurrentWeaponReplicated;
if (CurrentWeaponReplicated) {
auto ShootWeaponComponent = CurrentWeaponReplicated->ShootWeaponComponent;
if (ShootWeaponComponent) {
if (Target && Target->RootComponent) {
g_PlayerController->OnPressFire();
} else {
g_PlayerController->OnReleaseFire();
}
}
}
}
}
}
}
/*
if (SDK防V2) {
    auto GWorld = GetFullWorld();
    if (!GWorld || !GWorld->PersistentLevel) return;
    auto Actors = *(TArray<AActor*>*)((uintptr_t)GWorld->PersistentLevel + 0x70);
    for (int i = 0; i < Actors.Num(); ++i) { 
        AActor* Actor = Actors[i];
continue;
if (Actor->IsA(ASTExtraPlayerController::StaticClass())) {
 auto playerChar = (ASTExtraPlayerController *) Actor;  
 playerChar->AntiCheatManagerComp->VsNoHitDetail.bShouldPunish = false;
 playerChar->AntiCheatManagerComp->VsLocusCheckHorizon.bShouldPunish = false;
 playerChar->AntiCheatManagerComp->CheatStateData2TotalCheatTimes.bShouldPunish = false;
 playerChar->AntiCheatManagerComp->MoveCheatAntiStrategy3TotalCheatTimes.bShouldPunish = false;
 playerChar->AntiCheatManagerComp->VsLocusCheckHorizon.bShouldPunish = false;
 playerChar->AntiCheatManagerComp->VsMuzzleRangeCircle.bShouldPunish = false;
 playerChar->AntiCheatManagerComp->VsMuzzleRangeUp.bShouldPunish = false;
 playerChar->AntiCheatManagerComp->VsDeConAndTimeOld.bShouldPunish = false;
 playerChar->AntiCheatManagerComp->VsBulletDirFailed.bShouldPunish = false;
 playerChar->AntiCheatManagerComp->VsBoneScale.bShouldPunish = false;
 playerChar->AntiCheatManagerComp->VsHitBoneNameNone.bShouldPunish = false;
 playerChar->AntiCheatManagerComp->VsImpactBulletPosOffsetBig.bShouldPunish = false;
 playerChar->AntiCheatManagerComp->ServerAccumulateErrorReplay.bShouldPunish = false;                              // 
 playerChar->AntiCheatManagerComp->DSSpeedOver10FailedCnt.bShouldPunish = false;                                   // 0x07D4(0x0020)
 playerChar->AntiCheatManagerComp->DSSpeedOver15FailedCnt.bShouldPunish = false;                                   // 0x07F4(0x0020)
 playerChar->AntiCheatManagerComp->DSSpeedOver20FailedCnt.bShouldPunish = false;                                   // 0x0814(0x0020)
 playerChar->AntiCheatManagerComp->SpeedQuickCheck.bShouldPunish = false;                                          // 0x0834(0x0020)
 playerChar->AntiCheatManagerComp->BulletDirError.bShouldPunish = false;                                           // 0x0854(0x0020)
 playerChar->AntiCheatManagerComp->SwitchMuzzleLocusError.bShouldPunish = false;                                   // 0x0874(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchMuzzleLocusErrorX.bShouldPunish = false;                                  // 0x0894(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchMuzzleLocusErrorY.bShouldPunish = false;                                  // 0x08B4(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchMuzzleLocusErrorZ.bShouldPunish = false;                                  // 0x08D4(0x0020) (Config)
 playerChar->AntiCheatManagerComp->Gun2ShooterPosError1.bShouldPunish = false;                                     // 0x08F4(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchHeadLocusError3.bShouldPunish = false;                                    // 0x0914(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchMuzzleLocusErrorLength.bShouldPunish = false;                             // 0x0934(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchShootPosHistoryLocusError3.bShouldPunish = false;                         // 0x0954(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchHitComponentUnvalid.bShouldPunish = false;                                // 0x0974(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchHitNoRender.bShouldPunish = false;                                        // 0x0994(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchHitOutCollisionBox.bShouldPunish = false;                                 // 0x09B4(0x0020) (Config)
 playerChar->AntiCheatManagerComp->HeadOverShootPos.bShouldPunish = false;                                         // 0x09D4(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchMuzzleImpactDirSkipPunish1.bShouldPunish = false;                         // 0x09F4(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchInvalidBulletNumInBarrel.bShouldPunish = false;                           // 0x0A14(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchShooterMovementError2.bShouldPunish = false;                              // 0x0A34(0x0020) (Config)
 playerChar->AntiCheatManagerComp->GunTailPosError.bShouldPunish = false;                                          // 0x0A54(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchMuzzleImpactDirSkipPunish2.bShouldPunish = false;                         // 0x0A74(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchMuzzleImpactDirError1.bShouldPunish = false;                              // 0x0A94(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchMuzzleImpactDirError2.bShouldPunish = false;                              // 0x0AB4(0x0020) (Config)
 playerChar->AntiCheatManagerComp->ShooterHead2PosBlock.bShouldPunish = false;                                     // 0x0AD4(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchShootPosHistoryLocusError2.bShouldPunish = false;                         // 0x0AF4(0x0020) (Config)
 playerChar->AntiCheatManagerComp->Head2GunTailPosError1.bShouldPunish = false;                                    // 0x0B14(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchShootDirExcepation1.bShouldPunish = false;                                // 0x0B34(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchShootDirExcepation2.bShouldPunish = false;                                // 0x0B54(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchCamerModeException.bShouldPunish = false;                                 // 0x0B74(0x0020) (Config)
 playerChar->AntiCheatManagerComp->SwitchShootPosHistoryLocusError4.bShouldPunish = false;                         // 0x0B94(0x0020) (Config)
 playerChar->AntiCheatManagerComp->VehicleSpeedZDeltaOver10TimesWhenNoXY.bShouldPunish = false;                    // 0x0C28(0x0020)
 playerChar->AntiCheatManagerComp->VehicleVelZCheck1.bShouldPunish = false;                                        // 0x0C48(0x0020)
 playerChar->AntiCheatManagerComp->VehicleVelZCheck2.bShouldPunish = false;                                        // 0x0C68(0x0020)
 playerChar->AntiCheatManagerComp->VehicleHitMuzzleCheck.bShouldPunish = false;                                    // 0x0C88(0x0020)
 playerChar->AntiCheatManagerComp->VehicleHitImpactPointCheck.bShouldPunish = false;                               // 0x0CA8(0x0020)
 playerChar->AntiCheatManagerComp->VehicleHitBlockWall.bShouldPunish = false;                                      // 0x0CC8(0x0020)
 //playerChar->AntiCheatManagerComp->VehicleMoveDirectionCheck.bShouldPunish = false;                               
 playerChar->AntiCheatManagerComp->VehicleSidesway1.bShouldPunish = false;                                         // 0x0D10(0x0020)
 playerChar->AntiCheatManagerComp->VehicleSidesway2.bShouldPunish = false;                                         // 0x0D30(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInMidAirVehicleExceedThreshold.bShouldPunish = false;                   // 0x0D58(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInMidAirVehicleEnemyDistanceTrial.bShouldPunish = false;                // 0x0D78(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInMidAirVehicleEnemyDistanceFurtherTrial.bShouldPunish = false;         // 0x0D98(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInMidAirVehicleHeightTrial.bShouldPunish = false;                       // 0x0DB8(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInMidAirVehicleHeightFurtherTrial.bShouldPunish = false;                // 0x0DD8(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInMidAirPawnExceedThreshold.bShouldPunish = false;                      // 0x0DF8(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInMidAirPawnEnemyDistanceTrial.bShouldPunish = false;                   // 0x0E18(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInMidAirPawnEnemyDistanceFurtherTrial.bShouldPunish = false;            // 0x0E38(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInMidAirPawnHeightTrial.bShouldPunish = false;                          // 0x0E58(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInMidAirPawnHeightFurtherTrial.bShouldPunish = false;                   // 0x0E78(0x0020)
 playerChar->AntiCheatManagerComp->DSRunning2DSpeedExceededCount.bShouldPunish = false;                            // 0x0E98(0x0020)
 playerChar->AntiCheatManagerComp->DSRunning2DSpeedTrial.bShouldPunish = false;                                    // 0x0EB8(0x0020)
 playerChar->AntiCheatManagerComp->DSRunning2DSpeedFurtherTrial.bShouldPunish = false;                             // 0x0ED8(0x0020)
 playerChar->AntiCheatManagerComp->DSIgnoreNetworkDying2DSpeedExceededCount.bShouldPunish = false;                 // 0x0EF8(0x0020)
 playerChar->AntiCheatManagerComp->DSDyingMoveSpeedExceedCount.bShouldPunish = false;                              // 0x0F18(0x0020)
 playerChar->AntiCheatManagerComp->NonGunADSFarShootCount.bShouldPunish = false;                                   // 0x0F38(0x0020)
 playerChar->AntiCheatManagerComp->NonGunADSFarShootFromClientBulletDataCount.bShouldPunish = false;               // 0x0F58(0x0020)
 playerChar->AntiCheatManagerComp->NonGunADSFarShootFromClientBulletDataEnemyDistanceTrialCount.bShouldPunish = false;// 0x0F78(0x0020)
 playerChar->AntiCheatManagerComp->NonGunADSFarShootFromClientBulletDataEnemyDistanceFurtherTrialCount.bShouldPunish = false;// 0x0F98(0x0020)
 playerChar->AntiCheatManagerComp->ClientUploadFuzzyObjectVerifyFail.bShouldPunish = false;                        // 0x0FB8(0x0020)
 playerChar->AntiCheatManagerComp->ClientMoveTimeStampResetFrequencyExceedThreshold.bShouldPunish = false;         // 0x0FD8(0x0020)
 playerChar->AntiCheatManagerComp->ShootBirdNonGunADSExceedThreshold.bShouldPunish = false;                        // 0x0FF8(0x0020)
 playerChar->AntiCheatManagerComp->ShootBirdNonGunADSDistanceTrial.bShouldPunish = false;                          // 0x1018(0x0020)
 playerChar->AntiCheatManagerComp->ShootBirdNonGunADSDistanceFurtherTrial.bShouldPunish = false;                   // 0x1038(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInHighTangentMoveSpeedExceedThreshold.bShouldPunish = false;            // 0x1058(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInHighTangentMoveSpeedEnemyDistanceTrial.bShouldPunish = false;         // 0x1078(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInHighTangentMoveSpeedEnemyDistanceFurtherTrial.bShouldPunish = false;  // 0x1098(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInHighTangentMoveSpeedSpeedTrial.bShouldPunish = false;                 // 0x10B8(0x0020)
 playerChar->AntiCheatManagerComp->FarShootInHighTangentMoveSpeedSpeedFurtherTrial.bShouldPunish = false;          // 0x10D8(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireAfterKill.bShouldPunish = false;                    // 0x10F8(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireAfterKillDistanceTrial.bShouldPunish = false;       // 0x1118(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireAfterKillTimeTrial.bShouldPunish = false;           // 0x1138(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireAfterKillMaxTime.bShouldPunish = false;             // 0x1158(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFirePickUpItem.bShouldPunish = false;                   // 0x1178(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFirePickUpItemDistanceTrial.bShouldPunish = false;      // 0x1198(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFirePickUpItemTimeTrial.bShouldPunish = false;          // 0x11B8(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFirePickUpItemMaxTime.bShouldPunish = false;            // 0x11D8(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireNotKill.bShouldPunish = false;                      // 0x11F8(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireNotKillDistanceTrial.bShouldPunish = false;         // 0x1218(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireNotKillTimeTrial.bShouldPunish = false;             // 0x1238(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireNotKillMaxTime.bShouldPunish = false;               // 0x1258(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireOnVehicle.bShouldPunish = false;                    // 0x1278(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireOnVehicleDistanceTrial.bShouldPunish = false;       // 0x1298(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireOnVehicleTimeTrial.bShouldPunish = false;           // 0x12B8(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireOnVehicleMaxTime.bShouldPunish = false;             // 0x12D8(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireSameVehicle.bShouldPunish = false;                  // 0x12F8(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireSameVehicleTimeTrial.bShouldPunish = false;         // 0x1318(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireSameVehicleMaxTime.bShouldPunish = false;           // 0x1338(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpUseObjectTogether.bShouldPunish = false;                           // 0x1358(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpGetOnEnemyVehicleCount.bShouldPunish = false;                      // 0x1378(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireOneSideHasWeaponOnFoot.bShouldPunish = false;       // 0x1398(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpNearbyButNoFireOneSideHasWeaponOnFootDistanceTrial.bShouldPunish = false;// 0x13B8(0x0020)
 playerChar->AntiCheatManagerComp->IllegalTeamUpStayOnEnemyVehicle.bShouldPunish = false;                          // 0x13D8(0x0020)
 playerChar->AntiCheatManagerComp->KillBird.bShouldPunish = false;                                                 // 0x13F8(0x0020)
 playerChar->AntiCheatManagerComp->ParachuteLandingSecondsExceedThreshold.bShouldPunish = false;                   // 0x1418(0x0020)
 playerChar->AntiCheatManagerComp->ParachuteObliqueLandingSecondsExceedThreshold.bShouldPunish = false;    
 playerChar->bShouldReportAntiCheat = false;
 }}}
*/
if (IsCrossHair) {
    static float cnt = 0.0f;
    float r = cos(cnt) * .5f + .5f;
    float g = cos(cnt - 2.f * 3.14 / 3.f) * .5f + .5f;
    float b = cos(cnt - 4.f * 3.14 / 3.f) * .5f + .5f;
    
    if (cnt >= FLT_MAX) {
        cnt = 0.0f;
    } else {
        cnt += 0.01f;
    }

    memset(&ShootWeaponEntityComp->DeviationInfo, 0, sizeof(FSDeviation));
    
    ShootWeaponEntityComp->ShotGunCenterPerc = 0.0f;
    ShootWeaponEntityComp->ShotGunVerticalSpread = 0.0f;
    ShootWeaponEntityComp->ShotGunHorizontalSpread = 0.0f;
    ShootWeaponEntityComp->GameDeviationFactor = 0.0f;
    ShootWeaponEntityComp->GameDeviationAccuracy = 0.0f;

    // ⬇ Use the slider value instead of 0.0f
    ShootWeaponEntityComp->CrossHairInitialSize = crosshairSizeSlider;
    ShootWeaponEntityComp->CrossHairBurstSpeed = crosshairSizeSlider;
    ShootWeaponEntityComp->CrossHairBurstIncreaseSpeed = crosshairSizeSlider;

    ShootWeaponEntityComp->VehicleWeaponDeviationAngle = 0.0f;
}

                                                        if(IsHitXPL){
                                                            ShootWeaponEntityComp->ExtraHitPerformScale = 300;
                                                            ShootWeaponEntityComp->HUDAlphaDecreaseSpeedScale = 5.1f;
                                                        }
                                                       

if (CarFly) {
    if (localPlayer->CurrentVehicle) {

        static float CurrentHeight = 0.0f;  
        auto CurrentVehicle = localPlayer->CurrentVehicle;
        auto RootComponent = static_cast<UPrimitiveComponent*>(CurrentVehicle->K2_GetRootComponent());

        if (RootComponent) {
            if (localPlayer->CurrentVehicle->GetMoveForwardRate() > 0) {
                FVector Velocity;

                // Check if the car is below the desired height (500 meters)
                if (CurrentHeight < 70000.f) {  // 500 meters = 50000 cm
                    // Continue flying upwards
                    Velocity.X = carx;  // No horizontal movement
                    Velocity.Y = cary;  // No horizontal movement
                    Velocity.Z = carz;  // Vertical speed

                    // Update the current height based on the speed and time
                    CurrentHeight += Velocity.Z;  // This is a simplified approach

                    // Apply the velocity
                    RootComponent->SetAllPhysicsLinearVelocity(Velocity, true);
                } else {
                    
                    Velocity.Z = 0.f;
                    RootComponent->SetAllPhysicsLinearVelocity(Velocity, true);
                }
            }
        }
    }
}


if (localPlayer) {

    if (chaynhanhv2) {
        localPlayer->CharacterMovement->GravityScale = -15.f;
        localPlayer->CharacterMovement->JumpZVelocity = 10.f;
        localPlayer->CharacterMovement->JumpOffJumpZFactor = 10.f;
    }

    if (tudongnhay) {
        localPlayer->Jump();
    }

    if (IsFastDrop) {
        if (localPlayer->ParachuteComponent) {

            localPlayer->ParachuteComponent->CurrentFallSpeed = 8300.f;
            localPlayer->ParachuteComponent->FreeFall_AcceFall = 25000.f;
            localPlayer->ParachuteComponent->FreeFall_MaxFreeFallSpeed = 25000.f;
            localPlayer->ParachuteComponent->FreeFall_AcceForward = 25000.f;
            localPlayer->ParachuteComponent->FreeFall_MaxForwardExtraFallSpeed = 25000.f;

            localPlayer->ParachuteComponent->Opened_AcceFall = 5000.f;
            localPlayer->ParachuteComponent->Opened_MaxFreeFallSpeed = 5000.f;
            localPlayer->ParachuteComponent->Opened_AcceForward = 5000.f;
            localPlayer->ParachuteComponent->Opened_MaxForwardSpeed = 5000.f;
            localPlayer->ParachuteComponent->Opened_MaxForwardExtraFallSpeed = 5000.f;

            localPlayer->ParachuteComponent->AllowMaxDiatanceSqAtServer = 40000.f;
            localPlayer->ParachuteComponent->MaxZAllowDistance = 40000.f;
        }
    }
}


if(据点){
                                                          static float cnt = 0.0f;
                                                          float r = cos(cnt) * .5f + .5f;
                                                            float g = cos(cnt - 2.f * 3.14 / 3.f) * .5f + .5f;
                                                            float b = cos(cnt - 4.f * 3.14 / 3.f) * .5f + .5f;
                                                            if (cnt >= FLT_MAX) {
                                                                cnt = 0.0f;
                                                            } else {
                                                                cnt += 0.01f;
                                                            }
                                                            
                                                            memset(&ShootWeaponEntityComp->DeviationInfo, 0, sizeof(FSDeviation));
                                                            memset(&ShootWeaponEntityComp->RecoilInfo, 0, sizeof(FSRecoilInfo));
                                                            
                                                            ShootWeaponEntityComp->ShotGunCenterPerc = 0.0f;
                                                            ShootWeaponEntityComp->ShotGunVerticalSpread = 0.0f;
                                                            ShootWeaponEntityComp->ShotGunHorizontalSpread = 0.0f;
                                                            ShootWeaponEntityComp->GameDeviationFactor = 0.0f;
                                                            ShootWeaponEntityComp->GameDeviationAccuracy = 0.0f;
                                                            ShootWeaponEntityComp->CrossHairInitialSize = 0.0f;
                                                            ShootWeaponEntityComp->CrossHairBurstSpeed = 0.0f;
                                                            ShootWeaponEntityComp->CrossHairBurstIncreaseSpeed = 0.0f;
                                                            ShootWeaponEntityComp->VehicleWeaponDeviationAngle = 0.0f;
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                
                        if (ModSkinn) {
                            if (DeadBox) {
                                std::vector<APlayerTombBox *> TombBox;
                                GetAllActors(TombBox);
                                for (auto actor = TombBox.begin();
                                    actor != TombBox.end(); actor++) {
                                        auto TombBoxx = *actor;
                                        if (TombBoxx && TombBoxx->DamageCauser && TombBoxx->TargetPlayer && localPlayerController) // Check pointers before dereferencin
                                        {
                                            if (TombBoxx->DamageCauser->PlayerKey == localPlayerController->PlayerKey) {
                                                auto PlayerKey = TombBoxx->TargetPlayer->PlayerKey;
                                                if (AlreadyChangedSet.find(PlayerKey) == AlreadyChangedSet.end()) {
                                                if (localPlayer && localPlayer->WeaponManagerComponent) // Check pointers before dereferencing
                                                {
                                                    auto DeadBoxAvatarCompPtr = (uintptr_t*)((uintptr_t)TombBoxx + 0x718); //DeadBoxAvatarComponent_BP_C* DeadBoxAvatarComponent_BP
                                                    if (DeadBoxAvatarCompPtr) {
                                                        auto DeadBoxAvatarComp = *DeadBoxAvatarCompPtr;
                                                        auto CurrentWeaponReplicated = localPlayer->WeaponManagerComponent->CurrentWeaponReplicated;
                                                        if (CurrentWeaponReplicated) {

                                                            auto Weaponid = localPlayer->WeaponManagerComponent->CurrentWeaponReplicated->GetWeaponID();
                                                            if (Weaponid == 101004) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.M416_1);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            } else if (Weaponid == 101001) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.AKM);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }else if (Weaponid == 101002) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.M16A4);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 101003) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.Scar);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }else if (Weaponid == 101005) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.Groza);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }else if (Weaponid == 101100) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.Famas);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 101006) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.AUG);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 101007) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.QBZ);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 101008) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.M762);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 101102) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.ACE32);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 102001) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.UZI);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }else if (Weaponid == 102002) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.UMP);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }else if (Weaponid == 102003) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.Vector);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }else if (Weaponid == 102004) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.Thompson);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }else if (Weaponid == 102105) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.P90);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 102005) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.Bizon);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 103001) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.K98);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 103002) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.M24);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 103003) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.AWM);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 108001) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.Machete);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            
                                                            
                                                            else if (Weaponid == 103012) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.AMR);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 103007) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.MK14);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 103006) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.Mini14);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            
                                                            else if (Weaponid == 105002) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.DP28);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 105010) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.MG3);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 101012) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.Honey);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }

                                                            else if (Weaponid == 104001) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.S686);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            
                                                            else if (Weaponid == 104002) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.S1897);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }

                                                            else if (Weaponid == 104003) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.S12K);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            
                                                            
                                                            
                                                            else if (Weaponid == 104004) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.DBS);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 104102) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.NS2000);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                            else if (Weaponid == 105001) {
                                                                ChangeItemAVc(DeadBoxAvatarComp, new_Skin.M249);
                                                                AlreadyChangedSet.insert(PlayerKey);
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            if (localPlayer->WeaponManagerComponent != 0) {
                                if (localPlayer->WeaponManagerComponent->CurrentWeaponReplicated != 0 ) {
                                    int weapowep = localPlayer->WeaponManagerComponent->CurrentWeaponReplicated->GetWeaponID();
                                    auto currentTime = std::chrono::steady_clock::now();
                                    auto landchud = localPlayer->WeaponManagerComponent->CurrentWeaponReplicated->synData;
                                    auto timeDiff = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime - lastWeaponChangeTime).count();
                                    if (timeDiff > 1000) {
                                        for (int j = 0; j < landchud.Num(); j++) {
                                            auto& weaponInfo = landchud[j];
                                            auto weaponid = weaponInfo.DefineID.TypeSpecificID;
                                            if (weaponid != 0)
                                            {
                                                if (preferences.AKM && weapowep == 101001){
                                                    for (int i = 0; i < sizeof(akmv) / sizeof(akmv[0]); i++) {
                                                        if (weaponid == akmv[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AKM;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(akmmag) / sizeof(akmmag[0]); i++) {
                                                        if (weaponid == akmmag[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AKM_Mag;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(akreddot) / sizeof(akreddot[0]); i++) {
                                                        if (weaponid == akreddot[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AKM_reddot;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(akflash) / sizeof(akflash[0]); i++) {
                                                        if (weaponid == akflash[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AKM_flash;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(akcompe) / sizeof(akcompe[0]); i++) {
                                                        if (weaponid == akcompe[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AKM_compe;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(aksilent) / sizeof(aksilent[0]); i++) {
                                                        if (weaponid == aksilent[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AKM_silent;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(akholo) / sizeof(akholo[0]); i++) {
                                                        if (weaponid == akholo[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AKM_holo;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(akx2) / sizeof(akx2[0]); i++) {
                                                        if (weaponid == akx2[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AKM_x2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(akx3) / sizeof(akx3[0]); i++) {
                                                        if (weaponid == akx3[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AKM_x3;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(akx4) / sizeof(akx4[0]); i++) {
                                                        if (weaponid == akx4[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AKM_x4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(akx6) / sizeof(akx6[0]); i++) {
                                                        if (weaponid == akx6[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AKM_x6;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(akextendedMag) / sizeof(akextendedMag[0]); i++) {
                                                        if (weaponid == akextendedMag[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AKM_extendedMag;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(akquickNextended) / sizeof(akquickNextended[0]); i++) {
                                                        if (weaponid == akquickNextended[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AKM_quickNextended;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.KAR98 && weapowep == 103001){
                                                    for (int i = 0; i < sizeof(kar) / sizeof(kar[0]); i++) {
                                                        if (weaponid == kar[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.K98;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(karreddot) / sizeof(karreddot[0]); i++) {
                                                        if (weaponid == karreddot[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.K98_reddot;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(karholo) / sizeof(karholo[0]); i++) {
                                                        if (weaponid == karholo[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.K98_holo;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(karx2) / sizeof(karx2[0]); i++) {
                                                        if (weaponid == karx2[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.K98_x2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(karx3) / sizeof(karx3[0]); i++) {
                                                        if (weaponid == karx3[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.K98_x3;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(karx4) / sizeof(karx4[0]); i++) {
                                                        if (weaponid == karx4[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.K98_x4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(karx6) / sizeof(karx6[0]); i++) {
                                                        if (weaponid == karx6[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.K98_x6;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(karx8) / sizeof(karx8[0]); i++) {
                                                        if (weaponid == karx8[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.K98_x8;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.M24 && weapowep == 103002){
                                                    for (int i = 0; i < sizeof(m24) / sizeof(m24[0]); i++) {
                                                        if (weaponid == m24[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M24;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(m24reddot) / sizeof(m24reddot[0]); i++) {
                                                        if (weaponid == m24reddot[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M24_reddot;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(m24holo) / sizeof(m24holo[0]); i++) {
                                                        if (weaponid == m24holo[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M24_holo;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m24x2) / sizeof(m24x2[0]); i++) {
                                                        if (weaponid == m24x2[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M24_x2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m24x3) / sizeof(m24x3[0]); i++) {
                                                        if (weaponid == m24x3[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M24_x3;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m24x4) / sizeof(m24x4[0]); i++) {
                                                        if (weaponid == m24x4[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M24_x4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m24x6) / sizeof(m24x6[0]); i++) {
                                                        if (weaponid == m24x6[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M24_x6;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m24x8) / sizeof(m24x8[0]); i++) {
                                                        if (weaponid == m24x8[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M24_x8;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.AWM && weapowep == 103003){
                                                    for (int i = 0; i < sizeof(awm) / sizeof(awm[0]); i++) {
                                                        if (weaponid == awm[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AWM;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(awmreddot) / sizeof(awmreddot[0]); i++) {
                                                        if (weaponid == awmreddot[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AWM_reddot;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(awmholo) / sizeof(awmholo[0]); i++) {
                                                        if (weaponid == awmholo[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AWM_holo;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(awmx2) / sizeof(awmx2[0]); i++) {
                                                        if (weaponid == awmx2[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AWM_x2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(awmx3) / sizeof(awmx3[0]); i++) {
                                                        if (weaponid == awmx3[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AWM_x3;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(awmx4) / sizeof(awmx4[0]); i++) {
                                                        if (weaponid == awmx4[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AWM_x4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(awmx6) / sizeof(awmx6[0]); i++) {
                                                        if (weaponid == awmx6[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AWM_x6;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(awmx8) / sizeof(awmx8[0]); i++) {
                                                        if (weaponid == awmx8[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AWM_x8;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.Machete && weapowep == 108001){
                                                    for (int i = 0; i < sizeof(machete) / sizeof(machete[0]); i++) {
                                                        if (weaponid == machete[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Machete;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.AMR && weapowep == 103012){
                                                    for (int i = 0; i < sizeof(amr) / sizeof(amr[0]); i++) {
                                                        if (weaponid == amr[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AMR;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(amrreddot) / sizeof(amrreddot[0]); i++) {
                                                        if (weaponid == amrreddot[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AMR_reddot;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(amrholo) / sizeof(amrholo[0]); i++) {
                                                        if (weaponid == amrholo[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AMR_holo;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(amrx2) / sizeof(amrx2[0]); i++) {
                                                        if (weaponid == amrx2[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AMR_x2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(amrx3) / sizeof(amrx3[0]); i++) {
                                                        if (weaponid == amrx3[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AMR_x3;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(amrx4) / sizeof(amrx4[0]); i++) {
                                                        if (weaponid == amrx4[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AMR_x4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(amrx6) / sizeof(amrx6[0]); i++) {
                                                        if (weaponid == amrx6[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AMR_x6;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(amrx8) / sizeof(amrx8[0]); i++) {
                                                        if (weaponid == amrx8[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AMR_x8;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.MINI14 && weapowep == 103006){
                                                    for (int i = 0; i < sizeof(mini14) / sizeof(mini14[0]); i++) {
                                                        if (weaponid == mini14[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Mini14;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.TOMMY && weapowep == 102004){
                                                    for (int i = 0; i < sizeof(tommy) / sizeof(tommy[0]); i++) {
                                                        if (weaponid == tommy[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Thompson;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.P90 && weapowep == 102105){
                                                    for (int i = 0; i < sizeof(p90) / sizeof(p90[0]); i++) {
                                                        if (weaponid == p90[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.P90;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.ACE32 && weapowep == 101102){
                                                    for (int i = 0; i < sizeof(ace32) / sizeof(ace32[0]); i++) {
                                                        if (weaponid == ace32[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.ACE32;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(ace32) / sizeof(ace32[0]); i++) {
                                                        if (weaponid == ace32[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.ACE32;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(ace32reddot) / sizeof(ace32reddot[0]); i++) {
                                                        if (weaponid == ace32reddot[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.ACE32_reddot;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(ace32holo) / sizeof(ace32holo[0]); i++) {
                                                        if (weaponid == ace32holo[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.ACE32_holo;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(ace32x2) / sizeof(ace32x2[0]); i++) {
                                                        if (weaponid == ace32x2[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.ACE32_x2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(ace32x3) / sizeof(ace32x3[0]); i++) {
                                                        if (weaponid == ace32x3[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.ACE32_x3;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(ace32x4) / sizeof(ace32x4[0]); i++) {
                                                        if (weaponid == ace32x4[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.ACE32_x4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(ace32x6) / sizeof(ace32x6[0]); i++) {
                                                        if (weaponid == ace32x6[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.ACE32_x6;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.MK14 && weapowep == 1030075) {
                                                  for (int i = 0; i < sizeof(MK14) / sizeof(MK14[0]); i++) {
                                                  if (weaponid == MK14[i]) {
                                                      weaponInfo.DefineID.TypeSpecificID = new_Skin.MK14;
                                                      break;
                                                   }
                                                  }
                                                  for (int i = 0; i < sizeof(MK14_4) / sizeof(MK14_4[0]); i++) {
                                                  if (weaponid == scarmag[i]) {
                                                      weaponInfo.DefineID.TypeSpecificID = new_Skin.MK14_4;
                                                      break;
                                                   }
                                                  }
                                                  for (int i = 0; i < sizeof(MK14_2) / sizeof(MK14_2[0]); i++) {
                                                  if (weaponid == MK14_2[i]) {
                                                      weaponInfo.DefineID.TypeSpecificID = new_Skin.MK14_2;
                                                      break;
                                                   }
                                                  }
                                                  for (int i = 0; i < sizeof(MK14_5) / sizeof(MK14_5[0]); i++) {
                                                  if (weaponid == MK14_5[i]) {
                                                      weaponInfo.DefineID.TypeSpecificID = new_Skin.MK14_5;
                                                      break;
                                                   }
                                                  }
                                                  for (int i = 0; i < sizeof(MK14_6) / sizeof(MK14_6[0]); i++) {
                                                  if (weaponid == MK14_6[i]) {
                                                      weaponInfo.DefineID.TypeSpecificID = new_Skin.MK14_6;
                                                      break;
                                                   }
                                                  }
                                                  for (int i = 0; i < sizeof(MK14_10) / sizeof(MK14_10[0]); i++) {
                                                  if (weaponid == MK14_10[i]) {
                                                      weaponInfo.DefineID.TypeSpecificID = new_Skin.MK14_10;
                                                      break;
                                                   }
                                                  }
                                                  for (int i = 0; i < sizeof(MK14_11) / sizeof(MK14_11[0]); i++) {
                                                  if (weaponid == MK14_11[i]) {
                                                      weaponInfo.DefineID.TypeSpecificID = new_Skin.MK14_11;
                                                      break;
                                                   }
                                                  }
                                                  for (int i = 0; i < sizeof(MK14_12) / sizeof(MK14_12[0]); i++) {
                                                  if (weaponid == MK14_12[i]) {
                                                      weaponInfo.DefineID.TypeSpecificID = new_Skin.MK14_12;
                                                      break;
                                                   }
                                                  }
                                                  for (int i = 0; i < sizeof(MK14_13) / sizeof(MK14_13[0]); i++) {
                                                  if (weaponid == MK14_13[i]) {
                                                      weaponInfo.DefineID.TypeSpecificID = new_Skin.MK14_13;
                                                      break;
                                                   }
                                                  }
                                                  for (int i = 0; i < sizeof(MK14_14) / sizeof(MK14_14[0]); i++) {
                                                  if (weaponid == MK14_14[i]) {
                                                      weaponInfo.DefineID.TypeSpecificID = new_Skin.MK14_14;
                                                      break;
                                                   }
                                                  }
                                                  for (int i = 0; i < sizeof(MK14_15) / sizeof(MK14_15[0]); i++) {
                                                  if (weaponid == MK14_15[i]) {
                                                      weaponInfo.DefineID.TypeSpecificID = new_Skin.MK14_15;
                                                      break;
                                                   }
                                                  }
                                                    for (int i = 0; i < sizeof(longyin8888) / sizeof(longyin8888[0]); i++) {
                                                     if (weaponid == longyin8888[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x8888;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin1111) / sizeof(longyin1111[0]); i++) {
                                                     if (weaponid == longyin1111[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x1111;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin2222) / sizeof(longyin2222[0]); i++) {
                                                     if (weaponid == longyin2222[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x2222;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin3333) / sizeof(longyin3333[0]); i++) {
                                                     if (weaponid == longyin3333[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x3333;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin4444) / sizeof(longyin4444[0]); i++) {
                                                     if (weaponid == longyin4444[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x4444;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin6666) / sizeof(longyin6666[0]); i++) {
                                                     if (weaponid == longyin6666[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x6666;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb) / sizeof(tuosb[0]); i++) {
                                                     if (weaponid == tuosb[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb1) / sizeof(tuosb1[0]); i++) {
                                                     if (weaponid == tuosb1[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb1;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb2) / sizeof(tuosb2[0]); i++) {
                                                     if (weaponid == tuosb2[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb2;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb3) / sizeof(tuosb3[0]); i++) {
                                                     if (weaponid == tuosb3[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb3;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb4) / sizeof(tuosb4[0]); i++) {
                                                     if (weaponid == tuosb4[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb4;
                                                         break;
                                                      }
                                                     }
                                                }
                                                if (preferences.MK147 && weapowep == 1030072){
                                                     for (int i = 0; i < sizeof(mk147) / sizeof(mk147[0]); i++) {
                                                     if (weaponid == mk147[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.MK147;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin8888) / sizeof(longyin8888[0]); i++) {
                                                     if (weaponid == longyin8888[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x8888;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin1111) / sizeof(longyin1111[0]); i++) {
                                                     if (weaponid == longyin1111[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x1111;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin2222) / sizeof(longyin2222[0]); i++) {
                                                     if (weaponid == longyin2222[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x2222;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin3333) / sizeof(longyin3333[0]); i++) {
                                                     if (weaponid == longyin3333[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x3333;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin4444) / sizeof(longyin4444[0]); i++) {
                                                     if (weaponid == longyin4444[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x4444;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin6666) / sizeof(longyin6666[0]); i++) {
                                                     if (weaponid == longyin6666[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x6666;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb) / sizeof(tuosb[0]); i++) {
                                                     if (weaponid == tuosb[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb1) / sizeof(tuosb1[0]); i++) {
                                                     if (weaponid == tuosb1[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb1;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb2) / sizeof(tuosb2[0]); i++) {
                                                     if (weaponid == tuosb2[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb2;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb3) / sizeof(tuosb3[0]); i++) {
                                                     if (weaponid == tuosb3[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb3;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb4) / sizeof(tuosb4[0]); i++) {
                                                     if (weaponid == tuosb4[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb4;
                                                         break;
                                                      }
                                                     }
                                                }
                                                if (preferences.MK146 && weapowep == 1030074){
                                                     for (int i = 0; i < sizeof(mk146) / sizeof(mk146[0]); i++) {
                                                     if (weaponid == mk146[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.MK146;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin8888) / sizeof(longyin8888[0]); i++) {
                                                     if (weaponid == longyin8888[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x8888;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin1111) / sizeof(longyin1111[0]); i++) {
                                                     if (weaponid == longyin1111[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x1111;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin2222) / sizeof(longyin2222[0]); i++) {
                                                     if (weaponid == longyin2222[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x2222;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin3333) / sizeof(longyin3333[0]); i++) {
                                                     if (weaponid == longyin3333[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x3333;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin4444) / sizeof(longyin4444[0]); i++) {
                                                     if (weaponid == longyin4444[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x4444;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin6666) / sizeof(longyin6666[0]); i++) {
                                                     if (weaponid == longyin6666[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x6666;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb) / sizeof(tuosb[0]); i++) {
                                                     if (weaponid == tuosb[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb1) / sizeof(tuosb1[0]); i++) {
                                                     if (weaponid == tuosb1[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb1;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb2) / sizeof(tuosb2[0]); i++) {
                                                     if (weaponid == tuosb2[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb2;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb3) / sizeof(tuosb3[0]); i++) {
                                                     if (weaponid == tuosb3[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb3;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb4) / sizeof(tuosb4[0]); i++) {
                                                     if (weaponid == tuosb4[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb4;
                                                         break;
                                                      }
                                                     }
                                                }
                                                if (preferences.MK148 && weapowep == 1030073){
                                                     for (int i = 0; i < sizeof(mk148) / sizeof(mk148[0]); i++) {
                                                     if (weaponid == mk148[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.MK148;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin8888) / sizeof(longyin8888[0]); i++) {
                                                     if (weaponid == longyin8888[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x8888;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin1111) / sizeof(longyin1111[0]); i++) {
                                                     if (weaponid == longyin1111[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x1111;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin2222) / sizeof(longyin2222[0]); i++) {
                                                     if (weaponid == longyin2222[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x2222;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin3333) / sizeof(longyin3333[0]); i++) {
                                                     if (weaponid == longyin3333[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x3333;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin4444) / sizeof(longyin4444[0]); i++) {
                                                     if (weaponid == longyin4444[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x4444;
                                                         break;
                                                     }
                                                    }
                                                    for (int i = 0; i < sizeof(longyin6666) / sizeof(longyin6666[0]); i++) {
                                                     if (weaponid == longyin6666[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.longyin_x6666;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb) / sizeof(tuosb[0]); i++) {
                                                     if (weaponid == tuosb[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb1) / sizeof(tuosb1[0]); i++) {
                                                     if (weaponid == tuosb1[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb1;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb2) / sizeof(tuosb2[0]); i++) {
                                                     if (weaponid == tuosb2[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb2;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb3) / sizeof(tuosb3[0]); i++) {
                                                     if (weaponid == tuosb3[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb3;
                                                         break;
                                                      }
                                                     }
                                                    for (int i = 0; i < sizeof(tuosb4) / sizeof(tuosb4[0]); i++) {
                                                     if (weaponid == tuosb4[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.tuosb4;
                                                         break;
                                                      }
                                                     }
                                                }
                                                if (preferences.BIZON && weapowep == 102005){
                                                    for (int i = 0; i < sizeof(bizon) / sizeof(bizon[0]); i++) {
                                                        if (weaponid == bizon[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Bizon;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.VECTOR && weapowep == 102003){
                                                    for (int i = 0; i < sizeof(vectorr) / sizeof(vectorr[0]); i++) {
                                                        if (weaponid == vectorr[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Vector;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.UMP && weapowep == 102002){
                                                    for (int i = 0; i < sizeof(ump) / sizeof(ump[0]); i++) {
                                                     if (weaponid == ump[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpmag) / sizeof(umpmag[0]); i++) {
                                                     if (weaponid == umpmag[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_2;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpflash) / sizeof(umpflash[0]); i++) {
                                                     if (weaponid == umpflash[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_flash;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpcompe) / sizeof(umpcompe[0]); i++) {
                                                     if (weaponid == umpcompe[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_compe;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpsilent) / sizeof(umpsilent[0]); i++) {
                                                     if (weaponid == umpsilent[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_silent;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpreddot) / sizeof(umpreddot[0]); i++) {
                                                     if (weaponid == umpreddot[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_reddot;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpholo) / sizeof(umpholo[0]); i++) {
                                                     if (weaponid == umpholo[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_holo;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpx2) / sizeof(umpx2[0]); i++) {
                                                     if (weaponid == umpx2[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_x2;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpx3) / sizeof(umpx3[0]); i++) {
                                                     if (weaponid == umpx3[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_x3;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpx4) / sizeof(umpx4[0]); i++) {
                                                     if (weaponid == umpx4[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_x4;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpx6) / sizeof(umpx6[0]); i++) {
                                                     if (weaponid == umpx6[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_x6;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpquickMag) / sizeof(umpquickMag[0]); i++) {
                                                     if (weaponid == umpquickMag[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_quickMag;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpextendedMag) / sizeof(umpextendedMag[0]); i++) {
                                                     if (weaponid == umpextendedMag[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_extendedMag;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpquickNextended) / sizeof(umpquickNextended[0]); i++) {
                                                     if (weaponid == umpquickNextended[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_quickNextended;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpverical) / sizeof(umpverical[0]); i++) {
                                                     if (weaponid == umpverical[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_verical;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpangle) / sizeof(umpangle[0]); i++) {
                                                     if (weaponid == umpangle[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_angle;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umplightgrip) / sizeof(umplightgrip[0]); i++) {
                                                     if (weaponid == umplightgrip[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_lightgrip;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umppink) / sizeof(umppink[0]); i++) {
                                                     if (weaponid == umppink[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_pink;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umplazer) / sizeof(umplazer[0]); i++) {
                                                     if (weaponid == umplazer[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_lazer;
                                                         break;
                                                      }
                                                     }
                                                     for (int i = 0; i < sizeof(umpthumb) / sizeof(umpthumb[0]); i++) {
                                                     if (weaponid == umpthumb[i]) {
                                                         weaponInfo.DefineID.TypeSpecificID = new_Skin.UMP_thumb;
                                                         break;
                                                      }
                                                     }
                                                }
                                                if (preferences.UZI && weapowep == 102001){
                                                    for (int i = 0; i < sizeof(uzi) / sizeof(uzi[0]); i++) {
                                                        if (weaponid == uzi[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.UZI;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.M164 && weapowep == 101002){
                                                    for (int i = 0; i < sizeof(m16) / sizeof(m16[0]); i++) {
                                                        if (weaponid == m16[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M16A4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m16s) / sizeof(m16s[0]); i++) {
                                                        if (weaponid == m16s[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M16A4_Stock;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m16mag) / sizeof(m16mag[0]); i++) {
                                                        if (weaponid == m16mag[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M16A4_Mag;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.PAN && weapowep == 108004){
                                                    for (int i = 0; i < sizeof(pan) / sizeof(pan[0]); i++) {
                                                        if (weaponid == pan[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Pan;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.AUG && weapowep == 101006){
                                                    for (int i = 0; i < sizeof(aug) / sizeof(aug[0]); i++) {
                                                        if (weaponid == aug[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AUG;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(aug) / sizeof(aug[0]); i++) {
                                                        if (weaponid == aug[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AUG;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(augreddot) / sizeof(augreddot[0]); i++) {
                                                        if (weaponid == augreddot[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AUG_reddot;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(augholo) / sizeof(augholo[0]); i++) {
                                                        if (weaponid == augholo[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AUG_holo;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(augx2) / sizeof(augx2[0]); i++) {
                                                        if (weaponid == augx2[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AUG_x2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(augx3) / sizeof(augx3[0]); i++) {
                                                        if (weaponid == augx3[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AUG_x3;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(augx4) / sizeof(augx4[0]); i++) {
                                                        if (weaponid == augx4[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AUG_x4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(augx6) / sizeof(augx6[0]); i++) {
                                                        if (weaponid == augx6[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AUG_x6;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(augLazer) / sizeof(augLazer[0]); i++) {
                                                        if (weaponid == augLazer[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AUG_lazer;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(augFlash) / sizeof(augFlash[0]); i++) {
                                                        if (weaponid == augFlash[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AUG_flash;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.QBZ && weapowep == 101007){
                                                    for (int i = 0; i < sizeof(qbz) / sizeof(qbz[0]); i++) {
                                                        if (weaponid == qbz[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.QBZ;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.GROZA && weapowep == 101005){
                                                    for (int i = 0; i < sizeof(groza) / sizeof(groza[0]); i++) {
                                                        if (weaponid == groza[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Groza;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(Groza_2) / sizeof(Groza_2[0]); i++) {
                                                        if (weaponid == Groza_2[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Groza_2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(grozasilent) / sizeof(grozasilent[0]); i++) {
                                                        if (weaponid == grozasilent[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Groza_silent;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(grozareddot) / sizeof(grozareddot[0]); i++) {
                                                        if (weaponid == grozareddot[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Groza_reddot;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(grozaholo) / sizeof(grozaholo[0]); i++) {
                                                        if (weaponid == grozaholo[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Groza_holo;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(grozax2) / sizeof(grozax2[0]); i++) {
                                                        if (weaponid == grozax2[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Groza_x2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(grozax3) / sizeof(grozax3[0]); i++) {
                                                        if (weaponid == grozax3[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Groza_x3;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(grozax4) / sizeof(grozax4[0]); i++) {
                                                        if (weaponid == grozax4[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Groza_x4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(grozax6) / sizeof(grozax6[0]); i++) {
                                                        if (weaponid == grozax6[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Groza_x6;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(grozaquickMag) / sizeof(grozaquickMag[0]); i++) {
                                                        if (weaponid == grozaquickMag[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Groza_quickMag;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(grozaextendedMag) / sizeof(grozaextendedMag[0]); i++) {
                                                        if (weaponid == grozaextendedMag[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Groza_extendedMag;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(grozaquickNextended) / sizeof(grozaquickNextended[0]); i++) {
                                                        if (weaponid == grozaquickNextended[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Groza_quickNextended;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.FAMAS && weapowep == 101100){
                                                    for (int i = 0; i < sizeof(famas) / sizeof(famas[0]); i++) {
                                                        if (weaponid == famas[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Famas;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(famas) / sizeof(famas[0]); i++) {
                                                        if (weaponid == famas[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Famas;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(famasreddot) / sizeof(famasreddot[0]); i++) {
                                                        if (weaponid == famasreddot[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AMR_reddot;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(famasholo) / sizeof(famasholo[0]); i++) {
                                                        if (weaponid == famasholo[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.AMR_holo;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(famasx2) / sizeof(famasx2[0]); i++) {
                                                        if (weaponid == famasx2[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Famas_x2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(famasx3) / sizeof(famasx3[0]); i++) {
                                                        if (weaponid == famasx3[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Famas_x3;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(famasx4) / sizeof(famasx4[0]); i++) {
                                                        if (weaponid == famasx4[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Famas_x4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(famasx6) / sizeof(famasx6[0]); i++) {
                                                        if (weaponid == famasx6[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Famas_x6;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.DP28 && weapowep == 105002){
                                                    for (int i = 0; i < sizeof(dp) / sizeof(dp[0]); i++) {
                                                        if (weaponid == dp[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.DP28;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.MG3 && weapowep == 105010){
                                                    for (int i = 0; i < sizeof(mg3) / sizeof(mg3[0]); i++) {
                                                        if (weaponid == mg3[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.MG3;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(mg3reddot) / sizeof(mg3reddot[0]); i++) {
                                                        if (weaponid == mg3reddot[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.MG3_reddot;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(mg3holo) / sizeof(mg3holo[0]); i++) {
                                                        if (weaponid == mg3holo[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.MG3_holo;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(mg3x2) / sizeof(mg3x2[0]); i++) {
                                                        if (weaponid == mg3x2[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.MG3_x2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(mg3x3) / sizeof(mg3x3[0]); i++) {
                                                        if (weaponid == mg3x3[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.MG3_x3;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(mg3x4) / sizeof(mg3x4[0]); i++) {
                                                        if (weaponid == mg3x4[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.MG3_x4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(mg3x6) / sizeof(mg3x6[0]); i++) {
                                                        if (weaponid == mg3x6[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.MG3_x6;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.Honey && weapowep == 101012){
                                                    for (int i = 0; i < sizeof(honey) / sizeof(honey[0]); i++) {
                                                        if (weaponid == honey[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Honey;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.S12K && weapowep == 104003){
                                                    for (int i = 0; i < sizeof(s12k) / sizeof(s12k[0]); i++) {
                                                        if (weaponid == s12k[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.S12K;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.S686 && weapowep == 104001){
                                                    for (int i = 0; i < sizeof(s686) / sizeof(s686[0]); i++) {
                                                        if (weaponid == s686[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.S686;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.S1897 && weapowep == 104002){
                                                    for (int i = 0; i < sizeof(s1897) / sizeof(s1897[0]); i++) {
                                                        if (weaponid == s1897[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.S1897;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.DBS && weapowep == 104004){
                                                    for (int i = 0; i < sizeof(dbs) / sizeof(dbs[0]); i++) {
                                                        if (weaponid == dbs[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.DBS;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.NS2000 && weapowep == 104102){
                                                    for (int i = 0; i < sizeof(ns2000) / sizeof(ns2000[0]); i++) {
                                                        if (weaponid == ns2000[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.NS2000;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.M249 && weapowep == 105001){
                                                    for (int i = 0; i < sizeof(m249) / sizeof(m249[0]); i++) {
                                                        if (weaponid == m249[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M249;
                                                            break;
                                                        }
                                                    }
                                                     for (int i = 0; i < sizeof(m249s) / sizeof(m249s[0]); i++) {
                                                     if (weaponid == m249s[i]) {
                                                     weaponInfo.DefineID.TypeSpecificID = new_Skin.M249s;
                                                     break;
                                                     }
                                                     }
                                                }
                                                if (preferences.SCARL && weapowep == 101003){
                                                    for (int i = 0; i < sizeof(scar) / sizeof(scar[0]); i++) {
                                                        if (weaponid == scar[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarmag) / sizeof(scarmag[0]); i++) {
                                                        if (weaponid == scarmag[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_Mag;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarsight) / sizeof(scarsight[0]); i++) {
                                                        if (weaponid == scarsight[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_3;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarflash) / sizeof(scarflash[0]); i++) {
                                                        if (weaponid == scarflash[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_flash;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarcompe) / sizeof(scarcompe[0]); i++) {
                                                        if (weaponid == scarcompe[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_compe;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarsilent) / sizeof(scarsilent[0]); i++) {
                                                        if (weaponid == scarsilent[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_silent;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarreddot) / sizeof(scarreddot[0]); i++) {
                                                        if (weaponid == scarreddot[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_reddot;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarholo) / sizeof(scarholo[0]); i++) {
                                                        if (weaponid == scarholo[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_holo;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarx2) / sizeof(scarx2[0]); i++) {
                                                        if (weaponid == scarx2[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_x2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarx3) / sizeof(scarx3[0]); i++) {
                                                        if (weaponid == scarx3[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_x3;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarx4) / sizeof(scarx4[0]); i++) {
                                                        if (weaponid == scarx4[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_x4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarx6) / sizeof(scarx6[0]); i++) {
                                                        if (weaponid == scarx6[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_x6;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarquickMag) / sizeof(scarquickMag[0]); i++) {
                                                        if (weaponid == scarquickMag[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_quickMag;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarextendedMag) / sizeof(scarextendedMag[0]); i++) {
                                                        if (weaponid == scarextendedMag[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_extendedMag;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarquickNextended) / sizeof(scarquickNextended[0]); i++) {
                                                        if (weaponid == scarquickNextended[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_quickNextended;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarverical) / sizeof(scarverical[0]); i++) {
                                                        if (weaponid == scarverical[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_verical;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarangle) / sizeof(scarangle[0]); i++) {
                                                        if (weaponid == scarangle[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_angle;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarlightgrip) / sizeof(scarlightgrip[0]); i++) {
                                                        if (weaponid == scarlightgrip[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_lightgrip;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarpink) / sizeof(scarpink[0]); i++) {
                                                        if (weaponid == scarpink[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_pink;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarlazer) / sizeof(scarlazer[0]); i++) {
                                                        if (weaponid == scarlazer[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_lazer;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(scarthumb) / sizeof(scarthumb[0]); i++) {
                                                        if (weaponid == scarthumb[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.Scar_thumb;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.M762 && weapowep == 101008){
                                                    for (int i = 0; i < sizeof(m7) / sizeof(m7[0]); i++) {
                                                        if (weaponid == m7[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M762;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(m7) / sizeof(m7[0]); i++) {
                                                        if (weaponid == m7[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M762;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    for (int i = 0; i < sizeof(m7mag) / sizeof(m7mag[0]); i++) {
                                                        if (weaponid == m7mag[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M762_Mag;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(m7reddot) / sizeof(m7reddot[0]); i++) {
                                                        if (weaponid == m7reddot[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M762_reddot;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    for (int i = 0; i < sizeof(m7holo) / sizeof(m7holo[0]); i++) {
                                                        if (weaponid == m7holo[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M762_holo;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m7x2) / sizeof(m7x2[0]); i++) {
                                                        if (weaponid == m7x2[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M762_x2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m7x3) / sizeof(m7x3[0]); i++) {
                                                        if (weaponid == m7x3[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M762_x3;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m7x4) / sizeof(m7x4[0]); i++) {
                                                        if (weaponid == m7x4[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M762_x4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m7x6) / sizeof(m7x6[0]); i++) {
                                                        if (weaponid == m7x6[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M762_x6;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m7Lazer) / sizeof(m7Lazer[0]); i++) {
                                                        if (weaponid == m7Lazer[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M762_lazer;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m7Flash) / sizeof(m7Flash[0]); i++) {
                                                        if (weaponid == m7Flash[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M762_flash;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (preferences.M416 && weapowep == 101004) {
                                                    for (int i = 0; i < sizeof(m4v) / sizeof(m4v[0]); i++) {
                                                        if (weaponid == m4v[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M416_1;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m4mag) / sizeof(m4mag[0]); i++) {
                                                        if (weaponid == m4mag[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M416_2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m4sight) / sizeof(m4sight[0]); i++) {
                                                        if (weaponid == m4sight[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M416_3;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m4stock) / sizeof(m4stock[0]); i++) {
                                                        if (weaponid == m4stock[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M416_4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m4stock1) / sizeof(m4stock1[0]); i++) {
                                                        if (weaponid == m4stock1[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M416_stock;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m4reddot) / sizeof(m4reddot[0]); i++) {
                                                        if (weaponid == m4reddot[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M416_reddot;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m4holo) / sizeof(m4holo[0]); i++) {
                                                        if (weaponid == m4holo[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M416_holo;
                                                            break;
                                                        }
                                                    }
                                                    
                                                    for (int i = 0; i < sizeof(m4x2) / sizeof(m4x2[0]); i++) {
                                                        if (weaponid == m4x2[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M416_x2;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m4x3) / sizeof(m4x3[0]); i++) {
                                                        if (weaponid == m4x3[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M416_x3;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m4x4) / sizeof(m4x4[0]); i++) {
                                                        if (weaponid == m4x4[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M416_x4;
                                                            break;
                                                        }
                                                    }
                                                    for (int i = 0; i < sizeof(m4x6) / sizeof(m4x6[0]); i++) {
                                                        if (weaponid == m4x6[i]) {
                                                            weaponInfo.DefineID.TypeSpecificID = new_Skin.M416_x6;
                                                            break;
                                                        }
                                                    }
                                                }
                                                localPlayer->WeaponManagerComponent->CurrentWeaponReplicated->DelayHandleAvatarMeshChanged();
                                                lastWeaponChangeTime = currentTime;
                                            }
                                        }
                                    }
                                }
                            }
                            if (localPlayer -> CurrentVehicle) {
                                if (localPlayer -> CurrentVehicle -> VehicleAvatar) {
                                    std::string SkinIDStr = std::to_string((int) localPlayer -> CurrentVehicle -> VehicleAvatar -> GetDefaultAvatarID());
                                    Active::SkinCarDefault = localPlayer -> CurrentVehicle -> GetAvatarID();
                                    
                                    
                                    if (preferences.Moto && strstr(SkinIDStr.c_str(), "1901")) {
                                        Active::SkinCarMod = new_Skin.Moto;
                                        Active::SkinCarNew = true;
                                    } else if (preferences.Dacia && strstr(SkinIDStr.c_str(), "1903")) {
                                        Active::SkinCarMod = new_Skin.Dacia;
                                        Active::SkinCarNew = true;
                                    } else if (preferences.Boat && strstr(SkinIDStr.c_str(), "1911")) {
                                        Active::SkinCarMod = new_Skin.Boat;
                                        Active::SkinCarNew = true;
                                    } else if (preferences.MiniBus && strstr(SkinIDStr.c_str(), "1904")) {
                                        Active::SkinCarMod = new_Skin.MiniBus;
                                        Active::SkinCarNew = true;
                                    } else if (preferences.Mirado && strstr(SkinIDStr.c_str(), "1914")) {
                                        Active::SkinCarMod = new_Skin.Mirado;
                                        Active::SkinCarNew = true;
                                    } else if (preferences.Mirado && strstr(SkinIDStr.c_str(), "1915")) {
                                        Active::SkinCarMod = new_Skin.Mirado;
                                        Active::SkinCarNew = true;
                                    } else if (preferences.Buggy && strstr(SkinIDStr.c_str(), "1907")) {
                                        Active::SkinCarMod = new_Skin.Buggy;
                                        Active::SkinCarNew = true;
                                    }else if (preferences.CoupeRB && strstr(SkinIDStr.c_str(), "1961")) {
                                        Active::SkinCarMod = new_Skin.CoupeRP;
                                        Active::SkinCarNew = true;
                                    } else if (preferences.BigFoot && strstr(SkinIDStr.c_str(), "1953")) {
                                        Active::SkinCarMod = new_Skin.Bigfoot;
                                        Active::SkinCarNew = true;
                                    } else if (preferences.RZR && strstr(SkinIDStr.c_str(), "1966")) {
                                        Active::SkinCarMod = new_Skin.RZR;
                                        Active::SkinCarNew = true;
                                    } else if (preferences.Rony && strstr(SkinIDStr.c_str(), "1916")) {
                                        Active::SkinCarMod = new_Skin.Rony;
                                        Active::SkinCarNew = true;
                                    } else if (preferences.UAZ && strstr(SkinIDStr.c_str(), "1908")) {
                                        Active::SkinCarMod = new_Skin.UAZ;
                                        Active::SkinCarNew = true;
                                    } else Active::SkinCarNew = false;
                                    
                                    if (Active::SkinCarDefault != Active::SkinCarMod && Active::SkinCarNew) {
                                        
                                        localPlayer -> CurrentVehicle -> VehicleAvatar -> ChangeItemAvatar(Active::SkinCarMod, true);
                                    }
                                }
                            }
                            if (BagGun) {
                                if (auto *Backpack = localPlayerController->GetBackpackComponent()) {
                                    FIncNetArray &bagparr = Backpack->ItemListNet;
                                    auto &bagarr = bagparr.IncArray;
                                    bool Shit2 = false;

                                    for (int j = 0; j < bagarr.Num(); j++) {
                                        if (!bagarr.IsValidIndex(j))
                                            continue;

                                        int ID = bagarr[j].Unit.DefineID.TypeSpecificID;
                                        auto &AdditionalData = bagarr[j].Unit.AdditionalData;
                                        int NewSkinID = -1;

                                        if (preferences.M416 && std::find(std::begin(m4v), std::end(m4v), ID) != std::end(m4v)) { NewSkinID = new_Skin.M416_1; }
                                        else if (preferences.MK14 && std::find(std::begin(mk14), std::end(mk14), ID) != std::end(mk14)) { NewSkinID = new_Skin.MK14; }
                                        else if (preferences.AMR && std::find(std::begin(amr), std::end(amr), ID) != std::end(amr)) { NewSkinID = new_Skin.AMR; }
                                        else if (preferences.MG3 && std::find(std::begin(mg3), std::end(mg3), ID) != std::end(mg3)) { NewSkinID = new_Skin.MG3; }
                                        else if (preferences.S12K && std::find(std::begin(s12k), std::end(s12k), ID) != std::end(s12k)) { NewSkinID = new_Skin.S12K; }
                                        else if (preferences.DBS && std::find(std::begin(dbs), std::end(dbs), ID) != std::end(dbs)) { NewSkinID = new_Skin.DBS; }
                                        else if (preferences.S1897 && std::find(std::begin(s1897), std::end(s1897), ID) != std::end(s1897)) { NewSkinID = new_Skin.S1897; }
                                        else if (preferences.S686 && std::find(std::begin(s686), std::end(s686), ID) != std::end(s686)) { NewSkinID = new_Skin.S686; }
                                        else if (preferences.AKM && std::find(std::begin(akmv), std::end(akmv), ID) != std::end(akmv)) { NewSkinID = new_Skin.AKM; }
                                        else if (preferences.M762 && std::find(std::begin(m7), std::end(m7), ID) != std::end(m7)) { NewSkinID = new_Skin.M762; }
                                        else if (preferences.SCARL && std::find(std::begin(scar), std::end(scar), ID) != std::end(scar)) { NewSkinID = new_Skin.Scar; }
                                        else if (preferences.M249 && std::find(std::begin(m249), std::end(m249), ID) != std::end(m249)) { NewSkinID = new_Skin.M249; }
                                        else if (preferences.DP28 && std::find(std::begin(dp), std::end(dp), ID) != std::end(dp)) { NewSkinID = new_Skin.DP28; }
                                        else if (preferences.GROZA && std::find(std::begin(groza), std::end(groza), ID) != std::end(groza)) { NewSkinID = new_Skin.Groza; }
                                        else if (preferences.AUG && std::find(std::begin(aug), std::end(aug), ID) != std::end(aug)) { NewSkinID = new_Skin.AUG; }
                                        else if (preferences.PAN && std::find(std::begin(pan), std::end(pan), ID) != std::end(pan)) { NewSkinID = new_Skin.Pan; }
                                        else if (preferences.M16 && std::find(std::begin(m16), std::end(m16), ID) != std::end(m16)) { NewSkinID = new_Skin.M16A4; }
                                        else if (preferences.UZI && std::find(std::begin(uzi), std::end(uzi), ID) != std::end(uzi)) { NewSkinID = new_Skin.UZI; }
                                        else if (preferences.UMP && std::find(std::begin(ump), std::end(ump), ID) != std::end(ump)) { NewSkinID = new_Skin.UMP; }
                                        else if (preferences.VECTOR && std::find(std::begin(vectorr), std::end(vectorr), ID) != std::end(vectorr)) { NewSkinID = new_Skin.Vector; }
                                        else if (preferences.BIZON && std::find(std::begin(bizon), std::end(bizon), ID) != std::end(bizon)) { NewSkinID = new_Skin.Bizon; }
                                        else if (preferences.TOMMY && std::find(std::begin(tommy), std::end(tommy), ID) != std::end(tommy)) { NewSkinID = new_Skin.Thompson; }
                                        else if (preferences.AWM && std::find(std::begin(awm), std::end(awm), ID) != std::end(awm)) { NewSkinID = new_Skin.AWM; }
                                        else if (preferences.M24 && std::find(std::begin(m24), std::end(m24), ID) != std::end(m24)) { NewSkinID = new_Skin.M24; }
                                        else if (preferences.KAR98 && std::find(std::begin(kar), std::end(kar), ID) != std::end(kar)) { NewSkinID = new_Skin.K98; }
                                        else if (preferences.ACE32 && std::find(std::begin(ace32), std::end(ace32), ID) != std::end(ace32)) { NewSkinID = new_Skin.ACE32; }

                                        if (NewSkinID != -1) {
                                            bool Shit1 = false;

                                            for (int k = 0; k < AdditionalData.Num(); k++) {
                                                if (!AdditionalData.IsValidIndex(k))
                                                    continue;

                                                if (AdditionalData[k].EDataType ==
                                                    EBattleItemAdditionalDataType::
                                                    EBattleItemAdditionalDataType__WeaponAvatar) {
                                                if (AdditionalData[k].IntData != NewSkinID) {
                                                    AdditionalData[k].IntData = NewSkinID;
                                                    Shit2 = true;
                                                    }
                                                    Shit1 = true;
                                                    break;
                                                }
                                            }

                                            if (!Shit1) {
                                                FBattleItemAdditionalData NewEntry;
                                                NewEntry.EDataType = EBattleItemAdditionalDataType::
                                                EBattleItemAdditionalDataType__WeaponAvatar;
                                                NewEntry.IntData = NewSkinID;
                                                AdditionalData.Add(NewEntry);
                                                Shit2 = true;
                                            }
                                        }
                                    }

                                    if (Shit2 && Backpack) {
                                        Backpack->OnRep_ItemListNet();
                                    }
                                }
                            }
                            if (localPlayerController->BackpackComponent) {
                                 auto data = localPlayerController->BackpackComponent->ItemListNet;
                                 auto bag = data.IncArray;
                                 for (int j = 0; j < bag.Num(); j++) {
                                 int ID = bag[j].Unit.DefineID.TypeSpecificID;
                                 if (preferences.Outfit){
                                 for (int i = 0; i < sizeof(SuitX) / sizeof(SuitX[0]); i++) {
                                                 if (ID == SuitX[i]) {
                                                     bag[j].Unit.DefineID.TypeSpecificID = new_Skin.XSuits;
                                                     break;
                                                 }
                                             }
                                         }
                                     if (preferences.Bagg){
                                 for (int i = 0; i < sizeof(Bag) / sizeof(Bag[0]); i++) {
                                                 if (ID == Bag[i]) {
                                                     bag[j].Unit.DefineID.TypeSpecificID = bag3;
                                                     break;
                                                }
                                            }
                                        }
                                                if (preferences.Helmett){
                                for (int i = 0; i < sizeof(Helmet) / sizeof(Helmet[0]); i++) {
                                                 if (ID == Helmet[i]) {
                                                     bag[j].Unit.DefineID.TypeSpecificID = helmett3;
                                                     break;
                                                  }
                                                 }
                                                }
                                                if (preferences.Emote){
                                for (int i = 0; i < sizeof(emote1) / sizeof(emote1[0]); i++) {
                                                 if (ID == emote1[i]) {
                                                     bag[j].Unit.DefineID.TypeSpecificID = sEmote1;
                                                     break;
                                                  }
                                                 }
                                for (int i = 0; i < sizeof(emote2) / sizeof(emote2[0]); i++) {
                                                 if (ID == emote2[i]) {
                                                     bag[j].Unit.DefineID.TypeSpecificID = sEmote2;
                                                     break;
                                                  }
                                                 }
                                for (int i = 0; i < sizeof(emote3) / sizeof(emote3[0]); i++) {
                                             if (ID == emote3[i]) {
                                                 bag[j].Unit.DefineID.TypeSpecificID = sEmote3;
                                                 break;      
                                            }
                                        }
                                    }
                                }
                            }
                            if (localPlayer->AvatarComponent2) {

                                auto AvatarComp = localPlayer->AvatarComponent2;

                                FNetAvatarSyncData NetAvatarComp = * (FNetAvatarSyncData * )((uintptr_t)AvatarComp + AvatarSyncData);

                                auto Slotsybc = NetAvatarComp.SlotSyncData;
                                for (int i = 0; i < Slotsybc.Num(); i++) {
                                    auto Slottype = Slotsybc[i].SlotID;
                                    auto &Slotitem = Slotsybc[i].ItemId;

                                    if (preferences.Parachute) {
                                        if (Slottype == 11)
                                            Slotsybc[i].ItemId = new_Skin.Parachute;
                                    }
                                    if (preferences.Outfit) {
                                        if (Slottype == 5) {
                                            if (Slotitem != new_Skin.XSuits) {
                                                Slotitem = new_Skin.XSuits;
                                                callFunction = true;
                                            }
                                        }
                                    }
                                    if (preferences.Gloves) {
                                        if (Slottype == 16) {
                                            Slotitem = new_Skin.Gloves;
                                        }
                                    }
                                    if (preferences.Shortsx) {
                                        if (Slottype == 6) {
                                            if (Slotitem != new_Skin.Shortss) {
                                                Slotitem = new_Skin.Shortss;
                                                callFunction = true;
                                            }
                                        }
                                    }
                                    if (preferences.Shoes) {
                                        if (Slottype == 7) {
                                            if (Slotitem != new_Skin.Shoes) {
                                                Slotitem = new_Skin.Shoes;
                                                callFunction = true;
                                            }
                                        }
                                    }
                                    if (preferences.Bagg) {
                                        if (Slottype == 8) {
                                            if ((1501003000 <= Slotitem && Slotitem <= 1501003999) || Slotitem == 501003 || Slotitem == 501006 || Slotitem == 501009 || Slotitem == 501012 || Slotitem == 501103 || Slotitem == 501104 || Slotitem == 501105 || Slotitem == 501106) {
                                                if (Slotitem != bag3) {
                                                    Slotitem = bag3;
                                                    callFunction = true;
                                                }
                                            } else if ((1501002000 <= Slotitem && Slotitem <= 1501002999) || Slotitem == 501002 || Slotitem == 501005 || Slotitem == 501008 || Slotitem == 501011 || Slotitem == 501102) {
                                                if (Slotitem != bag2) {
                                                    Slotitem = bag2;
                                                    callFunction = true;
                                                }
                                            } else if ((1501001000 <= Slotitem && Slotitem <= 1501001999) || Slotitem == 501001 || Slotitem == 501004 || Slotitem == 501007 || Slotitem == 501010 || Slotitem == 501101) {
                                                if (Slotitem != bag1) {
                                                    Slotitem = bag1;
                                                    callFunction = true;
                                                }
                                            }
                                        }
                                    }
                                    if (preferences.Helmett) {
                                        if (Slottype == 9) {
                                            if ((1502003000 <= Slotitem && Slotitem <= 1502003999) || Slotitem == 502003 || Slotitem == 502101 || Slotitem == 502104 || Slotitem == 502105 || Slotitem == 502106 || Slotitem == 502107 || Slotitem == 502108 || Slotitem == 502109 || Slotitem == 502110 || Slotitem == 502111 || Slotitem == 502112) {
                                                if (Slotitem != helmett3) {
                                                    Slotitem = helmett3;
                                                    callFunction = true;
                                                }
                                            } else if ((1502002000 <= Slotitem && Slotitem <= 1502002999) || Slotitem == 502002 || Slotitem == 502005 || Slotitem == 502102) {
                                                if (Slotitem != helmett2) {
                                                    Slotitem = helmett2;
                                                    callFunction = true;
                                                }
                                            } else if ((1502001000 <= Slotitem && Slotitem <= 1502001999) || Slotitem == 502001 || Slotitem == 502004) {
                                                if (Slotitem != helmett1) {
                                                    Slotitem = helmett1;
                                                    callFunction = true;
                                                }
                                            }
                                        }
                                    }
                                    if (callFunction) {
                                        localPlayer->AvatarComponent2->OnRep_BodySlotStateChanged();
                                        localPlayerController->BackpackComponent->OnRep_ItemListNet();
                                        callFunction = false;
                                    }
                                }
                            }
                        }
if(枪械变大){
    auto WeaponManagerComponent = localPlayer->WeaponManagerComponent;
    if (WeaponManagerComponent) {
        auto Slot = WeaponManagerComponent->GetCurrentUsingPropSlot();
        if ((int) Slot.GetValue() >= 1 && (int) Slot.GetValue() <= 3) {
            auto CurrentWeaponReplicated = (ASTExtraShootWeapon *) WeaponManagerComponent->CurrentWeaponReplicated;
            if (CurrentWeaponReplicated) {
                auto ShootWeaponEntityComp = CurrentWeaponReplicated->ShootWeaponEntityComp;
                auto ShootWeaponEffectComp = CurrentWeaponReplicated->ShootWeaponEffectComp;
                if (ShootWeaponEntityComp && ShootWeaponEffectComp) {
if (枪械变大) {
    CurrentWeaponReplicated->RootComponent->RelativeScale3D.Y = Gun_Size;
    CurrentWeaponReplicated->RootComponent->RelativeScale3D.Z = Gun_Size;
    CurrentWeaponReplicated->RootComponent->RelativeScale3D.X = Gun_Size;
                      }
                 }
             }
         }
     }
 }

                            int totalEnemies = 0, totalBots = 0;
                            std::vector<ASTExtraPlayerCharacter *> PlayerCharacter;
                            GetAllActors(PlayerCharacter);
                            for (auto actor = PlayerCharacter.begin();
                                 actor != PlayerCharacter.end(); actor++) {
                                auto Player = *actor;

                                if (Player->PlayerKey == localPlayer->PlayerKey)
                                    continue;

                                if (Player->TeamID == localPlayer->TeamID)
                                    continue;

                                if (Player->bDead)
                                    continue;

                                if (Player->bHidden)
                                    continue;



                                if (!Player->RootComponent)
                                    continue;



                                if (Config.ESPMenu.IgnoreBot  && IsLogin) {
                                    if (Player->bEnsure)
                                        continue;
                                }


                                if (Player->bEnsure)
                                    totalBots++;

                                else totalEnemies++;
玩家 = totalEnemies;
人机 = totalBots;
                                if (ModSkinn && KillMessage) {
                                    auto wep = localPlayerController;
                                    int its = KillMessageOffset;
                                    auto VTable = (void**)wep->VTable;
                                    if (VTable && ( VTable[its] != hk_Broadcast)) {
                                        orig_Broadcast = decltype(orig_Broadcast)(VTable[its]);
                                        VTable[its] = (void *) hk_Broadcast;
                                    }
                                }
FVector Head = GetBoneLocationByName(Player, "Head");
Head.Z += 12.5f;
FVector Root = GetBoneLocationByName(Player, "Root");
FVector upper_r = GetBoneLocationByName(Player, "upperarm_r");
FVector lowerarm_r = GetBoneLocationByName(Player, "lowerarm_r");
FVector hand_r = GetBoneLocationByName(Player, "hand_r");
FVector upper_l = GetBoneLocationByName(Player, "upperarm_l");
FVector lowerarm_l = GetBoneLocationByName(Player, "lowerarm_l");
FVector hand_l = GetBoneLocationByName(Player, "hand_l");
FVector thigh_l = GetBoneLocationByName(Player, "thigh_l");
FVector calf_l = GetBoneLocationByName(Player, "calf_l");
FVector foot_l = GetBoneLocationByName(Player, "foot_l");
FVector thigh_r = GetBoneLocationByName(Player, "thigh_r");
FVector calf_r = GetBoneLocationByName(Player, "calf_r");
FVector foot_r = GetBoneLocationByName(Player, "foot_r");
FVector neck_01 = GetBoneLocationByName(Player, "neck_01");
FVector pelvis = GetBoneLocationByName(Player, "pelvis");                                
                                float Distance = Player->GetDistanceTo(localPlayer) / 100.f;
                                                    bool IsVisible = localPlayerController->LineOfSightTo(Player, {0,0,0}, true);
                        
                        if(IsVisible) {
    if(Player->bEnsure){
        // BOT visible → green
        visCol.R = 0.f;
        visCol.G = 0.5f;
        visCol.B = 0.f;
        visCol.A = 1.f;
    }else if(Player->Health == 0.0f){
        // dark green if knock down and visible
        visCol.R = 0.0f;
        visCol.G = 0.3f;
        visCol.B = 0.0f;
        visCol.A = 1.0f;
    }else{
        // green
        visCol.R = 0.f;
        visCol.G = 0.5f;
        visCol.B = 0.f;
        visCol.A = 1.f;
    }
}else if (Player->bEnsure){
    // BOT invisible → red (changed from gray)
    visCol.R = 1.f;
    visCol.G = 0.f;
    visCol.B = 0.f;
    visCol.A = 1.f;
}else if(Player->Health == 0.0f){
    // dark red if knocked down and not visible
    visCol.R = 0.549019607f;
    visCol.G = 0.039215686f;
    visCol.B = 0.050980392f;
    visCol.A = 1.0f;
}else{
    // normal invisible → red
    visCol.R = 1.f;
    visCol.G = 0.f;
    visCol.B = 0.f;
    visCol.A = 1.f;
}

if (Player->IsInvincible)
{
    // yellow
    visCol.R = 1.f;
    visCol.G = 1.f;
    visCol.B = 0.f;
    visCol.A = 1.f;
}

                        
           
                                  
                              
                                if (Distance < 500.f) {




if(Radar == 1  && IsLogin){
                                        bool out = false;
                                        struct Vector3 Pos;
                                                                                Pos.X = (RadarX * 10);
Pos.Y = (RadarY * 13);
                                        struct Vector3 Size;
                                        Size.X = 210;
                                        Size.Y = 200;    
                                        float RadarCenterX = Pos.X + (Size.X / 2);
                                        float RadarCenterY = Pos.Y + (Size.Y / 2);
                                        
                                        FVector MyPosition, EnemyPosition;
                                        ASTExtraVehicleBase * CurrentVehiclea = Player->CurrentVehicle;
                                            if (CurrentVehiclea) {
                                        MyPosition = CurrentVehiclea->RootComponent->RelativeLocation;
                                        } else {
                                        MyPosition = Player->RootComponent->RelativeLocation;
                                        }
                                        ASTExtraVehicleBase * CurrentVehicle = localPlayer->CurrentVehicle;
                                           if (CurrentVehicle) {
                                                EnemyPosition = CurrentVehicle->RootComponent->RelativeLocation;
                                        } else {
                                                EnemyPosition = localPlayer->RootComponent->RelativeLocation;
                                        }
                                        
                                        FVector RadarSketch = WorldToRadar(g_PlayerController->PlayerCameraManager->CameraCache.POV.Rotation.Yaw, MyPosition, EnemyPosition, Pos.X, Pos.Y, Vector3(Size.X, Size.Y, 0), out);
                                          
                                        DrawCircle(HUD, RadarCenterX + 0.5f,RadarCenterY + 0.5f, 100.0f, 100.0f, COLOR_WHITE);      
                                        
                                        DrawFilledRectangle(HUD, FVector2D{RadarCenterX + 0.5f,RadarCenterY + 0.5f}, 5, 5, COLOR_YELLOW);
                                        if (!g_PlayerController->LineOfSightTo(g_PlayerController->PlayerCameraManager,Head, true))
                                            {
                                            DrawFilledRectangle(HUD, FVector2D{RadarSketch.X,RadarSketch.Y}, 5, 5,COLOR_BLUE);
                                           }else{
                                            DrawFilledRectangle(HUD, FVector2D{RadarSketch.X,RadarSketch.Y}, 5, 5,COLOR_RED);
                                            }    
                                        }
        
//雷达
                            if (Radar == 2  && IsLogin) {
                            float lateralAngleView = (localPlayerController->ControlRotation.Yaw) - 90;
                            
                            FVector selfcoord = g_PlayerController->PlayerCameraManager->CameraCache.POV.Location;
                            FVector Objectcoord = Player->RootComponent->RelativeLocation;
                
                            //雷达坐标
                            // playerData.radar = rotateCoord(lateralAngleView, ImVec2((selfCoord.x - objectCoord.x) / 200, (selfCoord.y - objectCoord.y) / 200));
                            //suofang
                            
                            //缩放
                            int Ev = 200;
                            
                            FVector2D radar = rotateCoord(lateralAngleView,FVector2D((selfcoord.X - Objectcoord.X) / Ev,(selfcoord.Y - Objectcoord.Y) / Ev));
                            
                            FVector2D 雷达位置 = {500,200};
                            float 雷达大小 = 55;
                            Canvas->K2_DrawLine({(float)雷达位置.X - (225 * 雷达大小 / 100),(float)雷达位置.Y},{(float)雷达位置.X + (225 * 雷达大小 / 100) ,(float)雷达位置.Y}, 1, FLinearColor(1.f,1.f,1.f,1.f));
                            
                            Canvas->K2_DrawLine({(float)雷达位置.X,(float)雷达位置.Y - (225 * 雷达大小 / 100)},{(float)雷达位置.X ,(float)雷达位置.Y + (225 * 雷达大小 / 100)}, 1, FLinearColor(1.f,1.f,1.f,1.f));
                            
                          
                                
                            //+-
                            
                            Canvas->K2_DrawLine({(float)雷达位置.X  - (225 * 雷达大小 / 100),(float)雷达位置.Y - (225 * 雷达大小 / 100)},{(float)雷达位置.X  - (225 * 雷达大小 / 100) ,(float)雷达位置.Y + (225 * 雷达大小 / 100)}, 1, FLinearColor(1.f,1.f,1.f,1.f));
                            
                            Canvas->K2_DrawLine({(float)雷达位置.X  + (225 * 雷达大小 / 100),(float)雷达位置.Y - (225 * 雷达大小 / 100)},{(float)雷达位置.X  + (225 * 雷达大小 / 100) ,(float)雷达位置.Y + (225 * 雷达大小 / 100)}, 1, FLinearColor(1.f,1.f,1.f,1.f));
                            
                            Canvas->K2_DrawLine({(float)雷达位置.X - (225 * 雷达大小 / 100),(float)雷达位置.Y  - (225 * 雷达大小 / 100)},{(float)雷达位置.X + (225 * 雷达大小 / 100) ,(float)雷达位置.Y  - (225 * 雷达大小 / 100)}, 1, FLinearColor(1.f,1.f,1.f,1.f));
                            
                            Canvas->K2_DrawLine({(float)雷达位置.X - (225 * 雷达大小 / 100),(float)雷达位置.Y  + (225 * 雷达大小 / 100)},{(float)雷达位置.X + (225 * 雷达大小 / 100) ,(float)雷达位置.Y  + (225 * 雷达大小 / 100)}, 1, FLinearColor(1.f,1.f,1.f,1.f));
                            
                            
                            DrawCircle(Canvas, (float)雷达位置.X + radar.X * (雷达大小 / 100),(float)雷达位置.Y + radar.Y  * (雷达大小 / 100),2,50, FLinearColor(1.0f,0.0f,0.0f,1.0f));
                            
                            }//end radar


            }
                           
            UGameplayStatics* gGameplayStatics = (UGameplayStatics*)UGameplayStatics::StaticClass();


                    }
                }
}




                g_LocalPlayer = localPlayer;
                g_PlayerController = localPlayerController;
            }}
        }
    


    //from NSString to wstring
    std::wstring NStoWS ( NSString* Str )
    {
        NSStringEncoding pEncode    =   CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingUTF32LE );
        NSData* pSData              =   [ Str dataUsingEncoding : pEncode ];
        return std::wstring ( (wchar_t*) [ pSData bytes ], [ pSData length] / sizeof ( wchar_t ) );
    }
    //from wstring to NSString
    NSString* WStoNS ( const std::wstring& Str )
    {
        NSString* pString = [ [ NSString alloc ]
                              initWithBytes : (char*)Str.data()
                              length : Str.size() * sizeof(wchar_t)
                              encoding : CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingUTF32LE ) ];
        return pString;
    }


long long (*oRPC_ClientCoronaLab)(long long, long long*) = nullptr;

long long RPC_ClientCoronaLab(long long a1, long long* a2) {
    if (*(unsigned long long*)(*(unsigned long long*)a1 + 0x18) != 0)
        return 0LL;
    if (oRPC_ClientCoronaLab)
        return oRPC_ClientCoronaLab(a1, a2);
    return 0LL;
}

int Protect(uintptr_t addr, size_t len, int prot) {
    size_t page = (size_t)vm_page_size;
    void* start = (void*)(addr & -page);
    uintptr_t end = (addr + len + page - 1) & -page;
    return mprotect(start, end - (uintptr_t)start, prot);
}

void HookCoronaLab(void* localPlayerController) {
    if (CoronaLabHooked)
        return;

    if (!localPlayerController)
        return;

    int VTable_CoronaLab = 186;
    void** VTable = *(void***)localPlayerController;
    if (!VTable)
        return;

    if (VTable[VTable_CoronaLab] != (void*)RPC_ClientCoronaLab) {
        oRPC_ClientCoronaLab = (decltype(oRPC_ClientCoronaLab))VTable[VTable_CoronaLab];
        Protect((uintptr_t)&VTable[VTable_CoronaLab], sizeof(uintptr_t), PROT_READ | PROT_WRITE);
        VTable[VTable_CoronaLab] = (void*)RPC_ClientCoronaLab;
        CoronaLabHooked = true;
    }
}

void UnHookCoronaLab(void* localPlayerController) {
    if (!CoronaLabHooked)
        return;

    if (!localPlayerController)
        return;

    int VTable_CoronaLab = 186;
    void** VTable = *(void***)localPlayerController;
    if (!VTable)
        return;

    Protect((uintptr_t)&VTable[VTable_CoronaLab], sizeof(uintptr_t), PROT_READ | PROT_WRITE);
    VTable[VTable_CoronaLab] = (void*)oRPC_ClientCoronaLab;
    CoronaLabHooked = false;
}


    void *(*oProcessEvent)(UObject *pObj, UFunction *pFunc, void *pArgs);
    void *hkProcessEvent(UObject *pObj, UFunction *pFunc, void *pArgs) {
        if (pFunc) {
            if (pFunc->GetFullName() == ("Function Engine.HUD.ReceiveDrawHUD") ){
                AHUD *pHUD = (AHUD *) pObj;
                if (pHUD) {
                    auto Params = (AHUD_ReceiveDrawHUD_Params *) pArgs;
                    if (Params) {
/*if (!zQkX8A) 
return nullptr;*/

/*if (!PlayerzSDK()) {

    return 0;
}*/


RenderESP(pHUD, Params->SizeX, Params->SizeY);
                      screenWidth = Params->SizeX;
                     screenHeight = Params->SizeY;
                    }
                }
            }
return oProcessEvent(pObj, pFunc, pArgs);
        }}
        


void  *RTL_language(){
    
    auto MAIN =(FUObjectArray *) (obbbbl());
    auto gobjects = MAIN->ObjObjects;
    for (int i=0;i< gobjects.Num(); i++)
        if (auto obj = gobjects.GetByIndex(i)) {
            
            if(obj->IsA(AHUD::StaticClass())) {
                auto HUD = (AHUD *) obj;
                int its = 76;
                auto VTable = (void**)HUD->VTable;
                if (VTable && ( VTable[its] != hkProcessEvent)) {
                    oProcessEvent = decltype(oProcessEvent)(VTable[its]);
                    VTable[its] = (void *) hkProcessEvent;
                }
            }
          if(obj->IsA(ASTExtraPlayerController::StaticClass())) {
                auto HUD = (ASTExtraPlayerController *) obj;
                int its = 76;
                auto VTable = (void**)HUD->VTable;
                if (VTable && ( VTable[its] != hkProcessEvent)) {
                    oProcessEvent = decltype(oProcessEvent)(VTable[its]);
                    VTable[its] = (void *) hkProcessEvent;
                }
            }
            if (obj->IsA(ULobbyWeaponManagerComponent::StaticClass())) {
                auto HUD = (ULobbyWeaponManagerComponent *)obj;
                auto VTable = (void **)HUD->VTable;
                if (VTable && (VTable[76] != hkProcessEvent)) {
                  oProcessEvent = decltype(oProcessEvent)(VTable[76]);
                  VTable[76] = (void *)hkProcessEvent;
                }
            }
        }
    return 0;
}
#define hook GaYSSS9aAL


#define hook GaYSSS9aAL



+ (void)load
{
        FName::GNames = GetGNames();
    while (!FName::GNames) {
        FName::GNames = GetGNames();
          sleep(1);
    }
    
    
    UObject::GUObjectArray = (FUObjectArray *) (obbbbl());
    
    while (!UObject::GUObjectArray) {
    UObject::GUObjectArray = (FUObjectArray *) (obbbbl());
          sleep(1);
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    

          [self load1];
        
    });
}
+ (void)load1
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RTL_language();
    });
}
__attribute__((constructor)) void _init() {
    pthread_t t;
    

}

@end
