//
//  UIColor+keyboard.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/10.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "UIColor+keyboard.h"

@implementation UIColor(keyboard)

+ (UIColor*)lightColorForDefault {
	return [UIColor colorWithRed:247/255.0f green:248/255.0f blue:249/255.0f alpha:1];
}

+ (UIColor*)darkColorForDefault {
	return [UIColor colorWithRed:187/255.0f green:190/255.0f blue:195/255.0f alpha:1];
}

+ (UIColor*)lightColorForDark {
	return [UIColor colorWithRed:180/255.0f green:200/255.0f blue:200/255.0f alpha:0.5];
}

+ (UIColor*)darkColorForDark {
	return [UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:0.5];
}

@end