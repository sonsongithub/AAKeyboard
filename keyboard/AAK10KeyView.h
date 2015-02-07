//
//  AAK10KeyView.h
//  AAKeyboardApp
//
//  Created by sonson on 2015/02/07.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAK10KeyView;

@protocol AAK10KeyViewDelegate <NSObject>

- (void)didPush10KeyView:(AAK10KeyView*)view key:(NSString*)key;

@end

@interface AAK10KeyView : UIView

+ (instancetype)viewFromNib;
- (void)setWidth:(CGFloat)width;

@property (nonatomic, assign) id<AAK10KeyViewDelegate> delegate;

@end
