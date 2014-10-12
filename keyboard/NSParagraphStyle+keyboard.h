//
//  NSParagraphStyle+keyboard.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/12.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSParagraphStyle(keyboard)

/**
 * フォントサイズを指定して，行間などのAttributeが設定されたNSParagraphStyleオブジェクトを生成する．
 * @param fontSize パラグラフスタイル適用するNSAttributedStringに割り当てるフォントの大きさ．
 * @return NSParagraphStyleオブジェクト．
 **/
+ (NSParagraphStyle*)defaultParagraphStyleWithFontSize:(float)fontSize;

@end
