//
//  AAKPreviewController.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/30.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAKTextView;
@class AAKASCIIArt;
@class AAKASCIIArtGroup;

@interface AAKPreviewController : UIViewController
@property (nonatomic, strong) IBOutlet AAKTextView *textView;
@property (nonatomic, strong) AAKASCIIArtGroup *group;
@property (nonatomic, strong) AAKASCIIArt *art;
@end
