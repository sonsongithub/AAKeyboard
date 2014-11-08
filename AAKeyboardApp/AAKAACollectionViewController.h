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

/**
 * 指定されたアスキーアートを含むセルを返す．
 * 見つからない場合は，nilを返す．
 * @param asciiart アスキーアートオブジェクト．
 * @return アスキーアートオブジェクトを保持するAAKAACollectionViewCellインスタンスを返す．
 **/
- (id)cellForAsciiArt:(AAKASCIIArt*)asciiart;

@end
