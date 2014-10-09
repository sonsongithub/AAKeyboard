//
//  AAKKeyboardView.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKKeyboardView.h"
#import "AAKToolbar.h"
#import "AAKContentView.h"

@interface AAKKeyboardView() {
	AAKToolbar *_toolbar;
	AAKContentView *_contentView;
	NSLayoutConstraint	*_toolbarHeightConstraint;
}
@end

@implementation AAKKeyboardView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor blueColor];
		
		_toolbar = [[AAKToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_contentView = [[AAKContentView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		[self addSubview:_toolbar];
		[self addSubview:_contentView];
		
		_toolbar.translatesAutoresizingMaskIntoConstraints = NO;
		_contentView.translatesAutoresizingMaskIntoConstraints = NO;
		
		NSDictionary *views = NSDictionaryOfVariableBindings(_toolbar, _contentView);
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_toolbar]-0-|"
																		  options:0 metrics:0 views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_contentView]-0-|"
																		  options:0 metrics:0 views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_contentView]-0-[_toolbar]-0-|"
																		  options:0 metrics:0 views:views]];
		_toolbarHeightConstraint = [NSLayoutConstraint constraintWithItem:_toolbar
																attribute:NSLayoutAttributeHeight
																relatedBy:NSLayoutRelationEqual
																   toItem:nil
																attribute:NSLayoutAttributeNotAnAttribute
															   multiplier:1
																 constant:48];
		
		[_toolbar setCategories:@[@"hoge", @"hoooo"]];
//		[_toolbar setCategories:@[@"hoge", @"hoooo",@"hoge", @"hoooo",@"hoge", @"hoooo"]];
		
		[self addConstraint:_toolbarHeightConstraint];
		
		[self updateConstraints];
	}
	return self;
}

@end
