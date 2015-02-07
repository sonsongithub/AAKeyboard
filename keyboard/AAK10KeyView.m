//
//  AAK10KeyView.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/02/07.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAK10KeyView.h"

@interface AAK10KeyView() {
	IBOutlet NSLayoutConstraint *_10KeyWidthConstraint;
}
@end

@implementation AAK10KeyView

+ (instancetype)viewFromNib {
	// 通知ビューを貼り付ける
	UINib *nib = [UINib nibWithNibName:@"AAK10KeyView" bundle:nil];
	return [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
}

- (void)setWidth:(CGFloat)width {
	_10KeyWidthConstraint.constant = width;
	[self setNeedsLayout];
}

@end
