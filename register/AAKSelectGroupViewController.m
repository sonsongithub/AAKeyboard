//
//  AAKSelectGroupViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/15.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKSelectGroupViewController.h"
#import "ActionViewController.h"
#import "AAKKeyboardDataManager.h"
#import "AAKASCIIArtGroup.h"
#import "AAKEditViewController.h"

@interface AAKSelectGroupViewController () {
	NSArray *_groups;
}

@end

@implementation AAKSelectGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_groups = [[AAKKeyboardDataManager defaultManager] allGroups];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateNewGroupNotification:) name:AAKKeyboardDataManagerDidCreateNewGroupNotification object:nil];
}

- (void)didCreateNewGroupNotification:(NSNotification*)notification {
	_groups = [[AAKKeyboardDataManager defaultManager] allGroups];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark - Table view data source

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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	_editViewController.group = _groups[indexPath.row];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
