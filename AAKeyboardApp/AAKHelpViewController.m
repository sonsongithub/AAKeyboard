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
	NSInteger _numberOfPages;
	
	UIImageView *_imageView0;
	UIImageView *_imageView1;
	UIImageView *_imageView2;
	UIImageView *_imageView3;
	UIImageView *_imageView4;
}
@end

@implementation AAKHelpViewController

- (IBAction)close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateTileWithCurrentPage:(NSInteger)currentPage {
	_imageView0.hidden = (currentPage - 2 < 0);
	_imageView1.hidden = (currentPage - 1 < 0);
	_imageView2.hidden = NO;
	_imageView3.hidden = (currentPage + 1 >= _numberOfPages);
	_imageView4.hidden = (currentPage + 2 >= _numberOfPages);
	
	if (currentPage - 2 >= 0) {
		NSString *name = [NSString stringWithFormat:@"%@_ipad%03ld.png", self.helpIdentifier, currentPage - 2 + 1];
		UIImage *image = [UIImage imageNamed:name];
		_imageView0.image = image;
	}
	if (currentPage - 1 >= 0) {
		NSString *name = [NSString stringWithFormat:@"%@_ipad%03ld.png", self.helpIdentifier, currentPage - 1 + 1];
		UIImage *image = [UIImage imageNamed:name];
		_imageView1.image = image;
	}
	if (currentPage - 0 >= 0) {
		NSString *name = [NSString stringWithFormat:@"%@_ipad%03ld.png", self.helpIdentifier, currentPage + 0 + 1];
		UIImage *image = [UIImage imageNamed:name];
		_imageView2.image = image;
	}
	if (currentPage + 1 < _numberOfPages) {
		NSString *name = [NSString stringWithFormat:@"%@_ipad%03ld.png", self.helpIdentifier, currentPage + 1 + 1];
		UIImage *image = [UIImage imageNamed:name];
		_imageView3.image = image;
	}
	if (currentPage + 2 < _numberOfPages) {
		NSString *name = [NSString stringWithFormat:@"%@_ipad%03ld.png", self.helpIdentifier, currentPage + 2 + 1];
		UIImage *image = [UIImage imageNamed:name];
		_imageView4.image = image;
	}

	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_numberOfPages = 0;
	
	if ([self.helpIdentifier isEqualToString:@"setup"]) {
		_numberOfPages = 9;
	}
	if ([self.helpIdentifier isEqualToString:@"action"]) {
		_numberOfPages = 8;
	}
	if ([self.helpIdentifier isEqualToString:@"copy"]) {
		_numberOfPages = 6;
	}
	if ([self.helpIdentifier isEqualToString:@"app2tch"]) {
		_numberOfPages = 4;
	}
	if ([self.helpIdentifier isEqualToString:@"copyAsImage"]) {
		_numberOfPages = 5;
	}
	
	_scrollView.pagingEnabled = YES;
	self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
	_pageControl.numberOfPages = _numberOfPages;
	
	CGFloat offset = 10;
	
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		_contentWidth = 320 + offset * 2;
		_width.constant = 320 + offset * 2;
		_top.constant = -455;
		
		
//		for (NSInteger i = 0; i < numberOfPages; i++) {
//			UIImageView *v1 = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth * i, 0, contentWidth, 427)];
//			NSString *name = [NSString stringWithFormat:@"%@_ipad%03ld.png", self.helpIdentifier, i + 1];
//			v1.image = [UIImage imageNamed:name];
//			v1.contentMode = UIViewContentModeCenter;
//			[_scrollView addSubview:v1];
//		}
		_scrollView.contentSize = CGSizeMake(_contentWidth * _numberOfPages, 427);
		_scrollView.clipsToBounds = NO;
	}
	else {
		_contentWidth = 240 + offset * 2;
		_width.constant = _contentWidth;
		_top.constant = -455;
//		for (NSInteger i = 0; i < numberOfPages; i++) {
//			UIImageView *v1 = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth * i, 0, contentWidth, 427)];
//			NSString *name = [NSString stringWithFormat:@"%@%03ld.png", self.helpIdentifier, i + 1];
//			v1.image = [UIImage imageNamed:name];
//			v1.contentMode = UIViewContentModeCenter;
//			[_scrollView addSubview:v1];
//		}
		_scrollView.contentSize = CGSizeMake(_contentWidth * _numberOfPages, 427);
		_scrollView.clipsToBounds = NO;
	}
	
	_imageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth * -2, 0, _contentWidth, 427)];
	_imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth * -1, 0, _contentWidth, 427)];
	_imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth *  0, 0, _contentWidth, 427)];
	_imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth *  1, 0, _contentWidth, 427)];
	_imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth *  2, 0, _contentWidth, 427)];
	
	_imageView0.contentMode = UIViewContentModeCenter;
	_imageView1.contentMode = UIViewContentModeCenter;
	_imageView2.contentMode = UIViewContentModeCenter;
	_imageView3.contentMode = UIViewContentModeCenter;
	_imageView4.contentMode = UIViewContentModeCenter;
	
	[_scrollView addSubview:_imageView0];
	[_scrollView addSubview:_imageView1];
	[_scrollView addSubview:_imageView2];
	[_scrollView addSubview:_imageView3];
	[_scrollView addSubview:_imageView4];
	
	[self updateTileWithCurrentPage:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	_pageControl.currentPage = (NSInteger)scrollView.contentOffset.x / (NSInteger)_contentWidth;
	[self updateTileWithCurrentPage:_pageControl.currentPage];
}

@end
