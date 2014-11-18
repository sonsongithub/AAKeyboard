//
//  AAKEditViewController.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/22.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AAKASCIIArt;
@class AAKASCIIArtGroup;

@interface AAKEditViewController : UIViewController {
	IBOutlet UISlider			*_fontSizeSlider;
	IBOutlet UITableView		*_groupTableView;
	IBOutlet NSLayoutConstraint *_bottomTextViewMargin;
}
@property (nonatomic, strong) IBOutlet UITextView *AATextView;

@property (nonatomic, strong) AAKASCIIArt *asciiart;
@property (nonatomic, strong) AAKASCIIArtGroup *group;

- (IBAction)didChangeSlider:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@end
