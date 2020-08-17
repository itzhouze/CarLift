#import <libactivator/libactivator.h>
#import <Cephei/HBPreferences.h>
#import <RemoteLog.h>

static BOOL isEnabled = NO;
static BOOL activatorSwitchActivated = NO;

@interface ActivateNow : NSObject<LAListener> {}
@end
@implementation ActivateNow

-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    @autoreleasepool {
      activatorSwitchActivated = YES;
      //RLog(@"CarLift - Activated!");
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
      //RLog(@"CarLift - DEACTIVATED!");
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
  if (isEnabled && activatorSwitchActivated)
  {
    return;
  }

  %orig;
}
%end

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

  if (!isEnabled)
  {
    return;
  }

  %init;
}