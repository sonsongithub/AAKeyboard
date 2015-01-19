//
//  AAKAACloudCollectionViewCell.h
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAKCloudASCIIArt;

@interface AAKAACloudCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) IBOutlet AAKTextView *textView;			/** アスキーアートをレンダリングするビュー */
@property (nonatomic, assign) IBOutlet UIView *textBackView;			/** テキストの背景ビュー */
@property (nonatomic, assign) IBOutlet UILabel *titleLabel;				/** 名前用ラベル */
@property (nonatomic, strong) AAKCloudASCIIArt *asciiart;				/** 表示するアスキーアート */

@end
