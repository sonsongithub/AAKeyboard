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

/**
 * セルが現在選択中のグループだった場合にハイライトさせるためのメソッド．
 * @param highlighted ハイライトさせるかのフラグ．
 **/
- (void)setOriginalHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	if (highlighted) {
		self.contentView.backgroundColor = [UIColor colorWithRed:187/255.0f green:190/255.0f blue:195/255.0f alpha:1];
		_iconImageView.image = [UIImage imageNamed:@"historyHighlighted"];
	}
	else {
		self.contentView.backgroundColor = [UIColor colorWithRed:247/255.0f green:248/255.0f blue:249/255.0f alpha:1];
		_iconImageView.image = [UIImage imageNamed:@"history"];
	}
}

/**
 * セルを初期化する．
 * テキストビューの生成，レイアウト，背景色の設定，ジェスチャのアタッチを行う．
 **/
- (void)privateInit {
	
	self.contentView.backgroundColor = [UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
//	self.backgroundColor = [UIColor blueColor];
//	self.contentView.backgroundColor = [UIColor clearColor];
	
	[self setupVerticalSeperator];
	
	_iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"history"]];
	[self.contentView addSubview:_iconImageView];
	
	self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
	self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
}

#pragma mark - Override

- (void)layoutSubviews {
	// アイコン画像をセンタリング
	_iconImageView.center = self.contentView.center;
	_imageView.frame = self.contentView.bounds;
}

@end
