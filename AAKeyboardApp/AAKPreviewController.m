//
//  AAKPreviewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/30.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKPreviewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface AAKPreviewController () {
}

@end

@implementation AAKPreviewController

- (AAKContent*)content {
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
													   [AAKCloudASCIIArt uploadAA:_asciiart.text title:field.text];
												   }];
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
													 style:UIAlertActionStyleDefault
												   handler:nil];
	[alert addTextFieldWithConfigurationHandler:nil];
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
	
	// UI for CloudKit
#if !ENABLE_CLOUDKIT
	self.uploadButton.hidden = YES;
#endif
	
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
