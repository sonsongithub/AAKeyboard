//
//  AAKCategorySelectViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/07.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKCategorySelectViewController.h"
#import "AAKCategoryCollectionViewCell.h"

@interface AAKCategorySelectViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
	UICollectionView	*_collectionView;
	NSArray *_categories;
	NSArray *_sizeOfCategories;
}
@end

@implementation AAKCategorySelectViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	layout.minimumLineSpacing = 0;
	_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 40) collectionViewLayout:layout];
	_collectionView.alwaysBounceHorizontal = YES;
	_collectionView.showsHorizontalScrollIndicator = NO;
	_collectionView.backgroundColor = [UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
	[_collectionView registerClass:[AAKCategoryCollectionViewCell class] forCellWithReuseIdentifier:@"AAKCategoryCollectionViewCell"];
	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	//_collectionView.contentInset = UIEdgeInsetsMake(0, 44, 0, 0);
	[self.view addSubview:_collectionView];
	_collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView);
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[_collectionView(>=0)]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_collectionView(>=0)]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	[self.view updateConstraints];
}

- (void)setCategories:(NSArray*)categories {
	_categories = [NSArray arrayWithArray:categories];
	NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
	NSMutableArray *buf = [NSMutableArray arrayWithCapacity:[_categories count]];
	for (NSString *string in _categories) {
		CGSize s = [string sizeWithAttributes:attributes];
		s.width = floor(s.width) + 20;
		s.height = 40;
		[buf addObject:[NSValue valueWithCGSize:s]];
	}
	_sizeOfCategories = [NSArray arrayWithArray:buf];
	[_collectionView reloadData];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return [[_sizeOfCategories objectAtIndex:indexPath.item] CGSizeValue];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
//	if ([self.delegate respondsToSelector:@selector(inputCandidateAccessory:selectedString:)])
//		[self.delegate inputCandidateAccessory:self selectedString:[_titleList objectAtIndex:indexPath.item]];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
	return [_categories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
	AAKCategoryCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"AAKCategoryCollectionViewCell" forIndexPath:indexPath];
	cell.label.text = [_categories objectAtIndex:indexPath.item];
	cell.label.backgroundColor = [UIColor clearColor];
	return cell;
}

@end
