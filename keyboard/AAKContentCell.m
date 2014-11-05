//
//  AAKContentCell.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKContentCell.h"

#import "AAKShared.h"

@interface AAKContentCell() {
	UILabel		*_label;
	AAKTextView	*_textView;
	NSLayoutConstraint *_widthConstraint;
	NSLayoutConstraint *_heightConstraint;
}
@end

@implementation AAKContentCell

#pragma mark - Override

- (void)setBounds:(CGRect)bounds {
	[super setBounds:bounds];
	self.contentView.frame = bounds;
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

#pragma mark - UIGestureRecognizer

- (void)longPress:(UIGestureRecognizer*)gestureRecognizer {
	DNSLogMethod
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		DNSLog(@"UIGestureRecognizerStateBegan");
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
		DNSLog(@"UIGestureRecognizerStateChanged");
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
		DNSLog(@"UIGestureRecognizerStateEnded");
		[self copyAAImageToPasteBoard];
	}
}

#pragma mark - Instance method

- (void)copyAAImageToPasteBoard {
	
}

- (void)privateInit {
	// テキストビューをセットアップ
	_textView = [[AAKTextView alloc] initWithFrame:CGRectZero];
	[self.contentView addSubview:_textView];
	_textView.translatesAutoresizingMaskIntoConstraints = NO;
	_textView.backgroundColor = [UIColor clearColor];
	_textView.userInteractionEnabled = NO;
	
	// autolayout
	NSDictionary *views = NSDictionaryOfVariableBindings(_textView);
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_textView]-10-|"
																			 options:0 metrics:0 views:views]];
	[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_textView]-10-|"
																			 options:0 metrics:0 views:views]];
	
	// 背景をセット
	self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
	self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:222/255.0f green:222/255.0f blue:227/255.0f alpha:1];
	
	// ジェスチャを設定
	UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
	longPress.minimumPressDuration = 2;
	[self addGestureRecognizer:longPress];
}

@end
