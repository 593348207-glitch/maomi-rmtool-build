ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = MagicRecipe
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = RMTool
RMTool_FILES = Tweak.xm
RMTool_CFLAGS = -fobjc-arc
RMTool_CCFLAGS = -std=c++17
RMTool_FRAMEWORKS = UIKit Foundation
include $(THEOS_MAKE_PATH)/tweak.mk
after-install::
	install.exec "killall -9 MagicRecipe || true"
