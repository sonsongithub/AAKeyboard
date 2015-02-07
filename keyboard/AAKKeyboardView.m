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
#import "AAK10KeyView.h"

@interface AAKKeyboardView() <UICollectionViewDataSource, UICollectionViewDelegate, AAKToolbarDelegate> {
	AAKToolbar					*_toolbar;
	NSLayoutConstraint			*_toolbarHeightConstraint;
	UICollectionView			*_collectionView;
	UICollectionViewFlowLayout	*_collectionFlowLayout;
	NSArray						*_asciiarts;
	UIKeyboardAppearance		_keyboardAppearance;
	AAK10KeyView				*_numberKeyboardView;
}
@end

@implementation AAKKeyboardView

- (UIColor*)cellBackgroundColor {
	if (_keyboardAppearance == UIKeyboardAppearanceDark) {
		return [UIColor darkColorForDark];
	}
	else {
		return [UIColor colorWithRed:207.0/255.0f green:212.0/255.0f blue:216.0/255.0f alpha:1];
	}
}

#pragma mark - Instance method

/**
 * レイアウトをリロードして変更する．
 **/
- (void)load {
 	[_collectionFlowLayout invalidateLayout];
	[_toolbar layout];
	
	CGFloat w = (self.superview.frame.size.width > 480) ? 480 : self.superview.frame.size.width;
	[_numberKeyboardView setWidth:w];
}

/**
 * キーボードのツールバーの高さやフォントサイズを変更する．
 * @param toolbarHeight ツールバーの高さ．
 * @param fontSize ツールバーのタイトルのフォントサイズ．
 **/
- (void)setToolbarHeight:(CGFloat)toolbarHeight fontSize:(CGFloat)fontSize {
	_toolbarHeightConstraint.constant = toolbarHeight;
	_toolbar.height = toolbarHeight;
	_toolbar.fontSize = fontSize;
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
	_collectionView.contentInset = UIEdgeInsetsMake(0, -8, 0, -8);	// 端の線を常に表示させないためにヘッダとフッターを隠す
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
	
	_numberKeyboardView = [AAK10KeyView viewFromNib];
	_numberKeyboardView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
	[self addSubview:_numberKeyboardView];
	
	_numberKeyboardView.hidden = YES;
}

/**
 * ツールバーとアスキーアートのキービューの大きさを調整するautolayoutを設定する．
 **/
- (void)setupAutolayout {
	
	_toolbar.translatesAutoresizingMaskIntoConstraints = NO;
	_collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	_numberKeyboardView.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSDictionary *views = NSDictionaryOfVariableBindings(_toolbar, _collectionView, _numberKeyboardView);
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_toolbar]-0-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-[_toolbar]-0-|"
																 options:0 metrics:0 views:views]];
	
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_numberKeyboardView]-0-|"
																 options:0 metrics:0 views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_numberKeyboardView]-0-[_toolbar]-0-|"
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
	if (_toolbar.currentGroup.type == AAKASCIIArtHistoryGroup) {
		NSFetchRequest *request = [AAKASCIIArt MR_requestAllSortedBy:@"lastUsedTime" ascending:NO];
		[request setFetchLimit:20];
		_asciiarts = [AAKASCIIArt MR_executeFetchRequest:request];
	}
	else if ([_toolbar.currentGroup.title isEqualToString:@"0-9"]) {
		_asciiarts = [AAKASCIIArt MR_findAllSortedBy:@"text" ascending:YES withPredicate:[NSPredicate predicateWithFormat: @"group == %@", _toolbar.currentGroup]];
	}
	else {
		_asciiarts = [AAKASCIIArt MR_findAllSortedBy:@"lastUsedTime" ascending:NO withPredicate:[NSPredicate predicateWithFormat: @"group == %@", _toolbar.currentGroup]];
	}
}

/**
 * AAのセルのサイズを計算する．
 **/
- (void)arrangeAsciiArtCells {
	NSInteger columns = (_asciiarts.count - 1) / _numberOfRow + 1;
	
	CGFloat constraintWidth = self.frame.size.width * 0.5;

	for (int i = 0; i < columns; i++) {
		if ( i < columns - 1) {
			//
			CGFloat height = floor(_collectionView.frame.size.height / _numberOfRow);
			CGFloat maxWidth = 0;
			CGFloat heightSum = 0;
			for (int j = 0; j < _numberOfRow; j++) {
				AAKASCIIArt *asciiart = _asciiarts[_numberOfRow * i + j];
				CGFloat width = height * asciiart.ratio;
				if (width > constraintWidth)
					width = constraintWidth;
				if (width > maxWidth)
					maxWidth = width;
				heightSum += height;
			}
			for (int j = 0; j < _numberOfRow; j++) {
				AAKASCIIArt *asciiart = _asciiarts[_numberOfRow * i + j];
				if (j == 0)
					asciiart.contentSize = CGSizeMake(maxWidth, height + (_collectionView.frame.size.height - heightSum));
				else
					asciiart.contentSize = CGSizeMake(maxWidth, height);
			}
		}
		else {
			// 最終列
			NSInteger remained = (_asciiarts.count % _numberOfRow == 0) ? _numberOfRow : (_asciiarts.count % _numberOfRow);
			CGFloat height = floor(_collectionView.frame.size.height / remained);
			CGFloat maxWidth = 0;
			CGFloat heightSum = 0;
			for (int j = 0; j < remained; j++) {
				AAKASCIIArt *asciiart = _asciiarts[_numberOfRow * i + j];
				CGFloat width = height * asciiart.ratio;
				if (width > constraintWidth)
					width = constraintWidth;
				if (width > maxWidth)
					maxWidth = width;
				heightSum += height;
			}
			for (int j = 0; j < remained; j++) {
				AAKASCIIArt *asciiart = _asciiarts[_numberOfRow * i + j];
				if (j == 0)
					asciiart.contentSize = CGSizeMake(maxWidth, height + (_collectionView.frame.size.height - heightSum));
				else
					asciiart.contentSize = CGSizeMake(maxWidth, height);
			}
		}
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
		_numberOfRow = 1;
		
		self.backgroundColor = [UIColor clearColor];
		_keyboardAppearance = keyboardAppearance;
		
		[self prepareToolbar];
		
		[self prepareCollectionView];
		
		[self setupAutolayout];
		
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

- (void)toolbar:(AAKToolbar*)toolbar didPushNumberButton:(UIButton*)button {
	_numberKeyboardView.hidden = !_numberKeyboardView.hidden;
	_collectionView.hidden = !_numberKeyboardView.hidden;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	DNSLogMethod
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	AAKASCIIArt *source = _asciiarts[indexPath.item];
	[source updateLastUsedTime];
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
	[self.delegate keyboardView:self willInsertString:source.text];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	AAKASCIIArt *asciiart = _asciiarts[indexPath.item];
	return asciiart.contentSize;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
	if (view.frame.size.width > 0) {
		[self arrangeAsciiArtCells];
	}
	return [_asciiarts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
	AAKContentCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"AAKContentCell" forIndexPath:indexPath];
	cell.label.text = [NSString stringWithFormat:@"%ld", (long)indexPath.item];
	CGFloat fontSize = 15;
	AAKASCIIArt *source = _asciiarts[indexPath.item];
	
	cell.isTail = (indexPath.item/_numberOfRow == ((_asciiarts.count - 1)/_numberOfRow));
	
	if (_numberOfRow > 1)
		cell.isTop = (indexPath.item % _numberOfRow == 0);
	
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
	return CGSizeMake(8, _collectionView.frame.size.height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
	return CGSizeMake(8, _collectionView.frame.size.height);
}

@end
