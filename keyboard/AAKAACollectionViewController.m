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

@interface AAKAACollectionViewController () {
	NSArray *_group;
	NSArray *_AAGroups;
}
@end

@implementation AAKAACollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
	UINib *cellNib = [UINib nibWithNibName:@"AAKAACollectionViewCell" bundle:nil];
	[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return [_AAGroups count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSArray *data = _AAGroups[section];
    return data.count;
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
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(100, 100);
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
