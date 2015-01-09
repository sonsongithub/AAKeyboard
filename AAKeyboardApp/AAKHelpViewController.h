//
//  AAKHelpViewController.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/12/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAKHelpViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet NSLayoutConstraint *_top;
	IBOutlet NSLayoutConstraint *_width;
	IBOutlet UIScrollView *_scrollView;
	IBOutlet UIPageControl *_pageControl;
	IBOutlet UILabel *_descriptionLabel;
}
@property (nonatomic, copy) NSString *helpIdentifier;
@end
