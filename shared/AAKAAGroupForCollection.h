//
//  AAKAAGroupForCollection.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/08.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AAKASCIIArtGroup;
@class AAKASCIIArt;

@interface AAKAAGroupForCollection : NSObject

@property (nonatomic, readonly) AAKASCIIArtGroup *group;
@property (nonatomic, readonly) NSArray *asciiarts;

+ (instancetype)groupForCollectionWithGroup:(AAKASCIIArtGroup*)group asciiarts:(NSArray*)array;

@end
