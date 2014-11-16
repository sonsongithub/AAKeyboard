//
//  AAKAACollectionViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/23.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKAACollectionViewController.h"

#import "AAKAACollectionViewCell.h"
#import "AAKAASupplementaryView.h"
#import "AAKAAEditPresentationController.h"
#import "AAKAAEditAnimatedTransitioning.h"
#import "AAKAACollectionViewCell.h"
#import "AAKPreviewController.h"

@interface AAKAACollectionViewController () <AAKAACollectionViewCellDelegate, UIViewControllerTransitioningDelegate> {
	NSArray *_groups;	/** AAKAAGroupForCollectionオブジェクトの配列 */
}
@end

@implementation AAKAACollectionViewController

static NSString * const reuseIdentifier = @"Cell";

/**
 * 指定されたアスキーアートを含むセルを返す．
 * 見つからない場合は，nilを返す．
 * @param asciiart アスキーアートオブジェクト．
 * @return アスキーアートオブジェクトを保持するAAKAACollectionViewCellインスタンスを返す．
 **/
- (id)cellForAsciiArt:(_AAKASCIIArt*)asciiart {
	NSIndexPath *indexPath = [self indexPathForAsciiArt:asciiart];
	return [self.collectionView cellForItemAtIndexPath:indexPath];
}

/**
 * 指定されたアスキーアートを含むセルのパスを返す．
 * 見つからない場合は，nilを返す．
 * @param asciiart アスキーアートオブジェクト．
 * @return アスキーアートオブジェクトを保持するAAKAACollectionViewCellが持つはずであるNSIndexPathオブジェクト．
 **/
- (NSIndexPath*)indexPathForAsciiArt:(_AAKASCIIArt*)asciiart {
	for (int i = 0; i < [_groups count]; i++) {
		AAKAAGroupForCollection *collection = _groups[i];
		for (int j = 0; j < [collection.asciiarts count]; j++) {
			_AAKASCIIArt *art = collection.asciiarts[j];
			if (art.key == asciiart.key)
				return [NSIndexPath indexPathForItem:j inSection:i];
		}
	}
	return nil;
}

/**
 * AAKAAGroupForCollectionオブジェクトの配列ですべてのアスキーアートを列挙し，_groupsに保存する．
 **/
- (void)updateCollections {
	NSArray *temp = [[AAKKeyboardDataManager defaultManager] allGroups];
	NSMutableArray *buf = [NSMutableArray arrayWithCapacity:[temp count]];
	for (_AAKASCIIArtGroup *group in temp) {
		NSArray *asciiarts = [[AAKKeyboardDataManager defaultManager] asciiArtForGroup:group];
		AAKAAGroupForCollection *collection = [AAKAAGroupForCollection groupForCollectionWithGroup:group asciiarts:asciiarts];
		[buf addObject:collection];
	}
	_groups = [NSArray arrayWithArray:buf];
}

#pragma mark - Notification

/**
 * データベースが更新されるタイミングでビューを再ロードする．
 * @param notifiation 通知オブジェクト．
 **/
- (void)didUpdateDatabaseNotification:(NSNotification*)notification {
	[self updateCollections];
	[self.collectionView reloadData];
	
}

/**
 * アプリケーションがフォアグラウンドに来る直前に来る通知．
 * このタイミングでビューを再ロードする．
 * @param notifiation 通知オブジェクト．
 **/
