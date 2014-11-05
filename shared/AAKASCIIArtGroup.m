//
//  AAKASCIIArtGroup.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/13.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKASCIIArtGroup.h"

@interface AAKASCIIArtGroup()
@end

@implementation AAKASCIIArtGroup

#pragma mark - Class method

/**
 * @return
 **/
+ (AAKASCIIArtGroup*)defaultGroup {
	return [[AAKASCIIArtGroup alloc] initWithTitle:@"Default" key:1 type:AAKASCIIArtNormalGroup];
}

/**
 * @param key
 * @param title
 * @return
 **/
+ (AAKASCIIArtGroup*)groupWithTitle:(NSString*)title key:(NSInteger)key {
	return [[AAKASCIIArtGroup alloc] initWithTitle:title key:key type:AAKASCIIArtNormalGroup];
}

/**
 * @return
 **/
+ (AAKASCIIArtGroup*)historyGroup {
	return [[AAKASCIIArtGroup alloc] initWithTitle:@"history" key:-1 type:AAKASCIIArtHistoryGroup];
}

#pragma mark - Instance method

/**
 * @param title
 * @param key
 * @param type
 * @return
 **/
- (instancetype)initWithTitle:(NSString*)title key:(NSInteger)key type:(AAKASCIIArtGroupType)type {
	if (self = [super init]) {
		_title = title;
		_key = key;
		_type = type;
	}
	return self;
}

#pragma mark - Override

- (instancetype)init {
	self = [super init];
	if (self) {
		_title = nil;
		_type = AAKASCIIArtNormalGroup;
		_key = -1;
	}
	return self;
}

@end
