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

/**
 * キーボードで地球アイコンボタンが押されたことをメインのビューコントローラに送信するためのデリゲートメソッド．
 * @param keyboardView 送信元のAAKKeyboardViewビュー
 **/
- (void)keyboardViewDidPushEarthButton:(AAKKeyboardView*)keyboardView;

/**
 * キーボードで削除ボタンが押されたことをメインのビューコントローラに送信するためのデリゲートメソッド．
 * @param keyboardView 送信元のAAKKeyboardViewビュー
 **/
- (void)keyboardViewDidPushDeleteButton:(AAKKeyboardView*)keyboardView;

/**
 * キーボードから入力があり，文字列を入力するためのメソッド．
 * @param keyboardView 送信元のAAKKeyboardViewビュー
 * @param string 入力しようとされている文字列．
 **/
- (void)keyboardView:(AAKKeyboardView*)keyboardView willInsertString:(NSString*)string;

@end

@interface AAKKeyboardView : UIView
@property (nonatomic, assign) id <AAKKeyboardViewDelegate> delegate;

/**
 * AAKKeyboardViewクラスを初期化する．
 * @param frame ビューのframeを指定する．
 * @param keyboardAppearance 表示中のキーボードのアピアランス．
 * @return 初期化されたAAKKeyboardViewオブジェクト．
 **/
- (instancetype)initWithFrame:(CGRect)frame keyboardAppearance:(UIKeyboardAppearance)keyboardAppearance;

/**
 * レイアウトをリロードして変更する．
 **/
- (void)load;

/**
 * キーボードのツールバーの高さやフォントサイズを変更する．
 * @param toolbarHeight ツールバーの高さ．
 * @param fontSize ツールバーのタイトルのフォントサイズ．
 **/
- (void)setToolbarHeight:(CGFloat)toolbarHeight fontSize:(CGFloat)fontSize;

@end
