TARGET = iphone:clang:latest:14.0
ARCHS = arm64

DEBUG = 1
FINALPACKAGE = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = metalbiew

# دمج ملف كودك مع جميع ملفات الـ functions الخاصة بالـ SDK (سواء بالمسار الفرعي أو الرئيسي)
metalbiew_FILES = metalbiew.mm $(wildcard SDK/SDK/*.cpp) $(wildcard SDK/*.cpp)

# توجيه الكومبيلر للبحث داخل المجلدات الفرعية وتعطيل الأخطاء الصارمة الخاصة بالـ SDK
metalbiew_CFLAGS = -fobjc-arc -I. -I./SDK -I./SDK/SDK -Wno-error -Wno-return-stack-address

include $(THEOS_MAKE_PATH)/tweak.mk
