//
//  AAKBaseViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/08.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKBaseViewController.h"

#import "AAKToolbarController.h"
#import "AAKContentViewController.h"

@interface AAKBaseViewController () {
	AAKToolbarController *_toolbarController;
	AAKContentViewController *_contentViewController;
}
@end

@implementation AAKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor darkGrayColor];
	
	_toolbarController = [[AAKToolbarController alloc] init];
	[self.view addSubview:_toolbarController.view];
	[self addChildViewController:_toolbarController];
	
	_contentViewController = [[AAKContentViewController alloc] init];
	[self.view addSubview:_contentViewController.view];
	[self addChildViewController:_contentViewController];
	
	UIView *contentView = _contentViewController.view;
	contentView.translatesAutoresizingMaskIntoConstraints = NO;
	
	UIView *toolbar = _toolbarController.view;
	toolbar.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSDictionary *views = NSDictionaryOfVariableBindings(toolbar, contentView);
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[toolbar]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[contentView]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[contentView]-0-[toolbar]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:toolbar
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1
														   constant:80]];
	
	[self.view updateConstraints];
	
	[_toolbarController setCategories:@[@"hoge", @"hoooo",@"hoge", @"hoooo",@"hoge", @"hoooo",@"hoge"]];
}

@end
