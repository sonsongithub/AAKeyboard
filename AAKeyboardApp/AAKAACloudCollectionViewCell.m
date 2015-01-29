//
//  AAKAACloudCollectionViewCell.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAKAACloudCollectionViewCell.h"

@implementation AAKAACloudCollectionViewCell

/**
 * リストからAAをプレビューするアニメーションに使うテキストビューを作成する．
 * @return セルが表示中のAAがセットされたAAKTextViewオブジェクト．
 **/
- (AAKTextView*)textViewForAnimation {
	CGFloat fontSize = 15;
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_asciiart.ASCIIArt attributes:attributes];
	AAKTextView *textView = [[AAKTextView alloc] initWithFrame:self.textView.bounds];
	textView.attributedString = string;
	return textView;
}

@end
