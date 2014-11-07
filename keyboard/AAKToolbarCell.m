//
//  AAKCategoryCollectionViewCell.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/07.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKToolbarCell.h"

@implementation AAKToolbarCell

- (void)privateInit {
	self.backgroundColor = [UIColor blueColor];
	self.contentView.backgroundColor = [UIColor clearColor];
	_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	_label.textColor = [UIColor colorWithRed:0 green:120.0/255.0f blue:255.0/255.0f alpha:1];
	_label.textColor = [UIColor blackColor];
	_label.textAlignment = NSTextAlignmentCenter;
	_label.adjustsFontSizeToFitWidth = YES;
	_label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	[_label setFont:[UIFont systemFontOfSize:16]];
	[self.contentView addSubview:_label];
	
#if 0
	NSDictionary *views = NSDictionaryOfVariableBindings(_label);
	_label.translatesAutoresizingMaskIntoConstraints = NO;
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_label]-0-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_label]-0-|"
																 options:0 metrics:0 views:views]];
#endif
	
	self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
	self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
}

- (void)layoutSubviews {
//	NSLog(@"AAKToolbarCell= layoutSubviews");
	_label.center = self.contentView.center;
}

- (void)setBounds:(CGRect)bounds {
	[super setBounds:bounds];
	self.contentView.frame = bounds;
}

- (void)setOriginalHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	if (highlighted)
		_label.textColor = [UIColor whiteColor];
	else
		_label.textColor = [UIColor blackColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self setOriginalHighlighted:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self setOriginalHighlighted:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self setOriginalHighlighted:NO];
	[self.delegate didSelectToolbarCell:self];
}

- (void)setHighlighted:(BOOL)highlighted {
}

- (void)setSelected:(BOOL)selected {
}

- (void)updateConstraints {
	[super updateConstraints];
}

- (void)prepareForReuse {
	[super prepareForReuse];
	[self setNeedsDisplay];
	self.isHead = NO;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	[self privateInit];
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[self privateInit];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[[UIColor colorWithRed:254.0/255.0f green:254.0/255.0f blue:254.0/255.0f alpha:1] setFill];
	CGContextFillRect(context, rect);
	[[UIColor colorWithRed:203.0/255.0f green:203.0/255.0f blue:203.0/255.0f alpha:1] setFill];
//	CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
	CGContextFillRect(context, CGRectMake(rect.size.width - 0.5, 0, 0.5, rect.size.height));
	if (self.isHead)
		CGContextFillRect(context, CGRectMake(0, 0, 0.5, rect.size.height));
//	CGContextFillRect(context, CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5));
}

@end
