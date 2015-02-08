//
//  AAK10KeyView.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/02/07.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAK10KeyView.h"

@interface AAK10KeyBoarderView : UIView
@property (nonatomic, assign) UIKeyboardAppearance keyboardAppearance;
@property (nonatomic, assign) BOOL needsOutsideFrame;
@end

@implementation AAK10KeyBoarderView

- (IBAction)up:(id)sender {
	UIButton *b = sender;
	b.backgroundColor = [UIColor clearColor];
}

- (IBAction)down:(id)sender {
	UIButton *b = sender;
	b.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	self.backgroundColor = [UIColor clearColor];
	
	for (UIButton *b in self.subviews) {
		[b addTarget:self action:@selector(up:) forControlEvents:UIControlEventTouchUpInside];
		[b addTarget:self action:@selector(down:) forControlEvents:UIControlEventTouchDown];
		[b addTarget:self action:@selector(up:) forControlEvents:UIControlEventTouchUpOutside];
	}
	
	return self;
}

- (void)setNeedsOutsideFrame:(BOOL)needsOutsideFrame {
	_needsOutsideFrame = needsOutsideFrame;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat lineWidth = 0.25;
	
	CGContextSetLineWidth(context, lineWidth);
	
	UIColor *textColor = nil;
	
	if (_keyboardAppearance == UIKeyboardAppearanceDark)
		textColor = [UIColor whiteColor];
	else
		textColor = [UIColor blackColor];
	
	[textColor setStroke];
	
	CGFloat widthBlock = rect.size.width / 3;
	CGFloat heightBlock = rect.size.height / 4;

	if (self.needsOutsideFrame) {
		CGContextMoveToPoint(context, lineWidth, 0);
		CGContextAddLineToPoint(context, lineWidth, rect.size.height);
		CGContextMoveToPoint(context, floor(widthBlock), 0);
		CGContextAddLineToPoint(context, floor(widthBlock), rect.size.height);
		CGContextMoveToPoint(context, floor(2*widthBlock), 0);
		CGContextAddLineToPoint(context, floor(2*widthBlock), rect.size.height);
		CGContextMoveToPoint(context, floor(3*widthBlock) - lineWidth, 0);
		CGContextAddLineToPoint(context, floor(3*widthBlock) - lineWidth, rect.size.height);
		
		CGContextMoveToPoint(context, lineWidth, lineWidth);
		CGContextAddLineToPoint(context, rect.size.width - lineWidth, lineWidth);
		CGContextMoveToPoint(context, lineWidth, floor(heightBlock));
		CGContextAddLineToPoint(context, rect.size.width - lineWidth, floor(heightBlock));
		CGContextMoveToPoint(context, lineWidth, floor(heightBlock*2));
		CGContextAddLineToPoint(context, rect.size.width - lineWidth, floor(heightBlock*2));
		CGContextMoveToPoint(context, lineWidth, floor(heightBlock*3));
		CGContextAddLineToPoint(context, rect.size.width - lineWidth, floor(heightBlock*3));
	}
	else {
		CGContextMoveToPoint(context, floor(widthBlock), 0);
		CGContextAddLineToPoint(context, floor(widthBlock), rect.size.height);
		CGContextMoveToPoint(context, floor(2*widthBlock), 0);
		CGContextAddLineToPoint(context, floor(2*widthBlock), rect.size.height);
		
		CGContextMoveToPoint(context, 0, floor(heightBlock));
		CGContextAddLineToPoint(context, rect.size.width, floor(heightBlock));
		CGContextMoveToPoint(context, 0, floor(heightBlock*2));
		CGContextAddLineToPoint(context, rect.size.width, floor(heightBlock*2));
		CGContextMoveToPoint(context, 0, floor(heightBlock*3));
		CGContextAddLineToPoint(context, rect.size.width, floor(heightBlock*3));
	}
	
	CGContextStrokePath(context);
}

- (void)setKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
	_keyboardAppearance = keyboardAppearance;
	
	UIColor *textColor = nil;
	
	if (_keyboardAppearance == UIKeyboardAppearanceDark)
		textColor = [UIColor whiteColor];
	else
		textColor = [UIColor blackColor];
	
	for (UIButton *b in self.subviews) {
		[b setTitleColor:textColor forState:UIControlStateNormal];
	}
	
	[self setNeedsDisplay];
}

@end

@interface AAK10KeyView() {
	IBOutlet NSLayoutConstraint *_10KeyWidthConstraint;
	IBOutlet AAK10KeyBoarderView *_10KeyBoarderView;
}
@end

@implementation AAK10KeyView

- (void)setKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
	_keyboardAppearance = keyboardAppearance;
	_10KeyBoarderView.keyboardAppearance = keyboardAppearance;
}

- (IBAction)didPushKey:(id)sender {
	DNSLogMethod
	UIButton *b = sender;
	[self.delegate didPush10KeyView:self key:b.titleLabel.text];
}

+ (instancetype)viewFromNib {
	// 通知ビューを貼り付ける
	UINib *nib = [UINib nibWithNibName:@"AAK10KeyView" bundle:nil];
	return [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[_10KeyBoarderView setNeedsDisplay];
}

- (void)setBaseViewWidth:(CGFloat)width {
	_10KeyBoarderView.needsOutsideFrame = (width > 480);
	[self bringSubviewToFront:_10KeyBoarderView];
	_10KeyWidthConstraint.constant = (width > 480) ? 480 : width;
	[self setNeedsLayout];
	[_10KeyBoarderView setNeedsDisplay];
}

@end
