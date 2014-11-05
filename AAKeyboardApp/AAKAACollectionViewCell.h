//
//  AAKAACollectionViewCell.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/23.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAKTextView;
@class AAKASCIIArt;
@class AAKASCIIArtGroup;
@class AAKAACollectionViewCell;

@protocol AAKAACollectionViewCellDelegate <NSObject>

- (void)didSelectCell:(AAKAACollectionViewCell*)cell;
- (void)didPushCopyCell:(AAKAACollectionViewCell*)cell;
- (void)didPushDeleteCell:(AAKAACollectionViewCell*)cell;

@end

@interface AAKAACollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) IBOutlet AAKTextView *textView;
@property (nonatomic, assign) IBOutlet UIView *textBackView;
@property (nonatomic, assign) IBOutlet UIButton *myCopyButton;
@property (nonatomic, assign) IBOutlet UIButton *myDeleteButton;
@property (nonatomic, assign) IBOutlet UILabel *debugLabel;
@property (nonatomic, strong) AAKASCIIArt *asciiart;

@property (nonatomic, assign) IBOutlet NSLayoutConstraint *leftMargin;
@property (nonatomic, assign) IBOutlet NSLayoutConstraint *rightMargin;
@property (nonatomic, assign) IBOutlet NSLayoutConstraint *myCopyButtonWidth;
@property (nonatomic, assign) IBOutlet NSLayoutConstraint *myDeleteButtonWidth;

@property (nonatomic, assign) id <AAKAACollectionViewCellDelegate> delegate;

/**
 * リストからAAをプレビューするアニメーションに使うテキストビューを作成する．
 * @return セルが表示中のAAがセットされたAAKTextViewオブジェクト．
 **/
- (AAKTextView*)textViewForAnimation;

@end
