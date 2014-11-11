//
//  UIColor+keyboard.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/10.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(keyboard)

+ (UIColor*)lightColorForDefault;

+ (UIColor*)darkColorForDefault;

+ (UIColor*)lightColorForDark;

+ (UIColor*)darkColorForDark;

+ (UIColor*)keyColor __attribute__((deprecated));
+ (UIColor*)highlightedKeyColor __attribute__((deprecated));

+ (UIColor*)keyColorForKeyboardAppearance:(UIKeyboardAppearance)keyboardApperance __attribute__((deprecated));
+ (UIColor*)highlightedKeyColorForKeyboardAppearance:(UIKeyboardAppearance)keyboardApperance __attribute__((deprecated));

+ (UIColor*)darkColorForDarkMode __attribute__((deprecated));
+ (UIColor*)lightColorForDarkMode __attribute__((deprecated));

@end
