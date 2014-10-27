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

@interface AAKAACollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) IBOutlet AAKTextView *textView;
@property (nonatomic, assign) AAKASCIIArt *asciiart;

@end
