// ============================================================
//  Tweak.xm - ESP حقيقي للعب UE4 (نسخة معدلة لتصحيح الأخطاء)
// ============================================================

#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <mach-o/dyld.h>
#import <objc/runtime.h>
#include <vector>
#include <string>

// ============================================================
// 1. تعريفات الهياكل الأساسية (Unreal Engine 4)
// ============================================================
struct FVector {
    float X, Y, Z;
};

struct FName {
    int32_t Index;
    int32_t Number;
};

struct FString {
    wchar_t* Data;
    int32_t Length;
    int32_t MaxLength;
};

// ============================================================
// 2. قراءة الذاكرة بأمان
// ============================================================
template <typename T>
T ReadMemory(uintptr_t address) {
    T buffer = {};
    if (address == 0) return buffer;
    vm_size_t size = sizeof(T);
    vm_size_t outSize = 0;
    kern_return_t kr = vm_read_overwrite(mach_task_self(),
                                         (vm_address_t)address,
                                         size,
                                         (vm_address_t)&buffer,
                                         &outSize);
    if (kr != KERN_SUCCESS || outSize != size) return {};
    return buffer;
}

uintptr_t ReadPtr(uintptr_t address) {
    return ReadMemory<uintptr_t>(address);
}

// ============================================================
// 3. الأوفستات الخاصة بك (لم نغير شيئاً)
// ============================================================
#define OFFSET_UWORLD                             0x106B0FE80
#define OFFSET_GNAMES                             0x1050C4AB4
#define OFFSET_HOOK_HUD                           0x109A731B0
#define OFFSET_GET_HUD                            0x1038E4E8C
#define OFFSET_DRAW_TEXT                          0x1031F62BC
#define OFFSET_DRAW_LINE                          0x1063B95D8
#define OFFSET_DRAW_RECT_FILLED                   0x1063B9548
#define OFFSET_DRAW_CIRCLE_FILLED                 0x106798690
#define OFFSET_PROJECT_WORLD_TO_SCREEN            0x10636734C
#define OFFSET_BONE_POS                           0x10361CD48
#define OFFSET_LINE_OF_SIGHT_1                    0x10A523070
#define OFFSET_LINE_OF_SIGHT_2                    0x10AA8B300
#define OFFSET_LINE_OF_SIGHT_3                    0x106201DE0
#define OFFSET_LINE_OF_SIGHT_4                    0x106201EF0
#define OFFSET_LINE_OF_SIGHT_5                    0x10620D288
#define OFFSET_ENGINE                             0x10AAA3320

// ============================================================
// 4. المؤشرات للدوال
// ============================================================
uintptr_t baseAddress = 0;

typedef void (*tDrawText)(uintptr_t HUD, const wchar_t* Text, float X, float Y, float Scale, float R, float G, float B, float A, bool bShadow);
typedef void (*tDrawLine)(uintptr_t HUD, float X1, float Y1, float X2, float Y2, float Thickness, float R, float G, float B, float A);
typedef void (*tDrawRectFilled)(uintptr_t HUD, float X, float Y, float W, float H, float R, float G, float B, float A);
typedef void (*tDrawCircleFilled)(uintptr_t HUD, float X, float Y, float Radius, int Segments, float R, float G, float B, float A);
typedef bool (*tProjectWorldToScreen)(uintptr_t WorldContext, FVector WorldLocation, FVector* ScreenLocation);

tDrawText DrawText = nullptr;
tDrawLine DrawLine = nullptr;
tDrawRectFilled DrawRectFilled = nullptr;
tDrawCircleFilled DrawCircleFilled = nullptr;
tProjectWorldToScreen ProjectWorldToScreen = nullptr;

// ============================================================
// 5. قراءة أسماء اللاعبين من GNames (معدلة لإرجاع wstring)
// ============================================================
std::wstring GetNameFromGNames(int32_t Index) {
    uintptr_t GNamesPtr = ReadPtr(baseAddress + OFFSET_GNAMES);
    if (!GNamesPtr) return L"Unknown";
    
    uintptr_t NamePool = ReadPtr(GNamesPtr + 0x20);
    if (!NamePool) return L"Unknown";
    
    uintptr_t NameEntryPtr = ReadPtr(NamePool + (Index * 8));
    if (!NameEntryPtr) return L"Unknown";
    
    wchar_t NameBuffer[64] = {};
    vm_read_overwrite(mach_task_self(), NameEntryPtr + 0x4, 60, (vm_address_t)NameBuffer, NULL);
    return std::wstring(NameBuffer);
}

// ============================================================
// 6. الحصول على قائمة اللاعبين
// ============================================================
std::vector<uintptr_t> GetValidActors(uintptr_t UWorld) {
    std::vector<uintptr_t> Actors;
    uintptr_t PersistentLevel = ReadPtr(UWorld + 0x30);
    if (!PersistentLevel) return Actors;
    
    uintptr_t ActorsArray = ReadPtr(PersistentLevel + 0xA0);
    int32_t ActorCount = ReadMemory<int32_t>(PersistentLevel + 0xA8);
    if (!ActorsArray || ActorCount > 5000) return Actors;
    
    for (int i = 0; i < ActorCount; i++) {
        uintptr_t Actor = ReadPtr(ActorsArray + (i * 8));
        if (!Actor) continue;
        uintptr_t VTable = ReadPtr(Actor);
        if (!VTable || VTable < 0x100000000) continue;
        uintptr_t RootComponent = ReadPtr(Actor + 0x1A0);
        if (!RootComponent) continue;
        uintptr_t Mesh = ReadPtr(Actor + 0x328);
        if (!Mesh) continue;
        Actors.push_back(Actor);
    }
    return Actors;
}

