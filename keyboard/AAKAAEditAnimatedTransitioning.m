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
	AAKEditViewController *editViewController = nil;
	if ([fromController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *nav = (UINavigationController*)fromController;
		if ([nav.topViewController isKindOfClass:[AAKAACollectionViewController class]]) {
			collectionViewController = (AAKAACollectionViewController*)nav.topViewController;
		}
	}
	if ([toController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *nav = (UINavigationController*)toController;
		if ([nav.topViewController isKindOfClass:[AAKEditViewController class]]) {
			editViewController = (AAKEditViewController*)nav.topViewController;
		}
	}
	
	NSIndexPath *indexPath = [collectionViewController indexPathForAsciiArt:editViewController.art];
	
	AAKAACollectionViewCell *cell = (AAKAACollectionViewCell*)[collectionViewController.collectionView cellForItemAtIndexPath:indexPath];
	
	AAKTextView *textView = [cell textViewForAnimation];
	
	CGRect r = [[transitionContext containerView] convertRect:cell.textView.bounds fromView:cell.textView];
	
	//		textView.backgroundColor = [UIColor redColor];
	
	[[transitionContext containerView] addSubview:toController.view];
	[[transitionContext containerView] addSubview:textView];
	editViewController.view.alpha = 0;
	
	textView.frame = r;
	[textView updateLayout];
	[textView setNeedsDisplay];
	
	CGRect r2 = [[transitionContext containerView] convertRect:editViewController.AATextView.frame fromView:editViewController.AATextView.superview];
	
	CGRect r3;
	
	r3.origin = r2.origin;
	r3.origin.y += 110;
	r3.size = CGSizeMake(375, 375);
	
	[UIView animateWithDuration:0.5
					 animations:^{
						 textView.frame = r3;
						 textView.alpha = 0;
						 editViewController.view.alpha = 1.0;
					 } completion:^(BOOL finished) {
						 [transitionContext completeTransition:YES];
					 }];
}

- (void)animationDismissTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	AAKAACollectionViewController *collectionViewController = nil;
	AAKEditViewController *editViewController = nil;
	if ([fromController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *nav = (UINavigationController*)fromController;
		if ([nav.topViewController isKindOfClass:[AAKEditViewController class]]) {
			editViewController = (AAKEditViewController*)nav.topViewController;
		}
	}
	if ([toController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *nav = (UINavigationController*)toController;
		if ([nav.topViewController isKindOfClass:[AAKAACollectionViewController class]]) {
			collectionViewController = (AAKAACollectionViewController*)nav.topViewController;
		}
	}
	
	NSIndexPath *indexPath = [collectionViewController indexPathForAsciiArt:editViewController.art];
	
	AAKAACollectionViewCell *cell = (AAKAACollectionViewCell*)[collectionViewController.collectionView cellForItemAtIndexPath:indexPath];
	
	AAKTextView *textView = [cell textViewForAnimation];
	
	CGRect r3 = CGRectMake(0, 155, 375, 375);
	
	textView.frame = r3;
	textView.alpha = 0;
	
	CGRect r = [[transitionContext containerView] convertRect:cell.textView.bounds fromView:cell.textView];
	
	[[transitionContext containerView] addSubview:textView];
	
	[UIView animateWithDuration:0.5
					 animations:^{
						 textView.alpha = 1;
						 textView.frame = r;
						 fromController.view.alpha = 0;
					 } completion:^(BOOL finished) {
						 [editViewController.AATextView removeFromSuperview];
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
