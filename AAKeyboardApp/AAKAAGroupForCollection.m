//
//  AAKAAGroupForCollection.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/08.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKAAGroupForCollection.h"

@class AAKASCIIArtGroup;
@class AAKASCIIArt;

@implementation AAKAAGroupForCollection

+ (instancetype)groupForCollectionWithGroup:(AAKASCIIArtGroup*)group asciiarts:(NSArray*)array {
	return [[AAKAAGroupForCollection alloc] initWithGroup:group asciiarts:array];
}

- (instancetype)initWithGroup:(AAKASCIIArtGroup*)group asciiarts:(NSArray*)array {
	self = [super init];
	if (self) {
		_group = group;
		_asciiarts = array;
	}
	return self;
}

@end
