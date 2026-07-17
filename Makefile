# اسم التويك الخاص بك
TWEAK_NAME = TaiwanOffsetValidator

# ملف السورس الفعلي الموجود في مجلدك بناءً على الـ log الخاص بك
TaiwanOffsetValidator_FILES = metalbiew.mm

# المعماريات المستهدفة
ARCHS = arm64

# تحديد الجيلبريك المستهدف (Rootless)
THEOS_PACKAGE_SCHEME = rootless

# المكتبات البرمجية المطلوبة
TaiwanOffsetValidator_FRAMEWORKS = UIKit Foundation CoreGraphics

# خيارات المترجم (تفعيل التوافق مع C++17)
TaiwanOffsetValidator_CFLAGS = -fobjc-arc -std=c++17

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 ShadowTrackerExtra"
