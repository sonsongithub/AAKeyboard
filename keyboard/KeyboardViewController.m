//
//  KeyboardViewController.m
//  keyboard
//
//  Created by sonson on 2014/10/06.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "KeyboardViewController.h"
#import "AAKBaseViewController.h"
#import "AAKToolbarController.h"

@interface KeyboardViewController () {
	AAKBaseViewController	*_baseViewController;
	NSLayoutConstraint		*_heightConstraint;
}
@end

@implementation KeyboardViewController

- (UITraitCollection *)overrideTraitCollectionForChildViewController:(UIViewController *)childViewController {
	return self.traitCollection;
}

- (void)updateViewConstraints {
	DNSLogMethod
	CGFloat height = CGRectGetHeight(self.view.bounds);
	_heightConstraint.constant = height;
    [super updateViewConstraints];
}

- (void)viewDidLayoutSubviews {
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.view setNeedsUpdateConstraints];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	DNSLogRect(self.view.bounds);
	_baseViewController = [[AAKBaseViewController alloc] init];
	[self.view addSubview:_baseViewController.view];
	[self addChildViewController:_baseViewController];
	
	UIView *baseView = _baseViewController.view;
	
	baseView.translatesAutoresizingMaskIntoConstraints = NO;
	NSDictionary *views = NSDictionaryOfVariableBindings(baseView);
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[baseView]-(==0)-|"
																	  options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[baseView]-(==0)-|"
																	  options:0 metrics:0 views:views]];
	
	CGFloat height = CGRectGetHeight(self.view.bounds);
	_heightConstraint = [NSLayoutConstraint constraintWithItem:baseView
														 attribute:NSLayoutAttributeHeight
														 relatedBy:NSLayoutRelationEqual
															toItem:nil
														 attribute:NSLayoutAttributeNotAnAttribute
														multiplier:0.0
														  constant:height];
	[self.view addConstraint:_heightConstraint];
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
}

@end
