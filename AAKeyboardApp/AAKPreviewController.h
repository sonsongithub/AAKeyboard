//
//  AAKPreviewController.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/30.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>

@class AAKTextView;

@interface AAKPreviewController : UIViewController <AAKDestinationPreviewControllerProtocol>
@property (nonatomic, strong) IBOutlet AAKTextView *textView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topMarginConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bottomMarginConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *rightMarginConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *leftMarginConstraint;

@property (nonatomic, strong) IBOutlet UIButton *pictureSaveButton;
@property (nonatomic, strong) IBOutlet UIButton *uploadButton;
@property (nonatomic, strong) IBOutlet UIButton *trashButton;
@property (nonatomic, strong) IBOutlet UIButton *editButton;


@property (nonatomic, strong) AAKASCIIArt *asciiart;

+ (CGFloat)marginConstant;

@end
