//
//  AAKCategoryCollectionViewCell.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/07.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAKCategoryCollectionViewCell : UICollectionViewCell {
	IBOutlet UILabel *_label;
}
@property (nonatomic, readonly) UILabel *label;
@property (nonatomic, assign) BOOL isHead;
@end
