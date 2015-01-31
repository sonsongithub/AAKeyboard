//
//  AAKCloudSendReportViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/02/01.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAKCloudSendReportViewController.h"

@interface AAKCloudSendReportViewController() <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constraint;

@end

@implementation AAKCloudSendReportViewController

- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)send:(id)sender {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0)
		return 120;
	else if (indexPath.section == 1)
		return 44;
	else
		return 200;
}

@end
