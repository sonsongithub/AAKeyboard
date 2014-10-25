//
//  AAKASCIIArtGroup.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/13.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKASCIIArtGroup.h"

@interface AAKASCIIArtGroup()
@property (nonatomic, readonly) NSString *path;
@end

@implementation AAKASCIIArtGroup

- (instancetype)initWithTitle:(NSString*)title key:(NSInteger)key type:(AAKASCIIArtGroupType)type {
	if (self = [super init]) {
		_title = title;
		_key = key;
		_type = type;
	}
	return self;
}

+ (AAKASCIIArtGroup*)defaultGroup {
	return [[AAKASCIIArtGroup alloc] initWithTitle:@"Default" key:0 type:AAKASCIIArtNormalGroup];
}

+ (AAKASCIIArtGroup*)groupWithTitle:(NSString*)title key:(NSInteger)key {
	return [[AAKASCIIArtGroup alloc] initWithTitle:title key:key type:AAKASCIIArtNormalGroup];
}

+ (AAKASCIIArtGroup*)historyGroup {
	return [[AAKASCIIArtGroup alloc] initWithTitle:@"history" key:-1 type:AAKASCIIArtHistoryGroup];
}

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
