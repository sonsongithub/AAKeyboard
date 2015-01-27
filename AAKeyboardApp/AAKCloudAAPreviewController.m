//
//  AAKCloudAAPreviewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/27.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAKCloudAAPreviewController.h"

@implementation AAKCloudAAPreviewController

/**
 * テキストビューに再度AAを突っ込みコンテンツを最新のものに更新する．
 **/
- (void)updateTextView {
	CGFloat fontSize = 15;
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_asciiart.ASCIIArt attributes:attributes];
	_textView.attributedString = string;
}

- (AAKContent*)content {
	return _asciiart;
}

+ (CGFloat)marginConstant {
	return 30;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_leftMarginConstraint.constant = [AAKCloudAAPreviewController marginConstant];
	_rightMarginConstraint.constant = [AAKCloudAAPreviewController marginConstant];
	_topMarginConstraint.constant = [AAKCloudAAPreviewController marginConstant];
	_bottomMarginConstraint.constant = [AAKCloudAAPreviewController marginConstant];
	
	_textView.userInteractionEnabled = NO;
	[self updateTextView];
}

@end
