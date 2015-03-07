//
//  AAKASCIIArt.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/17.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AAKAAEditAnimatedTransitioning.h"

@class AAKASCIIArtGroup;

@interface AAKASCIIArt : NSManagedObject <AAKContentProtocol>

@property (nonatomic) double lastUsedTime;
@property (nonatomic) double ratio;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) AAKASCIIArtGroup *group;

@property (nonatomic, assign) CGSize contentSize;

- (void)updateLastUsedTime;

- (void)updateRatio;

+ (NSData*)dataForJsonAllData;

@end
