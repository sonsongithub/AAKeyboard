//
//  KeyboardViewController.m
//  keyboard
//
//  Created by sonson on 2014/10/06.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "KeyboardViewController.h"

#import "AAKKeyboardView.h"
#import "AAKNotifyView.h"

@interface KeyboardViewController () <AAKKeyboardViewDelegate> {
	AAKKeyboardView *_keyboardView;
	NSLayoutConstraint *_heightConstraint;
	AAKNotifyView				*_notifyView;
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
	DNSLogMethod
	[super viewDidLayoutSubviews];
	
	// キーボードビューをセットアップ
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	
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
	DNSLogMethod
	[super viewDidAppear:animated];
	
	// このタイミングでないとうまくいかない
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
	
	// キーボードのメインビューを貼り付ける．
	// textDocumentProxyのkeyboardAppearanceがviewDidAppearの前にきまる．
	// viewDidLoadではアピアランスがわからないのでこのタイミングで初期化する必要がある．
	_keyboardView = [[AAKKeyboardView alloc] initWithFrame:self.view.bounds keyboardAppearance:self.textDocumentProxy.keyboardAppearance];
	_keyboardView.translatesAutoresizingMaskIntoConstraints = NO;
	_keyboardView.delegate = self;
	[self.view addSubview:_keyboardView];
	
	// 通知ビューを貼り付ける
	UINib *nib = [UINib nibWithNibName:@"AAKNotifyView" bundle:nil];
	_notifyView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
	_notifyView.translatesAutoresizingMaskIntoConstraints = NO;
	_notifyView.userInteractionEnabled = NO;
	_notifyView.hidden = YES;
	_notifyView.keyboardAppearance = self.textDocumentProxy.keyboardAppearance;
	[self.view addSubview:_notifyView];
	
	// キーボードビューも通知ビューも，このビューコントローラにぴっちり貼り付ける
	NSDictionary *views = NSDictionaryOfVariableBindings(_keyboardView, _notifyView);
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_keyboardView]-0-|"
																	  options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_keyboardView]-0-|"
																	  options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_notifyView]-0-|"
																	  options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_notifyView]-0-|"
																	  options:0 metrics:0 views:views]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidCopyAAImageToPasteboard:) name:AAKTextViewDidCopyAAImageToPasteboard object:nil];
}

- (void)textViewDidCopyAAImageToPasteboard:(NSNotification*)notification {
	_notifyView.hidden = NO;
	_notifyView.alpha = 0;
	[UIView animateWithDuration:0.4
					 animations:^{
						 _notifyView.alpha = 1;
					 }
					 completion:^(BOOL finished) {
						 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
							 [UIView animateWithDuration:0.4
											  animations:^{
												  _notifyView.alpha = 0;
											  } completion:^(BOOL finished) {
											  }];
						 });
					 }];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
	self.view.superview.backgroundColor = [UIColor clearColor];
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
