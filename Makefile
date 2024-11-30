TARGET = iphone:clang:16.5:14.0
ARCHS = arm64
MODULES = jailed
FINALPACKAGE = 1
CODESIGN_IPA = 0
PACKAGE_VERSION = X.X.X-X.X

libFLEX_ARCHS = arm64

TWEAK_NAME = TubeTweaks
DISPLAY_NAME = YouTube
BUNDLE_ID = com.google.ios.youtube

EXTRA_CFLAGS := -I$(THEOS_PROJECT_DIR)/Tweaks

export ADDITIONAL_CFLAGS = -I$(THEOS_PROJECT_DIR)/Tweaks

# TubeTweaks_INJECT_DYLIBS = Tweaks/YTLite/var/jb/Library/MobileSubstrate/DynamicLibraries/YTLite.dylib .theos/obj/Gonerino.dylib .theos/obj/libFLEX.dylib .theos/obj/YTUHD.dylib .theos/obj/YouPiP.dylib .theos/obj/YouTubeDislikesReturn.dylib .theos/obj/YTABConfig.dylib .theos/obj/YouMute.dylib .theos/obj/DontEatMyContent.dylib .theos/obj/YTHoldForSpeed.dylib .theos/obj/YTVideoOverlay.dylib .theos/obj/YouGroupSettings.dylib .theos/obj/YouQuality.dylib .theos/obj/YouTimeStamp.dylib .theos/obj/YouLoop.dylib
TubeTweaks_INJECT_DYLIBS = Tweaks/YTLite/var/jb/Library/MobileSubstrate/DynamicLibraries/YTLite.dylib .theos/obj/Gonerino.dylib .theos/obj/libFLEX.dylib .theos/obj/YTUHD.dylib .theos/obj/YouPiP.dylib .theos/obj/YTABConfig.dylib .theos/obj/YouMute.dylib .theos/obj/DontEatMyContent.dylib .theos/obj/YTHoldForSpeed.dylib .theos/obj/YTVideoOverlay.dylib .theos/obj/YouGroupSettings.dylib .theos/obj/YouQuality.dylib .theos/obj/YouTimeStamp.dylib .theos/obj/YouLoop.dylib
TubeTweaks_FILES = TubeTweaks.xm $(shell find Source -name '*.xm' -o -name '*.x' -o -name '*.m')
TubeTweaks_IPA = ./tmp/Payload/YouTube.app
TubeTweaks_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unsupported-availability-guard -Wno-unused-but-set-variable -DTWEAK_VERSION=$(PACKAGE_VERSION) $(EXTRA_CFLAGS)
TubeTweaks_FRAMEWORKS = UIKit Security
TubeTweaks_USE_FISHHOOK = 0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
# SUBPROJECTS += Tweaks/Gonerino Tweaks/Alderis Tweaks/FLEXing/libflex Tweaks/iSponsorBlock Tweaks/YTUHD Tweaks/YouPiP Tweaks/Return-YouTube-Dislikes Tweaks/YTABConfig Tweaks/YouMute Tweaks/DontEatMyContent Tweaks/YTHoldForSpeed Tweaks/YTVideoOverlay Tweaks/YouQuality Tweaks/YouTimeStamp Tweaks/YouGroupSettings Tweaks/YouLoop
SUBPROJECTS += Tweaks/Gonerino Tweaks/FLEXing/libflex Tweaks/YTUHD Tweaks/YouPiP Tweaks/YTABConfig Tweaks/YouMute Tweaks/DontEatMyContent Tweaks/YTHoldForSpeed Tweaks/YTVideoOverlay Tweaks/YouQuality Tweaks/YouTimeStamp Tweaks/YouGroupSettings Tweaks/YouLoop

include $(THEOS_MAKE_PATH)/aggregate.mk

YTLITE_PATH = Tweaks/YTLite
YTLITE_DYLIB = $(YTLITE_PATH)/var/jb/Library/MobileSubstrate/DynamicLibraries/YTLite.dylib
YTLITE_BUNDLE = $(YTLITE_PATH)/var/jb/Library/Application\ Support/YTLite.bundle

