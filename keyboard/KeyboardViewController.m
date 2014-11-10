//
//  KeyboardViewController.m
//  keyboard
//
//  Created by sonson on 2014/10/06.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "KeyboardViewController.h"

#import "AAKShared.h"
#import "AAKKeyboardView.h"

@interface KeyboardViewController () <AAKKeyboardViewDelegate> {
	AAKKeyboardView *_keyboardView;
	NSLayoutConstraint *_heightConstraint;
}
@end

@implementation KeyboardViewController

#pragma mark - Override

/**
 * キーボードのメインビューコントローラは，initメソッドで初期化される．
 **/
- (instancetype)init {
	DNSLogMethod
	self = [super init];
	if (self) {
		[AAKKeyboardDataManager defaultManager];
	}
	return self;
}

/**
 * デバッグ用．キーボードがどのタイミングで破棄されるかを確認する．
 **/
- (void)dealloc {
	DNSLogMethod
}

/**
 * ビューコントローラのビューがlayoutSubviewsを実行した直後に呼ばれる，
 **/
- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	// このキーボードビューのサイズをautolayoutで指定する．
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = CGRectGetWidth(screenBounds);
	CGFloat screenHeight = CGRectGetHeight(screenBounds);
	
	if (_heightConstraint)
		[self.view removeConstraint:_heightConstraint];
	
	if (screenWidth < screenHeight) {
		// 縦長の場合
		_heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
														 attribute:NSLayoutAttributeHeight
														 relatedBy:NSLayoutRelationEqual
															toItem:nil
														 attribute:NSLayoutAttributeNotAnAttribute
														multiplier:0.0
														  constant:216];
		[self.view addConstraint:_heightConstraint];
		[_keyboardView setPortraitMode];
	}
	else {
		// 横長の場合
		_heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
														 attribute:NSLayoutAttributeHeight
														 relatedBy:NSLayoutRelationEqual
															toItem:nil
														 attribute:NSLayoutAttributeNotAnAttribute
														multiplier:0.0
														  constant:162];
		[self.view addConstraint:_heightConstraint];
		[_keyboardView setLandscapeMode];
	}
	
	[_keyboardView load];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// このビューの左右の端のマージンを設定する．
	[self.view.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.view
																	attribute:NSLayoutAttributeLeading
																	relatedBy:NSLayoutRelationEqual
																	   toItem:self.view.superview
																	attribute:NSLayoutAttributeLeading
																   multiplier:1.0
																	 constant:0.0]];
	
	[self.view.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.view
																	attribute:NSLayoutAttributeTrailing
																	relatedBy:NSLayoutRelationEqual
																	   toItem:self.view.superview
																	attribute:NSLayoutAttributeTrailing
																   multiplier:1.0
																	 constant:0.0]];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// キーボードビューをセットアップ
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	_keyboardView = [[AAKKeyboardView alloc] initWithFrame:self.view.bounds keyboardAppearance:self.textDocumentProxy.keyboardAppearance];
	_keyboardView.translatesAutoresizingMaskIntoConstraints = NO;
	_keyboardView.delegate = self;
	[self.view addSubview:_keyboardView];
	
	// キーボードビューは，このビューコントローラにぴっちり貼り付ける
	NSDictionary *views = NSDictionaryOfVariableBindings(_keyboardView);
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_keyboardView]-0-|"
																	  options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_keyboardView]-0-|"
																	  options:0 metrics:0 views:views]];
}

#pragma mark - AAKeyboardViewDelegate

- (void)keyboardViewDidPushEarthButton:(AAKKeyboardView*)keyboardView {
	[self advanceToNextInputMode];
}

- (void)keyboardViewDidPushDeleteButton:(AAKKeyboardView*)keyboardView {
	[self.textDocumentProxy deleteBackward];
}

- (void)keyboardView:(AAKKeyboardView*)keyboardView willInsertString:(NSString*)string {
	[self.textDocumentProxy insertText:string];
}

#pragma mark - UITextInput

- (void)textWillChange:(id<UITextInput>)textInput {
}

- (void)textDidChange:(id<UITextInput>)textInput {
}

@end
