//
//  AAKToolbarHeaderView.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKToolbarHeaderView.h"

#import "AAKShared.h"

@interface AAKToolbarHeaderView() {
	IBOutlet UIImageView *_rightSeperatorImageView;
}
@end

@implementation AAKToolbarHeaderView

- (void)setKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
	_keyboardAppearance = keyboardAppearance;
	_rightSeperatorImageView.image = [UIImage rightEdgeWithKeyboardAppearance:_keyboardAppearance];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	self.backgroundColor = [UIColor clearColor];
}

@end
