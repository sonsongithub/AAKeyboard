//
//  AppDelegate.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/06.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AppDelegate.h"
#import "AAKKeyboardDataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 * 2tchのスキーマが読み出されたときにコールされるデリゲートメソッド．
 * アプリケーションがactive, background, スリープのときにはこのメソッドがコールされる．
 * アプリケーションが起動していないときは，このメソッドはコールされない．
 * @param application UIApplicationオブジェクト．
 * @param url エラーオブジェクト．
 **/
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)URL {
	NSLog(@"%@", URL);
	NSString *body = [URL.absoluteString stringByReplacingOccurrencesOfString:@"aakeyboard://" withString:@""];
	NSString *aa = [body stringByRemovingPercentEncoding];
	NSLog(@"%@", aa);
	return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
#if TARGET_IPHONE_SIMULATOR
	// Show the path to document directory for iOS simulator
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSLog(@"%@", documentsDirectory);
#endif
	
	NSArray *a = [[AAKKeyboardDataManager defaultManager] groups];
	NSLog(@"%@", a);
	
	[AAKKeyboardDataManager defaultManager];

	if ([launchOptions objectForKey:UIApplicationLaunchOptionsURLKey]) {
		NSURL *URL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
		NSLog(@"%@", URL);
		NSString *body = [URL.absoluteString stringByReplacingOccurrencesOfString:@"aakeyboard://app?register=" withString:@""];
		NSString *aa = [body stringByRemovingPercentEncoding];
		NSLog(@"%@", aa);
	}
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
