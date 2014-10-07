//
//  UITraitCollection+keyboard.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/07.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "UITraitCollection+keyboard.h"

@implementation UITraitCollection(keyboard)

- (NSString*)description {
	NSMutableString *string = [NSMutableString string];
	switch (self.verticalSizeClass) {
		case UIUserInterfaceSizeClassUnspecified:
			[string appendString:@"(Vertical = Unspecified)"];
			break;
		case UIUserInterfaceSizeClassCompact:
			[string appendString:@"(Vertical = Compact)"];
			break;
		case UIUserInterfaceSizeClassRegular:
			[string appendString:@"(Vertical = Regular)"];
			break;
		default:
			break;
	}
	switch (self.horizontalSizeClass) {
		case UIUserInterfaceSizeClassUnspecified:
			[string appendString:@"(Horizontal = Unspecified)"];
			break;
		case UIUserInterfaceSizeClassCompact:
			[string appendString:@"(Horizontal = Compact)"];
			break;
		case UIUserInterfaceSizeClassRegular:
			[string appendString:@"(Horizontal = Regular)"];
			break;
		default:
			break;
	}
	[string appendFormat:@"Scale = %lf", self.displayScale];
	return [NSString stringWithString:string];
}

@end
