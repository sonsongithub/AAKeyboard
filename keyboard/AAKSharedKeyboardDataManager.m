//
//  AAKSharedKeyboardDataManager.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/20.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKSharedKeyboardDataManager.h"

#import "AAKHelper.h"
#import "AAKASCIIArtGroup.h"
#import "AAKASCIIArt.h"
#import "UZTextView.h"
#import "NSParagraphStyle+keyboard.h"

@implementation AAKSharedKeyboardDataManager

/**
 * AAKSSQLiteオブジェクトを保存するパスを返す．
 * @return SQLiteのファイルを保存するパス．
 */
- (NSString*)pathForDatabaseFile {
	NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sonson.AAKeyboardApp"];
	DNSLog(@"%@", [storeURL.path stringByAppendingPathComponent:@"aak.sql"]);
	return [storeURL.path stringByAppendingPathComponent:@"aak.sql"];
}

#pragma mark - Instance mathod

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
	sqlite3_exec(_database, "CREATE TABLE AAGroup (group_title TEXT UNIQUE, number INTEGER, group_key INTEGER PRIMARY KEY AUTOINCREMENT);", NULL, NULL, NULL);
	sqlite3_exec(_database, "CREATE TABLE AA (asciiart TEXT, number INTEGER, ratio NUMERIC, group_key INTEGER, lastUseTime NUMERIC, asciiart_key INTEGER PRIMARY KEY AUTOINCREMENT);", NULL, NULL, NULL);
	sqlite3_exec(_database, "INSERT INTO AAGroup (group_title, group_key) VALUES('Default', NULL);", NULL, NULL, NULL);
}

#pragma mark - Group

/**
 * すべてのグループ一覧を作成する．
 * @return グループ名の配列．
 **/
- (NSArray*)allGroups {
	const char *sql = "select DISTINCT group_title, group_key from AAGroup";
	sqlite3_stmt *statement = NULL;
	
	NSMutableArray *groups = [NSMutableArray array];
	
	if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
	}
	else {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			if (sqlite3_column_text(statement, 0)) {
				NSString *title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				NSInteger key = sqlite3_column_int(statement, 1);
				AAKASCIIArtGroup *obj = [AAKASCIIArtGroup groupWithTitle:title key:key];
				[groups addObject:obj];
			}
		}
	}
	sqlite3_finalize(statement);
	return [NSArray arrayWithArray:groups];
}

/**
 * AAが登録されているグループ一覧を作成する．
 * @return グループ名の配列．
 **/
- (NSArray*)groups {
	const char *sql = "select DISTINCT AAGroup.group_title, AA.group_key from AA, AAGroup where AA.group_key == AAGroup.group_key;";
	sqlite3_stmt *statement = NULL;
	
	NSMutableArray *groups = [NSMutableArray array];
	
	if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
	}
	else {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			if (sqlite3_column_text(statement, 0)) {
				NSString *title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				NSInteger key = sqlite3_column_int(statement, 1);
				AAKASCIIArtGroup *obj = [AAKASCIIArtGroup groupWithTitle:title key:key];
				[groups addObject:obj];
			}
		}
	}
	sqlite3_finalize(statement);
	return [NSArray arrayWithArray:groups];
}

/**
 * 新しいグループを作成する．
 * @param group 新しいグループ名の文字列．
 **/
- (void)insertNewGroup:(NSString*)group {
	sqlite3_stmt *statement = NULL;
	
	if (statement == nil) {
		static char *sql = "INSERT INTO AAGroup (group_title, group_key, number) VALUES(?, NULL, -1)";
		if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
			NSLog( @"Can't prepare statment to insert board information. into board, with messages '%s'.", sqlite3_errmsg(_database));
		}
		else {
		}
	}
	sqlite3_bind_text(statement, 1, [group UTF8String], -1, SQLITE_TRANSIENT);
	int success = sqlite3_step(statement);
	if (success != SQLITE_ERROR) {
	}
	else{
		NSLog(@"Error");
	}
	sqlite3_finalize(statement);
	[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil userInfo:nil];
}

/**
 * 新しいAAを追加する．
 * @param asciiArt アスキーアート本体．文字列．
 * @param group アスキーアートのグループのSQLiteデータベースのキー．
 **/
- (void)insertNewASCIIArt:(NSString*)asciiArt groupKey:(NSInteger)groupKey {
	sqlite3_stmt *statement = NULL;

	CGFloat fontSize = 18;
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:asciiArt attributes:attributes];
	
	CGSize size = [UZTextView sizeForAttributedString:string withBoundWidth:CGFLOAT_MAX margin:UIEdgeInsetsZero];
	CGFloat ratio = size.width / size.height;
	
	if (statement == nil) {
		static char *sql = "INSERT INTO AA (asciiart, group_key, ratio, lastUseTime, asciiart_key) VALUES(?, ?, ?, ?, NULL)";
		if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
			NSLog( @"Can't prepare statment to insert board information. into board, with messages '%s'.", sqlite3_errmsg(_database));
		}
		else {
		}
	}
	sqlite3_bind_text(statement, 1, [asciiArt UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int64(statement, 2, groupKey);
	sqlite3_bind_double(statement, 3, ratio);
	sqlite3_bind_double(statement, 4, [NSDate timeIntervalSinceReferenceDate]);
	int success = sqlite3_step(statement);
	if (success != SQLITE_ERROR) {
	}
	else{
		NSLog(@"Error");
	}
	sqlite3_finalize(statement);
	[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil userInfo:nil];
}

/**
 * groupに対応するのAAのリストを取得する．
 * @param group AAリストを取得したいグループ．
 **/
- (NSArray*)asciiArtForExistingGroup:(AAKASCIIArtGroup*)group {
	const char *sql = "select asciiart, asciiart_key, ratio from AA where group_key = ? order by lastUseTime desc";
	sqlite3_stmt *statement = NULL;
	
	NSMutableArray *groups = [NSMutableArray array];
	
	if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
	}
	else {
		sqlite3_bind_int64(statement, 1, group.key);
		while (sqlite3_step(statement) == SQLITE_ROW) {
			if (sqlite3_column_text(statement, 0)) {
				NSString *title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				NSInteger key = sqlite3_column_int(statement, 1);
				AAKASCIIArt *obj = [[AAKASCIIArt alloc] init];
				obj.asciiArt = title;
				obj.key = key;
				obj.ratio = sqlite3_column_double(statement, 2);
				[groups addObject:obj];
			}
		}
	}
	sqlite3_finalize(statement);
	return [NSArray arrayWithArray:groups];
}

