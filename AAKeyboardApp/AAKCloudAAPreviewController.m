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
	CKDatabase *database = [[CKContainer defaultContainer] publicCloudDatabase];
	CKRecord *newRecord = [[CKRecord alloc] initWithRecordType:@"AAKCloudASCIIArt" recordID:_asciiart.recordID];
	
	double refTime = [NSDate timeIntervalSinceReferenceDate];
	
	[newRecord setObject:_asciiart.ASCIIArt forKey:@"ASCIIArt"];
	[newRecord setObject:@(refTime) forKey:@"time"];
	[newRecord setObject:@(_asciiart.downloads+1) forKey:@"downloads"];
	[newRecord setObject:@(_asciiart.reported) forKey:@"reported"];
	[newRecord setObject:_asciiart.title forKey:@"title"];
	
	CKModifyRecordsOperation *operation = [CKModifyRecordsOperation testModifyRecordsOperationWithRecordsToSave:@[newRecord] recordIDsToDelete:@[]];
	operation.database = database;
	[_queue addOperation:operation];
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
