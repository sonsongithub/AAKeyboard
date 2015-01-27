//
//  AAKAACollectionViewCell.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/23.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAKAAEditAnimatedTransitioning.h"

@class AAKTextView;
@class _AAKASCIIArt;
@class _AAKASCIIArtGroup;
@class AAKAACollectionViewCell;

@protocol AAKAACollectionViewCellDelegate <NSObject>

/**
 * セルを選択したときに呼び出されるメソッド．
 * セルをタップした後はプレビューを拡大する．
 * @param cell メソッドをコールしたAAKAACollectionViewCellオブジェクト．
 **/
- (void)didSelectCell:(AAKAACollectionViewCell*)cell;

/**
 * セルの複製ボタンを押したときに呼び出されるメソッド．
 * @param cell メソッドをコールしたAAKAACollectionViewCellオブジェクト．
 **/
- (void)didPushDuplicateButtonOnCell:(AAKAACollectionViewCell*)cell;

/**
 * セルの削除ボタンを押したときに呼び出されるメソッド．
 * @param cell メソッドをコールしたAAKAACollectionViewCellオブジェクト．
 **/
- (void)didPushDeleteButtonOnCell:(AAKAACollectionViewCell*)cell;

@end

@interface AAKAACollectionViewCell : UICollectionViewCell <AAKSourceCollectionViewCellProtocol>

@property (nonatomic, assign) IBOutlet AAKTextView *textView;							/** アスキーアートをレンダリングするビュー */
@property (nonatomic, assign) IBOutlet UIView *textBackView;							/** テキストの背景ビュー */
@property (nonatomic, assign) IBOutlet UIButton *duplicateButtonOnCell;					/** 複製ボタン */
@property (nonatomic, assign) IBOutlet UIButton *deleteButtonOnCell;					/** 削除ボタン */
@property (nonatomic, assign) IBOutlet UILabel *debugLabel;								/** デバッグ用のラベル */
@property (nonatomic, assign) IBOutlet UIImageView *backImageView;

@property (nonatomic, assign) IBOutlet NSLayoutConstraint *leftMargin;					/** 背景のセルに対する左マージン */
@property (nonatomic, assign) IBOutlet NSLayoutConstraint *rightMargin;					/** 背景のセルに対する右マージン */
@property (nonatomic, assign) IBOutlet NSLayoutConstraint *duplicateButtonOnCellWidth;	/** 複製ボタンの幅 */
@property (nonatomic, assign) IBOutlet NSLayoutConstraint *deleteButtonOnCellWidth;		/** 削除ボタンの幅 */

@property (nonatomic, assign) id <AAKAACollectionViewCellDelegate> delegate;			/** 親のビューにコールバックするためのデリゲート */
@property (nonatomic, strong) AAKASCIIArt *asciiart;									/** 表示するアスキーアート */

@property (nonatomic, readonly) BOOL opened;

/**
 * リストからAAをプレビューするアニメーションに使うテキストビューを作成する．
 * @return セルが表示中のAAがセットされたAAKTextViewオブジェクト．
 **/
- (AAKTextView*)textViewForAnimation;

/**
 * 複製と削除ボタンを非表示にする．
 **/
- (void)closeAnimated:(BOOL)animated;

@end
