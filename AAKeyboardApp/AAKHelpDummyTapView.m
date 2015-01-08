//
//  AAKHelpDummyTapView.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/09.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAKHelpDummyTapView.h"

@implementation AAKHelpDummyTapView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	
	UIView *hitView = [super hitTest:point withEvent:event];
	if (hitView == self)
		return targetView;
	
	return hitView;
}

@end
