//
//  AAKHelpViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/12/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKHelpViewController.h"

@interface AAKHelpViewController () {
	CGFloat _contentWidth;
}
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
	if ([self.helpIdentifier isEqualToString:@"copyAsImage"]) {
		numberOfPages = 5;
	}
	
	_scrollView.pagingEnabled = YES;
	self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
	_pageControl.numberOfPages = numberOfPages;
	
	CGFloat offset = 10;
	
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		CGFloat contentWidth = 320 + offset * 2;
		_contentWidth = contentWidth;
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
		_contentWidth = contentWidth;
		_width.constant = contentWidth;
		_top.constant = -455;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	_pageControl.currentPage = (NSInteger)scrollView.contentOffset.x / (NSInteger)_contentWidth;
}

@end
