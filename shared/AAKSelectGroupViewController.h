//
//  AAKSelectGroupViewController.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/15.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionViewController;
@class AAKEditViewController;

@interface AAKSelectGroupViewController : UITableViewController

@property (nonatomic, assign) AAKEditViewController *editViewController;		/** 編集ビューコントローラ．変更したグループを設定するためにセットする．コードが汚い．*/

@end
