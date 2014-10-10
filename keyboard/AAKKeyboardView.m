//
//  AAKKeyboardView.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKKeyboardView.h"
#import "AAKToolbar.h"
#import "AAKContentCell.h"
#import "AAKContentFlowLayout.h"

@interface AAKKeyboardView() <UICollectionViewDataSource, UICollectionViewDelegate, AAKToolbarDelegate> {
	AAKToolbar *_toolbar;
	NSLayoutConstraint	*_toolbarHeightConstraint;
	UICollectionView	*_collectionView;
	AAKContentFlowLayout *_collectionFlowLayout;
	UIPageControl *_pageControl;
}
@end

@implementation AAKKeyboardView

- (void)load {
	NSInteger itemsPerPage = 2;
	CGFloat w = CGRectGetWidth(_collectionView.bounds)/itemsPerPage;
	CGFloat h = CGRectGetHeight(_collectionView.bounds);
	_collectionFlowLayout.itemSize = CGSizeMake(w, h);
	[_collectionFlowLayout invalidateLayout];
	_pageControl.numberOfPages = 20 / itemsPerPage;
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor blueColor];
		
		_pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
		
		_toolbar = [[AAKToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_toolbar.delegate = self;
		[self addSubview:_toolbar];
		[self addSubview:_pageControl];
		
		_collectionView.pagingEnabled = YES;
		_collectionFlowLayout = [[AAKContentFlowLayout alloc] init];
		_collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		_collectionFlowLayout.minimumLineSpacing = 0;
		_collectionFlowLayout.minimumInteritemSpacing = 0;
		_collectionFlowLayout.itemSize = CGSizeMake(100, 140);
		_collectionFlowLayout.sectionInset = UIEdgeInsetsZero;
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionFlowLayout];
		_collectionView.alwaysBounceHorizontal = YES;
		_collectionView.showsHorizontalScrollIndicator = NO;
		_collectionView.backgroundColor = [UIColor colorWithRed:254.0/255.0f green:254.0/255.0f blue:254.0/255.0f alpha:1];
		[_collectionView registerClass:[AAKContentCell class] forCellWithReuseIdentifier:@"AAKContentCell"];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		[self addSubview:_collectionView];
		
		_pageControl.translatesAutoresizingMaskIntoConstraints = NO;
		_toolbar.translatesAutoresizingMaskIntoConstraints = NO;
		_collectionView.translatesAutoresizingMaskIntoConstraints = NO;
		
		NSDictionary *views = NSDictionaryOfVariableBindings(_toolbar, _collectionView, _pageControl);
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_toolbar]-0-|"
																	 options:0 metrics:0 views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_pageControl]-0-|"
																	 options:0 metrics:0 views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|"
																		  options:0 metrics:0 views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_pageControl(==20)]-0-[_collectionView]-0-[_toolbar]-0-|"
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
	return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
	AAKContentCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"AAKContentCell" forIndexPath:indexPath];
	cell.label.text = [NSString stringWithFormat:@"%ld", indexPath.item];
	return cell;
}

#pragma mark - AAKToolbarDelegate

- (void)toolbar:(AAKToolbar*)toolbar didSelectCategoryIndex:(NSInteger)index {
}

- (void)toolbar:(AAKToolbar*)toolbar didPushEarthButton:(UIButton*)button {
	[self.delegate keyboardViewDidPushEarthButton:self];
}

- (void)toolbar:(AAKToolbar*)toolbar didPushHistoryButton:(UIButton*)button {
}

- (void)toolbar:(AAKToolbar*)toolbar didPushDeleteButton:(UIButton*)button {
	[self.delegate keyboardViewDidPushDeleteButton:self];
}

@end
