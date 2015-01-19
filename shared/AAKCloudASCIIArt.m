//
//  AAKCloudASCIIArt.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/17.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAKCloudASCIIArt.h"

@implementation AAKCloudASCIIArt

+ (instancetype)cloudASCIIArtWithRecord:(CKRecord*)record {
	AAKCloudASCIIArt *obj = [[AAKCloudASCIIArt alloc] initWithASCIIArt:[record objectForKey:@"ASCIIArt"]
																 title:[record objectForKey:@"title"]
															 downloads:[record objectForKey:@"downloads"]
															  reported:[record objectForKey:@"reported"]];
	return obj;
}

- (instancetype)initWithASCIIArt:(NSString*)ASCIIArt
						   title:(NSString*)title
					   downloads:(NSNumber*)downloads
						reported:(NSNumber*)reported {
	self = [super init];
	_ASCIIArt = [ASCIIArt copy];
	_title = [title copy];
	_downloads = downloads.integerValue;
	_reported = reported.integerValue;
	return self;
}

@end
