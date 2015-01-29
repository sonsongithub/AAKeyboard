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
	
	// insert likedRecordID
	[AAKCloudASCIIArt addLikedRecordIDToPrivateDatabase:_asciiart.recordID];
	
	// increment like counter
	[AAKCloudASCIIArt incrementLikeCounter:_asciiart.recordID completionBlock:^(CKRecord *record, NSError *operationError) {
		if (operationError == nil) {
			NSNumber *like = [record objectForKey:@"like"];
			self.likeLabel.text = like.stringValue;
		}
	}];
}

- (IBAction)download:(id)sender {
	[AAKCloudASCIIArt incrementDownloadCounter:_asciiart.recordID completionBlock:^(CKRecord *record, NSError *operationError) {
	}];
	AAKASCIIArt *newASCIIArt = [AAKASCIIArt MR_createEntity];
	newASCIIArt.text = _asciiart.ASCIIArt;
	newASCIIArt.group = [AAKASCIIArtGroup defaultGroup];
	
	[newASCIIArt updateLastUsedTime];
	[newASCIIArt updateRatio];
	
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil];
}

- (IBAction)sendReport:(id)sender {
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

- (void)queryCheckDidLikeEver {
	_didLikeEver = NO;
	
	CKDatabase *privateCloudDatabase = [[CKContainer defaultContainer] privateCloudDatabase];
	
	NSString *temp = [NSString stringWithFormat:@"likedRecordID BEGINSWITH '%@'", _asciiart.recordID.recordName];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:temp];
	CKQuery *query = [[CKQuery alloc] initWithRecordType:@"AAKCloudLikeHistory"
											   predicate:predicate];
	CKQueryOperation *op = [[CKQueryOperation alloc] initWithQuery:query];
	op.resultsLimit = 1;
	op.recordFetchedBlock = ^(CKRecord *record) {
		_didLikeEver = YES;
	};
	op.database = privateCloudDatabase;
	op.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.likeButton.enabled = !_didLikeEver;
		});
	};
	[_queue addOperation:op];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.titleLabel.text = _asciiart.title;
	self.likeLabel.text = @(_asciiart.like).stringValue;

	self.likeButton.enabled = NO;
	self.likeButton.hidden = YES;
	self.baseLikeView.hidden = YES;
	//[self queryCheckDidLikeEver];
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
