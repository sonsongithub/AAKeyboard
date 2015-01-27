//
//  AAKAAEditAnimatedTransitioning.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/29.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAKTextView;

@protocol AAKContentProtocol <NSObject>
- (CGFloat)ratio;
@end
typedef NSObject<AAKContentProtocol> AAKContent;

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
typedef UICollectionViewController<AAKSourceCollectionViewControllerProtocol> AAKSourceCollectionViewController;

@protocol AAKDestinationPreviewControllerProtocol <NSObject>
@required
/**
 * プレビューで表示するテキストビュー．
 * @return ビューコントローラが保持するAAKTextViewオブジェクト．
 **/
- (AAKTextView*)textView;

/**
 * プレビューが保持するアスキーアートのオブジェクトを返す．
 * オブジェクトは，AAKCloudASCIIArtあるいはAAKASCIIArtクラス．
 * @return AAのaspect ratio.
 **/
- (AAKContent*)content;

/**
 * プレビュー上のマージン．
 * @return マージンの値．
 **/
+ (CGFloat)marginConstant;

@end
typedef UIViewController<AAKDestinationPreviewControllerProtocol> AAKDestinationPreviewController;

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
