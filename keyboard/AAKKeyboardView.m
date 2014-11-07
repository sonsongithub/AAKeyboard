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

#import "AAKShared.h"

@interface AAKKeyboardView() <UICollectionViewDataSource, UICollectionViewDelegate, AAKToolbarDelegate> {
	AAKToolbar					*_toolbar;
	NSLayoutConstraint			*_toolbarHeightConstraint;
	UICollectionView			*_collectionView;
	UICollectionViewFlowLayout	*_collectionFlowLayout;
	NSArray						*_asciiarts;
	AAKASCIIArtGroup			*_currentGroup;
	NSArray						*_groups;
}
@end

@implementation AAKKeyboardView

- (void)dealloc {
	[[NSUserDefaults standardUserDefaults] setInteger:_currentGroup.key forKey:@"groupKey"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

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
	_toolbar = [[AAKToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
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
	_collectionView.backgroundColor = [UIColor colorWithRed:254.0/255.0f green:254.0/255.0f blue:254.0/255.0f alpha:1];
	_collectionView.backgroundColor = [UIColor clearColor];
	[_collectionView registerClass:[AAKContentCell class] forCellWithReuseIdentifier:@"AAKContentCell"];
	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	[self addSubview:_collectionView];
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

- (AAKASCIIArtGroup*)groupForGroupKey:(NSInteger)key {
	for (AAKASCIIArtGroup *group in _groups) {
		if (group.key == key)
			return group;
	}
	return [AAKASCIIArtGroup defaultGroup];
}

- (void)updateASCIIArtsForCurrentGroup {
	for (AAKASCIIArtGroup *group in _groups) {
		if (_currentGroup.key == group.key) {
			_asciiarts = [[AAKKeyboardDataManager defaultManager] asciiArtForGroup:group];
			return;
		}
	}
	_currentGroup = [AAKASCIIArtGroup defaultGroup];
	_asciiarts = [[AAKKeyboardDataManager defaultManager] asciiArtForGroup:_currentGroup];
}

#pragma mark - Override

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self prepareToolbar];
		
		[self prepareCollectionView];
		
		[self setupAutolayout];
		
		_groups = [[AAKKeyboardDataManager defaultManager] groups];
		NSMutableArray *array = [NSMutableArray arrayWithArray:@[[AAKASCIIArtGroup historyGroup]]];
		[array addObjectsFromArray:_groups];
		[_toolbar setGroups:array];
		
		NSInteger groupKey = [[NSUserDefaults standardUserDefaults] integerForKey:@"groupKey"];
		_currentGroup = [self groupForGroupKey:groupKey];
		
		[self updateASCIIArtsForCurrentGroup];
		
		[_toolbar setCurrentGroup:_currentGroup];
		
		[self updateConstraints];
	}
	return self;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	DNSLogMethod
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	AAKASCIIArt *source = _asciiarts[indexPath.item];
	[[AAKKeyboardDataManager defaultManager] insertHistoryASCIIArtKey:source.key];
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
	return CGSizeMake(width, height);
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
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:source.text attributes:attributes];
	cell.textView.attributedString = string;
	[cell.label sizeToFit];
	return cell;
}

#pragma mark - AAKToolbarDelegate

- (void)toolbar:(AAKToolbar*)toolbar didSelectGroup:(AAKASCIIArtGroup*)group {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		_currentGroup = group;
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

@end
