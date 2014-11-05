//
//  AAKSQLite.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/15.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKSQLite.h"

#import <sqlite3.h>
#import "AAKHelper.h"
#import "AAKASCIIArtGroup.h"

NSString *const AAKSQLiteDidCreateNewGroupNotification = @"AAKSQLiteDidCreateNewGroupNotification";

@interface AAKSQLite() {
	sqlite3 *_database;
}
@end

@implementation AAKSQLite

static AAKSQLite* sharedSQLiteDatabase = nil;	/**< AAKSSQLiteオブジェクトのシングルトンオブジェクト */

#pragma mark - Class mathod

/**
 * シングルトンモデルで利用するAAKSSQLiteオブジェクトを返す．
 * このメソッド以外からAAKSSQLiteオブジェクトを生成してはならない．
 * @return AAKSSQLiteオブジェクト．シングルトンモデル．
 */
+ (AAKSQLite*)sharedInstance {
	if (sharedSQLiteDatabase == nil) {
		sharedSQLiteDatabase = [[AAKSQLite alloc] init];
	}
	return sharedSQLiteDatabase;
}

/**
 * AAKSSQLiteオブジェクトを保存するパスを返す．
 * @return SQLiteのファイルを保存するパス．
 */
+ (NSString*)pathForDatabaseFile {
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
	sqlite3_exec(_database, "CREATE TABLE AAGroup (group_title TEXT UNIQUE, group_key INTEGER PRIMARY KEY AUTOINCREMENT);", NULL, NULL, NULL);
	sqlite3_exec(_database, "CREATE TABLE AA (asciiart TEXT, group_key INTEGER, asciiart_key INTEGER PRIMARY KEY AUTOINCREMENT);", NULL, NULL, NULL);
	sqlite3_exec(_database, "CREATE UNIQUE INDEX AAIndex ON AA(group_key ASC);", NULL, NULL, NULL);
	sqlite3_exec(_database, "INSERT INTO AAGroup (group_title, group_key) VALUES('Default', NULL);", NULL, NULL, NULL);
}

#pragma mark - Group

/**
 * グループ一覧を作成する．
 * @return グループ名の配列．
 **/
- (NSArray*)groups {
	const char *sql = "select group_title, group_key from AAGroup";
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
		static char *sql = "INSERT INTO AAGroup (group_title, group_key) VALUES(?, NULL)";
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
}

/**
 * 新しいAAを追加する．
 * @param asciiArt アスキーアート本体．文字列．
 * @param group アスキーアートのグループのSQLiteデータベースのキー．
 **/
- (void)insertNewASCIIArt:(NSString*)asciiArt groupKey:(NSInteger)groupKey {
	sqlite3_stmt *statement = NULL;
	
	if (statement == nil) {
		static char *sql = "INSERT INTO AA (asciiart, group_key, asciiart_key) VALUES(?, ?, NULL)";
		if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
			NSLog( @"Can't prepare statment to insert board information. into board, with messages '%s'.", sqlite3_errmsg(_database));
		}
		else {
		}
	}
	sqlite3_bind_text(statement, 1, [asciiArt UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int64(statement, 2, groupKey);
	int success = sqlite3_step(statement);
	if (success != SQLITE_ERROR) {
	}
	else{
		NSLog(@"Error");
	}
	sqlite3_finalize(statement);
}

#pragma mark - Override

- (id)init {
	self = [super init];
	if (self) {
		// Initialization code here.
		NSString *path = [AAKSQLite pathForDatabaseFile];
		
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