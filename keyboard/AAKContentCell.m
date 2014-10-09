//
//  AAKContentCell.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKContentCell.h"

@interface AAKContentCell() {
	UILabel *_label;
}
@end

@implementation AAKContentCell

- (void)setBounds:(CGRect)bounds {
	[super setBounds:bounds];
	self.contentView.frame = bounds;
}

- (void)privateInit {
	_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	_label.textColor = [UIColor blackColor];
	_label.backgroundColor = [UIColor lightGrayColor];
	_label.textAlignment = NSTextAlignmentCenter;
	_label.adjustsFontSizeToFitWidth = NO;
	_label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	[_label setFont:[UIFont systemFontOfSize:16]];
	[self.contentView addSubview:_label];
	
	_label.translatesAutoresizingMaskIntoConstraints = NO;

	NSDictionary *views = NSDictionaryOfVariableBindings(_label);
	
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-3-[_label]-3-|"
																 options:0 metrics:0 views:views]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_label]-3-|"
																 options:0 metrics:0 views:views]];
	
	self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
	self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:222/255.0f green:222/255.0f blue:227/255.0f alpha:1];
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

@end
