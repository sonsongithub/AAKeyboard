//
//  AAKHelpViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/12/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKHelpViewController.h"

@interface AAKHelpViewController ()

@end

@implementation AAKHelpViewController

- (IBAction)close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSInteger numberOfPages = 0;
	
	if ([self.helpIdentifier isEqualToString:@"setup"]) {
		numberOfPages = 9;
	}
	if ([self.helpIdentifier isEqualToString:@"action"]) {
		numberOfPages = 8;
	}
	if ([self.helpIdentifier isEqualToString:@"copy"]) {
		numberOfPages = 6;
	}
	if ([self.helpIdentifier isEqualToString:@"app2tch"]) {
		numberOfPages = 4;
	}
	
	
	_scrollView.pagingEnabled = YES;
	self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
	
	CGFloat offset = 10;
	
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		CGFloat contentWidth = 320 + offset * 2;
		_width.constant = 320 + offset * 2;
		_top.constant = -455;
		for (NSInteger i = 0; i < numberOfPages; i++) {
			UIImageView *v1 = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth * i, 0, contentWidth, 427)];
			NSString *name = [NSString stringWithFormat:@"%@_ipad%03ld.png", self.helpIdentifier, i + 1];
			v1.image = [UIImage imageNamed:name];
			v1.contentMode = UIViewContentModeCenter;
			[_scrollView addSubview:v1];
		}
		_scrollView.contentSize = CGSizeMake(contentWidth * numberOfPages, 427);
		_scrollView.clipsToBounds = NO;
	}
	else {
		CGFloat contentWidth = 240 + offset * 2;
		_width.constant = contentWidth;
		_top.constant = -328;
		for (NSInteger i = 0; i < numberOfPages; i++) {
			UIImageView *v1 = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth * i, 0, contentWidth, 427)];
			NSString *name = [NSString stringWithFormat:@"%@%03ld.png", self.helpIdentifier, i + 1];
			v1.image = [UIImage imageNamed:name];
			v1.contentMode = UIViewContentModeCenter;
			[_scrollView addSubview:v1];
		}
		_scrollView.contentSize = CGSizeMake(contentWidth * numberOfPages, 427);
		_scrollView.clipsToBounds = NO;
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
