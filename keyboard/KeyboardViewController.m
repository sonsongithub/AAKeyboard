//
//  KeyboardViewController.m
//  keyboard
//
//  Created by sonson on 2014/10/06.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "KeyboardViewController.h"

#import "AAKKeyboardView.h"

@interface KeyboardViewController () {
	AAKKeyboardView *_keyboardView;
	NSLayoutConstraint *_heightConstraint;
}
@end

@implementation KeyboardViewController

- (UITraitCollection *)overrideTraitCollectionForChildViewController:(UIViewController *)childViewController {
	return self.traitCollection;
}

- (void)updateViewConstraints {
//	DNSLogMethod
//	CGRect screenBounds = [[UIScreen mainScreen] bounds];
//	CGFloat screenWidth = CGRectGetWidth(screenBounds);
//	CGFloat screenHeight = CGRectGetHeight(screenBounds);
//	
//	if (screenWidth < screenHeight) {
//		_heightConstraint.constant = 216;
//	}
//	else {
//		_heightConstraint.constant = 162;
//	}
    [super updateViewConstraints];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = CGRectGetWidth(screenBounds);
	CGFloat screenHeight = CGRectGetHeight(screenBounds);
	
	[self.view removeConstraint:_heightConstraint];

	if (screenWidth < screenHeight) {
		_heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
														 attribute:NSLayoutAttributeHeight
														 relatedBy:NSLayoutRelationEqual
															toItem:nil
														 attribute:NSLayoutAttributeNotAnAttribute
														multiplier:0.0
														  constant:216];
		[self.view addConstraint:_heightConstraint];
	}
	else {
		_heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
														 attribute:NSLayoutAttributeHeight
														 relatedBy:NSLayoutRelationEqual
															toItem:nil
														 attribute:NSLayoutAttributeNotAnAttribute
														multiplier:0.0
														  constant:162];
		[self.view addConstraint:_heightConstraint];
	}
	
	[_keyboardView load];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	UIView *view = self.view;
	
	NSDictionary *views = NSDictionaryOfVariableBindings(view);
	[self.view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
																	  options:0 metrics:0 views:views]];
	[self.view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
																	  options:0 metrics:0 views:views]];
	
	CGFloat height = CGRectGetHeight(self.view.bounds);
	_heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
													 attribute:NSLayoutAttributeHeight
													 relatedBy:NSLayoutRelationEqual
														toItem:nil
													 attribute:NSLayoutAttributeNotAnAttribute
													multiplier:0.0
													  constant:height];
	[self.view addConstraint:_heightConstraint];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	 self.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	_keyboardView = [[AAKKeyboardView alloc] initWithFrame:self.view.bounds];
	_keyboardView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_keyboardView];
	
	NSDictionary *views = NSDictionaryOfVariableBindings(_keyboardView);
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_keyboardView]-0-|"
																	  options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_keyboardView]-0-|"
																	  options:0 metrics:0 views:views]];
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
