//
//  ViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/06.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "ViewController.h"
#import "DummyKeyboardViewController.h"

@interface ViewController () {
}
@end

@implementation ViewController

- (UITraitCollection *)overrideTraitCollectionForChildViewController:(UIViewController *)childViewController {
	return self.traitCollection;
}

- (void)keyboardDidChangeFrameNotification:(NSNotification*)notification {
	NSValue *value = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect rect = [value CGRectValue];
	NSLog(@"%f,%f,%f,%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrameNotification:) name:UIKeyboardDidChangeFrameNotification object:nil];
	
	
	DummyKeyboardViewController *controller = [[DummyKeyboardViewController alloc] init];
	[self addChildViewController:controller];
	[self.view addSubview:controller.view];
}

@end