/**
 * groupに対応するのAAのリストを取得する．
 * @param group AAリストを取得したいグループ．
 **/
- (NSArray*)asciiArtHistory {
	const char *sql = "select asciiart, asciiart_key, ratio from AA order by lastUseTime desc limit 20";
	sqlite3_stmt *statement = NULL;
	
	NSMutableArray *groups = [NSMutableArray array];
	
	if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
		DNSLog( @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
	}
	else {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			if (sqlite3_column_text(statement, 0)) {
				NSString *title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				NSInteger key = sqlite3_column_int(statement, 1);
				AAKASCIIArt *obj = [[AAKASCIIArt alloc] init];
				obj.asciiArt = title;
				obj.key = key;
				obj.ratio = sqlite3_column_double(statement, 2);
				[groups addObject:obj];
			}
		}
	}
	sqlite3_finalize(statement);
	return [NSArray arrayWithArray:groups];
}

/**
 * groupに対応するのAAのリストを取得する．
 * @param group AAリストを取得したいグループ．
 **/
- (NSArray*)asciiArtForGroup:(AAKASCIIArtGroup*)group {
	if (group.type == AAKASCIIArtNormalGroup) {
		return [self asciiArtForExistingGroup:group];
	}
	else if (group.type == AAKASCIIArtHistoryGroup) {
		return [self asciiArtHistory];
	}
	return nil;
	
}

/**
 * 履歴を追加する．
 * @param key アスキーアートのデータベース上でのキー．
 **/
- (void)insertHistoryASCIIArtKey:(NSInteger)key {
	sqlite3_stmt *statement = NULL;
	static char *sql = "update AA set lastUseTime = ? where asciiart_key = ?";
	if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
		NSLog( @"Can't prepare statment to insert board information. into board, with messages '%s'.", sqlite3_errmsg(_database));
	}
	else {
	}
	sqlite3_bind_double(statement, 1, [NSDate timeIntervalSinceReferenceDate]);
	sqlite3_bind_int64(statement, 2, key);
	int success = sqlite3_step(statement);
	if (success != SQLITE_ERROR) {
	}
	else{
		NSLog(@"Error");
	}
	sqlite3_finalize(statement);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil userInfo:nil];
}

/**
 * AAを更新する．
 * @param asciiArt アスキーアートオブジェクト．
 * @param group アスキーアートグループオブジェクト．
 **/
- (BOOL)updateASCIIArt:(AAKASCIIArt*)asciiArt group:(AAKASCIIArtGroup*)group {
	sqlite3_stmt *statement = NULL;
	static char *sql = "update AA set asciiart = ?, group_key = ? where asciiart_key = ?";
	if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
		NSLog( @"Can't prepare statment to insert board information. into board, with messages '%s'.", sqlite3_errmsg(_database));
	}
	else {
	}
	sqlite3_bind_text(statement, 1, [asciiArt.asciiArt UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int64(statement, 2, group.key);
	sqlite3_bind_int64(statement, 3, asciiArt.key);
	int success = sqlite3_step(statement);
	if (success != SQLITE_ERROR) {
	}
	else{
		NSLog(@"Error");
	}
	sqlite3_finalize(statement);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil userInfo:nil];
	
	return NO;
}


/**
 * AAを削除する．
 * @param asciiArt アスキーアートオブジェクト．
 * @param group アスキーアートグループオブジェクト．
 **/
- (BOOL)deleteASCIIArt:(AAKASCIIArt*)asciiArt {
	sqlite3_stmt *statement = NULL;
	static char *sql = "delete from AA where asciiart_key = ?";
	if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
		NSLog( @"Can't prepare statment to insert board information. into board, with messages '%s'.", sqlite3_errmsg(_database));
	}
	else {
	}
	sqlite3_bind_int64(statement, 1, asciiArt.key);
	int success = sqlite3_step(statement);
	if (success != SQLITE_ERROR) {
	}
	else{
		NSLog(@"Error");
	}
	sqlite3_finalize(statement);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:AAKKeyboardDataManagerDidUpdateNotification object:nil userInfo:@{AAKKeyboardDataManagerDidRemoveObjectKey:asciiArt}];
	return NO;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		// Initialization code here.
		NSString *path = [self pathForDatabaseFile];
		
		if (sqlite3_open([path UTF8String], &_database) == SQLITE_OK) {
			sqlite3_exec(_database, "PRAGMA auto_vacuum=1", NULL, NULL, NULL);
		}
		else {
			assert(1);
			NSLog(@"SQLite database can't be opened....");
		}
		[self initializeDatabaseTable];
	}
	return self;
}

@end
