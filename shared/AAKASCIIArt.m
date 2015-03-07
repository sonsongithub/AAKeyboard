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
@dynamic title;

@synthesize contentSize;

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

+ (NSArray*)getAllArts {
	NSArray *results = [AAKASCIIArt MR_findAllWithPredicate:[NSPredicate predicateWithFormat: @"TRUEPREDICATE"]];
	NSMutableArray *groups = [NSMutableArray array];
	for (AAKASCIIArt *art in results) {
		NSMutableDictionary *targetGroup = nil;
		for (NSMutableDictionary *group in groups) {
			if ([group[@"name"] isEqualToString:art.group.title]) {
				targetGroup = group;
				break;
			}
		}
		if (targetGroup == nil) {
			targetGroup = [NSMutableDictionary dictionary];
			targetGroup[@"name"] = art.group.title;
			targetGroup[@"aa"] = [NSMutableArray array];
			[groups addObject:targetGroup];
		}
		[targetGroup[@"aa"] addObject:art.text];
	}
	return [NSArray arrayWithArray:groups];
}

+ (NSData*)dataForJsonAllData {
	NSArray *array = [self getAllArts];
	NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
//	NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	return data;
}

@end
