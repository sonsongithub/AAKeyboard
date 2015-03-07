//
//  AAKGroupRenameViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/25.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKGroupRenameViewController.h"

@interface AAKGroupRenameViewController () {
	IBOutlet UITextField *_renameField;
}
@end

@implementation AAKGroupRenameViewController

- (IBAction)save:(id)sender {
	NSString *newGroupTitle = _renameField.text;
	
	if ([AAKASCIIArtGroup MR_countOfEntitiesWithPredicate:[NSPredicate predicateWithFormat:@"title = %@", newGroupTitle]] == 0) {
		_group.title = newGroupTitle;
		[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
		[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil];
		[self.navigationController popViewControllerAnimated:YES];
	}
	else {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
																	   message:NSLocalizedString(@"The name has been already used by the other group.", nil)
																preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
														 style:UIAlertActionStyleDefault
													   handler:^(UIAlertAction *action) {
													   }];
		[alert addAction:action];
		[self presentViewController:alert
						   animated:YES
						 completion:^{
						 }];
		_renameField.text = _group.title;
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	_renameField.text = _group.title;
}

@end
