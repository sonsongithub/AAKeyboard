//
//  AAKPreviewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/30.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKPreviewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <CloudKit/CloudKit.h>

@interface AAKPreviewController () {
	NSOperationQueue *_queue;
}

@end

@interface CKModifyRecordsOperation(test)
+ (instancetype)testModifyRecordsOperationWithRecordsToSave:(NSArray /* CKRecord */ *)records recordIDsToDelete:(NSArray /* CKRecordID */ *)recordIDs;
@end

@implementation CKModifyRecordsOperation(test)

+ (instancetype)testModifyRecordsOperationWithRecordsToSave:(NSArray /* CKRecord */ *)records recordIDsToDelete:(NSArray /* CKRecordID */ *)recordIDs {
	//
	// You have to set appropriate role at iCloud Dashboard in order to edit a property of your record.
	//
	CKModifyRecordsOperation *operation = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:records recordIDsToDelete:recordIDs];
	
	//
	// Save policy
	//
	operation.savePolicy = CKRecordSaveIfServerRecordUnchanged;
	//	operation.savePolicy = CKRecordSaveAllKeys;
	//	operation.savePolicy = CKRecordSaveChangedKeys;
	
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

@implementation AAKPreviewController

- (CGFloat)contentRatio {
	return self.asciiart.ratio;
}

- (id)asciiart {
	return _asciiart;
}

+ (CGFloat)marginConstant {
	return 30;
}

#pragma mark - IBAction

- (IBAction)upload:(id)sender {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"iCloud", nil)
																   message:NSLocalizedString(@"Please input the title of AA.", nil)
															preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *upload = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
													 style:UIAlertActionStyleDefault
												   handler:^(UIAlertAction *action) {
													   
													   UITextField *field = alert.textFields[0];
													   
													   CKDatabase *database = [[CKContainer defaultContainer] publicCloudDatabase];
													   
													   double refTime = [NSDate timeIntervalSinceReferenceDate];
													   CKRecord *newRecord = [[CKRecord alloc] initWithRecordType:@"AAKCloudASCIIArt"];
													   
													   [newRecord setObject:_textView.attributedString.string forKey:@"ASCIIArt"];
													   [newRecord setObject:@(refTime) forKey:@"time"];
													   [newRecord setObject:@(0) forKey:@"downloads"];
													   [newRecord setObject:@(0) forKey:@"reported"];
													   [newRecord setObject:field.text forKey:@"title"];
													   
													   CKModifyRecordsOperation *operation = [CKModifyRecordsOperation testModifyRecordsOperationWithRecordsToSave:@[newRecord] recordIDsToDelete:@[]];
													   operation.database = database;
													   [_queue addOperation:operation];
												   }];
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
													 style:UIAlertActionStyleDefault
												   handler:^(UIAlertAction *action) {
												   }];
	[alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
	}];
	[alert addAction:cancel];
	[alert addAction:upload];
	[self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveAsImage:(id)sender {
	DNSLogMethod
	
	UIImage *image = [self.textView imageForPasteBoard];
	
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	[library writeImageToSavedPhotosAlbum:image.CGImage metadata:nil
						  completionBlock:^(NSURL *assetURL, NSError *error){
							  if (error) {
								  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
																					  message:[error localizedDescription]
																					 delegate:nil
																			cancelButtonTitle:nil
																			otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
								  [alertView show];
							  }
							  else {
								  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AAKeyboard", nil)
																					  message:[NSString stringWithFormat:NSLocalizedString(@"Image has been saved.", nil)]
																					 delegate:nil
																			cancelButtonTitle:nil
																			otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
								  [alertView show];
							  }
						  }];
}

#pragma mark - Instance method

/**
 * テキストビューに再度AAを突っ込みコンテンツを最新のものに更新する．
 **/
- (void)updateTextView {
	CGFloat fontSize = 15;
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_asciiart.text attributes:attributes];
	_textView.attributedString = string;
}

/**
 * データが更新された通知を受け取って実行する．
 * @param notification 通知オブジェクト．
 **/
- (void)keyboardDataManagerDidUpdateNotification:(NSNotification*)notification {
	[self updateTextView];
}

#pragma mark - Override

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = YES;
	self.navigationController.toolbarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_queue = [[NSOperationQueue alloc] init];
	
	_leftMarginConstraint.constant = [AAKPreviewController marginConstant];
	_rightMarginConstraint.constant = [AAKPreviewController marginConstant];
	_topMarginConstraint.constant = [AAKPreviewController marginConstant];
	_bottomMarginConstraint.constant = [AAKPreviewController marginConstant];
	
	_textView.userInteractionEnabled = NO;
	[self updateTextView];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDataManagerDidUpdateNotification:) name:AAKKeyboardDataManagerDidUpdateNotification object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"PushAAKEditController"]) {
		AAKEditViewController *vc = (AAKEditViewController*)segue.destinationViewController;
		vc.asciiart = self.asciiart;
	}
}

@end
