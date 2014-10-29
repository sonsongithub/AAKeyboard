//
//  AAKAACollectionViewController.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/23.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAKASCIIArt;

@interface AAKAACollectionViewController : UICollectionViewController
- (NSIndexPath*)indexPathForAsciiArt:(AAKASCIIArt*)asciiart;
@end
