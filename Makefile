TARGET = iphone:clang:latest:14.0
ARCHS = arm64

DEBUG = 1
FINALPACKAGE = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = metalbiew

# دمج ملف كودك مع جميع ملفات الـ functions الخاصة بالـ SDK
metalbiew_FILES = metalbiew.mm $(wildcard SDK/*.cpp)

# توجيه الكومبيلر للبحث داخل مجلد الـ SDK بعد فك الضغط
metalbiew_CFLAGS = -fobjc-arc -I./SDK -I.

include $(THEOS_MAKE_PATH)/tweak.mk
