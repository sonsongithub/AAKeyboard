//
//  AAKCategoryCollectionViewCell.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/07.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKToolbarCell.h"

@implementation AAKToolbarCell

- (UIColor*)cellHighlightedBackgroundColor {
	if (_keyboardAppearance == UIKeyboardAppearanceDark) {
		return [UIColor lightColorForDark];
	}
	else {
		return [UIColor darkColorForDefault];
	}
}

- (UIColor*)textColor {
	if (_keyboardAppearance == UIKeyboardAppearanceDark) {
		return [UIColor whiteColor];
	}
	else {
		return [UIColor blackColor];
	}
}

- (UIColor*)highlightedTextColor {
	if (_keyboardAppearance == UIKeyboardAppearanceDark) {
		return [UIColor whiteColor];
	}
	else {
		return [UIColor whiteColor];
	}
}

#pragma mark - Setter

/**
 * セルがセクションの末尾にあるかのフラグ．
 * 末尾にある場合は，枠線を表示しない．
 * @param isTail
 **/
- (void)setIsTail:(BOOL)isTail {
	_isTail = isTail;
	_imageView.hidden = _isTail;
}

- (void)setKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
	_keyboardAppearance = keyboardAppearance;
	_imageView.image = [UIImage rightEdgeWithKeyboardAppearance:_keyboardAppearance];
}

#pragma mark - Instance method

/**
 * セルが現在選択中のグループだった場合にハイライトさせるためのメソッド．
 * @param highlighted ハイライトさせるかのフラグ．
 **/
- (void)setOriginalHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	self.selectedBackgroundView.backgroundColor = [self cellHighlightedBackgroundColor];
	if (highlighted) {
		_label.textColor = [self highlightedTextColor];
	}
	else {
		_label.textColor = [self textColor];
	}
}

/**
 * セルに表示させるグループを入力する．
 * @param group AAKASCIIArtGroupオブジェクト．
 **/
- (void)setGroup:(AAKASCIIArtGroup *)group {
	_group = group;
	_label.text = _group.title;
//	[_label sizeToFit];
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

/**
 * セルの右端に配置する縦線をセットアップする．
 **/
- (void)setupVerticalSeperator {
	_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	[self.contentView addSubview:_imageView];
}

/**
 * セルを初期化する．
 * テキストビューの生成，レイアウト，背景色の設定，ジェスチャのアタッチを行う．
 **/
- (void)privateInit {
	self.backgroundColor = [UIColor clearColor];
	self.contentView.backgroundColor = [UIColor clearColor];
	_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	_label.textAlignment = NSTextAlignmentCenter;
//	_label.adjustsFontSizeToFitWidth = YES;
	_label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	[_label setFont:[UIFont systemFontOfSize:16]];
	// 背景をセット
	self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
	
	[self.contentView addSubview:_label];

	[self setupVerticalSeperator];
}

#pragma mark - Override

- (void)layoutSubviews {
	// タイトルラベルをセンタリング．
	[super layoutSubviews];
//	_label.center = CGPointFloor(self.contentView.center);
	_label.frame = self.contentView.bounds;
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

@end
