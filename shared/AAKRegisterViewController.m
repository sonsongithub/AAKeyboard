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
 * 現在選択されているグループオブジェクトの識別子をApp GroupのUserDefaultに保存する．
 **/
- (void)saveCurrentGroup {
	if (![self.group.objectID isTemporaryID]) {
		// Save to sharedDefaults
		NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.sonson.AAKeyboardApp"];
		[sharedDefaults setObject:self.group.objectID.URIRepresentation.absoluteString forKey:@"AAKLastRegisteredGroupURIRepresentation"];
		[sharedDefaults synchronize];
	}
}

/**
 * 最後に選択されたグループを取りだし，現在の保存先グループとしてセットする．
 **/
- (void)restoreCurrentGroup {
	NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.sonson.AAKeyboardApp"];
	NSURL *url = [NSURL URLWithString:[sharedDefaults objectForKey:@"AAKLastRegisteredGroupURIRepresentation"]];
	if (url) {
		NSManagedObjectID *objectID = [[[NSManagedObjectContext MR_defaultContext] persistentStoreCoordinator] managedObjectIDForURIRepresentation:url];
		id obj = [[NSManagedObjectContext MR_defaultContext] objectWithID:objectID];
		if ([obj isKindOfClass:[AAKASCIIArtGroup class]]) {
			AAKASCIIArtGroup *group = (AAKASCIIArtGroup*)obj;
			self.group = group;
			[_groupTableView reloadData];
		}
	}
}

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
	
	[self saveCurrentGroup];
	
	if (self.callbackSchemeURL != nil) {
#ifdef TARGET_IS_EXTENSION
		[self.extensionContext openURL:self.callbackSchemeURL completionHandler:nil];
#else
		[[UIApplication sharedApplication] openURL:self.callbackSchemeURL];
#endif
	}
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
	[self restoreCurrentGroup];
}

@end
