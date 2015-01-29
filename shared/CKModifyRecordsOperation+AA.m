//
//  CKModifyRecordsOperation+AA.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/29.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "CKModifyRecordsOperation+AA.h"

@implementation CKModifyRecordsOperation(AA)

+ (instancetype)testModifyRecordsOperationWithRecordsToSave:(NSArray /* CKRecord */ *)records recordIDsToDelete:(NSArray /* CKRecordID */ *)recordIDs {
	//
	// You have to set appropriate role at iCloud Dashboard in order to edit a property of your record.
	//
	CKModifyRecordsOperation *operation = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:records recordIDsToDelete:recordIDs];
	
	//
	// Save policy
	//
	operation.savePolicy = CKRecordSaveChangedKeys;
	
	operation.completionBlock = ^(void) {
	};
	operation.modifyRecordsCompletionBlock = ^(NSArray *savedRecords, NSArray *deletedRecordIDs, NSError *error) {
		if (error) {
			DNSLog(@"%@-%@", error, [error localizedDescription]);
		}
		if ([savedRecords count]) {
			DNSLog(@"savedRecords = %@", savedRecords);
		}
		if ([deletedRecordIDs count]) {
			DNSLog(@"deletedRecordIDs = %@", deletedRecordIDs);
		}
	};
	operation.perRecordCompletionBlock = ^(CKRecord *record, NSError *error) {
		DNSLog(@"%@", error);
	};
	operation.perRecordProgressBlock = ^(CKRecord *record, double progress) {
	};
	
	return operation;
}

@end