//
//  AAKAAEditAnimatedTransitioning.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/29.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKAAEditAnimatedTransitioning.h"

#import "AAKAACollectionViewController.h"
#import "AAKAACollectionViewCell.h"
#import "AAKPreviewController.h"

@interface AAKAAEditAnimatedTransitioning() {
	BOOL _isPresent;	/** 表示中であるかのフラグ．このフラグがYESのときは，すでに表示中を意味する． */
}
@end

@implementation AAKAAEditAnimatedTransitioning

/**
 * AAKAAEditAnimatedTransitioningオブジェクトを初期化する．
 * 表示中であるかのフラグ．このフラグがYESのときは，すでに表示中を意味する．
 * 表示する時も，破棄する時もこのクラスを使う．
 * @param presentFlag 表示中であるかのフラグ
 * @return 初期化されたAAKAAEditAnimatedTransitioningオブジェクト．
 **/
- (instancetype)initWithPresentFlag:(BOOL)presentFlag {
	self = [super init];
	if (self) {
		_isPresent = presentFlag;
	}
	return self;
}

/**
 * プレビューコントローラ上のtextviewでレンダリングされるAAの実サイズを取得する．
 * このサイズは，セルとプレビュー間の拡大縮小アニメーションに使う．
 * @param transitionContext トランジションのコンテキストオブジェクト．
 * @param previewController プレビューコントローラ．このビューコントローラがもつAAKASCIIArtオブジェクトからアスキーアートのアスペクト比を取得する．
 * @return プレビューコントローラ上のtextviewでレンダリングされるAAのサイズ．
 **/
- (CGSize)AASizeForPreviewControllerWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
								 previewController:(AAKPreviewController*)previewController {
	// 画面全体のフレームを取得する．
	CGRect containerViewFrame = [transitionContext containerView].frame;
	
	containerViewFrame = CGRectInset(containerViewFrame, [AAKPreviewController marginConstant], [AAKPreviewController marginConstant]);

	// aspect ratio
	// コンテナビューとプレビューコントローラのサイズが同じなのでこれでよい
	CGFloat containerViewRatio = containerViewFrame.size.width / containerViewFrame.size.height;
	CGFloat asciiartRatio = previewController.asciiart.ratio;
	
	if (containerViewRatio >= asciiartRatio) {
		float w = containerViewFrame.size.height * asciiartRatio;
		float h = containerViewFrame.size.height;
		return CGSizeMake(w, h);
	}
	else {
		float w = containerViewFrame.size.width;
		float h = containerViewFrame.size.width / asciiartRatio;
		return CGSizeMake(w, h);
	}
}

/**
 * コレクションコントローラ上のセルのtextviewでレンダリングされるAAの実サイズを取得する．
 * セルは，指定したプレビューコントローラと同じアスキーアートをもつものが選ばれる．
 * このサイズは，セルとプレビュー間の拡大縮小アニメーションに使う．
 * @param transitionContext トランジションのコンテキストオブジェクト．
 * @param previewController プレビューコントローラ．このビューコントローラがもつAAKASCIIArtオブジェクトからアスキーアートのアスペクト比を取得する．
 * @param collectionViewController コレクションビューコントローラ．このビューコントローラがもつcollectionビューコントローラから，プレビューコントローラのアスキーアートと同じアスキーアートをもつセルを取得する．
 * @return コレクションコントローラ上のセルのtextviewでレンダリングされるAAのサイズ．
 **/
- (CGSize)AASizeForAACollectionViewControllerWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
										  previewController:(AAKPreviewController*)previewController
								   collectionViewController:(AAKAACollectionViewController*)collectionViewController {
	
	AAKAACollectionViewCell *cell = [collectionViewController cellForAsciiArt:previewController.asciiart];
	
	// aspect ratio
	// コンテナビューとプレビューコントローラのサイズが同じなのでこれでよい
	CGFloat textViewOnCellRatio = cell.textView.frame.size.width / cell.textView.frame.size.height;
	CGFloat asciiartRatio = previewController.asciiart.ratio;
	
	if (textViewOnCellRatio >= asciiartRatio) {
		float w = cell.textView.frame.size.height * asciiartRatio;
		float h = cell.textView.frame.size.height;
		return CGSizeMake(w, h);
	}
	else {
		float w = cell.textView.frame.size.width;
		float h = cell.textView.frame.size.width / asciiartRatio;
		return CGSizeMake(w, h);
	}
}

/**
 * ナビゲーションコントローラのトップビューからAAKAACollectionViewControllerを抽出する．
 * 引数のviewControllerがナビゲーションコントローラではない場合，AAKAACollectionViewControllerが見つからない場合はnilを返す．
 * @param viewController ビューコントローラ．
 * @return 抽出したAAKAACollectionViewControllerビューコントローラ．
 **/
