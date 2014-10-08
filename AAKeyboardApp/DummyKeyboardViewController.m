//
//  DummyKeyboardViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/07.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "DummyKeyboardViewController.h"

#import "AAKCategorySelectViewController.h"

@interface DummyKeyboardViewController () {
	AAKCategorySelectViewController *_categorySelectViewController;
}
@end

@implementation DummyKeyboardViewController

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	UIView *selfView = self.view;
	NSDictionary *views = NSDictionaryOfVariableBindings(selfView);
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[selfView]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	[self.view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[selfView]-(==0)-|"
																				options:0 metrics:0 views:views]];
	[self.view.superview addConstraint:[NSLayoutConstraint constraintWithItem:selfView
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1
														   constant:216]];
	[self updateViewConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor lightGrayColor];
	
	// Do any additional setup after loading the view, typically from a nib.
	_categorySelectViewController = [[AAKCategorySelectViewController alloc] init];
	[self.view addSubview:_categorySelectViewController.view];
	
	[self addChildViewController:_categorySelectViewController];
	
	UIView *categorySelectView = _categorySelectViewController.view;
	categorySelectView.translatesAutoresizingMaskIntoConstraints = NO;
	NSDictionary *views = NSDictionaryOfVariableBindings(categorySelectView);
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[categorySelectView]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[categorySelectView]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:categorySelectView
														  attribute:NSLayoutAttributeHeight
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1
														   constant:80]];
	[self.view updateConstraints];
	
	// remained 216 - 48 = 168
	
	[_categorySelectViewController setCategories:@[@"hoge", @"hoooo",@"hoge", @"hoooo",@"hoge", @"hoooo",@"hoge"]];
}

@end
