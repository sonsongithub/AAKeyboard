//
//  ASCIIArt.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/14.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ASCIIArtGroup;

@interface ASCIIArt : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic) double ratio;
@property (nonatomic) double lastUsedTime;
@property (nonatomic, retain) ASCIIArtGroup *relationship;

@end
