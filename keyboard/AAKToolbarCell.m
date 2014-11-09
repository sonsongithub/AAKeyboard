//
//  AAKCategoryCollectionViewCell.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/07.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKToolbarCell.h"

#import "AAKShared.h"

@implementation AAKToolbarCell

#pragma mark - Instance method

/**
 * セルが現在選択中のグループだった場合にハイライトさせるためのメソッド．
 * @param highlighted ハイライトさせるかのフラグ．
 **/
- (void)setOriginalHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	if (highlighted)
		_label.textColor = [UIColor whiteColor];
	else
		_label.textColor = [UIColor blackColor];
}

/**
 * セルに表示させるグループを入力する．
 * @param group AAKASCIIArtGroupオブジェクト．
 **/
- (void)setGroup:(AAKASCIIArtGroup *)group {
	_group = group;
	_label.text = _group.title;
	[_label sizeToFit];
}

- (void)setIsTail:(BOOL)isTail {
	_isTail = isTail;
	_imageView.hidden = _isTail;
}

/**
 * グループのタイトルを表示するラベルのフォントサイズを指定する．
 * 画面の回転によってフォントサイズが変更されるために，このメソッドが必要．
 * @param fontSize グループのタイトルを表示するラベルのフォントサイズ．
 **/
- (void)setFontSize:(CGFloat)fontSize {
	_fontSize = fontSize;
	_label.font = [UIFont systemFontOfSize:_fontSize];
}

- (void)setupVerticalSeperator {
	UIImage *temp = [UIImage imageNamed:@"rightEdge"];
	UIImage *temp2 = [temp stretchableImageWithLeftCapWidth:1 topCapHeight:1];
	_imageView = [[UIImageView alloc] initWithImage:temp2];
	[self.contentView addSubview:_imageView];
}

/**
 * セルを初期化する．
 * テキストビューの生成，レイアウト，背景色の設定，ジェスチャのアタッチを行う．
 **/
- (void)privateInit {
	self.backgroundColor = [UIColor blueColor];
	self.contentView.backgroundColor = [UIColor clearColor];
	_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	_label.textColor = [UIColor colorWithRed:0 green:120.0/255.0f blue:255.0/255.0f alpha:1];
	_label.textColor = [UIColor blackColor];
	_label.textAlignment = NSTextAlignmentCenter;
	_label.adjustsFontSizeToFitWidth = YES;
	_label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	[_label setFont:[UIFont systemFontOfSize:16]];
	[self.contentView addSubview:_label];

	[self setupVerticalSeperator];
	
	self.contentView.backgroundColor = [UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
	
#if 0
	NSDictionary *views = NSDictionaryOfVariableBindings(_label);
	_label.translatesAutoresizingMaskIntoConstraints = NO;
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_label]-0-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_label]-0-|"
																 options:0 metrics:0 views:views]];
#endif
	
	self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
	self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
}

#pragma mark - Override

- (void)layoutSubviews {
	// タイトルラベルをセンタリング．
	[super layoutSubviews];
	_label.center = self.contentView.center;
	_imageView.frame = self.contentView.bounds;
}

- (void)setBounds:(CGRect)bounds {
	// iOS8？向けのバグ回避？
	[super setBounds:bounds];
	self.contentView.frame = bounds;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// タップしたら，親のビューにイベントをコールバックする．
	[self.delegate didSelectToolbarCell:self];
}

- (void)setHighlighted:(BOOL)highlighted {
}

- (void)setSelected:(BOOL)selected {
}

- (void)prepareForReuse {
	[super prepareForReuse];
	[self setNeedsDisplay];
	self.isTail = NO;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	[self privateInit];
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[self privateInit];
}

//- (void)drawRect:(CGRect)rect {
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	[[UIColor colorWithRed:254.0/255.0f green:254.0/255.0f blue:254.0/255.0f alpha:1] setFill];
//	CGContextFillRect(context, rect);
//	[[UIColor colorWithRed:23.0/255.0f green:23.0/255.0f blue:23.0/255.0f alpha:1] setFill];
////	CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
//	CGContextFillRect(context, CGRectMake(rect.size.width - 0.5, 0, 0.5, rect.size.height));
//	if (self.isHead)
//		CGContextFillRect(context, CGRectMake(0, 0, 0.5, rect.size.height));
////	CGContextFillRect(context, CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5));
//}

@end
