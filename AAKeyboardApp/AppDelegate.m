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
	
	_AAKASCIIArt *asciiart = [[_AAKASCIIArt alloc] init];
	
	asciiart.text = decodedString;
	
	con.asciiart_ = asciiart;
	
	[self.window.rootViewController presentViewController:nav animated:YES completion:nil];
	
	return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[MagicalRecord cleanUp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[MagicalRecord cleanUp];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sonson.AAKeyboardApp"];
	NSURL *fileURL = [containerURL URLByAppendingPathComponent:@"asciiart.db"];
	
	[MagicalRecord setupCoreDataStackWithStoreAtURL:fileURL];
	
	[AAKASCIIArtGroup addDefaultASCIIArtGroup];
	
	NSArray *people = [AAKASCIIArtGroup MR_findAll];
	for (AAKASCIIArtGroup *group in people) {
		DNSLog(@"---------->%@", group);
		DNSLog(@"%@", group.title);
	}
	
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

#if TARGET_IPHONE_SIMULATOR
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSLog(@"%@", documentsDirectory);
#endif
	
	[AAKKeyboardDataManager defaultManager];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		UINavigationController *nav = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"AAKRegisterNavigationController"];
		AAKRegisterViewController *con = (AAKRegisterViewController*)nav.topViewController;
		
		_AAKASCIIArt *asciiart = [[_AAKASCIIArt alloc] init];
		
		asciiart.text = @"a";
		
		con.asciiart_ = asciiart;
		
		[self.window.rootViewController presentViewController:nav animated:YES completion:nil];
	});
	
	
	return YES;
}

@end
