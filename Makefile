ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = PUBGMobile

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RavFenShadow

RavFenShadow_FILES = Tweak.mm
RavFenShadow_FRAMEWORKS = UIKit QuartzCore CoreGraphics Foundation
RavFenShadow_CFLAGS = -fobjc-arc -Wno-error=deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk
