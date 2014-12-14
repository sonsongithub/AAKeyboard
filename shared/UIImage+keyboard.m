//
//  UIImage+keyboard.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/11.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "UIImage+keyboard.h"

@implementation UIImage(keyboard)

+ (UIImage*)rightEdgeWithKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
	UIImage *temp = nil;
	if (keyboardAppearance == UIKeyboardAppearanceDark) {
		temp = [UIImage imageNamed:@"darkRightEdge"];
	}
	else {
		temp = [UIImage imageNamed:@"rightEdge"];
	}
	return [temp stretchableImageWithLeftCapWidth:2 topCapHeight:2];
}

+ (UIImage*)leftEdgeWithKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
	UIImage *temp = nil;
	if (keyboardAppearance == UIKeyboardAppearanceDark) {
		temp = [UIImage imageNamed:@"darkLeftEdge"];
	}
	else {
		temp = [UIImage imageNamed:@"leftEdge"];
	}
	return [temp stretchableImageWithLeftCapWidth:2 topCapHeight:2];
}

+ (UIImage*)topEdgeWithKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
	UIImage *temp = nil;
	if (keyboardAppearance == UIKeyboardAppearanceDark) {
		temp = [UIImage imageNamed:@"darkTopEdge"];
	}
	else {
		temp = [UIImage imageNamed:@"topEdge"];
	}
	return [temp stretchableImageWithLeftCapWidth:0 topCapHeight:1];
}

@end
