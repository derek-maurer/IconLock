include theos/makefiles/common.mk

LIBRARY_NAME = Toggle
Toggle_FILES = Toggle.m
Toggle_FRAMEWORKS = UIKit CoreGraphics
Toggle_INSTALL_PATH = /var/mobile/Library/SBSettings/Toggles/IconLock/

include $(THEOS_MAKE_PATH)/library.mk

internal-stage::
	$(ECHO_NOTHING)cp -r Themes $(THEOS_STAGING_DIR)/var/mobile/Library/SBSettings/$(ECHO_END)

after-install::
	ssh root@$(THEOS_DEVICE_IP) 'killall SpringBoard'

