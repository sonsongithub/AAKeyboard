//
//  AAKAAEditAnimatedTransitioning.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/29.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAKTextView;

@protocol AAKSourceCollectionViewControllerProtocol <NSObject>
@required
/**
 * contentを持つセルを返す．実装は，ビューコントローラに依存する．
 *
 * @param content コンテンツオブジェクト．AAKCloudASCIIArtあるいはAAKASCIIArtのオブジェクト．
 * @return AAKSourceCollectionViewCellProtocolプロトコルをフォローするオブジェクト．
 **/
- (id)cellForContent:(id)content;
@end

@protocol AAKDestinationPreviewControllerProtocol <NSObject>
@required
/**
 * プレビューで表示するテキストビュー．
 * @return ビューコントローラが保持するAAKTextViewオブジェクト．
 **/
- (AAKTextView*)textView;

/**
 * プレビューで表示するAAのaspect ratio.
 * @return AAのaspect ratio.
 **/
- (CGFloat)contentRatio;

/**
 * プレビューが保持するアスキーアートのオブジェクトを返す．
 * オブジェクトは，AAKCloudASCIIArtあるいはAAKASCIIArtクラス．
 * @return AAのaspect ratio.
 **/
- (id)asciiart;

/**
 * プレビュー上のマージン．
 * @return マージンの値．
 **/
+ (CGFloat)marginConstant;

@end

@protocol AAKSourceCollectionViewCellProtocol <NSObject>
@required
/**
 * セルで表示するテキストビュー．
 * @return セルが保持するAAKTextViewオブジェクト．
 **/
- (AAKTextView*)textView;

/**
 * アニメーションに使うテキストビューを生成する．
 * サイズや位置はセルに合わせて生成される．
 * @return AAKTextViewオブジェクト．
 **/
- (AAKTextView*)textViewForAnimation;
@end

typedef UICollectionViewController<AAKSourceCollectionViewControllerProtocol> AAKSourceCollectionViewController;
typedef UIViewController<AAKDestinationPreviewControllerProtocol> AAKDestinationPreviewController;
typedef UICollectionViewCell<AAKSourceCollectionViewCellProtocol> AAKSourceCollectionViewCell;

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
