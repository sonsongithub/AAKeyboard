//
//  AAKDummyDatabaseWrapper.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/17.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKDummyDatabaseWrapper.h"

@implementation AAKDummyDatabaseWrapper

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
	return YES;
#endif
}

@end
