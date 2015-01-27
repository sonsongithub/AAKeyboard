//
//  AAKCloudASCIIArt.h
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/17.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

@interface AAKCloudASCIIArt : NSObject

@property (nonatomic, readonly) NSString *ASCIIArt;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSInteger downloads;
@property (nonatomic, readonly) NSInteger reported;
@property (nonatomic, readonly) double ratio;

+ (instancetype)cloudASCIIArtWithRecord:(CKRecord*)record;

@end
