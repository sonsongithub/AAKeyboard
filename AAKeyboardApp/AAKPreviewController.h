//
//  AAKPreviewController.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/30.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAKTextView;

@interface AAKPreviewController : UIViewController
@property (nonatomic, strong) IBOutlet AAKTextView *textView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) AAKASCIIArt *asciiart;
@end