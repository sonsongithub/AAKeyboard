//
//  AAKToolbar.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAKToolbar;

@protocol AAKToolbarDelegate <NSObject>

- (void)toolbar:(AAKToolbar*)toolbar didSelectCategoryIndex:(NSInteger)index;
- (void)toolbar:(AAKToolbar*)toolbar didPushEarthButton:(UIButton*)button;
- (void)toolbar:(AAKToolbar*)toolbar didPushDeleteButton:(UIButton*)button;

@end

@interface AAKToolbar : UIView
@property (nonatomic, assign) id <AAKToolbarDelegate> delegate;
- (void)setCategories:(NSArray*)categories;
- (void)layout;
@end
