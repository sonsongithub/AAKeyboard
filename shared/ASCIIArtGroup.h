//
//  ASCIIArtGroup.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/14.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ASCIIArtGroup : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic) int64_t order;
@property (nonatomic) int64_t type;

@end
