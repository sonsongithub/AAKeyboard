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

NSString *const AAKKeyboardDataManagerDidCreateNewGroupNotification = @"AAKKeyboardDataManagerDidCreateNewGroupNotification";

static AAKKeyboardDataManager *sharedKeyboardDataManager = nil;

@implementation AAKKeyboardDataManager

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
}

/**
 * AAKSSQLiteオブジェクトのトランザクションをコミット，終了する．
 */
- (void)commitTransaction {
}

/**
 * テーブルを作成する．
 */
- (void)initializeDatabaseTable {
}

#pragma mark - Group

/**
 * グループ一覧を作成する．
 * @return グループ名の配列．
 **/
- (NSArray*)groups {
	return nil;
}

/**
 * すべてのグループ一覧を作成する．
 * @return グループ名の配列．
 **/
- (NSArray*)allGroups {
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
 * @param group アスキーアートのグループのSQLiteデータベースのキー．
 **/
- (void)insertNewASCIIArt:(NSString*)asciiArt groupKey:(NSInteger)groupKey {
}

/**
 * AAを更新する．
 * @param asciiArt アスキーアートオブジェクト．
 * @param group アスキーアートグループオブジェクト．
 **/
- (BOOL)updateASCIIArt:(AAKASCIIArt*)asciiArt group:(AAKASCIIArtGroup*)group {
	return NO;
}

/**
 * groupに対応するのAAのリストを取得する．
 * @param group AAリストを取得したいグループ．
 **/
- (NSArray*)asciiArtForGroup:(AAKASCIIArtGroup*)group {
	return nil;
}

/**
 * 履歴を追加する．
 * @param asciiArt アスキーアートの文字列．
 * @param key アスキーアートのデータベース上でのキー．
 **/
- (void)insertHistoryASCIIArtKey:(NSInteger)key {
}

@end
