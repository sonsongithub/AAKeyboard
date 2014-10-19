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

- (instancetype)initWithTitle:(NSString*)title key:(NSInteger)key {
	if (self = [super init]) {
		_title = title;
		_key = key;
	}
	return self;
}

+ (AAKASCIIArtGroup*)groupWithTitle:(NSString*)title key:(NSInteger)key {
	return [[AAKASCIIArtGroup alloc] initWithTitle:title key:key];
}

@end
