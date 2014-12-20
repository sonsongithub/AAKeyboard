//
//  AAKCoreDataStack.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/18.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKCoreDataStack.h"

NSString *const AAKKeyboardDataManagerDidUpdateNotification			= @"AAKKeyboardDataManagerDidUpdateNotification";

@implementation AAKCoreDataStack

/**
 * 実行中のプロセスが共有データにアクセスできるかを判定する．
 * @return 共有データにアクセスできる場合は，YESを返す．
 **/
+ (BOOL)isOpenAccessGranted {
#ifdef DISABLED_APP_GROUPS
	DNSLog(@"Full Access: Off by force.");
	return NO;
#else
	NSError *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *containerPath = [[fm containerURLForSecurityApplicationGroupIdentifier:@"group.com.sonson.AAKeyboardApp"] path];
	
	[fm contentsOfDirectoryAtPath:containerPath error:&error];
	
	if (error != nil) {
		DNSLog(@"Full Access: Off , %@", [error localizedDescription]);
		return NO;
	}
	
	DNSLog(@"Full Access On");
	
	NSString *accessLockPath = [containerPath stringByAppendingPathComponent:@"access.lock"];
	if (![fm isReadableFileAtPath:accessLockPath])
		[@"access" writeToFile:accessLockPath atomically:NO encoding:NSUTF8StringEncoding error:&error];
	
	return YES;
#endif
}

+ (BOOL)hasEverAccessGroupContainerByKeyboardApp {
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *containerPath = [[fm containerURLForSecurityApplicationGroupIdentifier:@"group.com.sonson.AAKeyboardApp"] path];
	NSString *accessLockPath = [containerPath stringByAppendingPathComponent:@"access.lock"];
	return [fm isReadableFileAtPath:accessLockPath];
}

+ (void)addDefaultData {
	NSArray *array = [AAKASCIIArt MR_findAll];
	if (array.count > 0)
		return;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"default.json" ofType:nil];
	NSData *jsonData = [NSData dataWithContentsOfFile:path];
	NSArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
	
	int i = 1;
	
	for (NSDictionary *dict in json) {
		NSString *title = dict[@"name"];
		NSArray *aa_array = dict[@"aa"];
		
		AAKASCIIArtGroup *group	= [AAKASCIIArtGroup MR_createEntity];
		group.title = title;
		group.type = AAKASCIIArtNormalGroup;
		group.order = i++;
		
		for (NSString *aa in [aa_array reverseObjectEnumerator]) {
			AAKASCIIArt *newASCIIArt = [AAKASCIIArt MR_createEntity];
			newASCIIArt.text = aa;
			newASCIIArt.group = group;
			[newASCIIArt updateLastUsedTime];
			[newASCIIArt updateRatio];
		}
	}
	
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

+ (void)setupMagicalRecordForAppGroupsContainer {
	NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sonson.AAKeyboardApp"];
	NSURL *fileURL = [containerURL URLByAppendingPathComponent:@"asciiart.db"];
	DNSLog(@"%@", fileURL);
	[MagicalRecord setupCoreDataStackWithStoreAtURL:fileURL];
	[AAKASCIIArtGroup addDefaultASCIIArtGroup];
	[AAKCoreDataStack addDefaultData];
}

+ (void)setupMagicalRecordForLocal {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = paths[0];
	NSURL *containerURL = [NSURL fileURLWithPath:path];
	NSURL *fileURL = [containerURL URLByAppendingPathComponent:@"asciiart.db"];
	DNSLog(@"%@", fileURL);
	[MagicalRecord setupCoreDataStackWithStoreAtURL:fileURL];
	[AAKCoreDataStack addDefaultData];
}

@end
