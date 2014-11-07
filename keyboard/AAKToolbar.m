//
//  AAKToolbar.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKToolbar.h"

#import "AAKToolbarCell.h"
#import "AAKToolbarHistoryCell.h"

#import "AAKShared.h"

@interface AAKToolbar() <UICollectionViewDataSource, UICollectionViewDelegate, AAKToolbarCellDelegate> {
	UICollectionView			*_collectionView;
	UICollectionViewFlowLayout	*_collectionFlowLayout;
	NSArray						*_sizeOfCategories;
	UIButton					*_earthKey;
	UIButton					*_deleteKey;
	NSArray						*_groups;
	NSLayoutConstraint			*_earthKeyWidthConstraint;
	NSLayoutConstraint			*_deleteKeyWidthConstraint;
}
@end

@implementation AAKToolbar

#pragma mark - Instance method

/**
 * 現在，選択中のグループのアスキーアートオブジェクトの配列を返す．
 * @return AAKASCIIArtオブジェクトを含むNSArray，
 **/
- (NSArray*)asciiArtsForCurrentGroup {
	return [[AAKKeyboardDataManager defaultManager] asciiArtForGroup:_currentGroup];
}

/**
 * 指定されたキーを持つAAKASCIIArtGroupオブジェクトを_groupsの中から返す．
 * 指定されたキーを持つオブジェクトが存在しない場合は，先頭のオブジェクトを返す．
 * @return AAKASCIIArtオブジェクトを含むNSArray，
 **/
- (AAKASCIIArtGroup*)groupForGroupKey:(NSInteger)key {
	for (AAKASCIIArtGroup *group in _groups) {
		if (group.key == key)
			return group;
	}
	return _groups[0];
}

/**
 * ツールバーの選択状態になっているセルを更新する．
 * reloadDataだと色々問題が発生するため．
 **/
- (void)updateSelectedCell {
	for (AAKToolbarCell *cell in [_collectionView visibleCells]) {
		[cell setOriginalHighlighted:(cell.group.key == _currentGroup.key)];
	}
}

/**
 * 両脇のボタンを初期化，配置する．
 **/
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
	
	[self addSubview:_earthKey];
	[self addSubview:_deleteKey];
}

/**
 * ツールバー全体をレイアウトする．
 * グループ名の枠の大きさを計算し，すべてのセルの幅を計算する．そのあとに，セルのレイアウトを更新したりする．
 **/
- (void)layout {
	[self updateWithWidth:CGRectGetWidth(_collectionView.bounds)];
	[_collectionFlowLayout invalidateLayout];
	[_collectionView reloadData];
}

/**
 * 各グループのボタンのサイズを再計算する．
 * 幅より，すべてのボタンの幅の総和が狭い場合は，均等にあまり割り当て，スクロールしないようにする．
 **/
- (void)updateWithWidth:(CGFloat)width {
	// 幅が不当なときは計算しない．
	if (width < 1)
		return;
	
	// まず，普通にすべてのグループについて幅を計算する．
	NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:_fontSize]};
	NSMutableArray *buf = [NSMutableArray arrayWithCapacity:[_groups count]];
	CGFloat sumation = 0;
	for (AAKASCIIArtGroup *group in _groups) {
		CGSize s = [group.title sizeWithAttributes:attributes];
		s.width = floor(s.width) + 20;
		sumation += s.width;
		s.height = _height;
		[buf addObject:[NSValue valueWithCGSize:s]];
	}
	
	_collectionView.alwaysBounceHorizontal = YES;
	
	// すべてのグループの幅の総和がビューの幅よりも小さい場合，
	// あまりの部分をそれぞれのセルに割り当てて，空白を作らないようにする．
	if (sumation < width) {
		// 固定になるので，バウンスは解除する．
		_collectionView.alwaysBounceHorizontal = NO;
		
		CGFloat leftWidth = width - sumation;
		CGFloat quota = leftWidth / buf.count;
		
		if (quota > 1) {
			quota = floor(quota);
			CGFloat leftQuota = 0;
			for (int i = 0; i < buf.count; i++) {
				CGSize s = [[buf objectAtIndex:i] CGSizeValue];
				if (i < buf.count - 1) {
					s.width = s.width + quota;
					leftQuota += quota;
				}
				else {
					s.width = s.width + leftWidth - leftQuota;
				}
				[buf replaceObjectAtIndex:i withObject:[NSValue valueWithCGSize:s]];
			}
		}
		else {
			CGSize s = [[buf objectAtIndex:0] CGSizeValue];
			s.width = s.width + leftWidth;
			[buf replaceObjectAtIndex:0 withObject:[NSValue valueWithCGSize:s]];
			
		}
	}
	_sizeOfCategories = [NSArray arrayWithArray:buf];
}

