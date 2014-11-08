//
//  AAKAAEditAnimatedTransitioning.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/29.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAKAAEditAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

/**
 * AAKAAEditAnimatedTransitioningオブジェクトを初期化する．
 * 表示中であるかのフラグ．このフラグがYESのときは，すでに表示中を意味する．
 * 表示する時も，破棄する時もこのクラスを使う．
 * @param presentFlag 表示中であるかのフラグ
 * @return 初期化されたAAKAAEditAnimatedTransitioningオブジェクト．
 **/
- (instancetype)initWithPresentFlag:(BOOL)presentFlag;

@end
