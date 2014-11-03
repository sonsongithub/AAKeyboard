//
//  AAKAAEditAnimatedTransitioning.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/29.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKAAEditAnimatedTransitioning.h"

#import "AAKAACollectionViewController.h"
#import "AAKEditViewController.h"
#import "AAKTextView.h"
#import "AAKAACollectionViewCell.h"
#import "AAKPreviewController.h"
#import "AAKASCIIArt.h"
#import "AAKHelper.h"

@interface AAKAAEditAnimatedTransitioning() {
	BOOL _isPresent;
}
@end

@implementation AAKAAEditAnimatedTransitioning

- (instancetype)initWithPresentFlag:(BOOL)presentFlag {
	self = [super init];
	if (self) {
		_isPresent = presentFlag;
	}
	return self;
}

- (CGSize)AASizeForPreviewControllerWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
								 previewController:(AAKPreviewController*)previewController
						  collectionViewController:(AAKAACollectionViewController*)collectionViewController {
	
	AAKAACollectionViewCell *cell = [collectionViewController cellForAsciiArt:previewController.art];
	
	CGRect containerViewFrame = [transitionContext containerView].frame;
	
	{
		CGFloat a = containerViewFrame.size.width / containerViewFrame.size.height;
		CGFloat b = cell.asciiart.ratio;
		if (a >= b) {
			float w = containerViewFrame.size.height * b;
			float h = containerViewFrame.size.height;
			return CGSizeMake(w, h);
		}
		else {
			float w = containerViewFrame.size.width;
			float h = containerViewFrame.size.width / b;
			return CGSizeMake(w, h);
		}
	}
}

- (CGSize)AASizeForAACollectionViewControllerWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
										  previewController:(AAKPreviewController*)previewController
								   collectionViewController:(AAKAACollectionViewController*)collectionViewController {
	
	AAKAACollectionViewCell *cell = [collectionViewController cellForAsciiArt:previewController.art];
	
	{
		CGFloat a = cell.textView.frame.size.width / cell.textView.frame.size.height;
		CGFloat b = cell.asciiart.ratio;
		if (a >= b) {
			float w = cell.textView.frame.size.height * b;
			float h = cell.textView.frame.size.height;
			return CGSizeMake(w, h);
		}
		else {
			float w = cell.textView.frame.size.width;
			float h = cell.textView.frame.size.width / b;
			return CGSizeMake(w, h);
		}
	}
}

- (void)animationPresentTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	AAKAACollectionViewController *collectionViewController = nil;
	AAKPreviewController *previewController = nil;
	if ([fromController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *nav = (UINavigationController*)fromController;
		if ([nav.topViewController isKindOfClass:[AAKAACollectionViewController class]]) {
			collectionViewController = (AAKAACollectionViewController*)nav.topViewController;
		}
	}
	if ([toController isKindOfClass:[AAKPreviewController class]]) {
		previewController = (AAKPreviewController*)toController;
	}

	AAKAACollectionViewCell *cell = [collectionViewController cellForAsciiArt:previewController.art];
	
	CGSize fromContentSize = [self AASizeForAACollectionViewControllerWithTransition:transitionContext
																   previewController:previewController
															collectionViewController:collectionViewController];
	CGSize toContentSize = [self AASizeForPreviewControllerWithTransition:transitionContext
														previewController:previewController
												 collectionViewController:collectionViewController];
	float scale = toContentSize.width / fromContentSize.width;
	
	
	AAKTextView *textView = [cell textViewForAnimation];
	
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
	
	
	[UIView animateWithDuration:[self transitionDuration:transitionContext]
					 animations:^{
						 textView.frame = frameOfDestinationTextView;
						 textView.center = CGPointMake(ceil([transitionContext containerView].center.x), ceil([transitionContext containerView].center.y));
						 textView.alpha = 1;
						 previewController.view.alpha = 1.0;
					 } completion:^(BOOL finished) {
						 previewController.view.alpha = 1.0;
						 DNSLogRect(textView.frame);
						 [textView removeFromSuperview];
						 [transitionContext completeTransition:YES];
						 previewController.textView.hidden = NO;
					 }];
}

- (void)animationDismissTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	AAKAACollectionViewController *collectionViewController = nil;
	AAKPreviewController *previewController = nil;
	if ([fromController isKindOfClass:[AAKPreviewController class]]) {
		previewController = (AAKPreviewController*)fromController;
	}
	if ([toController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *nav = (UINavigationController*)toController;
		if ([nav.topViewController isKindOfClass:[AAKAACollectionViewController class]]) {
			collectionViewController = (AAKAACollectionViewController*)nav.topViewController;
		}
	}
	
	AAKAACollectionViewCell *cell = [collectionViewController cellForAsciiArt:previewController.art];
	
	CGSize toContentSize = [self AASizeForAACollectionViewControllerWithTransition:transitionContext
																   previewController:previewController
															collectionViewController:collectionViewController];
	CGSize fromContentSize = [self AASizeForPreviewControllerWithTransition:transitionContext
														previewController:previewController
												 collectionViewController:collectionViewController];
	float scale = fromContentSize.width / toContentSize.width;
	
	cell.hidden = YES;
	
	AAKTextView *textView = [cell textViewForAnimation];
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
						 cell.hidden = NO;
						 [transitionContext completeTransition:YES];
					 }];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	if (_isPresent) {
		[self animationDismissTransition:transitionContext];
	}
	else {
		[self animationPresentTransition:transitionContext];
	}
}

- (CGFloat)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return 0.2;
}

@end
