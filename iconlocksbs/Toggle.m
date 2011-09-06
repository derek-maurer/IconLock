#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
#import "UIKit.h"
#import "UIModalView.h"

@interface AlertDelegate: NSObject {}
   -(void)showAlertForState:(BOOL)state;
@end

@implementation AlertDelegate 

BOOL enabled;

-(void)showAlertForState:(BOOL)state {
   enabled = state;
   UIModalView *alert = [[UIModalView alloc] initWithTitle:@"IconLock" buttons:[NSArray arrayWithObjects:@"Cancel", @"OK", nil] defaultButtonIndex:0 delegate:self context:NULL];
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

-(void)modalView:(id)view didDismissWithButtonIndex:(int)buttonIndex {

NSString *PLIST_PATH = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/com.homeschooldev.iconlock.plist"];

NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH] autorelease];

NSString *password = [NSString stringWithFormat:@"%@", [dict objectForKey:@"PassField"]];

UITextField *passField = [view textFieldAtIndex:0];
if (buttonIndex == 1) {
    if ([passField.text isEqualToString:password]) {

    if (enabled) {
       [dict setObject:[NSNumber numberWithBool:YES] forKey:@"Enabled"];
    }
    else {
       [dict setObject:[NSNumber numberWithBool:NO] forKey:@"Enabled"];
    }	      

     
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

// Required

BOOL isCapable()
{
   return YES;
}

BOOL isEnabled()
{
   NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.homeschooldev.iconlock.plist"];
BOOL enabled = [[dict objectForKey:@"Enabled"] boolValue];
   return enabled;
}

BOOL getStateFast()
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.homeschooldev.iconlock.plist"];
    BOOL enabled = [[dict objectForKey:@"Enabled"] boolValue];
    
    return enabled;
}

UIWindow* getAppWindow()
{
UIWindow* TheWindow = nil;
UIApplication* App = [UIApplication sharedApplication];
NSArray* windows = [App windows];
int i;
for(i = 0; i < [windows count]; i++)
{
TheWindow = [windows objectAtIndex:i];
if([TheWindow respondsToSelector:@selector(getCurrentTheme)])
{
break;
}
}

if(i == [windows count])
{
TheWindow = [App keyWindow];
}

return TheWindow;
}

void setState(BOOL enabled) {

    UIWindow* Window = getAppWindow();
    [Window closeButtonPressed];
NSString *PLIST_PATH = @"/var/mobile/Library/Preferences/com.homeschooldev.iconlock.plist";
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
    BOOL passenabled = [[dict objectForKey:@"PassEnabled"] boolValue];
    
    AlertDelegate *del = [[AlertDelegate alloc] init];
  
    if (enabled) {
	if (passenabled) {
	   [del showAlertForState:YES];
	}
	else {
	   [dict setObject:[NSNumber numberWithBool:YES] forKey:@"Enabled"];
[dict writeToFile:PLIST_PATH atomically:YES];
	}
    }
    else {
	if (passenabled) {
	   [del showAlertForState:NO];
	}
	else {
	   [dict setObject:[NSNumber numberWithBool:NO] forKey:@"Enabled"];
[dict writeToFile:PLIST_PATH atomically:YES];
	}
    }
 
}

float getDelayTime()
{
   return 0.0f;
}

/* Optional
void invokeHoldAction()
{
	
}

void closeWindow()
{
	
}*/





