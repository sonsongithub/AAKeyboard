//
//  AAKRegisterViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/22.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKRegisterViewController.h"

#import "AAKKeyboardDataManager.h"
#import "_AAKASCIIArtGroup.h"
#import "_AAKASCIIArt.h"

@interface AAKRegisterViewController ()

@end

@implementation AAKRegisterViewController

/**
 * 登録ボタンを押したときのイベント処理．
 * @param sender メッセージの送信元オブジェクト．
 **/
- (IBAction)registerAA:(id)sender {
//	[[AAKKeyboardDataManager defaultManager] insertNewASCIIArt:self.AATextView.text groupKey:self.group_.key];
	[self dismissViewControllerAnimated:YES completion:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil userInfo:nil];
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
//	self.asciiart_ = [[_AAKASCIIArt alloc] init];
//	self.asciiart_.text = self.AATextView.text;
//	self.asciiart_.group = [_AAKASCIIArtGroup defaultGroup];
}

@end
