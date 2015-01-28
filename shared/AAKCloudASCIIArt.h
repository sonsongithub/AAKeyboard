//
//  AAKCloudASCIIArt.h
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/17.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import "AAKAAEditAnimatedTransitioning.h"

@interface AAKCloudASCIIArt : NSObject <AAKContentProtocol>

@property (nonatomic, readonly) NSString *ASCIIArt;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSInteger downloads;
@property (nonatomic, readonly) NSInteger like;
@property (nonatomic, readonly) NSInteger reported;
@property (nonatomic, readonly) double ratio;
@property (nonatomic, readonly) CKRecordID *recordID;

+ (instancetype)cloudASCIIArtWithRecord:(CKRecord*)record;

@end
