//
//  UIColor+keyboard.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/10.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(keyboard)

+ (UIColor*)keyColor __attribute__((deprecated));
+ (UIColor*)highlightedKeyColor __attribute__((deprecated));

+ (UIColor*)keyColorForKeyboardAppearance:(UIKeyboardAppearance)keyboardApperance;
+ (UIColor*)highlightedKeyColorForKeyboardAppearance:(UIKeyboardAppearance)keyboardApperance;

+ (UIColor*)darkColorForDarkMode;
+ (UIColor*)lightColorForDarkMode;

@end
