//
//  AAKRegisterViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/22.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKRegisterViewController.h"

#import "AAKASCIIArtGroup.h"
#import "AAKASCIIArt.h"

@interface AAKRegisterViewController ()

@end

@implementation AAKRegisterViewController

/**
 * 登録ボタンを押したときのイベント処理．
 * @param sender メッセージの送信元オブジェクト．
 **/
- (IBAction)registerAA:(id)sender {
	AAKASCIIArt *newASCIIArt = [AAKASCIIArt MR_createEntity];
	newASCIIArt.text = self.AATextView.text;
	newASCIIArt.group = self.group;
	
	[newASCIIArt updateLastUsedTime];
	[newASCIIArt updateRatio];
	
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
	
	[self dismissViewControllerAnimated:YES completion:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil userInfo:nil];
	
	if (![self.group.objectID isTemporaryID]) {
		// Save to sharedDefaults
		NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.sonson.AAKeyboardApp"];
		[sharedDefaults setObject:self.group.title forKey:@"AAKLastRegisteredGroupTitle"];
		[sharedDefaults synchronize];
	}
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.sonson.AAKeyboardApp"];
	NSURL *groupTitle = [sharedDefaults objectForKey:@"AAKLastRegisteredGroupTitle"];
	
	NSArray *groups = [AAKASCIIArtGroup MR_findAllWithPredicate:[NSPredicate predicateWithFormat: @"title == %@", groupTitle]];
	if (groups.count > 0) {
		self.group = groups[0];
		[_groupTableView reloadData];
	}
}

@end
