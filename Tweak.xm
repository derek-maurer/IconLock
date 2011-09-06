#import <UIKit/UIKit.h>
#import "UIModalView.h"
//#import "SBIconController.h"
#import <SpringBoard/SBIconController.h>
#import "SpringBoard.h"

%class SBIconController
%class SBIconModel
%class SBIcon

@interface AlertDelegate: NSObject {

}
@end

@implementation AlertDelegate 

-(void)modalView:(id)view didDismissWithButtonIndex:(int)buttonIndex {

NSString *PLIST_PATH = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/com.homeschooldev.iconlock.plist"];

NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH] autorelease];

NSString *password = [NSString stringWithFormat:@"%@", [dict objectForKey:@"PassField"]];

UITextField *passField = [view textFieldAtIndex:0];
if (buttonIndex == 1) {
    if ([passField.text isEqualToString:password]) {
	 BOOL jitter = YES;
	 NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];	       [standardUserDefaults setBool:jitter forKey:@"IconLockPass"];
		[standardUserDefaults synchronize];

	SBIconController *controller = [$SBIconController sharedInstance];
	SBIcon *icon = [$SBIconModel sharedInstance];
	icon = [controller lastTouchedIcon];
	[controller _iconCanBeGrabbed:icon];
    }
    else {
	UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You entered an incorrect password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[error show];
	[error release];
    }
    [dict writeToFile:PLIST_PATH atomically:YES];
}
[self release];

}
@end




#define PLIST_PATH @"/var/mobile/Library/Preferences/com.homeschooldev.iconlock.plist"

%hook SBIconController

-(BOOL)_iconCanBeGrabbed:(id)grabbed {

NSDictionary *dict = [[[NSDictionary alloc] initWithContentsOfFile:PLIST_PATH] autorelease];

if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IconLockPass"] == YES) {
  return YES;
}

if (![[dict objectForKey:@"Enabled"] boolValue]){
  return YES;
}

return NO;
}

-(void)setIsEditing:(BOOL)editing {
//Test to see if tweak is enabled
NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH] autorelease];
if ([[dict objectForKey:@"Enabled"] boolValue]) {
if ([[dict objectForKey:@"PassEnabled"] boolValue]) {

if (!editing) {
BOOL jitter = NO;
	 NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];	       [standardUserDefaults setBool:jitter forKey:@"IconLockPass"];
		[standardUserDefaults synchronize];
}

if (editing) {
    NSString *pass = [dict objectForKey:@"PassField"];
    if (pass == nil || [pass isEqualToString:@""]) {

	UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"IconLock: Error" message:@"You must enter a password or disable the password protection feature from the settings app" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[error show];
	[error release];
    }
    else {
    UIModalView *alert = [[UIModalView alloc] initWithTitle:@"IconLock" buttons:[NSArray arrayWithObjects:@"Cancel", @"OK", nil] defaultButtonIndex:0 delegate:[[AlertDelegate alloc] init] context:NULL];
    [alert setBodyText:@"Enter a password to move icons"];
    [alert setNumberOfRows:1];
    [alert addTextFieldWithValue:@"" label:@"Password"];
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.placeholder = @"Password";
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;

  
    [alert popupAlertAnimated:YES];
    [alert release];

    }
    }	
}
}
%orig;
}

%end

