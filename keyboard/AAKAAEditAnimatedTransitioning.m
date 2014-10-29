//
//  AAKAAEditAnimatedTransitioning.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/29.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKAAEditAnimatedTransitioning.h"

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

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	if (_isPresent) {
		UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
		UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
		[transitionContext completeTransition:YES];
	}
	else {
		UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
		UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
		[[transitionContext containerView] addSubview:toController.view];
		[transitionContext completeTransition:YES];
	}
}

- (CGFloat)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	return 0.3;
}

@end
