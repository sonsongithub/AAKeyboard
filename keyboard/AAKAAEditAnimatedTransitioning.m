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

//	NSIndexPath *indexPath = [collectionViewController indexPathForAsciiArt:previewController.art];
//	AAKAACollectionViewCell *cell = (AAKAACollectionViewCell*)[collectionViewController.collectionView cellForItemAtIndexPath:indexPath];
	
	AAKAACollectionViewCell *cell = [collectionViewController cellForAsciiArt:previewController.art];
	
	AAKTextView *textView = [cell textViewForAnimation];
	
	NSLog(@"content ratio = %lf", textView.contentSize.width / textView.contentSize.height);
	NSLog(@"content ratio = %lf", textView.contentSize.width);
	NSLog(@"content ratio = %lf", textView.contentSize.height);
	CGRect r = [[transitionContext containerView] convertRect:cell.textView.bounds fromView:cell.textView];
	
	textView.backgroundColor = [UIColor redColor];
	
	[[transitionContext containerView] addSubview:toController.view];
	[[transitionContext containerView] addSubview:textView];
	previewController.view.alpha = 0;
	
	textView.frame = r;
	[textView updateLayout];
	[textView setNeedsDisplay];

	previewController.textView.hidden = YES;
	
	CGRect textViewFrame = CGRectMake(0, 0, 0, 0);
	

	CGRect containerViewFrame = [transitionContext containerView].frame;
	float viewRatio = containerViewFrame.size.width / containerViewFrame.size.height;
	
	float textViewRatio = cell.textView.frame.size.width / cell.textView.frame.size.height;
	
	NSLog(@"content ratio = %lf", textViewRatio);
	NSLog(@"content ratio = %lf", cell.asciiart.ratio);
	
	if (textViewRatio > cell.asciiart.ratio) {
		textViewFrame.size = CGSizeMake(containerViewFrame.size.height, containerViewFrame.size.height);
	}
	else {
		textViewFrame.size = CGSizeMake(containerViewFrame.size.width, containerViewFrame.size.width);
	}
	
	[UIView animateWithDuration:0.2
					 animations:^{
						 textView.frame = textViewFrame;
						 textView.center = CGPointMake(ceil([transitionContext containerView].center.x), ceil([transitionContext containerView].center.y));
						 textView.alpha = 0.4;
						 previewController.view.alpha = 1.0;
					 } completion:^(BOOL finished) {
						 previewController.view.alpha = 1.0;
//						 [textView removeFromSuperview];
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
	
//	NSIndexPath *indexPath = [collectionViewController indexPathForAsciiArt:previewController.art];
//	
//	AAKAACollectionViewCell *cell = (AAKAACollectionViewCell*)[collectionViewController.collectionView cellForItemAtIndexPath:indexPath];
	
	AAKAACollectionViewCell *cell = [collectionViewController cellForAsciiArt:previewController.art];
	
	cell.hidden = YES;
	
	AAKTextView *textView = [cell textViewForAnimation];
	
	//textView.backgroundColor = [UIColor redColor];
	
	CGRect r2 = [[transitionContext containerView] convertRect:previewController.textView.frame fromView:previewController.textView.superview];
	
	previewController.textView.hidden = YES;
	
	r2.size.height = r2.size.width;
	
	textView.frame = r2;
	
	textView.center = [[transitionContext containerView] convertPoint:previewController.textView.center fromView:previewController.textView.superview];
	
	CGRect r = [[transitionContext containerView] convertRect:cell.textView.bounds fromView:cell.textView];
	
	[[transitionContext containerView] addSubview:textView];
	
	float textViewRatio = cell.textView.frame.size.width / cell.textView.frame.size.height;
	
	NSLog(@"content ratio = %lf", textViewRatio);
	NSLog(@"content ratio = %lf", cell.asciiart.ratio);
	
	CGRect textViewFrame = CGRectMake(0, 0, 0, 0);
	CGRect containerViewFrame = [transitionContext containerView].frame;
	
	if (textViewRatio > cell.asciiart.ratio) {
		textViewFrame.size = CGSizeMake(containerViewFrame.size.height, containerViewFrame.size.height);
	}
	else {
		textViewFrame.size = CGSizeMake(containerViewFrame.size.width, containerViewFrame.size.width);
	}
	
	textView.frame = textViewFrame;
	textView.center = [transitionContext containerView].center;
	
	[UIView animateWithDuration:0.2
					 animations:^{
						 textView.alpha = 1;
						 textView.frame = r;
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
	return 0.3;
}

@end