/**
 * UICollectionViewを初期化する．
 **/
- (void)prepareCollectionView {
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
	[_collectionView registerClass:[AAKToolbarHistoryCell class] forCellWithReuseIdentifier:@"AAKToolbarHistoryCell"];
	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	
	[self addSubview:_collectionView];
}

/**
 * ツールバーボタンの大きさを調整するautolayoutを設定する．
 **/
- (void)setupAutolayout {
	_collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	_earthKey.translatesAutoresizingMaskIntoConstraints = NO;
	_deleteKey.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView, _earthKey, _deleteKey);
	
	_earthKeyWidthConstraint = [NSLayoutConstraint constraintWithItem:_earthKey
															attribute:NSLayoutAttributeWidth
															relatedBy:NSLayoutRelationEqual
															   toItem:nil
															attribute:NSLayoutAttributeNotAnAttribute
														   multiplier:1
															 constant:_height];
	[self addConstraint:_earthKeyWidthConstraint];
	_deleteKeyWidthConstraint = [NSLayoutConstraint constraintWithItem:_deleteKey
															 attribute:NSLayoutAttributeWidth
															 relatedBy:NSLayoutRelationEqual
																toItem:nil
															 attribute:NSLayoutAttributeNotAnAttribute
															multiplier:1
															  constant:_height];
	[self addConstraint:_deleteKeyWidthConstraint];
	
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[_earthKey]-0-[_collectionView(>=0)]-0-[_deleteKey]-(==0)-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_collectionView(>=0)]-(==0)-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_earthKey(>=0)]-(==0)-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_deleteKey(>=0)]-(==0)-|"
																 options:0 metrics:0 views:views]];
}

#pragma mark - IBAction

- (IBAction)pushEarthKey:(id)sender {
	[self.delegate toolbar:self didPushEarthButton:sender];
}

- (IBAction)pushDeleteKey:(id)sender {
	[self.delegate toolbar:self didPushDeleteButton:sender];
}

#pragma mark - Setter

- (void)setCurrentGroup:(AAKASCIIArtGroup *)currentGroup {
	_currentGroup = currentGroup;
	[self updateSelectedCell];
}

#pragma mark - AAKToolbarCellDelegate

- (void)didSelectToolbarCell:(AAKToolbarCell *)cell {
	_currentGroup = cell.group;
	[self updateSelectedCell];
	[self.delegate toolbar:self didSelectGroup:cell.group];
}

#pragma mark - Override

- (void)dealloc {
	[[NSUserDefaults standardUserDefaults] setInteger:_currentGroup.key forKey:@"groupKey"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		
		_groups = [[AAKKeyboardDataManager defaultManager] groups];
		
		NSInteger groupKey = [[NSUserDefaults standardUserDefaults] integerForKey:@"groupKey"];
		_currentGroup = [self groupForGroupKey:groupKey];
		
		self.backgroundColor = [UIColor redColor];
		_height = 48;
		_fontSize = 14;
		[self prepareButton];
		[self prepareCollectionView];
		[self setupAutolayout];
	}
	return self;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGSize size =  [[_sizeOfCategories objectAtIndex:indexPath.item] CGSizeValue];
	return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
	return [_groups count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AAKToolbarCell *cell = nil;
	AAKASCIIArtGroup *group = [_groups objectAtIndex:indexPath.item];
	
	if (group.type == AAKASCIIArtHistoryGroup) {
		cell = [cv dequeueReusableCellWithReuseIdentifier:@"AAKToolbarHistoryCell" forIndexPath:indexPath];
	}
	else {
		cell = [cv dequeueReusableCellWithReuseIdentifier:@"AAKToolbarCell" forIndexPath:indexPath];
	}
	
	cell.group = group;
	cell.delegate = self;
	[cell setOriginalHighlighted:(cell.group.key == _currentGroup.key)];
	cell.isHead = (indexPath.item == 0);
	
	return cell;
}

@end
