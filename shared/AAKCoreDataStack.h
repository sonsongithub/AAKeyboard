//
//  AAKCoreDataStack.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/18.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const AAKKeyboardDataManagerDidUpdateNotification;		/** データベースが更新された時に通知されるNotification */

@interface AAKCoreDataStack : NSObject

/**
 * 実行中のプロセスが共有データにアクセスできるかを判定する．
 * @return 共有データにアクセスできる場合は，YESを返す．
 **/
+ (BOOL)isOpenAccessGranted;

/**
 * 初回起動時のアスキーアートデータを生成し，CoreDataに入力する．
 **/
+ (void)addDefaultData;

/**
 * App GroupsのコンテナにCoreDataファイルを作成し，それを開く．
 **/
+ (void)setupMagicalRecordForAppGroupsContainer;

/**
 * プロセスのもつサンドボックスのドキュメントパスにCoreDataファイルを作成し，それを開く．
 **/
+ (void)setupMagicalRecordForLocal;

@end
