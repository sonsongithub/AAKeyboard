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
#import "AAKGroupRenameViewController.h"

@interface AAKSelectGroupViewController () {
	NSMutableArray *_groups;
}

@end

@implementation AAKSelectGroupViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"ToAAKGroupRenameViewController"]) {
		AAKGroupRenameViewController *con = segue.destinationViewController;
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		AAKASCIIArtGroup *group = _groups[indexPath.row];
		con.group = group;
	}
}

- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:^{
	}];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_groups = [NSMutableArray arrayWithArray:[AAKASCIIArtGroup MR_findAllSortedBy:@"order" ascending:YES]];
	self.tableView.allowsSelectionDuringEditing = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDataManagerDidUpdateNotification:) name:AAKKeyboardDataManagerDidUpdateNotification object:nil];
	
	if (self.navigationController.viewControllers[0] == self) {
		UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
		self.navigationItem.leftBarButtonItem = button;
	}
}

- (void)keyboardDataManagerDidUpdateNotification:(NSNotification*)notification {
	_groups = [NSMutableArray arrayWithArray:[AAKASCIIArtGroup MR_findAllSortedBy:@"order" ascending:YES]];
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
	
	// 通常時の右端のアクセサリ
	if ([group isEqual:_editViewController.group])
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
	
	// 編集時の右端のアクセサリ
	if (group.type != AAKASCIIArtDefaultGroup)
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	else
		cell.editingAccessoryType = UITableViewCellAccessoryNone;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView.editing) {
		AAKASCIIArtGroup *group = _groups[indexPath.row];
		if (group.type != AAKASCIIArtDefaultGroup) {
			[self performSegueWithIdentifier:@"ToAAKGroupRenameViewController" sender:self];
		}
		else {
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
	}
	else {
		_editViewController.group = _groups[indexPath.row];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

@end