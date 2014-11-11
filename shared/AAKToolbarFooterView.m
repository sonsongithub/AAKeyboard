//
//  AAKToolbarFooterView.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKToolbarFooterView.h"

#import "AAKShared.h"

@interface AAKToolbarFooterView() {
	IBOutlet UIImageView *_leftSeperatorImageView;
}
@end

@implementation AAKToolbarFooterView

- (void)setKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
	_keyboardAppearance = keyboardAppearance;
	_leftSeperatorImageView.image = [UIImage leftEdgeWithKeyboardAppearance:_keyboardAppearance];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	self.backgroundColor = [UIColor clearColor];
}

@end
