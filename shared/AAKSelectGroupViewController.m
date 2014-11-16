//
//  AAKSelectGroupViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/15.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKSelectGroupViewController.h"
#import "AAKKeyboardDataManager.h"
#import "_AAKASCIIArtGroup.h"
#import "AAKEditViewController.h"
#import "_AAKASCIIArt.h"

@interface AAKSelectGroupViewController () {
	NSMutableArray *_groups;
}

@end

@implementation AAKSelectGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_groups = [NSMutableArray arrayWithArray:[[AAKKeyboardDataManager defaultManager] allGroups]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDataManagerDidUpdateNotification:) name:AAKKeyboardDataManagerDidUpdateNotification object:nil];
}

- (void)keyboardDataManagerDidUpdateNotification:(NSNotification*)notification {
	_groups = [NSMutableArray arrayWithArray:[[AAKKeyboardDataManager defaultManager] allGroups]];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.navigationController setToolbarHidden:NO animated:YES];
	
//	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:nil action:nil];
	self.toolbarItems = @[self.editButtonItem];
	
	[self.tableView reloadData];
}

#pragma mark - Table view data source


/**
 * 削除したときの挙動．
 **/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		id removing = _groups[indexPath.row];
		[[AAKKeyboardDataManager defaultManager] moveToDefaultGroupFromASCIIArtGroup:removing];
		[[AAKKeyboardDataManager defaultManager] deleteASCIIArtGroup:removing];
		[_groups removeObjectAtIndex:indexPath.row];
		[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil userInfo:nil];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	_AAKASCIIArtGroup *group = _groups[indexPath.row];
	if (group.key == 1)
		return UITableViewCellEditingStyleNone;
	return UITableViewCellEditingStyleDelete;
}

/**
 * セルを移動したときの移動先のindex値を返す．
 * 履歴などの固定セルがある場合は，そのindex値を返さないにする．
 **/
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	return proposedDestinationIndexPath;
}

/**
 * 移動したときの処理．
 **/
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	id moving = _groups[fromIndexPath.row];
	[_groups removeObjectAtIndex:fromIndexPath.row];
	[_groups insertObject:moving atIndex:toIndexPath.row];
	
	int i = 0;
	for (_AAKASCIIArtGroup *grp in _groups)
		grp.number = i++;
	for (_AAKASCIIArtGroup *grp in _groups)
		[[AAKKeyboardDataManager defaultManager] updateASCIIArtGroup:grp];
	[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil userInfo:nil];
}

/**
 * セルの移動が可能かを返す．
 * 履歴などの固定セルは移動できないようにする．
 **/
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

/**
 * セルの編集（つまり削除）が可能かを返す．
 * 履歴などの固定セルは編集できないようにする．
 **/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	_AAKASCIIArtGroup *group = _groups[indexPath.row];
	cell.textLabel.text = group.title;
	
//	if (group.key == _editViewController.group_.key)
//		cell.accessoryType = UITableViewCellAccessoryCheckmark;
//	else
//		cell.accessoryType = UITableViewCellAccessoryNone;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[_editViewController setGroup_:_groups[indexPath.row]];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
