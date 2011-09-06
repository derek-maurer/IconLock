include theos/makefiles/common.mk

BUNDLE_NAME = IconLock
IconLock_FILES = IconLock.mm
IconLock_INSTALL_PATH = /Library/PreferenceBundles
IconLock_FRAMEWORKS = UIKit
IconLock_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/IconLock.plist$(ECHO_END)
