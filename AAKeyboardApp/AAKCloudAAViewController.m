//
//  AAKCloudAAViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/17.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAKCloudAAViewController.h"

#import "AAKCloudASCIIArt.h"
#import "AAKAACloudCollectionViewCell.h"
#import "AAKPreviewController.h"

@interface AAKCloudAAViewController ()
@end

@implementation AAKCloudAAViewController

static NSString * const reuseIdentifier = @"AAKAACloudCollectionViewCell";

- (void)startQuery {
	CKDatabase *database = [[CKContainer defaultContainer] publicCloudDatabase];
	
	 CKQueryOperation *op = nil;
	
	if (_currentCursor == nil) {
		op = [[CKQueryOperation alloc] initWithQuery:_query];
	}
	else {
		op = [[CKQueryOperation alloc] initWithCursor:_currentCursor];
		_currentCursor = nil;
	}
	op.resultsLimit = 4;
	op.recordFetchedBlock = ^(CKRecord *record) {
//		DNSLog(@"%@", record);
		AAKCloudASCIIArt *obj = [AAKCloudASCIIArt cloudASCIIArtWithRecord:record];
		[_asciiarts addObject:obj];
	};
	op.database = database;
	op.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error) {
		DNSLog(@"queryCompletionBlock");
		DNSLog(@"%ld", _asciiarts.count);
		dispatch_async(dispatch_get_main_queue(), ^{
			_currentCursor = cursor;
			if (error) {
				[self didFailCloudKitQuery];
			}
			else {
				[self didFinishCloudKitQuery];
			}
		});
	};
	[_queue addOperation:op];
}

#pragma mark <AAKCloudAAViewController>

- (IBAction)done:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <AAKCloudAAViewController>

- (void)didFailCloudKitQuery {
}

- (void)didFinishCloudKitQuery {
	[self.collectionView reloadData];
}

#pragma mark <UIViewController>

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Register cell and supplemental classes to collection view
	UINib *cellNib = [UINib nibWithNibName:@"AAKAACloudCollectionViewCell" bundle:nil];
	[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseIdentifier];
	
	self.collectionView.alwaysBounceVertical = YES;
	
	_queue = [[NSOperationQueue alloc] init];
	_asciiarts = [NSMutableArray array];
}

#pragma mark <UICollectionViewDataSource>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
//	AAKAACloudCollectionViewCell *cell = (AAKAACloudCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
	
//	UINavigationController *nav = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AAKPreviewNavigationController"];
//	AAKPreviewController *con = (AAKPreviewController*)nav.topViewController;
//	con.asciiart = cell.asciiart;
//	
//	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//		nav.modalPresentationStyle = UIModalPresentationPopover;
//		nav.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
//		nav.popoverPresentationController.sourceRect = [self.view convertRect:cell.frame fromView:cell.superview];
//		nav.popoverPresentationController.sourceView = self.view;
//		nav.popoverPresentationController.delegate = self;
//		[self presentViewController:nav animated:YES completion:nil];
//	}
//	else {
//		nav.modalPresentationStyle = UIModalPresentationCustom;
//		nav.transitioningDelegate = self;
//		[self presentViewController:nav animated:YES completion:nil];
//	}
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [_asciiarts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AAKAACloudCollectionViewCell *cell = (AAKAACloudCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	
	AAKCloudASCIIArt *obj = [_asciiarts objectAtIndex:indexPath.row];
	
	cell.asciiart = obj;
	
	CGFloat fontSize = 15;
	
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:obj.ASCIIArt attributes:attributes];
	cell.textView.attributedString = string;
	cell.titleLabel.text = obj.title;
	
    return cell;
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

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == _asciiarts.count - 1) {
		if (_currentCursor) {
			[self startQuery];
		}
	}
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
	CGFloat height = 400;
	return CGSizeMake(width, height);
}

@end
