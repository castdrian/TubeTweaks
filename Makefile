TARGET = iphone:clang:16.5:14.0
ARCHS = arm64
FINALPACKAGE = 1

EXTRA_CFLAGS := -I$(THEOS_PROJECT_DIR)/Tweaks -I$(THEOS_PROJECT_DIR)/YouTubeHeaders

export ADDITIONAL_CFLAGS = -I$(THEOS_PROJECT_DIR)/Tweaks -I$(THEOS_PROJECT_DIR)/YouTubeHeaders

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Tweaks/Gonerino Tweaks/YTABConfig Tweaks/DontEatMyContent Tweaks/YTVideoOverlay Tweaks/YouGroupSettings

include $(THEOS_MAKE_PATH)/aggregate.mk

YTLITE_PATH = Tweaks/YTLite
YTLITE_DYLIB = $(YTLITE_PATH)/var/jb/Library/MobileSubstrate/DynamicLibraries/YTLite.dylib
YTLITE_BUNDLE = $(YTLITE_PATH)/var/jb/Library/Application Support/YTLite.bundle

before-package::
	@echo -e "==> \033[1mMoving tweak's bundle to Resources/...\033[0m"
	@cp -R Tweaks/YTLite/var/jb/Library/Application\ Support/YTLite.bundle Resources/
	@cp -R Tweaks/YTABConfig/layout/Library/Application\ Support/YTABC.bundle Resources/
	@cp -R Tweaks/DontEatMyContent/layout/Library/Application\ Support/DontEatMyContent.bundle Resources/
	@cp -R Tweaks/YTVideoOverlay/layout/Library/Application\ Support/YTVideoOverlay.bundle Resources/
	@echo -e "==> \033[1mChanging the installation path of dylibs...\033[0m"

internal-clean::
	@rm -rf $(YTLITE_PATH)/*
	@rm -rf YouTubeHeader

before-all::
	@rm -rf $(YTLITE_PATH)/*
	@$(PRINT_FORMAT_BLUE) "Creating YouTube Headers symlink"
	@rm -rf YouTubeHeader
	@ln -sf $(THEOS)/include/YouTubeHeader .
	@$(PRINT_FORMAT_BLUE) "Downloading YTLite"
	@mkdir -p $(YTLITE_PATH)
	@LATEST_RELEASE=$$(curl -s -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/dayanch96/YTLite/releases/latest) && \
	DEB_URL=$$(echo "$$LATEST_RELEASE" | jq -r '.assets[] | select(.name | endswith("iphoneos-arm64.deb")) | .browser_download_url') && \
	if [ -n "$$DEB_URL" ]; then \
		cd $(YTLITE_PATH) && \
		curl -s -L -O "$$DEB_URL" && \
		DOWNLOADED_DEB=$$(ls *.deb) && \
		ar x "$$DOWNLOADED_DEB" && \
		tar xf data.tar* && \
		cd - > /dev/null; \
	else \
		$(PRINT_FORMAT_ERROR) "Failed to fetch YTLite release info" && exit 1; \
	fi && \
	if [ ! -f "$(YTLITE_DYLIB)" ] || [ ! -d "$(YTLITE_BUNDLE)" ]; then \
		$(PRINT_FORMAT_ERROR) "Failed to extract YTLite" && exit 1; \
	fi
