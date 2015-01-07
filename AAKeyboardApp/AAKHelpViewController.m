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
	
	_scrollView.pagingEnabled = YES;
	
	
	CGFloat offset = 10;
	
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		CGFloat contentWidth = 320 + offset * 2;
		_width.constant = 320 + offset * 2;
		_top.constant = -455;
		{
			UIImageView *v1 = [[UIImageView alloc] initWithFrame:CGRectMake(  0, 0, contentWidth, 427)];
			v1.image = [UIImage imageNamed:@"app2tch_ipad001.png"];
			v1.contentMode = UIViewContentModeCenter;
			[_scrollView addSubview:v1];
			UIImageView *v2 = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth, 0, contentWidth, 427)];
			v2.image = [UIImage imageNamed:@"app2tch_ipad002.png"];
			v2.contentMode = UIViewContentModeCenter;
			[_scrollView addSubview:v2];
			_scrollView.contentSize = CGSizeMake(contentWidth * 2, 427);
		}
		_scrollView.clipsToBounds = NO;
	}
	else {
		_width.constant = 280;
		_top.constant = -328;
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
