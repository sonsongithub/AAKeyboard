//
//  AAKCategorySelectViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/07.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKToolbarController.h"
#import "AAKToolbarCell.h"

@interface AAKToolbarController () <UICollectionViewDataSource, UICollectionViewDelegate> {
	UICollectionView	*_collectionView;
	NSArray *_categories;
	NSArray *_sizeOfCategories;
	UIButton	*_earthKey;
	UIButton	*_historyKey;
	UIButton	*_deleteKey;
}
@end

@implementation AAKToolbarController

- (IBAction)pushEarthKey:(id)sender {
	NSLog(@"pushEarthKey");
}

- (IBAction)pushDeleteKey:(id)sender {
	NSLog(@"pushDeleteKey");
}

- (IBAction)pushHistoryKey:(id)sender {
	NSLog(@"pushHistoryKey");
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	NSLog(@"%@", self.traitCollection);
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

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSLog(@"%@", self.traitCollection);
	
	[self prepareButton];
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	layout.minimumLineSpacing = 0;
	_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 40) collectionViewLayout:layout];
	_collectionView.alwaysBounceHorizontal = YES;
	_collectionView.showsHorizontalScrollIndicator = NO;
	_collectionView.backgroundColor = [UIColor colorWithRed:254.0/255.0f green:254.0/255.0f blue:254.0/255.0f alpha:1];
//	_collectionView.backgroundColor = [UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1];
	[_collectionView registerClass:[AAKToolbarCell class] forCellWithReuseIdentifier:@"AAKCategoryCollectionViewCell"];
	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	
	[self.view addSubview:_collectionView];
	[self.view addSubview:_earthKey];
	[self.view addSubview:_deleteKey];
	[self.view addSubview:_historyKey];
	
	_collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	_earthKey.translatesAutoresizingMaskIntoConstraints = NO;
	_deleteKey.translatesAutoresizingMaskIntoConstraints = NO;
	_historyKey.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView, _earthKey, _deleteKey, _historyKey);
	
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_earthKey
								 attribute:NSLayoutAttributeWidth
								 relatedBy:NSLayoutRelationEqual
									toItem:nil
								 attribute:NSLayoutAttributeNotAnAttribute
								multiplier:1
														   constant:48]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_deleteKey
														  attribute:NSLayoutAttributeWidth
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1
														   constant:48]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_historyKey
														  attribute:NSLayoutAttributeWidth
														  relatedBy:NSLayoutRelationEqual
															 toItem:nil
														  attribute:NSLayoutAttributeNotAnAttribute
														 multiplier:1
														   constant:48]];

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[_earthKey]-0-[_historyKey]-0-[_collectionView(>=0)]-0-[_deleteKey]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_collectionView(>=0)]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_earthKey(>=0)]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_deleteKey(>=0)]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_historyKey(>=0)]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	[self.view updateConstraints];
}

- (void)update {
	NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18]};
	NSMutableArray *buf = [NSMutableArray arrayWithCapacity:[_categories count]];
	CGFloat sumation = 0;
	for (NSString *string in _categories) {
		CGSize s = [string sizeWithAttributes:attributes];
		s.width = floor(s.width) + 20;
		sumation += s.width;
		s.height = self.view.frame.size.height;
		[buf addObject:[NSValue valueWithCGSize:s]];
	}
	_collectionView.alwaysBounceHorizontal = YES;
	NSLog(@"%f", _collectionView.frame.size.width);
	if (sumation < _collectionView.frame.size.width) {
		CGFloat sumation = 0;
		_collectionView.alwaysBounceHorizontal = NO;
		for (int i = 0; i < buf.count; i++) {
			CGSize s = [[buf objectAtIndex:i] CGSizeValue];
			
			if (i == buf.count - 1) {
				s.width = _collectionView.frame.size.width - sumation;
			}
			else {
				s.width = floor(_collectionView.frame.size.width / buf.count);
				sumation += s.width;
			}
			[buf replaceObjectAtIndex:i withObject:[NSValue valueWithCGSize:s]];
		}
	}
	_sizeOfCategories = [NSArray arrayWithArray:buf];
}

- (void)setCategories:(NSArray*)categories {
	_categories = [NSArray arrayWithArray:categories];
	[self update];
	[_collectionView reloadData];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
	}
								 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
									 [self update];
									 [_collectionView reloadData];
								 }];
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
	AAKToolbarCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"AAKCategoryCollectionViewCell" forIndexPath:indexPath];
	cell.label.text = [_categories objectAtIndex:indexPath.item];
	cell.label.backgroundColor = [UIColor clearColor];
	cell.isHead = (indexPath.item == 0);
	return cell;
}

@end
