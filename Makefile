include theos/makefiles/common.mk

TWEAK_NAME = IconLock
IconLock_FILES = Tweak.xm
IconLock_FRAMEWORKS = UIKit
SUBPROJECTS = iconlock iconlocksbs
include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/tweak.mk
