TARGET = iphone:clang:16.5:14.0
ARCHS = arm64
FINALPACKAGE = 1
THEOS_PACKAGE_SCHEME = rootless
SUBPROJECTS += Tweaks/Gonerino Tweaks/YTABConfig Tweaks/YouQuality Tweaks/DontEatMyContent Tweaks/YTVideoOverlay Tweaks/YouGroupSettings
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
	@$(PRINT_FORMAT_BLUE) "Downloading YTLite"
	@LATEST_RELEASE=$$(curl -s -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/dayanch96/YTLite/releases/latest) && \
	DEB_URL=$$(echo "$$LATEST_RELEASE" | jq -r '.assets[] | select(.name | endswith("iphoneos-arm64.deb")) | .browser_download_url') && \
	if [ -n "$$DEB_URL" ]; then \
		cd packages && \
		curl -s -L -O "$$DEB_URL" && \
		cd - > /dev/null; \
	else \
		$(PRINT_FORMAT_ERROR) "Failed to fetch YTLite release info" && exit 1; \
	fi
