//
//  AAKTextView.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/12.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKTextView.h"

#import "NSParagraphStyle+keyboard.h"

NSString *const AAKTextViewDidCopyAAImageToPasteboard = @"AAKTextViewDidCopyAAImageToPasteboard";

static CGFloat AAKTextViewImageWidth = 320;

@interface AAKTextView() {
	NSLayoutConstraint *_widthConstraint;
	NSLayoutConstraint *_heightConstraint;
	CGSize _contentSize;
}
@end

@implementation AAKTextView

/**
 * クリップボードにAAの画像を転送するために，画像データを作るためのメソッド．
 * @return UIImageオブジェクト．
 **/
- (UIImage*)imageForPasteBoard {
	CGFloat width = AAKTextViewImageWidth;
	
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:15];
	NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:15]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.attributedString.string attributes:attributes];
	
	CGSize textSize = [UZTextView sizeForAttributedString:string withBoundWidth:CGFLOAT_MAX margin:UIEdgeInsetsZero];
	AAKTextView *dummyTextView = [[AAKTextView alloc] initWithFrame:CGRectMake(0, 0, width, width / textSize.width * textSize.height)];
	dummyTextView.backgroundColor = [UIColor whiteColor];
	dummyTextView.attributedString = string;
	
	UIGraphicsBeginImageContextWithOptions(dummyTextView.bounds.size, NO, 0);
	[dummyTextView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

- (void)updateLayout {
	if (_lastLayoutWidth == (self.frame.size.width - (_margin.left + _margin.right))) {
		return;
	}
	
	// CoreText
	SAFE_CFRELEASE(_framesetter);
	SAFE_CFRELEASE(_frame);
	
	CFAttributedStringRef p = (__bridge CFAttributedStringRef)_attributedString;
	if (p) {
		_framesetter = CTFramesetterCreateWithAttributedString(p);
	}
	else {
		p = CFAttributedStringCreate(NULL, CFSTR(""), NULL);
		_framesetter = CTFramesetterCreateWithAttributedString(p);
		CFRelease(p);
	}
	
	_lastLayoutWidth = self.frame.size.width - (_margin.left + _margin.right);
	
	if (YES) {
		_lastLayoutWidth = CGFLOAT_MAX;
	}
	
	CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(_framesetter,
																	CFRangeMake(0, _attributedString.length),
																	NULL,
																	CGSizeMake(_lastLayoutWidth, CGFLOAT_MAX),
																	NULL);
	
	CGSize contentSize = frameSize;
	_contentSize = contentSize;
	frameSize.width = _lastLayoutWidth;
	_contentRect = CGRectZero;
	_contentRect.size = frameSize;
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, _contentRect);
	_frame = CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), path, NULL);
	CGPathRelease(path);
}

/**
 * アスキーアート描画のためにメソッドを拡張．
 * アスキーアートモードの場合，縮小してレンダリングする．
 **/
- (void)drawContent {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, _margin.left, _margin.top);
	
	CGFloat scale = 1;
	
	CGFloat a = self.frame.size.width / self.frame.size.height;
	CGFloat b = _contentSize.width / _contentSize.height;
	CGFloat ratio = 1;
	
	if (a >= b) {
		scale = self.frame.size.height / _contentSize.height;
		ratio = scale;
	}
	else {
		scale = self.frame.size.width / _contentSize.width;
		ratio = scale;
	}
	
	CGPoint offset = CGPointMake(0, 0);
	
	offset.x = (self.frame.size.width - scale * _contentSize.width) / 2;
	offset.y = (self.frame.size.height - scale * _contentSize.height) / 2;
	
	CGContextTranslateCTM(context, offset.x, offset.y);
	
	if (YES)
		CGContextScaleCTM(context, scale, scale);
	
	// draw text
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, 0, _contentRect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CTFrameDraw(_frame, context);
	CGContextRestoreGState(context);
	
	// for debug
	//	[self drawStringRectForDebug];
	
	// draw hightlighted text
	for (NSValue *value in _highlightRanges) {
		NSRange range = [value rangeValue];
		[self drawSelectedTextFragmentRectsFromIndex:range.location toIndex:range.location + range.length - 1 color:[[UIColor yellowColor] colorWithAlphaComponent:0.5]];
	}
	// draw selected strings
	if (_status > 0)
		[self drawSelectedTextFragmentRectsFromIndex:_head
											 toIndex:_tail
											   color:[self.tintColor colorWithAlphaComponent:_tintAlpha]];
	
	// draw tapped link range background
	if (_tappedLinkRange.length > 0)
		[self drawSelectedTextFragmentRectsFromIndex:_tappedLinkRange.location
											 toIndex:_tappedLinkRange.location + _tappedLinkRange.length - 1
											   color:[self.tintColor colorWithAlphaComponent:_tintAlpha]];
}

@end
