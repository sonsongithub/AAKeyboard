//
//  AAKASCIIArt.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/17.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKASCIIArt.h"
#import "AAKASCIIArtGroup.h"


@implementation AAKASCIIArt

@dynamic lastUsedTime;
@dynamic ratio;
@dynamic text;
@dynamic group;

- (void)updateLastUsedTime {
	self.lastUsedTime = [NSDate timeIntervalSinceReferenceDate];
}

- (void)updateRatio {
	CGFloat fontSize = 15;
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.text attributes:attributes];
	CGSize size = [UZTextView sizeForAttributedString:string withBoundWidth:CGFLOAT_MAX margin:UIEdgeInsetsZero];
	self.ratio = size.width / size.height;
}

@end
