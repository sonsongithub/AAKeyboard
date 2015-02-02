//
//  AAKCloudSendReportViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/02/01.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAKCloudSendReportViewController.h"

@interface AAKCloudSendReportViewController() <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *commentTextView;
@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet AAKTextView *aaTextView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation AAKCloudSendReportViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];

	CGFloat fontSize = 15;
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.asciiart.ASCIIArt attributes:attributes];
	self.aaTextView.attributedString = string;
	
#if 1
	self.emailTextField.text = @"hoge@hoge.com";
#endif
}

- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)send:(id)sender {
	CKDatabase *database = [[CKContainer defaultContainer] publicCloudDatabase];
	
	double refTime = [NSDate timeIntervalSinceReferenceDate];
	CKRecord *newRecord = [[CKRecord alloc] initWithRecordType:@"AAKCloudASCIIArtReport"];
	
	CKReference *reference = [[CKReference alloc] initWithRecordID:self.asciiart.recordID action:CKReferenceActionNone];
	
	[newRecord setObject:reference forKey:@"ASCIIArt"];
	[newRecord setObject:self.emailTextField.text forKey:@"email"];
	[newRecord setObject:self.commentTextView.text forKey:@"comment"];
	[newRecord setObject:@(refTime) forKey:@"time"];
	[newRecord setObject:@(self.selectedIndexPath.row) forKey:@"type"];
	
	CKModifyRecordsOperation *operation = [CKModifyRecordsOperation testModifyRecordsOperationWithRecordsToSave:@[newRecord] recordIDsToDelete:@[]];
	operation.database = database;
	[[AAKCloudASCIIArt sharedQueue] addOperation:operation];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 2) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		UITableViewCell *currentCheckedCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
		currentCheckedCell.accessoryType = UITableViewCellAccessoryNone;
		
		UITableViewCell *newCheckedCell = [tableView cellForRowAtIndexPath:indexPath];
		newCheckedCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		self.selectedIndexPath = indexPath;
	}
}

@end
