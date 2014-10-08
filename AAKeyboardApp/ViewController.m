//
//  ViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/06.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "ViewController.h"
#import "DummyKeyboardViewController.h"

@interface ViewController () {
}
@end

@implementation ViewController

- (UITraitCollection *)overrideTraitCollectionForChildViewController:(UIViewController *)childViewController {
	return self.traitCollection;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	DummyKeyboardViewController *controller = [[DummyKeyboardViewController alloc] init];
	[self addChildViewController:controller];
	[self.view addSubview:controller.view];
}

@end
