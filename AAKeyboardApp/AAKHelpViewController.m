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

	CGSize _imageSize;
	
	IBOutlet NSLayoutConstraint *_imageWidth;
	IBOutlet NSLayoutConstraint *_imageHeight;
	IBOutlet UIScrollView *_scrollView;
	IBOutlet UIPageControl *_pageControl;
	IBOutlet UILabel *_descriptionLabel;
	IBOutlet NSLayoutConstraint *_scrollViewWidth;
	IBOutlet NSLayoutConstraint *_scrollViewHeight;
	
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
			_imageView0.frame = CGRectMake(_contentWidth * (currentPage + 2), 0, _contentWidth, _imageSize.height);
			_imageView0 = _imageViews[1];
			_imageView1 = _imageViews[2];
			_imageView2 = _imageViews[3];
			_imageView3 = _imageViews[4];
			_imageView4 = _imageViews[0];
			_imageView4.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], (long)(currentPage + 3)]];
		}
		else {
			_imageView4.frame = CGRectMake(_contentWidth * (currentPage - 2), 0, _contentWidth, _imageSize.height);
			_imageView0 = _imageViews[4];
			_imageView1 = _imageViews[0];
			_imageView2 = _imageViews[1];
			_imageView3 = _imageViews[2];
			_imageView4 = _imageViews[3];
			_imageView0.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], (long)(currentPage - 1)]];
		}
	}
	_currentPage = currentPage;
	
	_descriptionLabel.text = _descriptions[_currentPage];
	_descriptionLabel.numberOfLines = 5;
	_descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
	_descriptionLabel.font = [UIFont systemFontOfSize:12];
	
	_imageView0.hidden = (_currentPage - 2 < 0);
	_imageView1.hidden = (_currentPage - 1 < 0);
	_imageView2.hidden = NO;
	_imageView3.hidden = (_currentPage + 1 >= _numberOfPages);
	_imageView4.hidden = (_currentPage + 2 >= _numberOfPages);
	
	_imageViews = @[_imageView0, _imageView1, _imageView2, _imageView3, _imageView4];
	
	if (_imageView0.image == nil && _currentPage - 1 > 0)
		_imageView0.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], (long)(_currentPage - 1)]];
	if (_imageView1.image == nil && _currentPage > 0)
		_imageView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], (long)(_currentPage    )]];
	if (_imageView2.image == nil && _currentPage + 1 > 0)
		_imageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], (long)(_currentPage + 1)]];
	if (_imageView3.image == nil && _currentPage + 2 > 0)
		_imageView3.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], (long)(_currentPage + 2)]];
	if (_imageView4.image == nil && _currentPage + 3 > 0)
		_imageView4.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], (long)(_currentPage + 3)]];
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
						  NSLocalizedString(@"At first, run Setting.app.", nil),
						  NSLocalizedString(@"Tap 'General'.", nil),
						  NSLocalizedString(@"Tap 'Keyboard'.", nil),
						  NSLocalizedString(@"Tap 'Keyboard', again.", nil),
						  NSLocalizedString(@"Tap 'Add new keyboard...' if you have not added AAKeyboard into your keyboards.", nil),
						  NSLocalizedString(@"Tap 'AAKeyboard' in order to enable to use AAKeyboard.", nil),
						  NSLocalizedString(@"And then, turn on 'Full access' of AAKeyboard in order to handle all functions of AAKeyboard.app.", nil),
						  NSLocalizedString(@"Turn on 'Full access' on this view for enabling all functions. AAKeyboard.app needs 'Full access' in order to save ascii art into the database. AAKeyboard.app does not access any other your private data.", nil),
						  NSLocalizedString(@"After turning on it, confirm this alert message which will be shown. Anyway, you can use minimum functions without turning on it.", nil)
						  ];
	}
	if ([self.helpIdentifier isEqualToString:@"action"]) {
		_descriptions = @[
						  NSLocalizedString(@"Let me give Safari.app as an example.", nil),
						  NSLocalizedString(@"Select text you want to register as ascii art.", nil),
						  NSLocalizedString(@"And then, tap action button on the bottom toolbar.", nil),
						  NSLocalizedString(@"Tap 'other' if you have never used this action.", nil),
						  NSLocalizedString(@"Enable 'Register AA' among the list. And then, 'Register AA' item will be shown in the action list.", nil),
						  NSLocalizedString(@"Tap 'Register AA'", nil),
						  NSLocalizedString(@"View to register your favorite AA will be opened.", nil)
						  ];
	}
	if ([self.helpIdentifier isEqualToString:@"copy"]) {
		_descriptions = @[
						  NSLocalizedString(@"Let me give twinkle.app as an example, run twinkle.app.", nil),
						  NSLocalizedString(@"Open the thread which contains your favorite AA. Long tap on AA and then view to select your action will be shown.", nil),
						  NSLocalizedString(@"Select 'Copy body' and quit twinkle.app.", nil),
						  NSLocalizedString(@"Run AAKeyboard.app.", nil),
						  NSLocalizedString(@"Tap 'clipboard' button on the bottom toolbar.", nil),
						  NSLocalizedString(@"View to register your favorite AA will be opened.", nil)
						  ];
	}
	if ([self.helpIdentifier isEqualToString:@"app2tch"]) {
		_descriptions = @[
						  NSLocalizedString(@"Run 2tch.app.", nil),
						  NSLocalizedString(@"Open the thread which contains your favorite AA. Tap the information area(red region).", nil),
						  NSLocalizedString(@"Popup menu will be shown and then tap 'Register AA' item.", nil),
						  NSLocalizedString(@"Automatically, AAKeyboard.app will be active instead of 2tch.app and view to register your favorite AA will be opened.", nil)
						  ];
	}
	if ([self.helpIdentifier isEqualToString:@"copyAsImage"]) {
		_descriptions = @[
						  NSLocalizedString(@"Let me give Notes.app as an example.", nil),
						  NSLocalizedString(@"Long tap on AA which you want to input.", nil),
						  NSLocalizedString(@"AA is copied to clipboard, and then message will be shown over the keyboard.", nil),
						  NSLocalizedString(@"Open popup menu on Notes.app.", nil),
						  NSLocalizedString(@"You can paste the image of AA to Notes.app. As well as Message.app, you can do it.", nil)
						  ];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// setup help pages
	_numberOfPages = [self helpPagesForHelpIndentifier];
	
	// get descriptions for each page
	[self setupDescriptions];

	_scrollView.pagingEnabled = YES;
	self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
	_pageControl.numberOfPages = _numberOfPages;
	
	// get image size
	UIImage *sample = [UIImage imageNamed:[NSString stringWithFormat:@"%@%03ld.png", [self fileName], (long)1]];
	
	CGFloat offset = 10;
	_imageSize = sample.size;
	
	if (_imageSize.height > self.view.frame.size.height - 150) {
		_imageSize.width = floor(_imageSize.width * (self.view.frame.size.height - 150) / _imageSize.height);
		_imageSize.height = floor(self.view.frame.size.height - 150);
	}
	
	_imageHeight.constant = _imageSize.height;
	_imageWidth.constant = _imageSize.width + offset * 2;
	_contentWidth = _imageSize.width + offset * 2;
	_scrollView.contentSize = CGSizeMake(_contentWidth * _numberOfPages, _imageSize.height);
	_scrollView.clipsToBounds = NO;
	
	_imageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth * -2, 0, _contentWidth, _imageSize.height)];
	_imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth * -1, 0, _contentWidth, _imageSize.height)];
	_imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth *  0, 0, _contentWidth, _imageSize.height)];
	_imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth *  1, 0, _contentWidth, _imageSize.height)];
	_imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(_contentWidth *  2, 0, _contentWidth, _imageSize.height)];
	
	_imageViews = @[_imageView0, _imageView1, _imageView2, _imageView3, _imageView4];
	
	for (UIImageView *v in _imageViews)
		v.contentMode = UIViewContentModeScaleAspectFit;
	
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
