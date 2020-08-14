#import <libactivator/libactivator.h>
#import <Cephei/HBPreferences.h>
#import <UIKit/UIKit.h>
#import <RemoteLog.h>

BOOL isEnabled = NO;
BOOL activatorSwitchActivated = NO;

@interface ActivateNow : NSObject<LAListener> {}
@end
@implementation ActivateNow

-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    @autoreleasepool {
      activatorSwitchActivated = YES;
      RLog(@"CarLift - Activated!");
    }
}

+(void)load {
    @autoreleasepool {
    	[LASharedActivator registerListener:[self new] forName:@"com.itzhouze.carlift.activate"];
    }
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
	return @"Activate";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
	return @"Temp override and disable raise to wake";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedGroupForListenerName:(NSString *)listenerName {
	return @"CarLift";
}
@end

@interface DeactivateNow : NSObject<LAListener> {}
@end
@implementation DeactivateNow

-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    @autoreleasepool {
      RLog(@"CarLift - DEACTIVATED!");
      activatorSwitchActivated = NO;
    }
}

+(void)load {
    @autoreleasepool {
    	[LASharedActivator registerListener:[self new] forName:@"com.itzhouze.carlift.deactivate"];
    }
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
	return @"Deactivate";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
	return @"Reset raise to wake to default settings";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedGroupForListenerName:(NSString *)listenerName {
	return @"CarLift";
}
@end

%hook SBLiftToWakeManager
-(void)liftToWakeController:(id)arg1 didObserveTransition:(long long)arg2 deviceOrientation:(long long)arg3  {
  if (!activatorSwitchActivated)
  {
    %orig;
  }
}
%end

// we are accessing Cephei from a tweak and it likes to throw hands if we do this so we
// set this boolean to true and it stops it. this is from the offical cephei docs
// Thanks to https://github.com/KodeyThomas
%hook HBForceCepheiPrefs
+ (BOOL)forceCepheiPrefsWhichIReallyNeedToAccessAndIKnowWhatImDoingISwear {
    return YES;
}
%end

%ctor {
  HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.itzhouze.carliftprefs"];

	// MAIN
  [preferences registerBool:&isEnabled default:YES forKey:@"isEnabled"];
}