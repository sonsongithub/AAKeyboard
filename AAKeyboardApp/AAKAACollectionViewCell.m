//
//  AAKAACollectionViewCell.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/23.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKAACollectionViewCell.h"

static NSInteger AAKSwipeDirectionThreadholdAsDegree = 20;		/** 斜めのスワイプを横方向へのスワイプと判定するための閾値 */
static NSInteger AAKCellButtonWidth = 96;						/** セルの複製，削除ボタンの幅 */

@interface AAKAACollectionViewCell() <UIGestureRecognizerDelegate> {
	CGPoint		_startPoint;	/** ジェスチャの開始点 */
	CGFloat		_movement;		/** ジェスチャの移動量 */
	BOOL		_opened;		/** 複製，削除ボタンが開いているかのフラグ */
}
@end

@implementation AAKAACollectionViewCell

/**
 * リストからAAをプレビューするアニメーションに使うテキストビューを作成する．
 * @return セルが表示中のAAがセットされたAAKTextViewオブジェクト．
 **/
- (AAKTextView*)textViewForAnimation {
	CGFloat fontSize = 15;
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_asciiart.text attributes:attributes];
	AAKTextView *textView = [[AAKTextView alloc] initWithFrame:self.textView.bounds];
	textView.attributedString = string;
	textView.backgroundColor = [UIColor whiteColor];
	return textView;
}

/**
 * 複製と削除ボタンを非表示にする．
 **/
- (void)closeAnimated:(BOOL)animated {
	_opened = NO;
	_leftMargin.constant = 0;
	_rightMargin.constant = 0;
	_duplicateButtonOnCellWidth.constant = 0;
	_deleteButtonOnCellWidth.constant = 0;
	
	if (animated) {
		[UIView animateWithDuration:0.3
						 animations:^{
							 [_textBackView.superview layoutIfNeeded];
						 }];
	}
}

/**
 * ジェスチャが開始されたタイミングの処理．
 * @param tapPoint ジェスチャ中のタップの位置．
 **/
- (void)gestureRecognizerStateBegan:(UISwipeGestureRecognizer*)gestureRecognizer {
	DNSLogMethod
	CGPoint translate = [gestureRecognizer locationInView:self];
	_startPoint = translate;
}

/**
 * ジェスチャ中にタップの位置が変更されたタイミングの処理．
 * @param tapPoint ジェスチャ中のタップの位置．
 **/
- (void)gestureRecognizerStateChanged:(UISwipeGestureRecognizer*)gestureRecognizer {
	DNSLogMethod
	CGPoint translate = [gestureRecognizer locationInView:self];
	CGFloat diff = _startPoint.x - translate.x;
	if (_opened) {
		_movement = AAKCellButtonWidth;
	}
	else {
		_movement = 0;
	}
	
	if (_movement + diff > 0) {
		_leftMargin.constant = -_movement - diff;
		_rightMargin.constant = _movement + diff;
		_duplicateButtonOnCellWidth.constant = (_movement+ diff);
		_deleteButtonOnCellWidth.constant = (_movement + diff);
		
	}
	else {
		_leftMargin.constant = 0;
		_rightMargin.constant = 0;
		_duplicateButtonOnCellWidth.constant = 0;
		_deleteButtonOnCellWidth.constant = 0;
	}
}

/**
 * ジェスチャが完了したタイミングの処理．
 * @param tapPoint ジェスチャ中のタップの位置．
 **/
- (void)gestureRecognizerStateEnded:(UISwipeGestureRecognizer*)gestureRecognizer {
	DNSLogMethod
	CGPoint translate = [gestureRecognizer locationInView:self];
	CGFloat diff = _startPoint.x - translate.x;
	if (_movement + diff < AAKCellButtonWidth * 0.6) {
		_opened = NO;
		_leftMargin.constant = 0;
		_rightMargin.constant = 0;
		_duplicateButtonOnCellWidth.constant = 0;
		_deleteButtonOnCellWidth.constant = 0;
	}
	else {
		_opened = YES;
		_leftMargin.constant = -AAKCellButtonWidth;
		_rightMargin.constant = AAKCellButtonWidth;
		_duplicateButtonOnCellWidth.constant = AAKCellButtonWidth;
		_deleteButtonOnCellWidth.constant = AAKCellButtonWidth;
	}
	[UIView animateWithDuration:0.3
					 animations:^{
						 [_textBackView.superview layoutIfNeeded];
					 }];
}

/**
 * ジェスチャレコガナイザの状態が変更された時にコールされる．
 * @param sender メッセージの送信元オブジェクト．UISwipeGestureRecognizerクラスのインスタンス．
 **/
- (void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		[self gestureRecognizerStateBegan:gestureRecognizer];
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
		[self gestureRecognizerStateChanged:gestureRecognizer];
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
		[self gestureRecognizerStateEnded:gestureRecognizer];
	}
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	// スワイプのジェスチャを開始するかを判定する
	if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
		UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
		CGPoint velocity = [panGesture velocityInView:panGesture.view];
		
		double radian = atan(velocity.y/velocity.x);
		double degree = radian * 180 / M_PI;
		
		// 指定した角度よりも大きく（斜めに）スワイプした場合は，ジェスチャは開始されない
		if (fabs(degree) > AAKSwipeDirectionThreadholdAsDegree) {
			return NO;
		}
	}
	return YES;
}

#pragma mark - IBAction

/**
 * 削除ボタンを押した時のメソッド．
 * @param sender メッセージの送信元オブジェクト
 **/
- (IBAction)delete:(id)sender {
	[_delegate didPushDeleteButtonOnCell:self];
	[self closeAnimated:YES];
}

/**
 * 複製ボタンを押した時のメソッド．
 * @param sender メッセージの送信元オブジェクト
 **/
- (IBAction)copy:(id)sender {
	[_delegate didPushDuplicateButtonOnCell:self];
	[self closeAnimated:YES];
}

#pragma mark - Override

- (void)prepareForReuse {
	[super prepareForReuse];
	[self closeAnimated:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_opened) {
		[self closeAnimated:YES];
	}
	else {
		[_delegate didSelectCell:self];
	}
}

- (void)awakeFromNib {
	[super awakeFromNib];

#if 1
	[self.debugLabel removeFromSuperview];
	self.debugLabel = nil;
#endif
	
	// ジェスチャを設定
	UIPanGestureRecognizer * swipeleft = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
	swipeleft.delegate = self;
	[self addGestureRecognizer:swipeleft];
	
	// ボタンを見えないように下に隠す
	[_duplicateButtonOnCell.superview sendSubviewToBack:_duplicateButtonOnCell];
	[_deleteButtonOnCell.superview sendSubviewToBack:_deleteButtonOnCell];
	
	// ボタンの大きさを０に修正しておく．
	_duplicateButtonOnCellWidth.constant = 0;
	_deleteButtonOnCellWidth.constant = 0;
}

@end
