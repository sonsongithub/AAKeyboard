//
//  AAKAACollectionViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/23.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKAACollectionViewController.h"

#import "AAKKeyboardDataManager.h"
#import "AAKASCIIArt.h"
#import "NSParagraphStyle+keyboard.h"
#import "AAKAACollectionViewCell.h"
#import "AAKTextView.h"
#import "AAKEditViewController.h"
#import "AAKAASupplementaryView.h"
#import "AAKASCIIArtGroup.h"
#import "AAKAAEditPresentationController.h"
#import "AAKAAEditAnimatedTransitioning.h"
#import "AAKAACollectionViewCell.h"

@interface AAKAACollectionViewController () <AAKAACollectionViewCellDelegate, UIViewControllerTransitioningDelegate> {
	NSArray *_group;
	NSArray *_AAGroups;
}
@end

@implementation AAKAACollectionViewController

static NSString * const reuseIdentifier = @"Cell";

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
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
	NSArray *data = _AAGroups[indexPath.section];
	AAKASCIIArtGroup *group = _group[indexPath.section];
	AAKASCIIArt *source = data[indexPath.item];
	
	UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"AAKEditNavigationController"];
	AAKEditViewController *con = (AAKEditViewController*)nav.topViewController;
	
	con.art = source;
	con.group = group;
	
	nav.modalPresentationStyle = UIModalPresentationCustom;
	nav.transitioningDelegate = self;
	
	[self presentViewController:nav animated:YES completion:nil];
}

- (void)didPushCopyCell:(AAKAACollectionViewCell*)cell {
	AAKASCIIArt *obj = cell.asciiart;
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
	[self.collectionView performBatchUpdates:^(void){
		
		[[AAKKeyboardDataManager defaultManager] duplicateASCIIArt:obj.key];
		
		NSMutableArray *buf = [NSMutableArray arrayWithCapacity:[_group count]];
		
		for (AAKASCIIArtGroup *group in _group) {
			NSArray *data = [[AAKKeyboardDataManager defaultManager] asciiArtForGroup:group];
			[buf addObject:data];
		}
		_AAGroups = [NSArray arrayWithArray:buf];
		[self.collectionView insertItemsAtIndexPaths:@[indexPath]];
	} completion:nil];
}

- (void)didPushDeleteCell:(AAKAACollectionViewCell*)cell {
	AAKASCIIArt *obj = cell.asciiart;
	NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
	[[AAKKeyboardDataManager defaultManager] deleteASCIIArt:obj];
	[self.collectionView performBatchUpdates:^(void){
		

		NSMutableArray *buf = [NSMutableArray arrayWithCapacity:[_group count]];

		for (AAKASCIIArtGroup *group in _group) {
			NSArray *data = [[AAKKeyboardDataManager defaultManager] asciiArtForGroup:group];
			[buf addObject:data];
		}
		_AAGroups = [NSArray arrayWithArray:buf];
		[self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
	} completion:nil];
}

- (void)didUpdateDatabase:(NSNotification*)notification {	
	NSDictionary *userInfo = notification.userInfo;
	
	AAKASCIIArt *deleted = userInfo[AAKKeyboardDataManagerDidRemoveObjectKey];
	
	if (deleted == nil) {
		_group = [[AAKKeyboardDataManager defaultManager] groups];
		
		NSMutableArray *buf = [NSMutableArray arrayWithCapacity:[_group count]];
		
		for (AAKASCIIArtGroup *group in _group) {
			NSArray *data = [[AAKKeyboardDataManager defaultManager] asciiArtForGroup:group];
			[buf addObject:data];
		}
		_AAGroups = [NSArray arrayWithArray:buf];
		[self.collectionView reloadData];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateDatabase:) name:AAKKeyboardDataManagerDidUpdateNotification object:nil];
  
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
	UINib *cellNib = [UINib nibWithNibName:@"AAKAACollectionViewCell" bundle:nil];
	[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
	UINib *nib = [UINib nibWithNibName:@"AAKAASupplementaryView" bundle:nil];
	[self.collectionView registerNib:nib
		  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
				 withReuseIdentifier:@"AAKAASupplementaryView"];
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	
    // Do any additional setup after loading the view.
	_group = [[AAKKeyboardDataManager defaultManager] groups];
	
	NSMutableArray *buf = [NSMutableArray arrayWithCapacity:[_group count]];
	
	for (AAKASCIIArtGroup *group in _group) {
		NSArray *data = [[AAKKeyboardDataManager defaultManager] asciiArtForGroup:group];
		[buf addObject:data];
	}
	_AAGroups = [NSArray arrayWithArray:buf];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

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
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:source.asciiArt attributes:attributes];
	cell.textView.attributedString = string;
	cell.asciiart = source;
	cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//	NSArray *data = _AAGroups[indexPath.section];
//	AAKASCIIArtGroup *group = _group[indexPath.section];
//	AAKASCIIArt *source = data[indexPath.item];
//	AAKEditViewController *con = [self.storyboard instantiateViewControllerWithIdentifier:@"AAKEditViewController"];
//	con.art = source;
//	con.group = group;
//	[self.navigationController pushViewController:con animated:YES];
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

- (CGSize)collectionView:(UICollectionView *)collectionView
				  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
	return CGSizeMake(320, 44);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//	NSArray *data = _AAGroups[indexPath.section];
//	AAKASCIIArt *source = data[indexPath.item];
	CGFloat width = self.collectionView.frame.size.width / 2;
	CGFloat height = width;
	return CGSizeMake(width, height);
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
													  presentingViewController:(UIViewController *)presenting
														  sourceViewController:(UIViewController *)source {
	return [[AAKAAEditPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
																  presentingController:(UIViewController *)presenting
																	  sourceController:(UIViewController *)source {
	return [[AAKAAEditAnimatedTransitioning alloc] initWithPresentFlag:NO];
	return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	return [[AAKAAEditAnimatedTransitioning alloc] initWithPresentFlag:YES];
}

@end
