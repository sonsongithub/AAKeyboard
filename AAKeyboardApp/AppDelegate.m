//
//  AppDelegate.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/06.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AppDelegate.h"

#import "AAKShared.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	NSString *body = [url.absoluteString stringByReplacingOccurrencesOfString:@"aakeyboard://app?register=" withString:@""];
	NSString *decodedString = [body stringByRemovingPercentEncoding];
	
	UINavigationController *nav = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"AAKRegisterNavigationController"];
	AAKRegisterViewController *con = (AAKRegisterViewController*)nav.topViewController;
	
	AAKASCIIArt *asciiart = [[AAKASCIIArt alloc] init];
	
	asciiart.text = decodedString;
	
	con.asciiart = asciiart;
	
	[self.window.rootViewController presentViewController:nav animated:YES completion:nil];
	
	return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

#if TARGET_IPHONE_SIMULATOR
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSLog(@"%@", documentsDirectory);
#endif
	
	[AAKKeyboardDataManager defaultManager];
	
	return YES;
}

@end
