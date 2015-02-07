//
//  AAK10KeyView.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/02/07.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAK10KeyView.h"

@interface AAK10KeyBoarderView : UIView
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

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, 0.5);
	
	[[UIColor whiteColor] setStroke];
	
	CGFloat widthBlock = rect.size.width / 3;
	CGFloat heightBlock = rect.size.height / 4;
	
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, 0, rect.size.height);
	CGContextMoveToPoint(context, widthBlock, 0);
	CGContextAddLineToPoint(context, widthBlock, rect.size.height);
	CGContextMoveToPoint(context, 2*widthBlock, 0);
	CGContextAddLineToPoint(context, 2*widthBlock, rect.size.height);
	CGContextMoveToPoint(context, 3*widthBlock, 0);
	CGContextAddLineToPoint(context, 3*widthBlock, rect.size.height);
	
	CGContextMoveToPoint(context, 0.5, heightBlock);
	CGContextAddLineToPoint(context, rect.size.width - 0.5, heightBlock);
	CGContextMoveToPoint(context, 0.5, heightBlock*2);
	CGContextAddLineToPoint(context, rect.size.width - 0.5, heightBlock*2);
	CGContextMoveToPoint(context, 0.5, heightBlock*3);
	CGContextAddLineToPoint(context, rect.size.width - 0.5, heightBlock*3);
	
	CGContextStrokePath(context);
}

@end

@interface AAK10KeyView() {
	IBOutlet NSLayoutConstraint *_10KeyWidthConstraint;
	IBOutlet AAK10KeyBoarderView *_10KeyBoarderView;
}
@end

@implementation AAK10KeyView

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

- (void)setWidth:(CGFloat)width {
	[self bringSubviewToFront:_10KeyBoarderView];
	_10KeyWidthConstraint.constant = width;
	[self setNeedsLayout];
	[_10KeyBoarderView setNeedsDisplay];
}

@end
