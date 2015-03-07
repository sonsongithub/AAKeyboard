//
//  CKModifyRecordsOperation+AA.h
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/29.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import <CloudKit/CloudKit.h>

@interface CKModifyRecordsOperation(AA)
+ (instancetype)testModifyRecordsOperationWithRecordsToSave:(NSArray /* CKRecord */ *)records recordIDsToDelete:(NSArray /* CKRecordID */ *)recordIDs;
@end