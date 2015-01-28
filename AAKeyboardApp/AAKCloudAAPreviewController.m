//
//  AAKCloudAAPreviewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/27.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAKCloudAAPreviewController.h"
#import "AAKPreviewController.h"

@implementation AAKCloudAAPreviewController

- (IBAction)like:(id)sender {
	_likeButton.enabled = NO;
	CKDatabase *database = [[CKContainer defaultContainer] publicCloudDatabase];
	{
		CKDatabase *privateCloudDatabase = [[CKContainer defaultContainer] privateCloudDatabase];
		CKRecord *newRecord = [[CKRecord alloc] initWithRecordType:@"AAKCloudLikeHistory"];
		
		[newRecord setObject:_asciiart.recordID.recordName forKey:@"likedRecordID"];
		
		CKModifyRecordsOperation *operation = [CKModifyRecordsOperation testModifyRecordsOperationWithRecordsToSave:@[newRecord] recordIDsToDelete:@[]];
		operation.database = privateCloudDatabase;
		[_queue addOperation:operation];
	}
	[database fetchRecordWithID:_asciiart.recordID
			  completionHandler:^(CKRecord *record, NSError *error) {
				  dispatch_async(dispatch_get_main_queue(), ^{
					  if (error == nil) {
						  NSNumber *like = [record objectForKey:@"like"];
						  [record setObject:@(like.integerValue + 1) forKey:@"like"];
						  
						  CKModifyRecordsOperation *operation = [CKModifyRecordsOperation testModifyRecordsOperationWithRecordsToSave:@[record] recordIDsToDelete:@[]];
						  operation.database = database;
						  operation.modifyRecordsCompletionBlock = ^ ( NSArray *savedRecords, NSArray *deletedRecordIDs, NSError *operationError) {
							  if (error == nil) {
								  dispatch_async(dispatch_get_main_queue(), ^{
									  self.likeLabel.text = @(like.integerValue + 1).stringValue;
								  });
							  }
						  };
						  [_queue addOperation:operation];
					  }
					  else {
					  }
				  });
			  }];
}

/**
 * テキストビューに再度AAを突っ込みコンテンツを最新のものに更新する．
 **/
- (void)updateTextView {
	CGFloat fontSize = 15;
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_asciiart.ASCIIArt attributes:attributes];
	_textView.attributedString = string;
}

- (AAKContent*)content {
	return _asciiart;
}

+ (CGFloat)marginConstant {
	return 30;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.titleLabel.text = _asciiart.title;
	self.likeLabel.text = @(_asciiart.like).stringValue;
	_likeHistory = YES;
	_likeButton.enabled = NO;
	CKDatabase *privateCloudDatabase = [[CKContainer defaultContainer] privateCloudDatabase];
	
	NSString *temp = [NSString stringWithFormat:@"likedRecordID BEGINSWITH '%@'", _asciiart.recordID.recordName];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:temp];
	CKQuery *query = [[CKQuery alloc] initWithRecordType:@"AAKCloudLikeHistory"
											   predicate:predicate];
	CKQueryOperation *op = [[CKQueryOperation alloc] initWithQuery:query];
	op.resultsLimit = 1;
	op.recordFetchedBlock = ^(CKRecord *record) {
		_likeHistory = NO;
	};
	op.database = privateCloudDatabase;
	op.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			_likeButton.enabled = _likeHistory;
		});
	};
	[_queue addOperation:op];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_queue = [[NSOperationQueue alloc] init];
	
	_leftMarginConstraint.constant = [AAKCloudAAPreviewController marginConstant];
	_rightMarginConstraint.constant = [AAKCloudAAPreviewController marginConstant];
	_topMarginConstraint.constant = [AAKCloudAAPreviewController marginConstant];
	_bottomMarginConstraint.constant = [AAKCloudAAPreviewController marginConstant];
	
	_textView.userInteractionEnabled = NO;
	[self updateTextView];
}

@end
