//
//  AAKKeyboardView.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAKKeyboardView;

@protocol AAKKeyboardViewDelegate <NSObject>

- (void)keyboardViewDidPushEarthButton:(AAKKeyboardView*)keyboardView;
- (void)keyboardViewDidPushDeleteButton:(AAKKeyboardView*)keyboardView;
- (void)keyboardView:(AAKKeyboardView*)keyboardView willInsertString:(NSString*)string;

@end

@interface AAKKeyboardView : UIView
@property (nonatomic, assign) id <AAKKeyboardViewDelegate> delegate;
- (void)load;
- (void)setPortraitMode;
- (void)setLandscapeMode;
@end
