//
//  AAKToolbarHistoryCell.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/12.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKToolbarHistoryCell.h"

@interface AAKToolbarHistoryCell() {
	UIImageView *_iconImageView;
}
@end

@implementation AAKToolbarHistoryCell

- (void)privateInit {
	self.backgroundColor = [UIColor blueColor];
	self.contentView.backgroundColor = [UIColor clearColor];
	
	_iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"history"]];
	[self.contentView addSubview:_iconImageView];
	
	self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
	self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:222/255.0f green:222/255.0f blue:227/255.0f alpha:1];
}

- (void)layoutSubviews {
	NSLog(@"AAKToolbarCell= layoutSubviews");
	_iconImageView.center = self.contentView.center;
}

@end
