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

/**
 * AAKToolbarがタップされ，グループが切り替えられたときに呼ばれるデリゲートメソッド．
 * @param toolbar AAKToolbarオブジェクト．
 **/
- (void)didSelectGroupToolbar:(AAKToolbar*)toolbar;

/**
 * AAKToolbarの地球アイコンボタンが押された時によばれるデリゲートメソッド．
 * @param toolbar AAKToolbarオブジェクト．
 * @param button 本当の送信元のUIButtonオブジェクト．
 **/
- (void)toolbar:(AAKToolbar*)toolbar didPushEarthButton:(UIButton*)button;

/**
 * AAKToolbarの削除ボタンが押された時によばれるデリゲートメソッド．
 * @param toolbar AAKToolbarオブジェクト．
 * @param button 本当の送信元のUIButtonオブジェクト．
 **/
- (void)toolbar:(AAKToolbar*)toolbar didPushDeleteButton:(UIButton*)button;

@end

@interface AAKToolbar : UIView
@property (nonatomic, assign) id <AAKToolbarDelegate> delegate;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, readonly) AAKASCIIArtGroup *currentGroup;

/**
 * ツールバー全体をレイアウトする．
 * グループ名の枠の大きさを計算し，すべてのセルの幅を計算する．そのあとに，セルのレイアウトを更新したりする．
 **/
- (void)layout;

/**
 * AAKToolbarクラスを初期化する．
 * @param frame ビューのframeを指定する．
 * @param keyboardAppearance 表示中のキーボードのアピアランス．
 * @return 初期化されたAAKToolbarオブジェクト．
 **/
- (instancetype)initWithFrame:(CGRect)frame keyboardAppearance:(UIKeyboardAppearance)keyboardAppearance;

@end
