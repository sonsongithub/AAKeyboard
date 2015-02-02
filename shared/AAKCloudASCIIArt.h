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
@property (nonatomic, readonly) double createdTime;
@property (nonatomic, readonly) CKRecordID *recordID;

+ (NSOperationQueue*)sharedQueue;
+ (void)uploadAA:(NSString*)AA title:(NSString*)title;
+ (instancetype)cloudASCIIArtWithRecord:(CKRecord*)record;

// like
+ (void)addLikedRecordIDToPrivateDatabase:(CKRecordID*)recordID;
+ (void)incrementLikeCounter:(CKRecordID*)recordID completionBlock:(void (^)(CKRecord *record, NSError *operationError))completionBlock;

// download
+ (void)incrementDownloadCounter:(CKRecordID*)recordID completionBlock:(void (^)(CKRecord *record, NSError *operationError))completionBlock;

+ (void)start;

@end
