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
#import "NSParagraphStyle+keyboard.h"
#import "AAKASCIIArt.h"

@interface AAKAACollectionViewCell() <UIGestureRecognizerDelegate> {
	CGPoint _startPoint;
	CGFloat _movement;
	BOOL _opened;
}
@end

@implementation AAKAACollectionViewCell

- (AAKTextView*)textViewForAnimation {
	CGFloat fontSize = 15;
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_asciiart.asciiArt attributes:attributes];
	DNSLogRect(self.textView.bounds);
	AAKTextView *textView = [[AAKTextView alloc] initWithFrame:self.textView.bounds];
	textView.attributedString = string;
	textView.backgroundColor = [UIColor whiteColor];
	return textView;
}

- (void)close {
	_opened = NO;
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
	
	float enableThreshold = 10;
	
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
	if (_opened) {
		[self close];
	}
	else {
		[_delegate didSelectCell:self];
	}
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
	
	
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		DNSLog(@"UIGestureRecognizerStateBegan");
		_startPoint = translate;
		DNSLogPoint(_startPoint);
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
		CGFloat diff = _startPoint.x - translate.x;
		DNSLog(@"UIGestureRecognizerStateChanged");
		DNSLog(@"%f", diff);
		if (_opened)
			_movement = 128;
		else
			_movement = 0;
		if (_movement + diff > 0) {
			_leftMargin.constant = -_movement - diff;
			_rightMargin.constant = _movement + diff;
			_myCopyButtonWidth.constant = (_movement+ diff) / 2;
			_myDeleteButtonWidth.constant = (_movement + diff) / 2;
				
		}
		else {
			_leftMargin.constant = 0;
			_rightMargin.constant = 0;
			_myCopyButtonWidth.constant = 0;
			_myDeleteButtonWidth.constant = 0;
		}
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
		CGFloat diff = _startPoint.x - translate.x;
		DNSLog(@"UIGestureRecognizerStateEnded");
		if (_movement + diff < 64) {
			_opened = NO;
			_leftMargin.constant = 0;
			_rightMargin.constant = 0;
			_myCopyButtonWidth.constant = 0;
			_myDeleteButtonWidth.constant = 0;
		}
		else {
			_opened = YES;
			_leftMargin.constant = -128;
			_rightMargin.constant = 128;
			_myCopyButtonWidth.constant = 64;
			_myDeleteButtonWidth.constant = 64;
		}
		[UIView animateWithDuration:0.3
						 animations:^{
							 [_textBackView.superview layoutIfNeeded];
						 }];
	}
}

@end
