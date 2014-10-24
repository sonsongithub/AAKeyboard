//
//  AAKEditViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/22.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKEditViewController.h"

#import "AAKASCIIArtGroup.h"
#import "AAKSelectGroupViewController.h"

@interface AAKEditViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation AAKEditViewController

- (void)setGroup:(AAKASCIIArtGroup *)group {
	_group = group;
	[_groupTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	_AATextView.font = [UIFont fontWithName:@"Mona" size:10];
	[_groupTableView reloadData];
	_AATextView.text = _asciiart;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

#pragma mark - IBAction

- (IBAction)didChangeSlider:(id)sender {
	_AATextView.font = [UIFont fontWithName:@"Mona" size:_fontSizeSlider.value];
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
	cell.detailTextLabel.text = _group.title;
	return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[AAKSelectGroupViewController class]]) {
		AAKSelectGroupViewController *con = segue.destinationViewController;
		con.editViewController = self;
	}
}

@end
