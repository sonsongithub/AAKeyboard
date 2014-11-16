//
//  AAKAAGroupForCollection.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/08.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class _AAKASCIIArtGroup;
@class _AAKASCIIArt;

@interface AAKAAGroupForCollection : NSObject

@property (nonatomic, readonly) _AAKASCIIArtGroup *group;
@property (nonatomic, readonly) NSArray *asciiarts;

+ (instancetype)groupForCollectionWithGroup:(_AAKASCIIArtGroup*)group asciiarts:(NSArray*)array;

@end
