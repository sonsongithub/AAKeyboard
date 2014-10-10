//
//  AAKContentFlowLayout.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/10.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKContentFlowLayout.h"

@implementation AAKContentFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
	CGFloat offsetAdjustment = MAXFLOAT;
	CGFloat horizontalCenter = proposedContentOffset.x;
	CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
	NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
	for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
		CGFloat itemHorizontalCenter = layoutAttributes.frame.origin.x;
		if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
			offsetAdjustment = itemHorizontalCenter - horizontalCenter;
		}
	}
	return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
