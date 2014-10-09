//
//  AAKToolbar.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKToolbar.h"

#import "AAKToolbarCell.h"

@interface AAKToolbar() <UICollectionViewDataSource, UICollectionViewDelegate> {
	UICollectionView	*_collectionView;
	UICollectionViewFlowLayout *_collectionFlowLayout;
	NSArray				*_categories;
	NSArray				*_sizeOfCategories;
	UIButton			*_earthKey;
	UIButton			*_historyKey;
	UIButton			*_deleteKey;
	
	NSLayoutConstraint	*_earthKeyWidthConstraint;
	NSLayoutConstraint	*_historyKeyWidthConstraint;
	NSLayoutConstraint	*_deleteKeyWidthConstraint;
}
@end

@implementation AAKToolbar

- (IBAction)pushEarthKey:(id)sender {
	NSLog(@"pushEarthKey");
}

- (IBAction)pushDeleteKey:(id)sender {
	NSLog(@"pushDeleteKey");
}

- (IBAction)pushHistoryKey:(id)sender {
	NSLog(@"pushHistoryKey");
}

- (CGFloat)toolbarHeight {
	return 48;
}

- (CGFloat)buttonWidth {
	return 48;
}

- (void)prepareButton {
	_earthKey = [[UIButton alloc] initWithFrame:CGRectZero];
	[_earthKey setImage:[UIImage imageNamed:@"earth"] forState:UIControlStateNormal];
	[_earthKey addTarget:self action:@selector(pushEarthKey:) forControlEvents:UIControlEventTouchUpInside];
	[_earthKey setBackgroundImage:[UIImage imageNamed:@"buttonBackHighlightedState"] forState:UIControlStateHighlighted];
	[_earthKey setBackgroundImage:[UIImage imageNamed:@"buttonBackNormalState"] forState:UIControlStateNormal];
	
	_deleteKey = [[UIButton alloc] initWithFrame:CGRectZero];
	[_deleteKey setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
	_deleteKey.backgroundColor = [UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
	[_deleteKey addTarget:self action:@selector(pushDeleteKey:) forControlEvents:UIControlEventTouchUpInside];
	[_deleteKey setBackgroundImage:[UIImage imageNamed:@"buttonBackHighlightedState"] forState:UIControlStateHighlighted];
	[_deleteKey setBackgroundImage:[UIImage imageNamed:@"buttonBackNormalState"] forState:UIControlStateNormal];
	
	_historyKey = [[UIButton alloc] initWithFrame:CGRectZero];
	[_historyKey setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
	_historyKey.backgroundColor = [UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
	[_historyKey addTarget:self action:@selector(pushHistoryKey:) forControlEvents:UIControlEventTouchUpInside];
	[_historyKey setBackgroundImage:[UIImage imageNamed:@"buttonBackHighlightedState"] forState:UIControlStateHighlighted];
	[_historyKey setBackgroundImage:[UIImage imageNamed:@"buttonBackNormalState"] forState:UIControlStateNormal];
}


- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor redColor];
		
		[self prepareButton];
		
		_collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
		_collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		_collectionFlowLayout.minimumLineSpacing = 0;
		_collectionFlowLayout.minimumInteritemSpacing = 0;
		
		_collectionFlowLayout.sectionInset = UIEdgeInsetsZero;
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionFlowLayout];
		_collectionView.alwaysBounceHorizontal = YES;
		_collectionView.showsHorizontalScrollIndicator = NO;
		_collectionView.backgroundColor = [UIColor colorWithRed:254.0/255.0f green:254.0/255.0f blue:254.0/255.0f alpha:1];
		//	_collectionView.backgroundColor = [UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
		[_collectionView registerClass:[AAKToolbarCell class] forCellWithReuseIdentifier:@"AAKToolbarCell"];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		
		[self addSubview:_collectionView];
		[self addSubview:_earthKey];
		[self addSubview:_deleteKey];
		[self addSubview:_historyKey];
		
		_collectionView.translatesAutoresizingMaskIntoConstraints = NO;
		_earthKey.translatesAutoresizingMaskIntoConstraints = NO;
		_deleteKey.translatesAutoresizingMaskIntoConstraints = NO;
		_historyKey.translatesAutoresizingMaskIntoConstraints = NO;
		
		NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView, _earthKey, _deleteKey, _historyKey);
		
		_earthKeyWidthConstraint = [NSLayoutConstraint constraintWithItem:_earthKey
																attribute:NSLayoutAttributeWidth
																relatedBy:NSLayoutRelationEqual
																   toItem:nil
																attribute:NSLayoutAttributeNotAnAttribute
															   multiplier:1
																 constant:[self buttonWidth]];
		[self addConstraint:_earthKeyWidthConstraint];
		_deleteKeyWidthConstraint = [NSLayoutConstraint constraintWithItem:_deleteKey
																 attribute:NSLayoutAttributeWidth
																 relatedBy:NSLayoutRelationEqual
																	toItem:nil
																 attribute:NSLayoutAttributeNotAnAttribute
																multiplier:1
																  constant:[self buttonWidth]];
		[self addConstraint:_deleteKeyWidthConstraint];
		_historyKeyWidthConstraint = [NSLayoutConstraint constraintWithItem:_historyKey
																  attribute:NSLayoutAttributeWidth
																  relatedBy:NSLayoutRelationEqual
																	 toItem:nil
																  attribute:NSLayoutAttributeNotAnAttribute
																 multiplier:1
																   constant:[self buttonWidth]];
		[self addConstraint:_historyKeyWidthConstraint];
		
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[_earthKey]-0-[_historyKey]-0-[_collectionView(>=0)]-0-[_deleteKey]-(==0)-|"
																		  options:0 metrics:0 views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_collectionView(>=0)]-(==0)-|"
																		  options:0 metrics:0 views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_earthKey(>=0)]-(==0)-|"
																		  options:0 metrics:0 views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_deleteKey(>=0)]-(==0)-|"
																		  options:0 metrics:0 views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_historyKey(>=0)]-(==0)-|"
																		  options:0 metrics:0 views:views]];
	}
	return self;
}

