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
	self.backgroundColor = [UIColor clearColor];
	self.contentView.backgroundColor = [UIColor clearColor];
	_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	_label.backgroundColor = [UIColor clearColor];
	_label.textColor = [UIColor colorWithRed:0 green:120.0/255.0f blue:255.0/255.0f alpha:1];
	_label.textColor = [UIColor blackColor];
	[_label setFont:[UIFont systemFontOfSize:18]];
	[self.contentView addSubview:_label];
	_label.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:_label  attribute:NSLayoutAttributeCenterX  relatedBy:NSLayoutRelationEqual  toItem:self.contentView  attribute:NSLayoutAttributeCenterX  multiplier:1  constant:0 ] ] ;
	[self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:_label  attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual  toItem:self.contentView  attribute:NSLayoutAttributeCenterY multiplier:1  constant:0 ] ] ;
	[self.contentView updateConstraints];
	self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
	self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:222/255.0f green:222/255.0f blue:227/255.0f alpha:1];
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
