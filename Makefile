# اسم التويك الخاص بك
TWEAK_NAME = TaiwanOffsetValidator

# ملفات السورس الفردية لترجمتها (تأكد من تسمية ملف الكود الأساسي بـ Tweak.xm أو تعديل الاسم هنا)
TaiwanOffsetValidator_FILES = Tweak.xm

# المعماريات المستهدفة (ببجي تعمل على 64-bit فقط)
ARCHS = arm64

# تحديد الجيلبريك المستهدف (Rootless أو Rootful)
THEOS_PACKAGE_SCHEME = rootless

# المكتبات البرمجية المطلوبة من النواة للتعامل مع الذاكرة والشاشة
TaiwanOffsetValidator_FRAMEWORKS = UIKit Foundation CoreGraphics

# خيارات المترجم (تفعيل التوافق مع معايير C++17 لتشغيل الـ Vector والمصفوفات بسلاسة)
TaiwanOffsetValidator_CFLAGS = -fobjc-arc -std=c++17

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 ShadowTrackerExtra"
