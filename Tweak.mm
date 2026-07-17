#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

// متغير لمنع تكرار الرسالة في كل إطار (لأن الدالة تتحدث 60 مرة في الثانية)
bool hasAlerted = false;

// 1. دالة مخصصة لإظهار تنبيه أصلي في منتصف شاشة الآيفون/الآيباد
void showScreenAlert(NSString *title, NSString *message) {
    dispatch_async(dispatch_get_main_queue(), ^{
        // الحصول على النافذة النشطة حالياً في اللعبة
        UIWindow *keyWindow = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *window in scene.windows) {
                        if (window.isKeyWindow) { keyWindow = window; break; }
                    }
                }
            }
        }
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].keyWindow;
        }

        // الوصول إلى المتحكم العلوي لرسم النافذة فوقه
        UIViewController *topController = keyWindow.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }

        // إنشاء نافذة التنبيه بنص مخصص
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"تم (أغلق اللعبة وعدّل)" 
                                                           style:UIAlertActionStyleDestructive 
                                                         handler:nil];
        [alert addAction:okAction];
        [topController presentViewController:alert animated:YES completion:nil];
    });
}

// 2. تعريف دالة الهوك الأصلية (سواء كانت دالة تحديث السلاح أو اللاعب)
void (*orig_WeaponTick)(void* _this, float deltaTime);

// 3. دالة الهوك الخاصة بنا التي ستقوم بالفحص الذكي
void hook_WeaponTick(void* _this, float deltaTime) {
    if (_this != nullptr && !hasAlerted) {
        
        uintptr_t weaponBase = (uintptr_t)_this;

        // قراءة القيم بناءً على الأوفستات الحالية
        bool isBoltAction   = *(bool*)(weaponBase + 0x01BE);
        uintptr_t pawnPtr   = *(uintptr_t*)(weaponBase + 0x01E0);
        float adsTimeline   = *(float*)(weaponBase + 0x020C);
        float boltHoldTime  = *(float*)(weaponBase + 0x0228);

        // --- اختبارات الأمان (التحقق من صحة الأوفست) ---
        bool isOffsetWrong = false;
        NSString *errorDetails = @"";

        // أ) فحص مؤشر اللاعب: إذا كان الأوفست خطأ، سيعطي عنواناً فارغاً 0x0 أو قيمة عشوائية غير منطقية
        if (pawnPtr == 0 || pawnPtr < 0x100000000) {
            isOffsetWrong = true;
            errorDetails = [errorDetails stringByAppendingString:@"❌ أوفست الـ Pawn خطأ أو المؤشر فارغ!\n"];
        }

        // ب) فحص وقت السكوب: وقت فتح السكوب في اللعبة مستحيل يكون سالب أو أطول من 5 ثوانٍ
        if (adsTimeline < 0.0f || adsTimeline > 5.0f) {
            isOffsetWrong = true;
            errorDetails = [errorDetails stringByAppendingString:[NSString stringWithFormat:@"❌ أوفست الـ ADS خطأ! القيمة المقروءة: %.4f\n", adsTimeline]];
        }

        // ج) فحص وقت السحب لأسلحة الترباس
        if (boltHoldTime < 0.0f || boltHoldTime > 10.0f) {
            isOffsetWrong = true;
            errorDetails = [errorDetails stringByAppendingString:[NSString stringWithFormat:@"❌ أوفست الـ Bolt Hold خطأ! القيمة: %.4f\n", boltHoldTime]];
        }

        // إذا نجح أحد اختبارات الخطأ، أظهر التنبيه فوراً بنص واضح في منتصف الشاشة
        if (isOffsetWrong) {
            hasAlerted = true; // تفعيل الحماية لمنع ظهور التنبيه مجدداً والكراش
            
            NSString *finalMessage = [NSString stringWithFormat:@"تنبيه RavFen AI:\n\n%@\nتأكد من تحديث الأوفستات في الـ SDK لنسخة اللعبة الحالية.", errorDetails];
            
            showScreenAlert(@"🚨 خطأ في الأوفستات!", finalMessage);
        }
    }

    // استدعاء الدالة الأصلية لتستمر اللعبة في العمل بشكل طبيعي لو كل شيء سليم
    orig_WeaponTick(_this, deltaTime);
}

// 4. تفعيل الهوك عند تشغيل الـ dylib
void init_verifier() {
    uintptr_t baseAddress = (uintptr_t)_dyld_get_image_header(0);
    
    // ضع أوفست الدالة التي تود عمل هوك عليها هنا (مثال: دالة تحديث السلاح)
    uintptr_t targetOffset = baseAddress + 0x1234567; 

    MSHookFunction((void*)targetOffset, (void*)&hook_WeaponTick, (void**)&orig_WeaponTick);
}

__attribute__((constructor)) void init() {
    // انتظار ثوانٍ لضمان استقرار واجهة اللعبة قبل فحص الـ UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        init_verifier();
    });
}
