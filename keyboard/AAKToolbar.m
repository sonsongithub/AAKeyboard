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
#import "AAKASCIIArtDummyHistoryGroup.h"

#import "UIColor+keyboard.h"
#import "UIImage+keyboard.h"

typedef enum AAKToolbarButtonStatus_ {
	AAKToolbarNumberButtonStatus	= 0,
	AAKToolbarASCIIArtButtonStatus	= 1,
}AAKToolbarButtonStatus;

@interface AAKToolbar() <UICollectionViewDataSource, UICollectionViewDelegate, AAKToolbarCellDelegate> {
	UICollectionView			*_collectionView;
	UICollectionViewFlowLayout	*_collectionFlowLayout;
	NSArray						*_sizeOfCategories;
	UIButton					*_earthKey;
	UIButton					*_deleteKey;
	UIButton					*_numberKey;
	NSArray						*_groups;
	NSLayoutConstraint			*_earthKeyWidthConstraint;
	NSLayoutConstraint			*_deleteKeyWidthConstraint;
	NSLayoutConstraint			*_numberKeyWidthConstraint;
	UIKeyboardAppearance		_keyboardAppearance;
	AAKToolbarButtonStatus		_status;
}
@end

@implementation AAKToolbar

- (UIColor*)buttonBackgroundColor {
	if (_keyboardAppearance == UIKeyboardAppearanceDark) {
		return [UIColor darkColorForDark];
	}
	else {
		return [UIColor darkColorForDefault];
	}
}

- (UIColor*)buttonHighlightedBackgroundColor {
	if (_keyboardAppearance == UIKeyboardAppearanceDark) {
		return [UIColor lightColorForDark];
	}
	else {
		return [UIColor lightColorForDefault];
	}
}

- (UIColor*)cellBackgroundColor {
	if (_keyboardAppearance == UIKeyboardAppearanceDark) {
		return [UIColor darkColorForDark];
	}
	else {
		return [UIColor lightColorForDefault];
	}
}

#pragma mark - Instance method

/**
 * ツールバーの選択状態になっているセルを更新する．
 * reloadDataだと色々問題が発生するため．
 **/
- (void)updateSelectedCell {
	for (AAKToolbarCell *cell in [_collectionView visibleCells]) {
		[cell setOriginalHighlighted:(cell.group == _currentGroup)];
	}
}

/**
 * 両サイドのボタンを押下したときに，そのボタンの背景色を反転させる．
 * @param sender
 **/
- (void)buttonHighlight:(UIButton*)sender {
	// 両脇のボタンはハイライトと通常の色が逆
	sender.backgroundColor = [self buttonHighlightedBackgroundColor];
}

/**
 * 両サイドのボタンを押下したときに，そのボタンの背景色を反転させる．
 * @param sender
 **/
- (void)buttonStopHighlight:(UIButton*)sender {
	// 両脇のボタンはハイライトと通常の色が逆
	sender.backgroundColor = [self buttonBackgroundColor];
}

/**
 * 両脇のボタンを初期化，配置する．
 **/
- (void)prepareButton {
	_earthKey = [self parepareEachButtonWithImageName:@"global" directionIsRight:YES action:@selector(pushEarthKey:)];
	_numberKey = [self parepareEachButtonWithImageName:@"numberKey" directionIsRight:YES action:@selector(pushNumberKey:)];
	_deleteKey = [self parepareEachButtonWithImageName:@"delete" directionIsRight:NO action:@selector(pushDeleteKey:)];
	[self addSubview:_numberKey];
	[self addSubview:_earthKey];
	[self addSubview:_deleteKey];
}

- (UIButton*)parepareEachButtonWithImageName:(NSString*)imageName directionIsRight:(BOOL)isRight action:(SEL)action {
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	[self attachActionToButton:button];
	[self setEdgeBackgroundImageToButton:button directionIsRight:isRight];
	[self setButtonIconTo:button imageName:imageName];
	return button;
}

- (void)attachActionToButton:(UIButton*)button {
	[button addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
	[button addTarget:self action:@selector(buttonStopHighlight:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setEdgeBackgroundImageToButton:(UIButton*)button directionIsRight:(BOOL)isRight {
	button.backgroundColor = [self buttonBackgroundColor];
	if (isRight) {
		UIImage *temp = [UIImage rightEdgeWithKeyboardAppearance:_keyboardAppearance];
		[button setBackgroundImage:temp forState:UIControlStateNormal];
		[button setBackgroundImage:temp forState:UIControlStateHighlighted];
	}
	else {
		UIImage *temp = [UIImage leftEdgeWithKeyboardAppearance:_keyboardAppearance];
		[button setBackgroundImage:temp forState:UIControlStateNormal];
		[button setBackgroundImage:temp forState:UIControlStateHighlighted];
	}
}

- (void)setButtonIconTo:(UIButton*)button imageName:(NSString*)imageName {
	NSString *name = nil;
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		if (_keyboardAppearance == UIKeyboardAppearanceDark)
			name = [NSString stringWithFormat:@"h%@HD", imageName];
		else
			name = [NSString stringWithFormat:@"%@HD", imageName];
	}
	else {
		if (_keyboardAppearance == UIKeyboardAppearanceDark)
			name = [NSString stringWithFormat:@"h%@", imageName];
		else
			name = [NSString stringWithFormat:@"%@", imageName];
	}
	[button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:name] forState:UIControlStateHighlighted];
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
	// flow layout
	_collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	_collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	_collectionFlowLayout.minimumLineSpacing = 0;
	_collectionFlowLayout.minimumInteritemSpacing = 0;
	_collectionFlowLayout.sectionInset = UIEdgeInsetsZero;
	
	// collection view
	_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionFlowLayout];
	_collectionView.alwaysBounceHorizontal = YES;
	_collectionView.showsHorizontalScrollIndicator = NO;
	_collectionView.backgroundColor = [self cellBackgroundColor];
	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	_collectionView.contentInset = UIEdgeInsetsMake(0, -8, 0, -8);	// 端の線を常に表示させないためにヘッダとフッターを隠す
	[self addSubview:_collectionView];
	
	// supplementary resources
	[_collectionView registerClass:[AAKToolbarCell class] forCellWithReuseIdentifier:@"AAKToolbarCell"];
	[_collectionView registerClass:[AAKToolbarHistoryCell class] forCellWithReuseIdentifier:@"AAKToolbarHistoryCell"];
	{
		UINib *nib = [UINib nibWithNibName:@"AAKToolbarHeaderView" bundle:nil];
		[_collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AAKToolbarHeaderView"];
	}
	{
		UINib *nib = [UINib nibWithNibName:@"AAKToolbarFooterView" bundle:nil];
		[_collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"AAKToolbarFooterView"];
	}
}

/**
 * ツールバーの上の枠線をセットアップする．
 **/
- (void)setupTopBorderLine {
	UIImageView *topBar = [[UIImageView alloc] initWithImage:[UIImage topEdgeWithKeyboardAppearance:_keyboardAppearance]];
	NSDictionary *views = NSDictionaryOfVariableBindings(topBar);
	topBar.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:topBar];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[topBar(==8)]-(>=0)-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[topBar(>=0)]-(==0)-|"
																 options:0 metrics:0 views:views]];
}

/**
 * ツールバーボタンの大きさを調整するautolayoutを設定する．
 **/
- (void)setupAutolayout {
	_collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	_earthKey.translatesAutoresizingMaskIntoConstraints = NO;
	_deleteKey.translatesAutoresizingMaskIntoConstraints = NO;
	_numberKey.translatesAutoresizingMaskIntoConstraints = NO;

	NSDictionary *views = NSDictionaryOfVariableBindings(_collectionView, _earthKey, _deleteKey, _numberKey);
	
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
	_numberKeyWidthConstraint = [NSLayoutConstraint constraintWithItem:_numberKey
															 attribute:NSLayoutAttributeWidth
															 relatedBy:NSLayoutRelationEqual
																toItem:nil
															 attribute:NSLayoutAttributeNotAnAttribute
															multiplier:1
															  constant:_height];
	[self addConstraint:_numberKeyWidthConstraint];
	
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[_earthKey]-0-[_numberKey]-0-[_collectionView(>=0)]-0-[_deleteKey]-(==0)-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_collectionView(>=0)]-(==0)-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_earthKey(>=0)]-(==0)-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_numberKey(>=0)]-(==0)-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_deleteKey(>=0)]-(==0)-|"
																 options:0 metrics:0 views:views]];
}

/**
 * AAKToolbarクラスを初期化する．
 * @param frame ビューのframeを指定する．
 * @param keyboardAppearance 表示中のキーボードのアピアランス．
 * @return 初期化されたAAKToolbarオブジェクト．
 **/
- (instancetype)initWithFrame:(CGRect)frame keyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
	self = [super initWithFrame:frame];
	if (self) {
		_keyboardAppearance = keyboardAppearance;
		
		self.backgroundColor = [UIColor clearColor];
		
		NSMutableArray *temp = [NSMutableArray array];
		NSArray *allgroups = [AAKASCIIArtGroup MR_findAllSortedBy:@"order" ascending:YES];
		
		
		[temp addObject:[AAKASCIIArtDummyHistoryGroup historyGroup]];
		
		for (AAKASCIIArtGroup *group in allgroups) {
			if ([AAKASCIIArt MR_countOfEntitiesWithPredicate:[NSPredicate predicateWithFormat:@"group == %@", group]]) {
				[temp addObject:group];
			}
		}
		
		_groups = [NSArray arrayWithArray:temp];
		
		[self updateWithWidth:100];
		
		
		_currentGroup = _groups[0];
		
		NSString *saveID = [[NSUserDefaults standardUserDefaults] objectForKey:@"groupKey"];
		for (AAKASCIIArtGroup *group in _groups) {
			if ([group respondsToSelector:@selector(objectID)]) {
				if ([group.objectID.URIRepresentation.absoluteString isEqualToString:saveID]) {
					_currentGroup = group;
					break;
				}
			}
		}
		
		_height = 48;		// dummyの初期値
		_fontSize = 14;		// dummyの初期値
		
		[self prepareButton];
		[self prepareCollectionView];
		[self setupAutolayout];
		[self setupTopBorderLine];
	}
	return self;
}

#pragma mark - IBAction

- (IBAction)pushEarthKey:(UIButton*)sender {
	sender.backgroundColor = [self buttonBackgroundColor];
	[self.delegate toolbar:self didPushEarthButton:sender];
}

- (IBAction)pushDeleteKey:(UIButton*)sender {
	sender.backgroundColor = [self buttonBackgroundColor];
	[self.delegate toolbar:self didPushDeleteButton:sender];
}

- (IBAction)pushNumberKey:(UIButton*)sender {
	sender.backgroundColor = [self buttonBackgroundColor];
	[self.delegate toolbar:self didPushNumberButton:sender];
	if (_status == AAKToolbarASCIIArtButtonStatus) {
		[self setButtonIconTo:_numberKey imageName:@"numberKey"];
		_status = AAKToolbarNumberButtonStatus;
	}
	else {
		[self setButtonIconTo:_numberKey imageName:@"asciiart"];
		_status = AAKToolbarASCIIArtButtonStatus;
	}
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
	[self.delegate didSelectGroupToolbar:self];
	[self setButtonIconTo:_numberKey imageName:@"numberKey"];
	_status = AAKToolbarNumberButtonStatus;
}

#pragma mark - Override

- (void)dealloc {
	if ([_currentGroup respondsToSelector:@selector(objectID)]) {
		[[NSUserDefaults standardUserDefaults] setObject:_currentGroup.objectID.URIRepresentation.absoluteString forKey:@"groupKey"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"groupKey"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
		   viewForSupplementaryElementOfKind:(NSString *)kind
								 atIndexPath:(NSIndexPath *)indexPath {
	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		AAKToolbarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
																				withReuseIdentifier:@"AAKToolbarHeaderView"
																					 forIndexPath:indexPath];
		headerView.keyboardAppearance = _keyboardAppearance;
		return headerView;
	}
	else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
		AAKToolbarFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
																			  withReuseIdentifier:@"AAKToolbarFooterView"
																					 forIndexPath:indexPath];
		footerView.keyboardAppearance = _keyboardAppearance;
		return footerView;
	}
	else {
		return nil;
	}
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
	cell.keyboardAppearance = _keyboardAppearance;
	cell.delegate = self;
	[cell setOriginalHighlighted:(cell.group == _currentGroup)];
	cell.isTail = (indexPath.item == ([_groups count] - 1));
	
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	return CGSizeMake(8, _height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
	return CGSizeMake(8, _height);
}

@end
