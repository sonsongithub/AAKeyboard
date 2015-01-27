//
//  AAKCloudAAPreviewController.h
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/27.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAKAAEditAnimatedTransitioning.h"
#import "AAKCloudASCIIArt.h"

@interface AAKCloudAAPreviewController : UIViewController <AAKDestinationPreviewControllerProtocol>
@property (nonatomic, strong) IBOutlet AAKTextView *textView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topMarginConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bottomMarginConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *rightMarginConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *leftMarginConstraint;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) AAKCloudASCIIArt *asciiart;

+ (CGFloat)marginConstant;
@end
