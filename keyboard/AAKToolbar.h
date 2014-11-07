//
//  AAKToolbar.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAKToolbar;
@class AAKASCIIArtGroup;

@protocol AAKToolbarDelegate <NSObject>

- (void)toolbar:(AAKToolbar*)toolbar didSelectGroup:(AAKASCIIArtGroup*)group;
- (void)toolbar:(AAKToolbar*)toolbar didPushEarthButton:(UIButton*)button;
- (void)toolbar:(AAKToolbar*)toolbar didPushDeleteButton:(UIButton*)button;

@end

@interface AAKToolbar : UIView
@property (nonatomic, assign) id <AAKToolbarDelegate> delegate;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, readonly) AAKASCIIArtGroup *currentGroup;
- (NSArray*)asciiArtsForCurrentGroup;
- (void)layout;
@end
