//
//  AAKCloudAARankingViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/24.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAKCloudAARankingViewController.h"

@implementation AAKCloudAARankingViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Ranking", nil);
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
	CKQuery *query = [[CKQuery alloc] initWithRecordType:@"AAKCloudASCIIArt"
											   predicate:predicate];
	query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"downloads" ascending:NO]];
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