- (void)applicationWillEnterForegroundNotification:(NSNotification*)notification {
	[self updateCollections];
	[self.collectionView reloadData];
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateDatabaseNotification:) name:AAKKeyboardDataManagerDidUpdateNotification object:nil];
	
    // Register cell and supplemental classes to collection view
	UINib *cellNib = [UINib nibWithNibName:@"AAKAACollectionViewCell" bundle:nil];
	[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
	UINib *nib = [UINib nibWithNibName:@"AAKAASupplementaryView" bundle:nil];
	[self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AAKAASupplementaryView"];
	
	[self updateCollections];
}

#pragma mark - UIViewControllerTransitionDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
													  presentingViewController:(UIViewController *)presenting
														  sourceViewController:(UIViewController *)source {
	return [[AAKAAEditPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
																  presentingController:(UIViewController *)presenting
																	  sourceController:(UIViewController *)source {
	return [[AAKAAEditAnimatedTransitioning alloc] initWithPresentFlag:NO];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	return [[AAKAAEditAnimatedTransitioning alloc] initWithPresentFlag:YES];
}

#pragma mark - AAKAACollectionViewCellDelegate

/**
 * セルを選択したときに呼び出されるメソッド．
 * セルをタップした後はプレビューを拡大する．
 * @param cell メソッドをコールしたAAKAACollectionViewCellオブジェクト．
 **/
- (void)didSelectCell:(AAKAACollectionViewCell*)cell {
	AAKPreviewController *con = (AAKPreviewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AAKPreviewController"];
	con.asciiart = cell.asciiart;
	con.modalPresentationStyle = UIModalPresentationCustom;
	con.transitioningDelegate = self;
	
	[self presentViewController:con animated:YES completion:nil];
}

/**
 * セルの複製ボタンを押したときに呼び出されるメソッド．
 * @param cell メソッドをコールしたAAKAACollectionViewCellオブジェクト．
 **/
- (void)didPushDuplicateButtonOnCell:(AAKAACollectionViewCell*)cell {
	_AAKASCIIArt *obj = cell.asciiart;
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
	[[AAKKeyboardDataManager defaultManager] duplicateASCIIArt:obj.key];
	[self.collectionView performBatchUpdates:^(void){
		[self updateCollections];
		[self.collectionView insertItemsAtIndexPaths:@[indexPath]];
	} completion:^(BOOL finished) {
		[self.collectionView reloadData];
	}];
}

/**
 * セルの削除ボタンを押したときに呼び出されるメソッド．
 * @param cell メソッドをコールしたAAKAACollectionViewCellオブジェクト．
 **/
- (void)didPushDeleteButtonOnCell:(AAKAACollectionViewCell*)cell {
	_AAKASCIIArt *obj = cell.asciiart;
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
	[[AAKKeyboardDataManager defaultManager] deleteASCIIArt:obj];
	[self.collectionView performBatchUpdates:^(void){
		
		[self updateCollections];
		
		[self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
	} completion:^(BOOL finished) {
		[self.collectionView reloadData];
	}];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return [_groups count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	AAKAAGroupForCollection *collection = _groups[section];
    return collection.asciiarts.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
		  viewForSupplementaryElementOfKind:(NSString *)kind
								atIndexPath:(NSIndexPath *)indexPath {
	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		AAKAAGroupForCollection *collection = _groups[indexPath.section];
		if ([collection.asciiarts count] > 0) {
			AAKAASupplementaryView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
																					withReuseIdentifier:@"AAKAASupplementaryView"
																						   forIndexPath:indexPath];
//			headerView.label.text = collection.group.title;
			return headerView;
		}
		return nil;
	}
	else {
		return nil;
	}
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AAKAACollectionViewCell *cell = (AAKAACollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    // Configure the cell
	
	AAKAAGroupForCollection *collection = _groups[indexPath.section];
	_AAKASCIIArt *source = collection.asciiarts[indexPath.item];
	CGFloat fontSize = 15;
	
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:source.text attributes:attributes];
	cell.textView.attributedString = string;
	cell.asciiart = source;
	cell.delegate = self;
	cell.debugLabel.text = [NSString stringWithFormat:@"%ld", (long)source.key];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	AAKAAGroupForCollection *collection = _groups[section];
	if ([collection.asciiarts count] > 0) {
		return CGSizeMake(320, 44);
	}
	return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat width = self.collectionView.frame.size.width / 2;
	CGFloat height = width;
	return CGSizeMake(width, height);
}

@end
