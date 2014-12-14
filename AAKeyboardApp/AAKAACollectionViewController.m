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

@interface AAKAACollectionViewController () <AAKAACollectionViewCellDelegate, UIViewControllerTransitioningDelegate, UIPopoverPresentationControllerDelegate> {
	NSArray *_groups;	/** AAKAAGroupForCollectionオブジェクトの配列 */
}
@end

@implementation AAKAACollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (IBAction)close:(UIStoryboardSegue*)segue {
}

- (IBAction)editGroup:(id)sender {
	[self performSegueWithIdentifier:@"OpenAAKSelectGroupViewController" sender:nil];
}

- (IBAction)registerNewAA:(id)sender {
	UINavigationController *nav = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AAKRegisterNavigationController"];
	[self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)openCloud:(id)sender {
}

- (IBAction)openGroupEditViewController:(id)sender {
	UINavigationController *nav = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"GroupEditNavigationController"];
	
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		nav.modalPresentationStyle = UIModalPresentationPopover;
		nav.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
		nav.popoverPresentationController.barButtonItem = sender;
		nav.popoverPresentationController.delegate = self;
		[self presentViewController:nav animated:YES completion:nil];
	}
	else {
		nav.modalPresentationStyle = UIModalPresentationCurrentContext;
		[self presentViewController:nav animated:YES completion:nil];
	}
}

- (IBAction)openSettingViewController:(id)sender {
	[self performSegueWithIdentifier:@"OpenSettingNavigationController" sender:nil];
}

/**
 * 指定されたアスキーアートを含むセルを返す．
 * 見つからない場合は，nilを返す．
 * @param asciiart アスキーアートオブジェクト．
 * @return アスキーアートオブジェクトを保持するAAKAACollectionViewCellインスタンスを返す．
 **/
- (id)cellForAsciiArt:(AAKASCIIArt*)asciiart {
	NSIndexPath *indexPath = [self indexPathForAsciiArt:asciiart];
	return [self.collectionView cellForItemAtIndexPath:indexPath];
}

/**
 * 指定されたアスキーアートを含むセルのパスを返す．
 * 見つからない場合は，nilを返す．
 * @param asciiart アスキーアートオブジェクト．
 * @return アスキーアートオブジェクトを保持するAAKAACollectionViewCellが持つはずであるNSIndexPathオブジェクト．
 **/
- (NSIndexPath*)indexPathForAsciiArt:(AAKASCIIArt*)asciiart {
	for (int i = 0; i < [_groups count]; i++) {
		AAKAAGroupForCollection *collection = _groups[i];
		for (int j = 0; j < [collection.asciiarts count]; j++) {
			AAKASCIIArt *art = collection.asciiarts[j];
			if (art == asciiart)
				return [NSIndexPath indexPathForItem:j inSection:i];
		}
	}
	return nil;
}

/**
 * AAKAAGroupForCollectionオブジェクトの配列ですべてのアスキーアートを列挙し，_groupsに保存する．
 **/
- (void)updateCollections {
	NSArray *temp = [AAKASCIIArtGroup MR_findAllSortedBy:@"order" ascending:YES];
	NSMutableArray *buf = [NSMutableArray arrayWithCapacity:[temp count]];
	for (AAKASCIIArtGroup *group in temp) {
		NSArray *asciiarts = [AAKASCIIArt MR_findAllSortedBy:@"lastUsedTime" ascending:NO withPredicate:[NSPredicate predicateWithFormat: @"group == %@", group]];
		AAKAAGroupForCollection *collection = [AAKAAGroupForCollection groupForCollectionWithGroup:group asciiarts:asciiarts];
		[buf addObject:collection];
	}
	_groups = [NSArray arrayWithArray:buf];
}

/**
 * LaunchScreenのスプラッシュをフェードアウトするためのビューを貼り付ける
 **/
- (void)showSplashView {
	UINib *nib = [UINib nibWithNibName:@"LaunchScreen" bundle:nil];
	UIView *view = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
	[self.navigationController.view addSubview:view];
	view.frame = view.superview.bounds;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:0.3 animations:^{
			view.alpha = 0;
		} completion:^(BOOL finished) {
			[view removeFromSuperview];
		}];
	});
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
	
	// navigation bar buttons
	UIBarButtonItem *list = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openGroupEditViewController:)];
	UIBarButtonItem *gear = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gear.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openSettingViewController:)];
	self.navigationController.navigationBar.topItem.rightBarButtonItems = @[gear, list];
	
	// データをCoreDataからフェッチ
	[self updateCollections];
	
	// スプラッシュ用のビューを貼り付ける
	[self showSplashView];
}

#pragma mark -

- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController {
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
	return YES;
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController
		  willRepositionPopoverToRect:(inout CGRect *)rect
							   inView:(inout UIView **)view {
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
	UINavigationController *nav = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AAKPreviewNavigationController"];
	AAKPreviewController *con = (AAKPreviewController*)nav.topViewController;
	con.asciiart = cell.asciiart;
	
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		nav.modalPresentationStyle = UIModalPresentationPopover;
		nav.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
		nav.popoverPresentationController.sourceRect = [self.view convertRect:cell.frame fromView:cell.superview];
		nav.popoverPresentationController.sourceView = self.view;
		nav.popoverPresentationController.delegate = self;
		[self presentViewController:nav animated:YES completion:nil];
	}
	else {
		nav.modalPresentationStyle = UIModalPresentationCustom;
		nav.transitioningDelegate = self;
		[self presentViewController:nav animated:YES completion:nil];
	}
	
}

/**
 * セルの複製ボタンを押したときに呼び出されるメソッド．
 * @param cell メソッドをコールしたAAKAACollectionViewCellオブジェクト．
 **/
- (void)didPushDuplicateButtonOnCell:(AAKAACollectionViewCell*)cell {
	AAKASCIIArt *obj = cell.asciiart;
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
	
	AAKASCIIArt *newASCIIArt = [AAKASCIIArt MR_createEntity];
	newASCIIArt.text = obj.text;
	newASCIIArt.group = obj.group;
	newASCIIArt.lastUsedTime = obj.lastUsedTime;
	[newASCIIArt updateRatio];
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
	
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
	AAKASCIIArt *obj = cell.asciiart;
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
	
	[obj MR_deleteEntity];
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
	
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
			headerView.label.text = collection.group.title;
			[headerView.groupAddButton addTarget:self action:@selector(registerNewAA:) forControlEvents:UIControlEventTouchUpInside];
			[headerView.cloudAddButton addTarget:self action:@selector(openCloud:) forControlEvents:UIControlEventTouchUpInside];
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
	AAKASCIIArt *source = collection.asciiarts[indexPath.item];
	CGFloat fontSize = 15;
	
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:source.text attributes:attributes];
	cell.textView.attributedString = string;
	cell.asciiart = source;
	cell.delegate = self;
	cell.debugLabel.text = [NSString stringWithFormat:@"%@", source.objectID];
	
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
		return CGSizeMake(320, 50);
	}
	return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular && self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
		if (collectionView.frame.size.width > collectionView.frame.size.height) {
			CGFloat width = self.collectionView.frame.size.width / 6;
			CGFloat height = 120;
			return CGSizeMake(width, height);
		}
		else {
			CGFloat width = self.collectionView.frame.size.width / 4;
			CGFloat height = 120;
			return CGSizeMake(width, height);
		}
	}
	else {
	}
	CGFloat width = self.collectionView.frame.size.width / 2;
	CGFloat height = width;
	return CGSizeMake(width, height);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
	}
								 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
									 [self.collectionView reloadData];
								 }];
}

@end
