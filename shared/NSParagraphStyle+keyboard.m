//
//  NSParagraphStyle+keyboard.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/12.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "NSParagraphStyle+keyboard.h"

@implementation NSParagraphStyle(keyboard)

/**
 * フォントサイズを指定して，行間などのAttributeが設定されたNSParagraphStyleオブジェクトを生成する．
 * @param fontSize パラグラフスタイル適用するNSAttributedStringに割り当てるフォントの大きさ．
 * @return NSParagraphStyleオブジェクト．
 **/
+ (NSParagraphStyle*)defaultParagraphStyleWithFontSize:(float)fontSize {
	NSMutableParagraphStyle  *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
	paragraphStyle.alignment = NSTextAlignmentLeft;
	paragraphStyle.maximumLineHeight = fontSize + 1;
	paragraphStyle.minimumLineHeight = fontSize + 1;
	paragraphStyle.lineSpacing = 1;
	paragraphStyle.paragraphSpacing = 1;
	paragraphStyle.paragraphSpacingBefore = 1;
	paragraphStyle.lineHeightMultiple = 0;
	return paragraphStyle;
}

@end
