THEOS_DEVICE_IP = 10.20.100.83

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += tweak carliftprefs

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
