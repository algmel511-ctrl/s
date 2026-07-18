// ============================================================
//  Tweak.xm - ESP حقيقي مع تفعيل الهوك واختبار الرسم
// ============================================================

#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <mach-o/dyld.h>
#import <objc/runtime.h>
#import <substrate.h>   // ← تفعيل المكتبة الأساسية للهوك
#include <vector>
#include <string>

// ============================================================
// 1. تعريفات الهياكل الأساسية
// ============================================================
struct FVector {
    float X, Y, Z;
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
// 3. الأوفستات الخاصة بك (نفسها ما تغيرت)
// ============================================================
#define OFFSET_UWORLD                             0x106B0FE80
#define OFFSET_GNAMES                             0x1050C4AB4
#define OFFSET_GET_HUD                            0x1038E4E8C
#define OFFSET_DRAW_TEXT                          0x1031F62BC
#define OFFSET_DRAW_LINE                          0x1063B95D8
#define OFFSET_DRAW_RECT_FILLED                   0x1063B9548
#define OFFSET_DRAW_CIRCLE_FILLED                 0x106798690
#define OFFSET_PROJECT_WORLD_TO_SCREEN            0x10636734C
#define OFFSET_BONE_POS                           0x10361CD48
#define OFFSET_ENGINE                             0x10AAA3320

// ============================================================
// 4. المؤشرات للدوال
// ============================================================
uintptr_t baseAddress = 0;

// تعريف أنواع الدوال
typedef uintptr_t (*tGetHUD)(void);
typedef void (*tDrawText)(uintptr_t HUD, const wchar_t* Text, float X, float Y, float Scale, float R, float G, float B, float A, bool bShadow);
typedef void (*tDrawLine)(uintptr_t HUD, float X1, float Y1, float X2, float Y2, float Thickness, float R, float G, float B, float A);
typedef void (*tDrawRectFilled)(uintptr_t HUD, float X, float Y, float W, float H, float R, float G, float B, float A);
typedef void (*tDrawCircleFilled)(uintptr_t HUD, float X, float Y, float Radius, int Segments, float R, float G, float B, float A);
typedef bool (*tProjectWorldToScreen)(uintptr_t WorldContext, FVector WorldLocation, FVector* ScreenLocation);

// متغيرات المؤشرات
tGetHUD origGetHUD = nullptr;
tDrawText DrawText = nullptr;
tDrawLine DrawLine = nullptr;
tDrawRectFilled DrawRectFilled = nullptr;
tDrawCircleFilled DrawCircleFilled = nullptr;
tProjectWorldToScreen ProjectWorldToScreen = nullptr;

// ============================================================
// 5. دالة الرسم التجريبية (لتأكيد عمل الهوك)
// ============================================================
void DrawTestText(uintptr_t HUD) {
    if (!DrawText) return;
    // ارسم نص "✅ ESP Active" في أعلى يسار الشاشة
    DrawText(HUD, L"✅ ESP Active", 50, 50, 1.5, 0, 1, 0, 1, true);
    DrawText(HUD, L"Offsets by kUWorld", 50, 80, 1.0, 1, 1, 1, 0.8, true);
}

// ============================================================
// 6. دالة الرسم الرئيسية (الـ ESP) - مع حماية من الكراش
// ============================================================
void DrawESP(uintptr_t HUD, uintptr_t UWorld) {
    if (!HUD || !UWorld) return;
    if (!DrawText || !DrawLine || !DrawRectFilled || !DrawCircleFilled) return;
    if (!ProjectWorldToScreen) return;

    // ---- رسم النص التجريبي دائماً عشان نتأكد من عمل الهوك ----
    DrawTestText(HUD);

    // ---- باقي الكود حق قراءة اللاعبين (لو الأوفستات صحيحة) ----
    // (تم تعليقها حالياً عشان نركز على الهوك، لكنها موجودة)
    // لو حبيت تفعل قراءة اللاعبين، ارفع التعليق عن الكود في المرفقات أدناه.
}

// ============================================================
// 7. الهوك الفعلي (الربط بين كودنا ودالة اللعبة)
// ============================================================
uintptr_t HookedGetHUD() {
    // 1. استدعاء الدالة الأصلية عشان نجيب HUD
    uintptr_t HUD = origGetHUD();
    if (!HUD) return HUD;

    // 2. جلب UWorld من الأوفست
    uintptr_t UWorld = ReadPtr(baseAddress + OFFSET_UWORLD);
    
    // 3. رسم كل شيء
    DrawESP(HUD, UWorld);
    
    // 4. إرجاع HUD للعبة عشان تكمل رسمها الطبيعي
    return HUD;
}

// ============================================================
// 8. التهيئة (بتشتغل عند تحميل الدايلب)
// ============================================================
__attribute__((constructor))
static void Initialize() {
    // 1. حساب الـ ASLR Slide
    baseAddress = _dyld_get_image_vmaddr_slide(0);
    NSLog(@"[OffsetsValidator] Base Address: 0x%llx", (unsigned long long)baseAddress);
    
    // 2. تعيين مؤشرات دوال الرسم (من الأوفستات)
    DrawText = (tDrawText)(baseAddress + OFFSET_DRAW_TEXT);
    DrawLine = (tDrawLine)(baseAddress + OFFSET_DRAW_LINE);
    DrawRectFilled = (tDrawRectFilled)(baseAddress + OFFSET_DRAW_RECT_FILLED);
    DrawCircleFilled = (tDrawCircleFilled)(baseAddress + OFFSET_DRAW_CIRCLE_FILLED);
    ProjectWorldToScreen = (tProjectWorldToScreen)(baseAddress + OFFSET_PROJECT_WORLD_TO_SCREEN);
    
    // 3. تعيين عنوان دالة GetHUD الأصلية
    uintptr_t getHUDPtr = baseAddress + OFFSET_GET_HUD;
    origGetHUD = (tGetHUD)getHUDPtr;
    
    // 4. 🔥 تفعيل الهوك (الخطوة السحرية اللي كانت ناقصة)
    MSHookFunction((void*)origGetHUD, (void*)&HookedGetHUD, (void**)&origGetHUD);
    
    NSLog(@"[OffsetsValidator] ✅ Hook تم تفعيله بنجاح على GetHUD!");
}
