//
//  AAKHelpSelectViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/08.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAKHelpSelectViewController.h"

#import "AAKHelpViewController.h"

@interface AAKHelpSelectViewController ()

@end

@implementation AAKHelpSelectViewController

- (IBAction)close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	DNSLog(@"%@", indexPath);

	if ([segue.destinationViewController isKindOfClass:[AAKHelpViewController class]]) {
		AAKHelpViewController *vc = (AAKHelpViewController*)segue.destinationViewController;
		
		if (indexPath.section == 0 && indexPath.row == 0) {
			vc.helpIdentifier = @"setup";
		}
		if (indexPath.section == 1 && indexPath.row == 0) {
			vc.helpIdentifier = @"action";
		}
		if (indexPath.section == 1 && indexPath.row == 1) {
			vc.helpIdentifier = @"copy";
		}
		if (indexPath.section == 1 && indexPath.row == 2) {
			vc.helpIdentifier = @"app2tch";
		}
	}
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
