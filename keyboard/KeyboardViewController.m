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

typedef enum AAKUIOrientation_ {
	AAKUIOrientationUnknown	= 0,
	AAKUIPortrait			= 1,
	AAKUILandscape			= 2,
}AAKUIOrientation;

@interface KeyboardViewController () <AAKKeyboardViewDelegate> {
	AAKKeyboardView		*_keyboardView;
	NSLayoutConstraint	*_heightConstraint;
	AAKNotifyView		*_notifyView;
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
		if ([AAKCoreDataStack isOpenAccessGranted]) {
			[AAKCoreDataStack setupMagicalRecordForAppGroupsContainer];
		}
		else {
			[AAKCoreDataStack setupMagicalRecordForLocal];
		}
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
 * キーボードの高さを返す
 **/
- (CGFloat)keyboardHeight {
	
	CGFloat smallFont = 16;
	CGFloat largeFont = 18;
	
	AAKUIOrientation orientation = [self orientation];
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		// iPad
		[_keyboardView setToolbarHeight:54 fontSize:largeFont];
		
		if (orientation == AAKUIPortrait) {
			return 264;
		}
		else {
			return 352;
		}
	}
	else {
		CGRect screenBounds = [[UIScreen mainScreen] bounds];
		CGFloat screenHeight = CGRectGetHeight(screenBounds);
		if (orientation == AAKUIPortrait) {
			if (screenHeight <= 480) {
				// iPhone4 or prioir
				[_keyboardView setToolbarHeight:54 fontSize:largeFont];
				return 216;
			}
			else if (screenHeight <= 568) {
				// iPhone5
				[_keyboardView setToolbarHeight:54 fontSize:largeFont];
				return 216;
			}
			else if (screenHeight <= 667) {
				// iPhone6
				[_keyboardView setToolbarHeight:47 fontSize:largeFont];
				return 216;
			}
			else if (screenHeight <= 736) {
				// iPhone6 plus
				[_keyboardView setToolbarHeight:51 fontSize:largeFont];
				return 226;
			}
			[_keyboardView setToolbarHeight:54 fontSize:largeFont];
			return 216;
		}
		else if (orientation == AAKUILandscape) {
			if (screenHeight <= 320) {
				// iPhone5 or prioir
				[_keyboardView setToolbarHeight:40 fontSize:smallFont];
				return 162;
			}
			else if (screenHeight <= 375) {
				// iPhone6
				[_keyboardView setToolbarHeight:37 fontSize:smallFont];
				return 162;
			}
			else if (screenHeight <= 414) {
				// iPhone6 plus
				[_keyboardView setToolbarHeight:37 fontSize:smallFont];
				return 162;
			}
			[_keyboardView setToolbarHeight:54 fontSize:smallFont];
			return 162;
		}
		else {
			[_keyboardView setToolbarHeight:54 fontSize:smallFont];
			return 216;
		}
	}
}

/**
 * 回転方向を返す
 **/
- (AAKUIOrientation)orientation {
	// このキーボードビューのサイズをautolayoutで指定する．
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = CGRectGetWidth(screenBounds);
	CGFloat screenHeight = CGRectGetHeight(screenBounds);
	
	// 方向を決める
	if (screenWidth < screenHeight) {
		// portrait
		return AAKUIPortrait;
	}
	else {
		// landscape
		return AAKUILandscape;
	}
}

/**
 * ビューコントローラのビューがlayoutSubviewsを実行した直後に呼ばれる，
 **/
- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	// キーボードビューをセットアップ
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	if (_heightConstraint)
		[self.view removeConstraint:_heightConstraint];
	
	CGFloat height = [self keyboardHeight];
	
	_heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
													 attribute:NSLayoutAttributeHeight
													 relatedBy:NSLayoutRelationEqual
														toItem:nil
													 attribute:NSLayoutAttributeNotAnAttribute
													multiplier:0.0
													  constant:height];
	[self.view addConstraint:_heightConstraint];
	
	if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular)
		_keyboardView.numberOfRow = 2;
	else
		_keyboardView.numberOfRow = 1;
	
	[_keyboardView updateASCIIArtsForCurrentGroup];
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
	
	if (![AAKCoreDataStack isOpenAccessGranted]) {
		[self showNotifyWithMessage:NSLocalizedString(@"To use full functions,\nturn on full access in settings.", nil) duration:2];
	}
	
}

- (void)showNotifyWithMessage:(NSString*)message duration:(CGFloat)duration {
	_notifyView.label.text = message;
	_notifyView.hidden = NO;
	_notifyView.alpha = 0;
	[UIView animateWithDuration:0.4
					 animations:^{
						 _notifyView.alpha = 1;
					 }
					 completion:^(BOOL finished) {
						 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
							 [UIView animateWithDuration:0.4
											  animations:^{
												  _notifyView.alpha = 0;
											  } completion:^(BOOL finished) {
											  }];
						 });
					 }];
}

- (void)textViewDidCopyAAImageToPasteboard:(NSNotification*)notification {
	if ([AAKCoreDataStack isOpenAccessGranted]) {
		[self showNotifyWithMessage:NSLocalizedString(@"Now, paste AA as image\nin a message", nil) duration:2];
	}
	else {
		[self showNotifyWithMessage:NSLocalizedString(@"To copy AA as image,\nturn on full access in settings.", nil) duration:2];
	}
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
