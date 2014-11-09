//
//  AAKToolbarHeaderView.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKToolbarHeaderView.h"

@interface AAKToolbarHeaderView() {
	IBOutlet UIImageView *_imageView;
}
@end

@implementation AAKToolbarHeaderView

- (void)awakeFromNib {
	[super awakeFromNib];
	UIImage *temp = [UIImage imageNamed:@"rightEdge"];
	UIImage *temp2 = [temp stretchableImageWithLeftCapWidth:1 topCapHeight:1];
	_imageView.image = temp2;
}

@end
