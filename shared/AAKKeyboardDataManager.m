//
//  AAKKeyboardDataManager.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/20.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKKeyboardDataManager.h"

#import "AAKASCIIArtGroup.h"
#import "AAKASCIIArt.h"
#import "AAKHelper.h"
#import "AAKLocalKeyboardDataManager.h"
#import "AAKSharedKeyboardDataManager.h"

NSString *const AAKKeyboardDataManagerDidUpdateNotification			= @"AAKKeyboardDataManagerDidUpdateNotification";

static AAKKeyboardDataManager *sharedKeyboardDataManager = nil;

@implementation AAKKeyboardDataManager

/**
 * シングルトンぽく扱うAAKKeyboardDataManagerクラスを生成，アクセスする．
 * 実行中のプロセスが共有データにアクセスできない場合は，ローカルのドキュメントパスにSQLiteのデータベースを生成し，それを利用する．
 * @return AAKKeyboardDataManagerオブジェクトを返す．
 **/
+ (AAKKeyboardDataManager*)defaultManager {
	if (sharedKeyboardDataManager == nil) {
		if ([AAKKeyboardDataManager isOpenAccessGranted]) {
			sharedKeyboardDataManager = [[AAKSharedKeyboardDataManager alloc] init];
		}
		else {
			sharedKeyboardDataManager = [[AAKLocalKeyboardDataManager alloc] init];
		}
	}
	return sharedKeyboardDataManager;
}

/**
 * 実行中のプロセスが共有データにアクセスできるかを判定する．
 * @return 共有データにアクセスできる場合は，YESを返す．
 **/
+ (BOOL)isOpenAccessGranted {
	NSError *error = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *containerPath = [[fm containerURLForSecurityApplicationGroupIdentifier:@"group.com.sonson.AAKeyboardApp"] path];
	
	[fm contentsOfDirectoryAtPath:containerPath error:&error];
	
	if(error != nil){
		DNSLog(@"Full Access: Off , %@", [error localizedDescription]);
		return NO;
	}
	
	DNSLog(@"Full Access On");
	return YES;
}

/**
 * AAKSSQLiteオブジェクトのトランザクションを開始する．
 */
- (void)beginTransaction {
	sqlite3_exec(_database, "BEGIN", NULL, NULL, NULL);
}

/**
 * AAKSSQLiteオブジェクトのトランザクションをコミット，終了する．
 */
- (void)commitTransaction {
	sqlite3_exec(_database, "COMMIT", NULL, NULL, NULL);
	sqlite3_exec(_database, "END", NULL, NULL, NULL);
}

/**
 * テーブルを作成する．
 */
- (void)initializeDatabaseTable {
}

#pragma mark - Group


/**
 * すべてのグループ一覧を作成する．
 * @return グループ名の配列．
 **/
- (NSArray*)allGroups {
	return nil;
}

/**
 * AAが登録されているグループ一覧を作成する．
 * @return グループ名の配列．
 **/
- (NSArray*)groups {
	return nil;
}

/**
 * AAが登録されているグループ一覧を作成する．
 * @return グループ名の配列．
 **/
- (NSArray*)groupsWithoutHistory {
	return nil;
}

/**
 * 新しいグループを作成する．
 * @param group 新しいグループ名の文字列．
 **/
- (void)insertNewGroup:(NSString*)group {
}

/**
 * 新しいAAを追加する．
 * @param asciiArt アスキーアート本体．文字列．
 * @param groupKey アスキーアートのグループのSQLiteデータベースのキー．
 **/
- (void)insertNewASCIIArt:(NSString*)asciiArt groupKey:(NSInteger)groupKey {
}

/**
 * AAをコピーする
 **/
- (void)duplicateASCIIArt:(NSInteger)asciiArtKey {
}

/**
 * 最近使用したAAのリストを返す．
 * @return 最近使用したAAのリスト．NSArrayオブジェクト．
 **/
- (NSArray*)asciiArtHistory {
	return nil;
}

/**
 * 指定されたAAKASCIIArtGroupオブジェクトが指定するgroupに含まれるAAのリストを取得する．
 * 履歴グループが渡されたときは，最近の履歴を返す．
 * @param group AAリストを取得したいグループ．
 * @return AAのリスト．NSArrayオブジェクト．
 **/
- (NSArray*)asciiArtForGroup:(AAKASCIIArtGroup*)group {
	return nil;
}

/**
 * 履歴を追加する．
 * @param key アスキーアートのデータベース上でのキー．
 **/
- (void)insertHistoryASCIIArtKey:(NSInteger)key {
}

/**
 * AAを更新する．
 * @param asciiArt アスキーアートオブジェクト．
 * @return 削除に成功した場合にYESを返す．（未実装）
 **/
- (BOOL)updateASCIIArt:(AAKASCIIArt*)asciiArt {
	return NO;
}

/**
 * グループの順番を更新する．
 * @param group グループオブジェクト．
 * @return 削除に成功した場合にYESを返す．（未実装）
 **/
- (BOOL)updateASCIIArtGroup:(AAKASCIIArtGroup*)group {
	return NO;
}

/**
 * AAを削除する．
 * @param asciiArt 削除したいアスキーアートオブジェクト．
 * @return 削除に成功した場合にYESを返す．（未実装）
 **/
- (BOOL)deleteASCIIArt:(AAKASCIIArt*)asciiArt {
	return NO;
}

/**
 * 特定のグループのアスキーアートをDefaultグループに移動する．
 * @param group グループオブジェクト．
 * @return 削除に成功した場合にYESを返す．（未実装）
 **/
- (BOOL)moveToDefaultGroupFromASCIIArtGroup:(AAKASCIIArtGroup*)group {
	return NO;
}

/**
 * グループを削除する．
 * @param group アスキーアートグループ
 * @return 削除に成功した場合にYESを返す．（未実装）
 **/
- (BOOL)deleteASCIIArtGroup:(AAKASCIIArtGroup*)group {
	return NO;
}

@end
