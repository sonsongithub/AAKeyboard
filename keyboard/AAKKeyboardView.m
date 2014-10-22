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
#import "AAKContentFlowLayout.h"
#import "NSParagraphStyle+keyboard.h"
#import "AAKHelper.h"
#import "AAKKeyboardDataManager.h"
#import "AAKASCIIArtGroup.h"
#import "AAKASCIIArt.h"

@interface AAKKeyboardView() <UICollectionViewDataSource, UICollectionViewDelegate, AAKToolbarDelegate> {
	AAKToolbar *_toolbar;
	NSLayoutConstraint	*_toolbarHeightConstraint;
	UICollectionView	*_collectionView;
	AAKContentFlowLayout *_collectionFlowLayout;
	NSArray *_asciiarts;
}
@end

@implementation AAKKeyboardView

- (void)load {
	NSInteger itemsPerPage = 3;
	CGFloat w = CGRectGetWidth(self.bounds);
	NSLog(@"width =	%f", w);
	if (w == 1024) {
		itemsPerPage = 8;
	}
	else if (w == 768) {
		itemsPerPage = 6;
	}
	else if (w == 736) {
		itemsPerPage = 6;
	}
	else if (w == 667) {
		itemsPerPage = 6;
	}
	else if (w == 480) {
		itemsPerPage = 6;
	}
	else if (w == 414) {
		itemsPerPage = 4;
	}
	else if (w == 375) {
		itemsPerPage = 3;
	}
	else if (w == 320) {
		itemsPerPage = 3;
	}
	CGFloat pageWidth = w / itemsPerPage;
	CGFloat h = CGRectGetHeight(_collectionView.bounds);
	_collectionFlowLayout.itemSize = CGSizeMake(pageWidth, h);
	_collectionFlowLayout.numberOfPage = itemsPerPage;
	[_collectionFlowLayout invalidateLayout];
	[_toolbar layout];
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

- (void)setPortraitMode {
	_toolbarHeightConstraint.constant = 48;
	_toolbar.height = 48;
	_toolbar.fontSize = 14;
}

- (void)setLandscapeMode {
	_toolbarHeightConstraint.constant = 30;
	_toolbar.height = 30;
	_toolbar.fontSize = 12;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_toolbar = [[AAKToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_toolbar.delegate = self;
		[self addSubview:_toolbar];
		
		_collectionFlowLayout = [[AAKContentFlowLayout alloc] init];
		_collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		_collectionFlowLayout.minimumLineSpacing = 0;
		_collectionFlowLayout.minimumInteritemSpacing = 0;
		_collectionFlowLayout.itemSize = CGSizeMake(100, 140);
		_collectionFlowLayout.sectionInset = UIEdgeInsetsZero;
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionFlowLayout];
		_collectionView.alwaysBounceHorizontal = YES;
		_collectionView.showsHorizontalScrollIndicator = NO;
		_collectionView.backgroundColor = [UIColor colorWithRed:254.0/255.0f green:254.0/255.0f blue:254.0/255.0f alpha:1];
		_collectionView.backgroundColor = [UIColor clearColor];
		[_collectionView registerClass:[AAKContentCell class] forCellWithReuseIdentifier:@"AAKContentCell"];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		[self addSubview:_collectionView];
		
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
		NSArray *groups = [[AAKKeyboardDataManager defaultManager] groups];
		
		NSMutableArray *array = [NSMutableArray arrayWithArray:@[[AAKASCIIArtGroup historyGroup]]];
		[array addObjectsFromArray:groups];
		
		[_toolbar setCategories:array];
		
		[self addConstraint:_toolbarHeightConstraint];
		
		_asciiarts = [[AAKKeyboardDataManager defaultManager] asciiArtForGroup:groups[0]];
		
		[self updateConstraints];
	}
	return self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	AAKASCIIArt *source = _asciiarts[indexPath.item];
	[[AAKKeyboardDataManager defaultManager] insertHistoryASCIIArtKey:source.key];
	[self.delegate keyboardView:self willInsertString:source.asciiArt];
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
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:source.asciiArt attributes:attributes];
	cell.textView.attributedString = string;
	[cell.label sizeToFit];
	return cell;
}

#pragma mark - AAKToolbarDelegate

- (void)toolbar:(AAKToolbar*)toolbar didSelectGroup:(AAKASCIIArtGroup*)group {
	_asciiarts = [[AAKKeyboardDataManager defaultManager] asciiArtForGroup:group];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
