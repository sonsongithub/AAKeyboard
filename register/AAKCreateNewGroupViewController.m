//
//  AAKCreateNewGroupViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/15.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKCreateNewGroupViewController.h"

#import "AAKKeyboardDataManager.h"

@interface AAKCreateNewGroupViewController () {
	IBOutlet UITextField *_newGroupTextField;
}
@end

@implementation AAKCreateNewGroupViewController

- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)create:(id)sender {
	NSString *newGroup = _newGroupTextField.text;
	[[AAKKeyboardDataManager defaultManager] insertNewGroup:newGroup];
	[self dismissViewControllerAnimated:YES completion:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
