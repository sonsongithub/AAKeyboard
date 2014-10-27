//
//  AAKKeyboardDataManager.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/20.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

@class AAKASCIIArt;
@class AAKASCIIArtGroup;

extern NSString *const AAKKeyboardDataManagerDidCreateNewGroupNotification __attribute((deprecated("Use AAKKeyboardDataManagerDidUpdateNotification instaed")));
extern NSString *const AAKKeyboardDataManagerDidUpdateNotification;

@interface AAKKeyboardDataManager : NSObject {
	sqlite3 *_database;
}

+ (AAKKeyboardDataManager*)defaultManager;

/**
 * AAKSSQLiteオブジェクトのトランザクションを開始する．
 */
- (void)beginTransaction;

/**
 * AAKSSQLiteオブジェクトのトランザクションをコミット，終了する．
 */
- (void)commitTransaction;

/**
 * テーブルを作成する．
 */
- (void)initializeDatabaseTable;

#pragma mark - Group

/**
 * グループ一覧を作成する．AAが登録されていないグループは含まれない．
 * @return グループ名の配列．
 **/
- (NSArray*)groups;

/**
 * すべてのグループ一覧を作成する．
 * @return グループ名の配列．
 **/
- (NSArray*)allGroups;

/**
 * 新しいグループを作成する．
 * @param group 新しいグループ名の文字列．
 **/
- (void)insertNewGroup:(NSString*)group;

/**
 * 新しいAAを追加する．
 * @param asciiArt アスキーアート本体．文字列．
 * @param group アスキーアートのグループのSQLiteデータベースのキー．
 **/
- (void)insertNewASCIIArt:(NSString*)asciiArt groupKey:(NSInteger)groupKey;

/**
 * groupに対応するのAAのリストを取得する．
 * @param group AAリストを取得したいグループ．
 **/
- (NSArray*)asciiArtForGroup:(AAKASCIIArtGroup*)group;

/**
 * 履歴を追加する．
 * @param asciiArt アスキーアートの文字列．
 * @param key アスキーアートのデータベース上でのキー．
 **/
- (void)insertHistoryASCIIArtKey:(NSInteger)key;

/**
 * AAを更新する．
 * @param asciiArt アスキーアートオブジェクト．
 * @param group アスキーアートグループオブジェクト．
 **/
- (BOOL)updateASCIIArt:(AAKASCIIArt*)asciiArt group:(AAKASCIIArtGroup*)group;

@end
