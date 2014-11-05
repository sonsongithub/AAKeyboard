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

extern NSString *const AAKKeyboardDataManagerDidUpdateNotification;		/** データベースが更新された時に通知されるNotification */

@interface AAKKeyboardDataManager : NSObject {
	sqlite3 *_database;
}

/**
 * シングルトンぽく扱うAAKKeyboardDataManagerクラスを生成，アクセスする．
 * 実行中のプロセスが共有データにアクセスできない場合は，ローカルのドキュメントパスにSQLiteのデータベースを生成し，それを利用する．
 * @return AAKKeyboardDataManagerオブジェクトを返す．
 **/
+ (AAKKeyboardDataManager*)defaultManager;

/**
 * 実行中のプロセスが共有データにアクセスできるかを判定する．
 * @return 共有データにアクセスできる場合は，YESを返す．
 **/
+ (BOOL)isOpenAccessGranted;

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
 * すべてのグループ一覧を作成する．
 * @return グループ名の配列．
 **/
- (NSArray*)allGroups;

/**
 * AAが登録されているグループ一覧を作成する．
 * @return グループ名の配列．
 **/
- (NSArray*)groups;

/**
 * 新しいグループを作成する．
 * @param group 新しいグループ名の文字列．
 **/
- (void)insertNewGroup:(NSString*)group;

/**
 * 新しいAAを追加する．
 * @param asciiArt アスキーアート本体．文字列．
 * @param groupKey アスキーアートのグループのSQLiteデータベースのキー．
 **/
- (void)insertNewASCIIArt:(NSString*)asciiArt groupKey:(NSInteger)groupKey;

/**
 * AAをコピーする
 **/
- (void)duplicateASCIIArt:(NSInteger)asciiArtKey;

/**
 * 最近使用したAAのリストを返す．
 * @return 最近使用したAAのリスト．NSArrayオブジェクト．
 **/
- (NSArray*)asciiArtHistory;

/**
 * 指定されたAAKASCIIArtGroupオブジェクトが指定するgroupに含まれるAAのリストを取得する．
 * 履歴グループが渡されたときは，最近の履歴を返す．
 * @param group AAリストを取得したいグループ．
 * @return AAのリスト．NSArrayオブジェクト．
 **/
- (NSArray*)asciiArtForGroup:(AAKASCIIArtGroup*)group;

/**
 * 履歴を追加する．
 * @param key アスキーアートのデータベース上でのキー．
 **/
- (void)insertHistoryASCIIArtKey:(NSInteger)key;

/**
 * AAを更新する．
 * @param asciiArt アスキーアートオブジェクト．
 * @return 削除に成功した場合にYESを返す．（未実装）
 **/
- (BOOL)updateASCIIArt:(AAKASCIIArt*)asciiArt;

/**
 * AAを削除する．
 * @param asciiArt 削除したいアスキーアートオブジェクト．
 * @return 削除に成功した場合にYESを返す．（未実装）
 **/
- (BOOL)deleteASCIIArt:(AAKASCIIArt*)asciiArt;

@end
