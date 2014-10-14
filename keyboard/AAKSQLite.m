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
