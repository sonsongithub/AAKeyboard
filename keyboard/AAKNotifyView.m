//
//  AAKNotifyView.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/11.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKNotifyView.h"

@interface AAKNotifyView() {
}
@end

@implementation AAKNotifyView

- (void)layoutSubviews {
	[super layoutSubviews];
	[self setNeedsDisplay];
}

- (void)setKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
	_keyboardAppearance = keyboardAppearance;
	if (_keyboardAppearance == UIKeyboardAppearanceDark) {
		_label.textColor = [UIColor blackColor];
	}
	else {
		_label.textColor = [UIColor whiteColor];
	}
}

// draw round corner rect
- (void)setPathRoundCornerRect:(CGRect)rect radius:(float)radius {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect {
	CGSize rectSize = CGSizeMake(260, 120);
	CGFloat x = (self.frame.size.width - rectSize.width)/2;
	CGFloat y = (self.frame.size.height - rectSize.height)/2;
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (_keyboardAppearance == UIKeyboardAppearanceDark) {
		[[[UIColor whiteColor] colorWithAlphaComponent:0.8] setFill];
	}
	else {
		[[[UIColor blackColor] colorWithAlphaComponent:0.5] setFill];
	}
	[self setPathRoundCornerRect:CGRectMake(x, y, rectSize.width, rectSize.height) radius:5];
	CGContextFillPath(context);
}

@end
