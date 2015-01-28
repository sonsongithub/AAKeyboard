//
//  AAKPreviewController.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/30.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAKAAEditAnimatedTransitioning.h"
#import <CloudKit/CloudKit.h>

@interface CKModifyRecordsOperation(test)
+ (instancetype)testModifyRecordsOperationWithRecordsToSave:(NSArray /* CKRecord */ *)records recordIDsToDelete:(NSArray /* CKRecordID */ *)recordIDs;
@end


@class AAKTextView;

@interface AAKPreviewController : UIViewController <AAKDestinationPreviewControllerProtocol>
@property (nonatomic, strong) IBOutlet AAKTextView *textView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topMarginConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bottomMarginConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *rightMarginConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *leftMarginConstraint;

@property (nonatomic, strong) AAKASCIIArt *asciiart;

+ (CGFloat)marginConstant;

@end
