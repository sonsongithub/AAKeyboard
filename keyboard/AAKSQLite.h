//
//  AAKSQLite.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/15.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const AAKSQLiteDidCreateNewGroupNotification;

@interface AAKSQLite : NSObject

/**
 * シングルトンモデルで利用するAAKSSQLiteオブジェクトを返す．
 * このメソッド以外からAAKSSQLiteオブジェクトを生成してはならない．
 * @return AAKSSQLiteオブジェクト．シングルトンモデル．
 */
+ (AAKSQLite*)sharedInstance;

- (NSArray*)groups;
- (void)insertNewGroup:(NSString*)group;

/**
 * 新しいAAを追加する．
 * @param asciiArt アスキーアート本体．文字列．
 * @param group アスキーアートのグループのSQLiteデータベースのキー．
 **/
- (void)insertNewASCIIArt:(NSString*)asciiArt groupKey:(NSInteger)groupKey;

@end