before-package::
	@echo -e "==> \033[1mMoving tweak's bundle to Resources/...\033[0m"
# 	@mkdir -p Resources/Frameworks/Alderis.framework
# 	@if [ -d ".theos/obj/install/Library/Frameworks/Alderis.framework" ]; then \
# 		find .theos/obj/install/Library/Frameworks/Alderis.framework -maxdepth 1 -type f -exec cp {} Resources/Frameworks/Alderis.framework/ \; ; \
# 	elif [ -d "Tweaks/Alderis/lcpshim/.theos/obj/install/Library/Frameworks/Alderis.framework" ]; then \
# 		find Tweaks/Alderis/lcpshim/.theos/obj/install/Library/Frameworks/Alderis.framework -maxdepth 1 -type f -exec cp {} Resources/Frameworks/Alderis.framework/ \; ; \
# 	fi
	@cp -R Tweaks/YTLite/var/jb/Library/Application\ Support/YTLite.bundle Resources/
	@cp -R Tweaks/YTUHD/layout/Library/Application\ Support/YTUHD.bundle Resources/
	@cp -R Tweaks/YouPiP/layout/Library/Application\ Support/YouPiP.bundle Resources/
#   @cp -R Tweaks/Return-YouTube-Dislikes/layout/Library/Application\ Support/RYD.bundle Resources/
	@cp -R Tweaks/YTABConfig/layout/Library/Application\ Support/YTABC.bundle Resources/
	@cp -R Tweaks/YouMute/layout/Library/Application\ Support/YouMute.bundle Resources/
	@cp -R Tweaks/DontEatMyContent/layout/Library/Application\ Support/DontEatMyContent.bundle Resources/
	@cp -R Tweaks/YTHoldForSpeed/layout/Library/Application\ Support/YTHoldForSpeed.bundle Resources/
#   @cp -R Tweaks/iSponsorBlock/layout/Library/Application\ Support/iSponsorBlock.bundle Resources/
	@cp -R Tweaks/YTVideoOverlay/layout/Library/Application\ Support/YTVideoOverlay.bundle Resources/
	@cp -R Tweaks/YouQuality/layout/Library/Application\ Support/YouQuality.bundle Resources/
	@cp -R Tweaks/YouTimeStamp/layout/Library/Application\ Support/YouTimeStamp.bundle Resources/
	@cp -R Tweaks/YouLoop/layout/Library/Application\ Support/YouLoop.bundle Resources/
	@cp -R lang/TubeTweaks.bundle Resources/
	@echo -e "==> \033[1mChanging the installation path of dylibs...\033[0m"
	@ldid -r .theos/obj/iSponsorBlock.dylib && install_name_tool -change /usr/lib/libcolorpicker.dylib @rpath/libcolorpicker.dylib .theos/obj/iSponsorBlock.dylib
	@codesign --remove-signature .theos/obj/libcolorpicker.dylib && install_name_tool -change /Library/Frameworks/Alderis.framework/Alderis @rpath/Alderis.framework/Alderis .theos/obj/libcolorpicker.dylib

internal-clean::
	@rm -rf $(YTLITE_PATH)/*

before-all::
	rm -rf $(YTLITE_PATH)/*; \
	$(PRINT_FORMAT_BLUE) "Downloading YTLite"; \
	LATEST_VERSION=$$(curl -s https://api.github.com/repos/dayanch96/YTLite/releases/latest | grep -o '"tag_name": "v[^"]*"' | cut -d'"' -f4 | tr -d 'v'); \
	cd $(YTLITE_PATH) && \
	curl -s -L -O "https://github.com/dayanch96/YTLite/releases/latest/download/com.dvntm.ytlite_$${LATEST_VERSION}_iphoneos-arm64.deb" && \
	DOWNLOADED_DEB=$$(ls *.deb) && \
	tar -xf "$$DOWNLOADED_DEB" && tar -xf data.tar* && \
	cd - > /dev/null; \
	if [[ ! -f $(YTLITE_DYLIB) || ! -d $(YTLITE_BUNDLE) ]]; then \
		$(PRINT_FORMAT_ERROR) "Failed to extract YTLite"; exit 1; \
	fi; \
