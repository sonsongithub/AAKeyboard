//
//  AAKSettingViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/19.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKSettingViewController.h"

@interface AAKSettingViewController ()

@end

@implementation AAKSettingViewController

- (IBAction)done:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)openSettingApp:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Keyboard"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 2) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end