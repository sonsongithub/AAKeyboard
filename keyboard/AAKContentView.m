//
//  AAKContentView.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKContentView.h"
#import "AAKContentCell.h"

@interface AAKContentView() <UICollectionViewDelegate, UICollectionViewDataSource> {
	UIPageControl		*_pageControl;
	UICollectionView	*_collectionView;
	UICollectionViewFlowLayout *_collectionFlowLayout;
	NSArray				*_categories;
	float w;
	float h;
}
@end

@implementation AAKContentView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
//		self.backgroundColor = [UIColor greenColor];
		
		_collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
		_collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		_collectionFlowLayout.minimumLineSpacing = 0;
		_collectionFlowLayout.minimumInteritemSpacing = 0;
//		_collectionFlowLayout.itemSize = CGSizeMake(100, 140);
		_collectionFlowLayout.sectionInset = UIEdgeInsetsZero;
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionFlowLayout];
		_collectionView.alwaysBounceHorizontal = YES;
		_collectionView.showsHorizontalScrollIndicator = NO;
		_collectionView.backgroundColor = [UIColor colorWithRed:254.0/255.0f green:254.0/255.0f blue:254.0/255.0f alpha:1];
		//	_collectionView.backgroundColor = [UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
		[_collectionView registerClass:[AAKContentCell class] forCellWithReuseIdentifier:@"AAKContentCell"];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		
		[self addSubview:_collectionView];
		
		_pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
		[self addSubview:_pageControl];
		
		_pageControl.numberOfPages = 10;
		_pageControl.currentPage = 1;
		_pageControl.translatesAutoresizingMaskIntoConstraints = NO;
		_collectionView.translatesAutoresizingMaskIntoConstraints = NO;
		
		NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView, _pageControl);
		
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView(>=0)]-0-|"
																		  options:0 metrics:0 views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_pageControl]-0-|"
																		  options:0 metrics:0 views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_pageControl]-0-[_collectionView(>=0)]-0-|"
																		  options:0 metrics:0 views:views]];
		NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:_pageControl
																attribute:NSLayoutAttributeHeight
																relatedBy:NSLayoutRelationEqual
																   toItem:nil
																attribute:NSLayoutAttributeNotAnAttribute
															   multiplier:1
																 constant:20];
		[self addConstraint:c];
		[_collectionView reloadData];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
//	NSLog(@"layoutSubviews");
//	[super layoutSubviews];
//	NSLog(@"=======================>%f", CGRectGetWidth(self.bounds));
//	_collectionFlowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.bounds)/4, CGRectGetHeight(self.bounds) - 20);
//	[_collectionFlowLayout invalidateLayout];
//	w = CGRectGetWidth(_collectionView.bounds)/4;
//	h = CGRectGetHeight(_collectionView.bounds) - 20;
//	[_collectionView reloadData];
}

- (void)load {
	w = CGRectGetWidth(_collectionView.bounds)/4;
	h = CGRectGetHeight(_collectionView.bounds) - 20;
//	[_collectionView reloadData];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(w, h);
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

@end