- (void)layoutSubviews
{
	NSLog(@"layoutSubviews");
	[super layoutSubviews];
	NSLog(@"%f", CGRectGetWidth(_collectionView.bounds));
	[self updateWithWidth:CGRectGetWidth(_collectionView.bounds)];
//	[_collectionFlowLayout invalidateLayout];
//	[_collectionView reloadData];
}

- (void)updateWithWidth:(CGFloat)width {
	NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
	NSMutableArray *buf = [NSMutableArray arrayWithCapacity:[_categories count]];
	CGFloat sumation = 0;
	for (NSString *string in _categories) {
		CGSize s = [string sizeWithAttributes:attributes];
		s.width = floor(s.width) + 20;
		sumation += s.width;
		s.height = [self toolbarHeight];
		[buf addObject:[NSValue valueWithCGSize:s]];
	}
	NSLog(@"sumation = %f", sumation);
	NSLog(@"collection = %f", width);
#if 1
	CGFloat parentWidth = width;
	_collectionView.alwaysBounceHorizontal = YES;
	if (sumation < parentWidth) {
		CGFloat sumation = 0;
		_collectionView.alwaysBounceHorizontal = NO;
		for (int i = 0; i < buf.count; i++) {
			CGSize s = [[buf objectAtIndex:i] CGSizeValue];
			
			if (i == buf.count - 1) {
				s.width = parentWidth - sumation;
			}
			else {
				s.width = floor(parentWidth / buf.count);
				sumation += s.width;
			}
			[buf replaceObjectAtIndex:i withObject:[NSValue valueWithCGSize:s]];
		}
	}
#endif
	_sizeOfCategories = [NSArray arrayWithArray:buf];
}

- (void)setCategories:(NSArray*)categories {
	_categories = [NSArray arrayWithArray:categories];
	[self updateWithWidth:CGRectGetWidth(_collectionView.bounds)];
	[_collectionView reloadData];
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
	return [[_sizeOfCategories objectAtIndex:indexPath.item] CGSizeValue];
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
	return [_categories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
	AAKToolbarCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"AAKToolbarCell" forIndexPath:indexPath];
	cell.label.text = [_categories objectAtIndex:indexPath.item];
	cell.isHead = (indexPath.item == 0);
	return cell;
}

@end
