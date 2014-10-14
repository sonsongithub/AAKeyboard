//
//  AAKSQLite.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/15.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAKSQLite : NSObject

/**
 * シングルトンモデルで利用するAAKSSQLiteオブジェクトを返す．
 * このメソッド以外からAAKSSQLiteオブジェクトを生成してはならない．
 * @return AAKSSQLiteオブジェクト．シングルトンモデル．
 */
+ (AAKSQLite*)sharedInstance;

@end
