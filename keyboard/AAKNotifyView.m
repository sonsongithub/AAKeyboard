//
//  AAKNotifyView.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/11.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKNotifyView.h"

@interface AAKNotifyBackView : UIView
@property (nonatomic, assign) UIKeyboardAppearance keyboardAppearance;
@end

@implementation AAKNotifyBackView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	self.backgroundColor = [UIColor clearColor];
	return self;
}

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
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (_keyboardAppearance == UIKeyboardAppearanceDark) {
		[[[UIColor whiteColor] colorWithAlphaComponent:0.8] setFill];
	}
	else {
		[[[UIColor blackColor] colorWithAlphaComponent:0.5] setFill];
	}
	[self setPathRoundCornerRect:CGRectMake(0, 0, rect.size.width, rect.size.height) radius:5];
	CGContextFillPath(context);
}

@end

@interface AAKNotifyView() {
}
@property (nonatomic, strong) AAKNotifyBackView *backView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) UIKeyboardAppearance keyboardAppearance;
@end

@implementation AAKNotifyView

- (instancetype)initWithMarginSize:(CGSize)marginSize keyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
	self = [super initWithFrame:CGRectZero];
	self.backgroundColor = [UIColor clearColor];
	AAKNotifyBackView *backView = [[AAKNotifyBackView alloc] initWithFrame:CGRectZero];
	backView.translatesAutoresizingMaskIntoConstraints = NO;
	self.keyboardAppearance = keyboardAppearance;
	backView.keyboardAppearance = keyboardAppearance;
	self.backView = backView;
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.translatesAutoresizingMaskIntoConstraints = NO;
	self.label = label;
	self.label.backgroundColor = [UIColor clearColor];
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.numberOfLines = 4;
	self.label.font = [UIFont systemFontOfSize:14];
	
	if (_keyboardAppearance == UIKeyboardAppearanceDark) {
		self.label.textColor = [UIColor blackColor];
	}
	else {
		self.label.textColor = [UIColor whiteColor];
	}
	
	NSDictionary *views = NSDictionaryOfVariableBindings(backView, label);
	[self addSubview:backView];
	[self addSubview:label];
	
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%d-[backView]-%d-|", (int)marginSize.width, (int)marginSize.width]
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%d-[backView]-%d-|", (int)marginSize.height, (int)marginSize.height]
																 options:0 metrics:0 views:views]];
	
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%d-[label]-%d-|", (int)marginSize.width+8, (int)marginSize.width+8]
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%d-[label]-%d-|", (int)marginSize.height+8, (int)marginSize.height+8]
																 options:0 metrics:0 views:views]];
	return self;
}

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


- (void)setText:(NSString*)text {
	self.label.text = text;
}

@end
