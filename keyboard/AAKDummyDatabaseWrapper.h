//
//  AAKDummyDatabaseWrapper.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/17.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAKDummyDatabaseWrapper : NSObject

/**
 * 実行中のプロセスが共有データにアクセスできるかを判定する．
 * @return 共有データにアクセスできる場合は，YESを返す．
 **/
+ (BOOL)isOpenAccessGranted;

@end
