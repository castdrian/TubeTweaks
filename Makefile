TARGET = iphone:clang:16.5:14.0
ARCHS = arm64
FINALPACKAGE = 1
THEOS_PACKAGE_SCHEME = rootless
SUBPROJECTS += Tweaks/Gonerino Tweaks/YSRUDFFS Tweaks/YouQuality Tweaks/YouPiP Tweaks/YTVideoOverlay Tweaks/YouGroupSettings
EXTRA_CFLAGS := -I$(THEOS_PROJECT_DIR)/Tweaks -I$(THEOS_PROJECT_DIR)/YouTubeHeaders

export ADDITIONAL_CFLAGS = -I$(THEOS_PROJECT_DIR)/Tweaks -I$(THEOS_PROJECT_DIR)/YouTubeHeaders

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

internal-clean::
	@rm -rf YouTubeHeader

before-all::
	@$(PRINT_FORMAT_BLUE) "Creating YouTube Headers symlink"
	@rm -rf YouTubeHeader
	@ln -sf $(THEOS)/include/YouTubeHeader .
	@mkdir -p packages
