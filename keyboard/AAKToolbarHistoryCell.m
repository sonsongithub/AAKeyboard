//
//  AAKToolbarHistoryCell.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/12.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKToolbarHistoryCell.h"

@interface AAKToolbarHistoryCell() {
	UIImageView *_iconImageView;
}
@end

@implementation AAKToolbarHistoryCell

#pragma mark - Instance method

- (UIImage*)historyIcon {
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		if (self.keyboardAppearance == UIKeyboardAppearanceDark) {
			return [UIImage imageNamed:@"hhistoryHD"];
		}
		else {
			return [UIImage imageNamed:@"historyHD"];
		}
	}
	else {
		if (self.keyboardAppearance == UIKeyboardAppearanceDark) {
			return [UIImage imageNamed:@"hhistory"];
		}
		else {
			return [UIImage imageNamed:@"history"];
		}
	}
}

- (UIImage*)highlightedHistoryIcon {
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		if (self.keyboardAppearance == UIKeyboardAppearanceDark) {
			return [UIImage imageNamed:@"hhistoryHD"];
		}
		else {
			return [UIImage imageNamed:@"hhistoryHD"];
		}
	}
	else {
		if (self.keyboardAppearance == UIKeyboardAppearanceDark) {
			return [UIImage imageNamed:@"hhistory"];
		}
		else {
			return [UIImage imageNamed:@"hhistory"];
		}
	}
}

/**
 * セルが現在選択中のグループだった場合にハイライトさせるためのメソッド．
 * @param highlighted ハイライトさせるかのフラグ．
 **/
- (void)setOriginalHighlighted:(BOOL)highlighted {
	[super setOriginalHighlighted:highlighted];
	if (highlighted) {
		_iconImageView.image = [self highlightedHistoryIcon];
	}
	else {
		_iconImageView.image = [self historyIcon];
	}
}

/**
 * セルを初期化する．
 * テキストビューの生成，レイアウト，背景色の設定，ジェスチャのアタッチを行う．
 **/
- (void)privateInit {
	[self setupVerticalSeperator];
	self.backgroundColor = [UIColor clearColor];
	self.contentView.backgroundColor = [UIColor clearColor];
	_iconImageView = [[UIImageView alloc] initWithImage:[self historyIcon]];
	[self.contentView addSubview:_iconImageView];
	self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
}

#pragma mark - Override

- (void)layoutSubviews {
	// アイコン画像をセンタリング
	_iconImageView.center = self.contentView.center;
	_imageView.frame = self.contentView.bounds;
}

@end
