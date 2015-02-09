//
//  AAKRegisterViewController.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/22.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKEditViewController.h"

@interface AAKRegisterViewController : AAKEditViewController

/**
 * 現在選択されているグループオブジェクトの識別子をApp GroupのUserDefaultに保存する．
 **/
- (void)saveCurrentGroup;

/**
 * 最後に選択されたグループを取りだし，現在の保存先グループとしてセットする．
 **/
- (void)restoreCurrentGroup;

@end
