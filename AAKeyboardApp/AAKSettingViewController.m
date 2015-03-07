//
//  AAKSettingViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/19.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKSettingViewController.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AAKSettingViewController () <MFMailComposeViewControllerDelegate> {
	IBOutlet UILabel *_versionLabel;
	IBOutlet UILabel *_buildLabel;
}
@end

@implementation NSBundle(AAKSettingViewController)

+ (id)infoValueFromMainBundleForKey:(NSString*)key {
	if ([[[self mainBundle] localizedInfoDictionary] objectForKey:key])
		return [[[self mainBundle] localizedInfoDictionary] objectForKey:key];
	return [[[self mainBundle] infoDictionary] objectForKey:key];
}

@end

@implementation AAKSettingViewController

#pragma mark - Version informatin

- (NSString*)mailInformation {
	return [NSString stringWithFormat:NSLocalizedString(@"\n\nYour system's information ----------\n%@ %@.%@.%@\niOS %@\n Device %@", nil),
			[self name],
			[self versionAndBuildCondition],
			[self build],
			[self revision],
			[UIDevice currentDevice].systemVersion,
			[UIDeviceUtil hardwareDescription]];
}

- (NSString*)version {
	return [NSBundle infoValueFromMainBundleForKey:@"CFBundleShortVersionString"];
}

- (NSString*)versionAndBuildCondition {
	NSString *buildCharacter = @"";
#if defined(_DEBUG)
	buildCharacter = @"(Debug)";
#endif
	return [NSString stringWithFormat:@"%@%@", [NSBundle infoValueFromMainBundleForKey:@"CFBundleShortVersionString"], buildCharacter];
}

- (NSString*)revision {
	return [NSBundle infoValueFromMainBundleForKey:@"GitRevision"];
}

- (NSString*)name {
	return [NSBundle infoValueFromMainBundleForKey:@"CFBundleDisplayName"];
}

- (NSString*)build {
	return [NSBundle infoValueFromMainBundleForKey:@"CFBundleVersion"];
}

- (void)sendFeedbackMail {
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
		picker.mailComposeDelegate = self;
		
		[picker setSubject:[NSString stringWithFormat:NSLocalizedString(@"[%@ contact] ", nil), [NSBundle infoValueFromMainBundleForKey:@"CFBundleName"]]];
		[picker setToRecipients:[NSArray arrayWithObject:[NSBundle infoValueFromMainBundleForKey:@"SupportMailAddress"]]];
		
		NSString *body = [self mailInformation];
		[picker setMessageBody:body isHTML:NO];
		
		if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
			picker.modalPresentationStyle = UIModalPresentationFormSheet;
		[self presentViewController:picker animated:YES completion:^(void){}];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Mail error", nil)
														message:[NSString stringWithFormat:NSLocalizedString(@"%@ needs a mail account in order to send your report.", nil), [NSBundle infoValueFromMainBundleForKey:@"CFBundleName"]]
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
											  otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
		[alert show];
	}
}

#pragma mark - IBAction

- (IBAction)done:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openSettingApp:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Keyboard"]];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#if defined(_DEBUG)
	return 3;
#else
	return 2;
#endif
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 0 && indexPath.row == 5) {
		[self sendFeedbackMail];
	}
	if (indexPath.section == 1 && indexPath.row == 0) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
	}
	if (indexPath.section == 2 && indexPath.row == 0) {
		NSData *data = [AAKASCIIArt dataForJsonAllData];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *outputPath = [documentsDirectory stringByAppendingPathComponent:@"export_aa.json"];
		[data writeToFile:outputPath atomically:NO];
	}
}

#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	_versionLabel.text = [self versionAndBuildCondition];
	_buildLabel.text = [self revision];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error  {
	[self dismissViewControllerAnimated:YES completion:^(void){}];
}

@end