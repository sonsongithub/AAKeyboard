//
//  AAKToolbarFooterView.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKToolbarFooterView.h"

@interface AAKToolbarFooterView() {
	IBOutlet UIImageView *_leftSeperatorImageView;
}
@end

@implementation AAKToolbarFooterView

- (void)awakeFromNib {
	[super awakeFromNib];
	UIImage *temp = [UIImage imageNamed:@"leftEdge"];
	UIImage *temp2 = [temp stretchableImageWithLeftCapWidth:1 topCapHeight:1];
	_leftSeperatorImageView.image = temp2;
	self.backgroundColor = [UIColor clearColor];
}

@end
