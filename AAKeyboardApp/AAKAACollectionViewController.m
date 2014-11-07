//
//  AAKAACollectionViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/23.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKAACollectionViewController.h"

#import "AAKShared.h"

#import "AAKAACollectionViewCell.h"
#import "AAKAASupplementaryView.h"
#import "AAKAAEditPresentationController.h"
#import "AAKAAEditAnimatedTransitioning.h"
#import "AAKAACollectionViewCell.h"
#import "AAKPreviewController.h"

@interface AAKAACollectionViewController () <AAKAACollectionViewCellDelegate, UIViewControllerTransitioningDelegate> {
	NSArray *_group;
	NSArray *_AAGroups;
}
@end

@implementation AAKAACollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (id)cellForAsciiArt:(AAKASCIIArt*)asciiart {
	NSArray *visibleCells = [self.collectionView visibleCells];
	for (AAKAACollectionViewCell* cell in visibleCells) {
		if (cell.asciiart.key == asciiart.key)
			return cell;
	}
	return nil;
}

- (NSIndexPath*)indexPathForAsciiArt:(AAKASCIIArt*)asciiart {
	for (int i = 0; i < [_AAGroups count]; i++) {
		NSArray *buf = _AAGroups[i];
		for (int j = 0; j < [buf count]; j++) {
			AAKASCIIArt *art = buf[j];
			if (art.key == asciiart.key)
				return [NSIndexPath indexPathForItem:j inSection:i];
		}
	}
	return nil;
}

- (void)didSelectCell:(AAKAACollectionViewCell*)cell {
	NSLog(@"%p", cell);
	AAKPreviewController *con = (AAKPreviewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AAKPreviewController"];
	con.asciiart = cell.asciiart;
	con.modalPresentationStyle = UIModalPresentationCustom;
	con.transitioningDelegate = self;
	
	[self presentViewController:con animated:YES completion:nil];
}

- (void)didPushCopyCell:(AAKAACollectionViewCell*)cell {
	AAKASCIIArt *obj = cell.asciiart;
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
	[[AAKKeyboardDataManager defaultManager] duplicateASCIIArt:obj.key];
	[self.collectionView performBatchUpdates:^(void){
		[self updateContent];
		[self.collectionView insertItemsAtIndexPaths:@[indexPath]];
	} completion:^(BOOL finished) {
		[self.collectionView reloadData];
	}];
}

- (void)didPushDeleteCell:(AAKAACollectionViewCell*)cell {
	AAKASCIIArt *obj = cell.asciiart;
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
	[[AAKKeyboardDataManager defaultManager] deleteASCIIArt:obj];
	[self.collectionView performBatchUpdates:^(void){
		
		[self updateContent];
		
		[self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
	} completion:^(BOOL finished) {
		[self.collectionView reloadData];
	}];
}

- (void)didUpdateDatabase:(NSNotification*)notification {
	[self updateContent];
	[self.collectionView reloadData];
	
}

- (void)applicationWillEnterForegroundNotification:(NSNotification*)notification {
	[self updateContent];
	[self.collectionView reloadData];
}

- (void)updateContent {
	_group = [[AAKKeyboardDataManager defaultManager] groupsWithoutHistory];
	
	NSMutableArray *buf = [NSMutableArray arrayWithCapacity:[_group count]];
	
	for (AAKASCIIArtGroup *group in _group) {
		NSArray *data = [[AAKKeyboardDataManager defaultManager] asciiArtForGroup:group];
		[buf addObject:data];
	}
	_AAGroups = [NSArray arrayWithArray:buf];
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateDatabase:) name:AAKKeyboardDataManagerDidUpdateNotification object:nil];
	
    // Register cell classes to collection view
	UINib *cellNib = [UINib nibWithNibName:@"AAKAACollectionViewCell" bundle:nil];
	[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
	
	UINib *nib = [UINib nibWithNibName:@"AAKAASupplementaryView" bundle:nil];
	[self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AAKAASupplementaryView"];
	
	[self updateContent];
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

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return [_AAGroups count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSArray *data = _AAGroups[section];
    return data.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		AAKAASupplementaryView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AAKAASupplementaryView" forIndexPath:indexPath];
		AAKASCIIArtGroup *group = _group[indexPath.section];
		headerView.label.text = group.title;
		return headerView;
	} else {
		return nil;
	}
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AAKAACollectionViewCell *cell = (AAKAACollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cvCell" forIndexPath:indexPath];
    // Configure the cell
	
	NSArray *data = _AAGroups[indexPath.section];
	AAKASCIIArt *source = data[indexPath.item];
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
	return CGSizeMake(320, 44);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//	NSArray *data = _AAGroups[indexPath.section];
//	AAKASCIIArt *source = data[indexPath.item];
	CGFloat width = self.collectionView.frame.size.width / 2;
	CGFloat height = width;
	return CGSizeMake(width, height);
}

@end
