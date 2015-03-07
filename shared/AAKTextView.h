//
//  AAKTextView.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/12.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "UZTextView.h"

extern NSString *const AAKTextViewDidCopyAAImageToPasteboard;

@interface AAKTextView : UZTextView

/**
 * クリップボードにAAの画像を転送するために，画像データを作るためのメソッド．
 * @return UIImageオブジェクト．
 **/
- (UIImage*)imageForPasteBoard;

@end
