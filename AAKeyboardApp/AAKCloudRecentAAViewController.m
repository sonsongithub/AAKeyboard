//
//  AAKCloudRecentAAViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/24.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAKCloudRecentAAViewController.h"

@implementation AAKCloudRecentAAViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = NSLocalizedString(@"New", nil);
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
	CKQuery *query = [[CKQuery alloc] initWithRecordType:@"AAKCloudASCIIArt"
											   predicate:predicate];
	query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]];
	_query = query;
	[self startQuery];
}

#pragma mark <AAKCloudAAViewController>

- (void)didFailCloudKitQuery {
	[super didFailCloudKitQuery];
}

- (void)didFinishCloudKitQuery {
	[super didFinishCloudKitQuery];
}

@end
