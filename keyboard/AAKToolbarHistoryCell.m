//
//  AAKToolbarHistoryCell.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/12.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKToolbarHistoryCell.h"

#import "AAKShared.h"

@interface AAKToolbarHistoryCell() {
	UIImageView *_iconImageView;
}
@end

@implementation AAKToolbarHistoryCell

#pragma mark - Instance method

/**
 * セルが現在選択中のグループだった場合にハイライトさせるためのメソッド．
 * @param highlighted ハイライトさせるかのフラグ．
 **/
- (void)setOriginalHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	if (highlighted) {
		self.contentView.backgroundColor = [UIColor highlightedKeyColor];
		_iconImageView.image = [UIImage imageNamed:@"historyHighlighted"];
	}
	else {
		self.contentView.backgroundColor = [UIColor keyColor];
		_iconImageView.image = [UIImage imageNamed:@"history"];
	}
}

/**
 * セルを初期化する．
 * テキストビューの生成，レイアウト，背景色の設定，ジェスチャのアタッチを行う．
 **/
- (void)privateInit {
	self.contentView.backgroundColor = [UIColor keyColor];
	
	[self setupVerticalSeperator];
	
	_iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"history"]];
	[self.contentView addSubview:_iconImageView];
	
	self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
	self.selectedBackgroundView.backgroundColor = [UIColor highlightedKeyColor];
}

#pragma mark - Override

- (void)layoutSubviews {
	// アイコン画像をセンタリング
	_iconImageView.center = self.contentView.center;
	_imageView.frame = self.contentView.bounds;
}

@end
