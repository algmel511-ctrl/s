TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES := SpringBoard
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = OffsetsValidator
OffsetsValidator_FILES = Tweak.xm
OffsetsValidator_CFLAGS = -fobjc-arc
OffsetsValidator_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
