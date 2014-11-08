//
//  AAKCategoryCollectionViewCell.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/07.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAKASCIIArtGroup;
@class AAKToolbarCell;

@protocol AAKToolbarCellDelegate <NSObject>

/**
 * AAKToolbarCellがタップされたときに呼ばれるデリゲートメソッド．
 * @param cell タップされたAAKToolbarCellオブジェクト．
 **/
- (void)didSelectToolbarCell:(AAKToolbarCell*)cell;

@end

@interface AAKToolbarCell : UICollectionViewCell {
	IBOutlet UILabel *_label;
}
@property (nonatomic, readonly) UILabel *label;
@property (nonatomic, assign) AAKASCIIArtGroup *group;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) BOOL isHead;
@property (nonatomic, assign) id <AAKToolbarCellDelegate> delegate;
- (void)setOriginalHighlighted:(BOOL)highlighted;
@end
