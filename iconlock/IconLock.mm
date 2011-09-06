#import <Preferences/Preferences.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ICONLOCK_PLIST_PATH @"/var/mobile/Library/Preferences/com.homeschooldev.iconlock.plist"
#define PASS_PLIST_PATH @"/var/mobile/Library/Preferences/com.homeschooldev.passiconlock.plist"

@interface IconLockListController: PSListController  {
    
}
-(NSArray *)loadSpecifiersWithPlist:(NSString *)plist;
-(void)donateButton:(id)arg;
-(void)twitterButton:(id)arg;
-(void)bugButton:(id)arg;
-(void)enteredPass:(NSString *)string;
@end

@implementation IconLockListController
- (id)specifiers {
    if(_specifiers == nil) {
	_specifiers = [self loadSpecifiersWithPlist:nil];
    }

    return _specifiers;
}

-(NSArray *)loadSpecifiersWithPlist:(NSString *)plist {
    NSDictionary *icondict = [[[NSDictionary alloc] initWithContentsOfFile:ICONLOCK_PLIST_PATH] autorelease];
    
    NSArray *spec = [[[NSArray alloc] init] autorelease];
	
	if ([[icondict objectForKey:@"PassEnabled"] boolValue]){
	    spec = [[self loadSpecifiersFromPlistName:@"PasswordPlist" target:self] retain];
	}   
	else {
	    spec = [[self loadSpecifiersFromPlistName:@"IconLock" target: self] retain];
	}
    
    
    return spec;
}

-(void)enteredPass:(id)arg {
    
    [self reload];

    NSDictionary *passdict = [[[NSDictionary alloc] initWithContentsOfFile:PASS_PLIST_PATH] autorelease];
    
    NSDictionary *icondict = [[[NSDictionary alloc] initWithContentsOfFile:ICONLOCK_PLIST_PATH] autorelease];

    NSString *enteredPass = [passdict objectForKey:@"PassEnteryField"];
    NSString *savedPass = [icondict objectForKey:@"PassField"];
    
    if ([enteredPass isEqualToString:savedPass]) {
	for (int i=0; i<5; i++) {
	    [self removeSpecifierAtIndex:i animated:YES];
	}

    NSArray *array = [[[NSArray alloc] init] autorelease];
    array = [self loadSpecifiersFromPlistName:@"IconLock" target:self];
    int arraySize = array.count;
	
    for (int i=0; i<arraySize; i++) {
	[self addSpecifier:[array objectAtIndex:i] animated:YES];
    }
    }
    else {
	UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You entered an incorrect password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[error show];
	[error release];
    }
}

-(void)getPass:(id)arg {
    /*NSDictionary *dict = [[[NSDictionary alloc] initWithContentsOfFile:ICONLOCK_PLIST_PATH] autorelease];
    NSString *pass = [dict objectForKey:@"PassEnteryField"];
    PSSpecifier *spec = [self specifierAtIndex:4];
    NSArray *values = spec.values;
    NSLog(@"%@ %@",values, pass);*/
}

-(void)twitterButton:(id)arg {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/homesch00ldev"]];
}

-(void)bugButton:(id)arg {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:derekm9292@gmail.com?&subject=IconLock%20bug"]];
}

-(void)donateButton:(id)arg {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=C2VUW8ZXX3XFC"]];
}

@end

/*
static void passReloadPrefsNotification(CFNotificationCenterRef center,
					   void *observer,
					   CFStringRef name,
					   const void *object,
					   CFDictionaryRef userInfo) {
    IconLockListController *controller = [[IconLockListController alloc] init];
[controller passwordSwitchChanged];
[controller release];
   
}

static __attribute__((constructor)) void awesomeInitFunction() {
    CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
	CFNotificationCenterAddObserver(r, NULL, &passReloadPrefsNotification,
				    CFSTR("com.homeschooldev.passswitch"), NULL, 0); 

}*/
// vim:ft=objc
