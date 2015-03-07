//
//  UIImage+keyboard.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/11.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(keyboard)

+ (UIImage*)rightEdgeWithKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance;
+ (UIImage*)leftEdgeWithKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance;
+ (UIImage*)topEdgeWithKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance;

@end