// ============================================================
// 7. جلب موقع اللاعب
// ============================================================
FVector GetActorLocation(uintptr_t Actor) {
    uintptr_t RootComponent = ReadPtr(Actor + 0x1A0);
    if (!RootComponent) return FVector{0,0,0};
    return ReadMemory<FVector>(RootComponent + 0x120);
}

// ============================================================
// 8. دالة الرسم الرئيسية (مع تصحيح النصوص)
// ============================================================
void DrawESP(uintptr_t HUD, uintptr_t UWorld) {
    if (!HUD || !UWorld) return;
    if (!DrawText || !DrawLine || !DrawRectFilled || !DrawCircleFilled) return;
    if (!ProjectWorldToScreen) return;
    
    // اللاعب المحلي
    uintptr_t GameInstance = ReadPtr(UWorld + 0x1A8);
    if (!GameInstance) return;
    uintptr_t LocalPlayer = ReadPtr(GameInstance + 0x38);
    if (!LocalPlayer) return;
    uintptr_t PlayerController = ReadPtr(LocalPlayer + 0x30);
    if (!PlayerController) return;
    uintptr_t LocalPawn = ReadPtr(PlayerController + 0x348);
    if (!LocalPawn) return;
    FVector LocalPos = GetActorLocation(LocalPawn);
    
    std::vector<uintptr_t> Actors = GetValidActors(UWorld);
    
    for (uintptr_t Actor : Actors) {
        if (Actor == LocalPawn) continue;
        FVector WorldPos = GetActorLocation(Actor);
        if (WorldPos.X == 0 && WorldPos.Y == 0) continue;
        
        float Distance = sqrtf(powf(WorldPos.X - LocalPos.X, 2) +
                              powf(WorldPos.Y - LocalPos.Y, 2) +
                              powf(WorldPos.Z - LocalPos.Z, 2)) / 100.0f;
        if (Distance > 200.0f) continue;
        
        FVector ScreenPos = {};
        if (!ProjectWorldToScreen(UWorld, WorldPos, &ScreenPos)) continue;
        
        float X = ScreenPos.X;
        float Y = ScreenPos.Y;
        float screenWidth = [UIScreen mainScreen].bounds.size.width;
        float screenHeight = [UIScreen mainScreen].bounds.size.height;
        if (X < 0 || Y < 0 || X > screenWidth || Y > screenHeight) continue;
        
        // قراءة اسم اللاعب
        int32_t PlayerNameIndex = ReadMemory<int32_t>(Actor + 0x238);
        std::wstring PlayerName = GetNameFromGNames(PlayerNameIndex);
        
        // تحضير النص بصيغة wchar_t
        wchar_t buffer[128];
        swprintf(buffer, sizeof(buffer)/sizeof(wchar_t), L"%ls [%.0fm]", PlayerName.c_str(), Distance);
        
        // رسم النص (يستخدم wchar_t الآن)
        DrawText(HUD, buffer, X - 30, Y - 40, 1.0, 1, 1, 1, 1, true);
        
        // رسم دائرة خضراء
        DrawCircleFilled(HUD, X, Y + 10, 15, 12, 0, 1, 0, 0.5);
        
        // رسم خط
        DrawLine(HUD, X, Y + 10, X, screenHeight, 2.0, 1, 0, 0, 0.6);
        
        // مربع خلفية الاسم
        DrawRectFilled(HUD, X - 40, Y - 60, 80, 25, 0, 0, 0, 0.4);
    }
}

// ============================================================
// 9. هوك دالة HUD (نقطة الدخول)
// ============================================================
uintptr_t origGetHUD = 0;

uintptr_t HookedGetHUD() {
    uintptr_t HUD = ((uintptr_t(*)())origGetHUD)();
    if (!HUD) return HUD;
    
    uintptr_t UWorld = ReadPtr(baseAddress + OFFSET_UWORLD);
    if (!UWorld) return HUD;
    
    DrawESP(HUD, UWorld);
    return HUD;
}

// ============================================================
// 10. التهيئة (بتشتغل عند تحميل الدايلب)
// ============================================================
__attribute__((constructor))
static void Initialize() {
    baseAddress = _dyld_get_image_vmaddr_slide(0);
    
    // تعيين المؤشرات
    DrawText = (tDrawText)(baseAddress + OFFSET_DRAW_TEXT);
    DrawLine = (tDrawLine)(baseAddress + OFFSET_DRAW_LINE);
    DrawRectFilled = (tDrawRectFilled)(baseAddress + OFFSET_DRAW_RECT_FILLED);
    DrawCircleFilled = (tDrawCircleFilled)(baseAddress + OFFSET_DRAW_CIRCLE_FILLED);
    ProjectWorldToScreen = (tProjectWorldToScreen)(baseAddress + OFFSET_PROJECT_WORLD_TO_SCREEN);
    
    origGetHUD = baseAddress + OFFSET_GET_HUD;
    
    // هنا سيتم الهوك بواسطة MSHookFunction (تحتاج لـ Substrate)
    // مثال: MSHookFunction((void*)origGetHUD, (void*)HookedGetHUD, NULL);
    
    NSLog(@"[OffsetsValidator] تم تحميل ESP الحقيقي بنجاح!");
}
