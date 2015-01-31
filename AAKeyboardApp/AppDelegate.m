//
//  AppDelegate.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/06.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AppDelegate.h"

#import "AAKASCIIArtGroup.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	NSString *body = [url.absoluteString stringByReplacingOccurrencesOfString:@"aakeyboard://app?register=" withString:@""];
	NSString *decodedString = [body stringByRemovingPercentEncoding];
	
	UINavigationController *nav = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"AAKRegisterNavigationController"];
	AAKRegisterViewController *con = (AAKRegisterViewController*)nav.topViewController;
	
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		nav.modalPresentationStyle = UIModalPresentationFormSheet;
		[self.window.rootViewController presentViewController:nav animated:YES completion:^{
			con.AATextView.text = decodedString;
		}];
		
	}
	else {
		nav.modalPresentationStyle = UIModalPresentationCurrentContext;
		[self.window.rootViewController presentViewController:nav animated:YES completion:^{
			con.AATextView.text = decodedString;
		}];
	}
	
	return YES;
}

- (void)showKeyboardGrantWarning {
//	if (![AAKCoreDataStack hasEverAccessGroupContainerByKeyboardApp]) {
//		UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
//																	   message:NSLocalizedString(@"It couldn't be done because AAKeyboard has not been given 'Full access'. ", nil)
//																preferredStyle:UIAlertControllerStyleAlert];
//		UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
//														 style:UIAlertActionStyleDefault
//													   handler:^(UIAlertAction *action) {
//													   }];
//		[alert addAction:action];
//		[self.window.rootViewController presentViewController:alert animated:YES completion:nil];
//	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	[AAKCoreDataStack setupMagicalRecordForAppGroupsContainer];
	[self showKeyboardGrantWarning];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[MagicalRecord cleanUp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[MagicalRecord cleanUp];
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[AAKCoreDataStack setupMagicalRecordForAppGroupsContainer];
	[self showKeyboardGrantWarning];
	
	
	return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if TARGET_IPHONE_SIMULATOR
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSLog(@"%@", documentsDirectory);
#endif
	return YES;
}

@end
