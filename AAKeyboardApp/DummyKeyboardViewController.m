//
//  DummyKeyboardViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/07.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "DummyKeyboardViewController.h"

@interface DummyKeyboardViewController () {
}
@end

@implementation DummyKeyboardViewController

- (UITraitCollection *)overrideTraitCollectionForChildViewController:(UIViewController *)childViewController {
	return self.traitCollection;
}

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
}

@end
