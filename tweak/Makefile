ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CarLift
CarLift_FILES = Tweak.x
CarLift_CFLAGS = -fobjc-arc
CarLift_LIBRARIES = activator
CarLift_FRAMEWORKS = UIKit
CarLift_EXTRA_FRAMEWORKS += Cephei
CarLift_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk