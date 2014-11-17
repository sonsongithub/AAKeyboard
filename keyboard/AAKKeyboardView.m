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

@interface AAKKeyboardView() <UICollectionViewDataSource, UICollectionViewDelegate, AAKToolbarDelegate> {
	AAKToolbar					*_toolbar;
	NSLayoutConstraint			*_toolbarHeightConstraint;
	UICollectionView			*_collectionView;
	UICollectionViewFlowLayout	*_collectionFlowLayout;
	NSArray						*_asciiarts;
	UIKeyboardAppearance		_keyboardAppearance;
}
@end

@implementation AAKKeyboardView

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
 * レイアウトをリロードして変更する．
 **/
- (void)load {
 	[_collectionFlowLayout invalidateLayout];
	[_toolbar layout];
}

/**
 * キーボードを縦のときに合わせる．
 * ツールバーの高さやフォントサイズを変更する．
 **/
- (void)setPortraitMode {
	_toolbarHeightConstraint.constant = 48;
	_toolbar.height = 48;
	_toolbar.fontSize = 14;
}

/**
 * キーボードを縦のときに合わせる．
 * ツールバーの高さやフォントサイズを変更する．
 **/
- (void)setLandscapeMode {
	_toolbarHeightConstraint.constant = 30;
	_toolbar.height = 30;
	_toolbar.fontSize = 12;
}

/**
 * グループ選択や切り替え，削除ボタンためのツールバーを初期化する．
 **/
- (void)prepareToolbar {
	_toolbar = [[AAKToolbar alloc] initWithFrame:CGRectZero keyboardAppearance:_keyboardAppearance];
	_toolbar.delegate = self;
	[self addSubview:_toolbar];
}

/**
 * UICollectionViewを初期化する．
 **/
- (void)prepareCollectionView {
	// collection flow layoutを設定
	_collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
	_collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	_collectionFlowLayout.minimumLineSpacing = 0;
	_collectionFlowLayout.minimumInteritemSpacing = 0;
	_collectionFlowLayout.itemSize = CGSizeMake(100, 140);
	_collectionFlowLayout.sectionInset = UIEdgeInsetsZero;
	
	// collection viewを生成，セットアップ
	_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionFlowLayout];
	_collectionView.alwaysBounceHorizontal = YES;
	_collectionView.showsHorizontalScrollIndicator = NO;
	_collectionView.backgroundColor = [self cellBackgroundColor];
	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	_collectionView.contentInset = UIEdgeInsetsMake(0, -2, 0, -2);	// 端の線を常に表示させないためにヘッダとフッターを隠す
	[self addSubview:_collectionView];
	
	// supplementary
	[_collectionView registerClass:[AAKContentCell class] forCellWithReuseIdentifier:@"AAKContentCell"];
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
 * ツールバーとアスキーアートのキービューの大きさを調整するautolayoutを設定する．
 **/
- (void)setupAutolayout {
	
	_toolbar.translatesAutoresizingMaskIntoConstraints = NO;
	_collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSDictionary *views = NSDictionaryOfVariableBindings(_toolbar, _collectionView);
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_toolbar]-0-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-[_toolbar]-0-|"
																 options:0 metrics:0 views:views]];
	_toolbarHeightConstraint = [NSLayoutConstraint constraintWithItem:_toolbar
															attribute:NSLayoutAttributeHeight
															relatedBy:NSLayoutRelationEqual
															   toItem:nil
															attribute:NSLayoutAttributeNotAnAttribute
														   multiplier:1
															 constant:48];
	[self addConstraint:_toolbarHeightConstraint];
}

/**
 * アスキーアートオブジェクトの配列を現在選択中のグループに従ってアップデートする．
 **/
- (void)updateASCIIArtsForCurrentGroup {
	if (_toolbar.currentGroup) {
		_asciiarts = [AAKASCIIArt MR_findAllWithPredicate:[NSPredicate predicateWithFormat: @"group == %@", _toolbar.currentGroup]];
	}
	else {
		NSFetchRequest *request = [AAKASCIIArt MR_requestAllSortedBy:@"lastUsedTime" ascending:NO];
		[request setFetchLimit:20];
		_asciiarts = [AAKASCIIArt MR_executeFetchRequest:request];
	}
}

/**
 * AAKKeyboardViewクラスを初期化する．
 * @param frame ビューのframeを指定する．
 * @param keyboardAppearance 表示中のキーボードのアピアランス．
 * @return 初期化されたAAKKeyboardViewオブジェクト．
 **/
- (instancetype)initWithFrame:(CGRect)frame keyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		_keyboardAppearance = keyboardAppearance;
		
		[self prepareToolbar];
		
		[self prepareCollectionView];
		
		[self setupAutolayout];
		
		[self updateASCIIArtsForCurrentGroup];
		
		[self updateConstraints];
	}
	return self;
}

#pragma mark - AAKToolbarDelegate

- (void)didSelectGroupToolbar:(AAKToolbar*)toolbar {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self updateASCIIArtsForCurrentGroup];
		[_collectionView reloadData];
	});
}

- (void)toolbar:(AAKToolbar*)toolbar didPushEarthButton:(UIButton*)button {
	[self.delegate keyboardViewDidPushEarthButton:self];
}

- (void)toolbar:(AAKToolbar*)toolbar didPushDeleteButton:(UIButton*)button {
	[self.delegate keyboardViewDidPushDeleteButton:self];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	DNSLogMethod
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	AAKASCIIArt *source = _asciiarts[indexPath.item];
//	[[AAKKeyboardDataManager defaultManager] insertHistoryASCIIArtKey:source.key];
	[self.delegate keyboardView:self willInsertString:source.text];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	AAKASCIIArt *source = _asciiarts[indexPath.item];
	CGFloat height = collectionView.frame.size.height;
	CGFloat width = height * source.ratio;
	CGFloat constraintWidth = self.frame.size.width * 0.75;
	if (width > constraintWidth) {
		width = constraintWidth;
	}
	return CGSizeMake(floor(width), floor(height));
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
	return [_asciiarts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
	AAKContentCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"AAKContentCell" forIndexPath:indexPath];
	cell.label.text = [NSString stringWithFormat:@"%ld", (long)indexPath.item];
	CGFloat fontSize = 15;
	AAKASCIIArt *source = _asciiarts[indexPath.item];
	
	cell.isTail = ((_asciiarts.count - 1) == indexPath.item);
	cell.keyboardAppearance = _keyboardAppearance;
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSForegroundColorAttributeName:[cell colorForAA], NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:source.text attributes:attributes];
	cell.textView.attributedString = string;
	[cell.label sizeToFit];
	return cell;
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	return CGSizeMake(2, _collectionView.frame.size.height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
	return CGSizeMake(2, _collectionView.frame.size.height);
}

@end
