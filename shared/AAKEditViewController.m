//
//  AAKEditViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/22.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKEditViewController.h"

#import "AAKHelper.h"
#import "AAKSelectGroupViewController.h"

#import "AAKASCIIArt.h"
#import "AAKASCIIArtGroup.h"

@interface AAKEditViewController () <UITableViewDataSource, UITableViewDelegate>
@end

UIView *topView(UIView *current) {
	if (current.superview == nil) {
		if ([current isKindOfClass:[UIWindow class]])
			return current;
		return nil;
	}
	return topView(current.superview);
}

@implementation AAKEditViewController

- (void)setGroup:(AAKASCIIArtGroup *)group {
	_group = group;
	[_groupTableView reloadData];
}

#pragma mark - Instance method

- (CGFloat)getSpaceKeyboardRect:(CGRect)keyboardRect {
#ifndef TARGET_IS_EXTENSION
	UIView *rootView = [[UIApplication sharedApplication] keyWindow];
	CGRect rect = [rootView convertRect:_AATextView.frame fromView:self.view];
#else
	UIView *rootView = topView(self.view);
	CGRect rect = [rootView convertRect:_AATextView.frame fromView:self.view];
	UIScreen *mainScreen = [UIScreen mainScreen];
	rect.origin.x += floor((mainScreen.bounds.size.width - rootView.bounds.size.width)/2);
	rect.origin.y += floor((mainScreen.bounds.size.height - rootView.bounds.size.height)/2);
#endif
	CGRect intersected = CGRectIntersection(keyboardRect, rect);
	return intersected.size.height;
}

- (void)keyboardWillChangeFrameNotification:(NSNotification*)notification {
	CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	_bottomTextViewMargin.constant = [self getSpaceKeyboardRect:rect];
}

#pragma mark - IBAction

/**
 * 保存ボタンを押したときのイベント処理．
 * @param sender メッセージの送信元オブジェクト．
 **/
- (IBAction)save:(id)sender {
	self.asciiart.text = _AATextView.text;
	self.asciiart.group = self.group;
	[self.asciiart updateLastUsedTime];
	[self.asciiart updateRatio];
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
	[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil userInfo:nil];
	[self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * キャンセルボタンを押したときのイベント処理．
 * @param sender メッセージの送信元オブジェクト．
 **/
- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * フォントサイズを調整するスライダの値が変わった時のイベント処理．
 * @param sender メッセージの送信元オブジェクト．
 **/
- (IBAction)didChangeSlider:(id)sender {
	_AATextView.font = [UIFont fontWithName:@"Mona" size:_fontSizeSlider.value];
}

#pragma mark - Override

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[AAKSelectGroupViewController class]]) {
		// グループ選択ビューにこのビューコントローラのインスタンスを渡す
		// コードが汚い
		AAKSelectGroupViewController *con = segue.destinationViewController;
		con.editViewController = self;
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// UIを更新
	_AATextView.font = [UIFont fontWithName:@"Mona" size:10];
	_AATextView.text = self.asciiart.text;
	
	// デフォルトグループを取得
	self.group = [AAKASCIIArtGroup defaultGroup];
	
	[_groupTableView reloadData];
	
	// キーボードのサイズ変更
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	cell.detailTextLabel.text = self.group.title;
	return cell;
}

@end
