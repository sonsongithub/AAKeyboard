//
//  AAKAACollectionViewCell.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/23.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKAACollectionViewCell.h"

#import "AAKKeyboardDataManager.h"
#import "AAKHelper.h"
#import "AAKTextView.h"

@interface AAKAACollectionViewCell() <UIGestureRecognizerDelegate> {
	CGPoint _startPoint;
	CGFloat _movement;
}
@end

@implementation AAKAACollectionViewCell

- (void)close {
	_leftMargin.constant = 0;
	_rightMargin.constant = 0;
	_myCopyButtonWidth.constant = 0;
	_myDeleteButtonWidth.constant = 0;
	[UIView animateWithDuration:0.3
					 animations:^{
						 [_textBackView.superview layoutIfNeeded];
					 }];
}

- (IBAction)delete:(id)sender {
	[_delegate didPushDeleteCell:self];
	[self close];
}

- (IBAction)copy:(id)sender {
	[_delegate didPushCopyCell:self];
	[self close];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	
	float enableThreshold = 2;
	
	if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
		
		UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
		CGPoint velocity = [panGesture velocityInView:panGesture.view];
		
		double radian = atan(velocity.y/velocity.x);
		double degree = radian * 180 / M_PI;
		
		if (fabs(degree) > enableThreshold) {
			return NO;
		}
	}
	return YES;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_leftMargin.constant = 0;
	_rightMargin.constant = 0;
	_myCopyButtonWidth.constant = 0;
	_myDeleteButtonWidth.constant = 0;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	DNSLogMethod
	[_delegate didSelectCell:self];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	UIPanGestureRecognizer * swipeleft = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
	swipeleft.delegate = self;
	[self addGestureRecognizer:swipeleft];
	
	[_myCopyButton.superview sendSubviewToBack:_myCopyButton];
	[_myDeleteButton.superview sendSubviewToBack:_myDeleteButton];
	
	_myCopyButtonWidth.constant = 0;
	_myDeleteButtonWidth.constant = 0;
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer {
	
	CGPoint translate = [gestureRecognizer locationInView:self];
	
	CGFloat diff = _startPoint.x - translate.x;
	
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		_startPoint = translate;
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
		if (_movement + diff > 0) {
			_leftMargin.constant = -_movement - diff;
			_rightMargin.constant = _movement + diff;
			_myCopyButtonWidth.constant = (_movement+ diff) / 2;
			_myDeleteButtonWidth.constant = (_movement + diff) / 2;
		}
		else {
			_leftMargin.constant = -_movement;
			_rightMargin.constant = _movement;
			_myCopyButtonWidth.constant = _movement/2;
			_myDeleteButtonWidth.constant = _movement/2;
		}
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
		if (_movement + diff < 64) {
			_movement = 0;
			_leftMargin.constant = -_movement;
			_rightMargin.constant = _movement;
			_myCopyButtonWidth.constant = _movement/2;
			_myDeleteButtonWidth.constant = _movement/2;
		}
		else {
			_movement = 128;
			_leftMargin.constant = -_movement;
			_rightMargin.constant = _movement;
			_myCopyButtonWidth.constant = _movement/2;
			_myDeleteButtonWidth.constant = _movement/2;
		}
		[UIView animateWithDuration:0.3
						 animations:^{
							 [_textBackView.superview layoutIfNeeded];
						 }];
	}
}

@end
