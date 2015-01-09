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
	NSInteger _currentPage;
	
	UIImageView *_imageView0;
	UIImageView *_imageView1;
	UIImageView *_imageView2;
	UIImageView *_imageView3;
	UIImageView *_imageView4;
	NSArray	*_imageViews;
	NSArray *_descriptions;
}
@end

@implementation AAKHelpViewController

- (IBAction)close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)controlImageViewAlpha {
	CGPoint b = _scrollView.center;
	for (UIImageView *v in _imageViews) {
		CGPoint p = [_scrollView.superview convertPoint:v.center fromView:_scrollView];
		v.alpha = 1 - pow(fabs(b.x - p.x)/350, 2);
	}
}

- (void)updateTileWithPage:(NSInteger)currentPage {
	
	if (currentPage == _currentPage)
		return;
	if (_currentPage >= 0) {
		if (currentPage > _currentPage) {
			_imageView0.frame = CGRectMake(_contentWidth * (currentPage + 2), 0, _contentWidth, 427);
			_imageView0 = _imageViews[1];
			_imageView1 = _imageViews[2];
			_imageView2 = _imageViews[3];
			_imageView3 = _imageViews[4];
			_imageView4 = _imageViews[0];
			_imageView4.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], currentPage + 3]];
		}
		else {
			_imageView4.frame = CGRectMake(_contentWidth * (currentPage - 2), 0, _contentWidth, 427);
			_imageView0 = _imageViews[4];
			_imageView1 = _imageViews[0];
			_imageView2 = _imageViews[1];
			_imageView3 = _imageViews[2];
			_imageView4 = _imageViews[3];
			_imageView0.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], currentPage - 1]];
		}
	}
	_currentPage = currentPage;
	
	_descriptionLabel.text = _descriptions[_currentPage];
	
	_imageView0.hidden = (_currentPage - 2 < 0);
	_imageView1.hidden = (_currentPage - 1 < 0);
	_imageView2.hidden = NO;
	_imageView3.hidden = (_currentPage + 1 >= _numberOfPages);
	_imageView4.hidden = (_currentPage + 2 >= _numberOfPages);
	
	_imageViews = @[_imageView0, _imageView1, _imageView2, _imageView3, _imageView4];
	
	if (_imageView0.image == nil && _currentPage - 1 > 0)
		_imageView0.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], _currentPage - 1]];
	if (_imageView1.image == nil && _currentPage > 0)
		_imageView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], _currentPage    ]];
	if (_imageView2.image == nil && _currentPage + 1 > 0)
		_imageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], _currentPage + 1]];
	if (_imageView3.image == nil && _currentPage + 2 > 0)
		_imageView3.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], _currentPage + 2]];
	if (_imageView4.image == nil && _currentPage + 3 > 0)
		_imageView4.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], _currentPage + 3]];
}

- (NSString*)fileName {
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
		return [NSString stringWithFormat:@"%@_ipad", self.helpIdentifier];
	else
		return [NSString stringWithFormat:@"%@", self.helpIdentifier];
}

- (NSInteger)helpPagesForHelpIndentifier {
	if ([self.helpIdentifier isEqualToString:@"setup"])
		return 9;
	if ([self.helpIdentifier isEqualToString:@"action"])
		return 7;
	if ([self.helpIdentifier isEqualToString:@"copy"])
		return 6;
	if ([self.helpIdentifier isEqualToString:@"app2tch"])
		return 4;
	if ([self.helpIdentifier isEqualToString:@"copyAsImage"])
		return 5;
	return 0;
}

- (void)setupDescriptions {
	if ([self.helpIdentifier isEqualToString:@"setup"]) {
		_descriptions = @[
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil)
						  ];
	}
	if ([self.helpIdentifier isEqualToString:@"action"]) {
		_descriptions = @[
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil)
						  ];
	}
	if ([self.helpIdentifier isEqualToString:@"copy"]) {
		_descriptions = @[
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil)
						  ];
	}
	if ([self.helpIdentifier isEqualToString:@"app2tch"]) {
		_descriptions = @[
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil)
						  ];
	}
	if ([self.helpIdentifier isEqualToString:@"copyAsImage"]) {
		_descriptions = @[
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil),
						  NSLocalizedString(@"hoge", nil)
						  ];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_numberOfPages = [self helpPagesForHelpIndentifier];
	
	[self setupDescriptions];

	_scrollView.pagingEnabled = YES;
	self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
	_pageControl.numberOfPages = _numberOfPages;
	
	CGFloat offset = 10;
	
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		_contentWidth = 320 + offset * 2;
		_width.constant = 320 + offset * 2;
		_top.constant = -455;
	}
	else {
		_contentWidth = 240 + offset * 2;
		_width.constant = _contentWidth;
		_top.constant = -455;
	}

	_scrollView.contentSize = CGSizeMake(_contentWidth * _numberOfPages, 427);
	_scrollView.clipsToBounds = NO;
	
	_imageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth * -2, 0, _contentWidth, 427)];
	_imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth * -1, 0, _contentWidth, 427)];
	_imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth *  0, 0, _contentWidth, 427)];
	_imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth *  1, 0, _contentWidth, 427)];
	_imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth *  2, 0, _contentWidth, 427)];
	
	_imageViews = @[_imageView0, _imageView1, _imageView2, _imageView3, _imageView4];
	
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
	
	_currentPage = -1;
	[self updateTileWithPage:0];
	[self controlImageViewAlpha];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	_pageControl.currentPage = (NSInteger)scrollView.contentOffset.x / (NSInteger)_contentWidth;
	[self updateTileWithPage:_pageControl.currentPage];
	
	
	[self controlImageViewAlpha];
}

@end
