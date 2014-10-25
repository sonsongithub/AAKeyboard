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

@interface AAKRegisterViewController ()

@end

@implementation AAKRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.group = [AAKASCIIArtGroup defaultGroup];
}

- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerAA:(id)sender {
	[[AAKKeyboardDataManager defaultManager] insertNewASCIIArt:_AATextView.text groupKey:self.group.key];
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end
