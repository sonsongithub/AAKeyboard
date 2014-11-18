//
//  AAKSelectGroupViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/15.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKSelectGroupViewController.h"
#import "AAKEditViewController.h"
#import "AAKASCIIArtGroup.h"

@interface AAKSelectGroupViewController () {
	NSMutableArray *_groups;
}

@end

@implementation AAKSelectGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_groups = [NSMutableArray arrayWithArray:[AAKASCIIArtGroup MR_findAll]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDataManagerDidUpdateNotification:) name:AAKKeyboardDataManagerDidUpdateNotification object:nil];
}

- (void)keyboardDataManagerDidUpdateNotification:(NSNotification*)notification {
	_groups = [NSMutableArray arrayWithArray:[AAKASCIIArtGroup MR_findAll]];
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.navigationController setToolbarHidden:NO animated:YES];
	self.toolbarItems = @[self.editButtonItem];
	[self.tableView reloadData];
}

#pragma mark - Table view data source

/**
 * 削除したときの挙動．
 **/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		AAKASCIIArtGroup *removing = _groups[indexPath.row];
		[removing MR_deleteEntity];
		[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
		[_groups removeObjectAtIndex:indexPath.row];
		[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil userInfo:nil];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	AAKASCIIArtGroup *group = _groups[indexPath.row];
	if (group.type == AAKASCIIArtDefaultGroup)
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
	for (AAKASCIIArtGroup *grp in _groups)
		grp.order = i++;
	
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
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
	AAKASCIIArtGroup *group = _groups[indexPath.row];
	cell.textLabel.text = group.title;
	
	if ([group isEqual:_editViewController.group])
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	_editViewController.group = _groups[indexPath.row];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