- (AAKAACollectionViewController*)collectionViewControllerFromViewController:(UIViewController*)viewController {
	AAKAACollectionViewController *collectionViewController = nil;
	if ([viewController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *nav = (UINavigationController*)viewController;
		if ([nav.topViewController isKindOfClass:[AAKAACollectionViewController class]]) {
			collectionViewController = (AAKAACollectionViewController*)nav.topViewController;
		}
	}
	return collectionViewController;
}

/**
 * ビューコントローラをAAKPreviewControllerとして返す．
 * ビューコントローラがAAKPreviewControllerクラスでない場合，nilを返す．
 * @param viewController ビューコントローラ．
 * @return 抽出したAAKPreviewControllerビューコントローラ．
 **/
- (AAKPreviewController*)previewViewControllerFromViewController:(UIViewController*)viewController {
	AAKPreviewController *outputViewController = nil;
	if ([viewController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *nav = (UINavigationController*)viewController;
		if ([nav.topViewController isKindOfClass:[AAKPreviewController class]]) {
			outputViewController = (AAKPreviewController*)nav.topViewController;
		}
	}
	return outputViewController;
}

/**
 * 表示トランジションを実行する．
 * @param transitionContext トランジションのコンテキストオブジェクト．
 **/
- (void)animationPresentTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

	AAKAACollectionViewController *collectionViewController = [self collectionViewControllerFromViewController:fromController];
	AAKPreviewController *previewController = [self previewViewControllerFromViewController:toController];
	
	// for error case
	if (previewController == nil || collectionViewController == nil) {
		[[transitionContext containerView] addSubview:toController.view];
		[transitionContext completeTransition:YES];
		return;
	}

	AAKAACollectionViewCell *cell = [collectionViewController cellForAsciiArt:previewController.asciiart];
	
	CGSize fromContentSize = [self AASizeForAACollectionViewControllerWithTransition:transitionContext
																   previewController:previewController
															collectionViewController:collectionViewController];
	CGSize toContentSize = [self AASizeForPreviewControllerWithTransition:transitionContext
														previewController:previewController];
	float scale = toContentSize.width / fromContentSize.width;
	
	
	AAKTextView *textView = [cell textViewForAnimation];
	textView.backgroundColor = [UIColor clearColor];
	
	// Magnify text view on cell keeping its aspect ratio.
	CGRect frameOfStartTextView = [[transitionContext containerView] convertRect:cell.textView.bounds fromView:cell.textView];
	textView.frame = frameOfStartTextView;
	[textView updateLayout];
	[textView setNeedsDisplay];
	CGRect frameOfDestinationTextView = CGRectMake(0, 0, cell.textView.frame.size.width * scale, cell.textView.frame.size.height * scale);
	
	// Setup destination view controller's view
	[[transitionContext containerView] addSubview:toController.view];
	[[transitionContext containerView] addSubview:textView];
	previewController.view.alpha = 0;
	previewController.textView.hidden = YES;
	
	cell.textView.hidden = YES;
	
	[UIView animateWithDuration:[self transitionDuration:transitionContext]
					 animations:^{
						 textView.frame = frameOfDestinationTextView;
						 textView.center = CGPointMake(ceil([transitionContext containerView].center.x), ceil([transitionContext containerView].center.y));
						 textView.alpha = 1;
						 previewController.view.alpha = 1.0;
					 } completion:^(BOOL finished) {
						 previewController.view.alpha = 1.0;
						 [textView removeFromSuperview];
						 [transitionContext completeTransition:YES];
						 previewController.textView.hidden = NO;
						 cell.textView.hidden = NO;
					 }];
}

/**
 * 破棄トランジションを実行する．
 * @param transitionContext トランジションのコンテキストオブジェクト．
 **/
- (void)animationDismissTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

	AAKAACollectionViewController *collectionViewController = [self collectionViewControllerFromViewController:toController];
	AAKPreviewController *previewController = [self previewViewControllerFromViewController:fromController];
	
	// for error case
	if (previewController == nil || collectionViewController == nil) {
		[transitionContext completeTransition:YES];
		return;
	}
	
	AAKAACollectionViewCell *cell = [collectionViewController cellForAsciiArt:previewController.asciiart];
	cell.textView.hidden = YES;
	
	CGSize toContentSize = [self AASizeForAACollectionViewControllerWithTransition:transitionContext
																   previewController:previewController
															collectionViewController:collectionViewController];
	CGSize fromContentSize = [self AASizeForPreviewControllerWithTransition:transitionContext
														previewController:previewController];
	float scale = fromContentSize.width / toContentSize.width;
	
	AAKTextView *textView = [cell textViewForAnimation];
	textView.backgroundColor = [UIColor clearColor];
	[[transitionContext containerView] addSubview:textView];
	
	previewController.textView.hidden = YES;
	
	CGRect frameOfDestinationTextView = [[transitionContext containerView] convertRect:cell.textView.bounds fromView:cell.textView];
	
	CGRect frameOfFromTextView = CGRectMake(0, 0, cell.textView.frame.size.width * scale, cell.textView.frame.size.height * scale);
	textView.frame = frameOfFromTextView;
	textView.center = [[transitionContext containerView] convertPoint:previewController.textView.center fromView:previewController.textView.superview];
	
	[UIView animateWithDuration:[self transitionDuration:transitionContext]
					 animations:^{
						 textView.alpha = 1;
						 textView.frame = frameOfDestinationTextView;
						 fromController.view.alpha = 0;
					 } completion:^(BOOL finished) {
						 [textView removeFromSuperview];
						 cell.textView.hidden = NO;
						 [transitionContext completeTransition:YES];
					 }];
}

#pragma mark - Override

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	// 表示か，破棄は，フラグで判定する．
	if (_isPresent) {
		[self animationDismissTransition:transitionContext];
	}
	else {
		[self animationPresentTransition:transitionContext];
	}
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return 0.2;
}

@end
