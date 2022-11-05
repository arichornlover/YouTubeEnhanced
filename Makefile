TARGET = iphone:clang:15.5:14.0
YouTubePlus_USE_FLEX = 0
YouTubePlus_USE_FISHHOOK = 0
ARCHS = arm64
MODULES = jailed
FINALPACKAGE = 1
CODESIGN_IPA = 0
PACKAGE_VERSION = 17.43.1

TWEAK_NAME = YouTubePlus
DISPLAY_NAME = YouTube
BUNDLE_ID = com.google.ios.youtube
 
YTRebornPlus_INJECT_DYLIBS = .theos/obj/libcolorpicker.dylib .theos/obj/iSponsorBlock.dylib .theos/obj/YTUHD.dylib .theos/obj/YouPiP.dylib .theos/obj/YouTubeDislikesReturn.dylib .theos/obj/YTABConfig.dylib
YTRebornPlus_FILES = YouTubePlus.xm Settings.xm
YTRebornPlus_IPA = ./tmp/Payload/YouTube.app
YTRebornPlus_CFLAGS = -fobjc-arc -DTWEAK_VERSION=$(PACKAGE_VERSION)
YTRebornPlus_FRAMEWORKS = UIKit Security

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Tweaks/Alderis Tweaks/iSponsorBlock Tweaks/YTUHD Tweaks/YouPiP Tweaks/Return-YouTube-Dislikes Tweaks/YTABConfig
include $(THEOS_MAKE_PATH)/aggregate.mk

before-package::
	@echo -e "==> \033[1mMoving tweak's bundle to Resources/...\033[0m"
	@mkdir -p Resources/Frameworks/Alderis.framework && find .theos/obj/install/Library/Frameworks/Alderis.framework -maxdepth 1 -type f -exec cp {} Resources/Frameworks/Alderis.framework/ \;
	@cp -R Tweaks/YTUHD/layout/Library/Application\ Support/YTUHD.bundle Resources/
	@cp -R Tweaks/YouPiP/layout/Library/Application\ Support/YouPiP.bundle Resources/
	@cp -R Tweaks/Return-YouTube-Dislikes/layout/Library/Application\ Support/RYD.bundle Resources/
	@cp -R Tweaks/YTABConfig/layout/Library/Application\ Support/YTABC.bundle Resources/
	@cp -R Tweaks/iSponsorBlock/layout/Library/Application\ Support/iSponsorBlock.bundle Resources/
	@cp -R lang/YouTubePlus.bundle Resources/
	@echo -e "==> \033[1mChanging the installation path of dylibs...\033[0m"
	@codesign --remove-signature .theos/obj/iSponsorBlock.dylib && install_name_tool -change /usr/lib/libcolorpicker.dylib @rpath/libcolorpicker.dylib .theos/obj/iSponsorBlock.dylib
	@codesign --remove-signature .theos/obj/libcolorpicker.dylib && install_name_tool -change /Library/Frameworks/Alderis.framework/Alderis @rpath/Alderis.framework/Alderis .theos/obj/libcolorpicker.dylib	
