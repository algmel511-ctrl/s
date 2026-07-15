TARGET = iphone:clang:latest:14.0
ARCHS = arm64
#Add arm64e if it needed
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1 
THEOS_PACKAGE_SCHEME = rootless
include $(THEOS)/makefiles/common.mk


TWEAK_NAME = App

App_FRAMEWORKS = IOKit  UIKit Foundation Security QuartzCore CoreGraphics CoreText  AVFoundation Accelerate GLKit SystemConfiguration GameController

App_CCFLAGS = -w -std=gnu++14 -fno-rtti -fno-exceptions -DNDEBUG \
              -Wno-module-import-in-extern-c \
              -Wno-unused-parameter \
              -Wno-unused-function \
              -Wno-missing-braces \
              -Wno-parentheses-equality \
              -Wno-shorten-64-to-32 \
              -Wno-sign-compare \
              -Wno-format-security \
              -Wno-missing-field-initializers \
              -Wno-c++11-extensions

App_CFLAGS = -w -fobjc-arc \
             -Wno-deprecated-declarations \
             -Wno-unused-variable \
             -Wno-unused-value \
             -Wno-format-security \
             -Wno-missing-braces \
             -Wno-parentheses-equality \
             -Wno-sign-compare \
             -Wno-shadow \
             -I./AFNetworking \
             -I./CocoaAsyncSocket \
             -I./Core \
             -I./Core/Categories \
             -I./Core/Mime \
             -I./Core/Responses \
             -I./EasyAES \
             -I./MBProgressHUD \
             -I./SAMKeychain \
             -I./SCLAlertView \
             -I./UDID \
             -I./UIKit \
             -I./Foundation


App_LDFLAGS += ESP/API/oldLib.a ESP/JRMemory.framework/JRMemory

App_FILES = ESP/Tweak.xm $(wildcard *.mm) $(wildcard ESP/*.mm) $(wildcard ESP/*.m) $(wildcard ESP/*.cpp) $(wildcard ESP/*.c) $(wildcard ESP/authcheatbot/*.m) $(wildcard ESP/imgui/*.mm) $(wildcard ESP/imgui/*.cpp) $(wildcard SDK/*.cpp) $(wildcard ESP/HOST/*.m) ESP/fViewController.mm 


 GO_EASY_ON_ME = 1

include $(THEOS_MAKE_PATH)/tweak.mk
