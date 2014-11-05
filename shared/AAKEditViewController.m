//
//  AAKEditViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/22.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKEditViewController.h"

#import "AAKASCIIArt.h"
#import "AAKASCIIArtGroup.h"
#import "AAKSelectGroupViewController.h"
#import "AAKKeyboardDataManager.h"

@interface AAKEditViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation AAKEditViewController

#pragma mark - Instance method

/**
 * セッター．アスキーアートが更新された時にグループの選択UIを更新するために実装．
 * @param asciiart アスキーアートオブジェクト．
 **/
- (void)setArt:(AAKASCIIArt *)art {
	_art = art;
	[_groupTableView reloadData];
}

/**
 * セッター．アスキーアートが更新された時にグループの選択UIを更新するために実装．
 * @param group アスキーアートのグループオブジェクト．
 **/
- (void)setGroup:(AAKASCIIArtGroup *)group {
	_art.group = group;
	[_groupTableView reloadData];
}

#pragma mark - IBAction

/**
 * 保存ボタンを押したときのイベント処理．
 * @param sender メッセージの送信元オブジェクト．
 **/
- (IBAction)save:(id)sender {
	_art.text = _AATextView.text;
	[[AAKKeyboardDataManager defaultManager] updateASCIIArt:_art];
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
	_AATextView.text = _art.text;
	[_groupTableView reloadData];
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
	cell.detailTextLabel.text = _art.group.title;
	return cell;
}

@end
