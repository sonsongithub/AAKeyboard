//
//  AAKASCIIArtGroup.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/17.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKASCIIArtGroup.h"


@implementation AAKASCIIArtGroup

@dynamic order;
@dynamic title;
@dynamic type;

+ (void)addDefaultASCIIArtGroup {
	NSArray *results = [AAKASCIIArtGroup MR_findAllWithPredicate:[NSPredicate predicateWithFormat: @"type == 0"]];
	
	if (results.count == 0) {
		AAKASCIIArtGroup *defaultGroup	= [AAKASCIIArtGroup MR_createEntity];
		defaultGroup.title = @"Default";
		defaultGroup.type = AAKASCIIArtDefaultGroup;
		defaultGroup.order = 0;
		[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
	}
}

+ (AAKASCIIArtGroup*)defaultGroup {
	NSArray *results = [AAKASCIIArtGroup MR_findAllWithPredicate:[NSPredicate predicateWithFormat: @"type == 0"]];
	if (results.count == 0) {
		AAKASCIIArtGroup *defaultGroup	= [AAKASCIIArtGroup MR_createEntity];
		defaultGroup.title = @"Default";
		defaultGroup.type = AAKASCIIArtDefaultGroup;
		defaultGroup.order = 0;
		[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
		return defaultGroup;
	}
	return results.firstObject;
}

@end
