//
//  AAKRegisterViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/22.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKRegisterViewController.h"

#import "AAKKeyboardDataManager.h"
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
	[[AAKKeyboardDataManager defaultManager] insertNewASCIIArt:self.AATextView.text groupKey:self.art.group.key];
	[self dismissViewControllerAnimated:YES completion:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil userInfo:nil];
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
	self.art = [[AAKASCIIArt alloc] init];
	self.art.text = self.AATextView.text;
	self.art.group = [AAKASCIIArtGroup defaultGroup];
}

@end
