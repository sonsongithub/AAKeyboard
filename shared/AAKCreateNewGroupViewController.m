//
//  AAKCreateNewGroupViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/15.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKCreateNewGroupViewController.h"

#import "AAKKeyboardDataManager.h"

#import "AAKASCIIArtGroup.h"

@interface AAKCreateNewGroupViewController () {
	IBOutlet UITextField *_newGroupTextField;
}
@end

@implementation AAKCreateNewGroupViewController

- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)create:(id)sender {
	NSString *newGroupTitle = _newGroupTextField.text;
	AAKASCIIArtGroup *newGroup = [AAKASCIIArtGroup MR_createEntity];
	newGroup.title = newGroupTitle;
	newGroup.type = AAKASCIIArtNormalGroup;
	newGroup.order = 0;
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
	[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
