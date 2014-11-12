//
//  AAKASCIIArtGroup.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/13.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKASCIIArtGroup.h"

@interface AAKASCIIArtGroup()
@end

@implementation AAKASCIIArtGroup

#pragma mark - Class method

/**
 * デフォルトのグループを返す．
 * @return デフォルト設定であるデフォルトグループを示すAAKASCIIArtGroupオブジェクトを返す．
 **/
+ (AAKASCIIArtGroup*)defaultGroup {
	AAKASCIIArtGroup *obj = [[AAKASCIIArtGroup alloc] initWithTitle:@"Default" key:1 type:AAKASCIIArtNormalGroup];
	obj.number = -1;
	return obj;
}

/**
 * 指定された名前のグループとキーを持つAAKASCIIArtGroupオブジェクトを生成する．
 * @param title グループの名前．
 * @param key グループを示すキー
 * @return 指定された値を持つAAKASCIIArtGroupオブジェクト．
 **/
+ (AAKASCIIArtGroup*)groupWithTitle:(NSString*)title key:(NSInteger)key {
	return [[AAKASCIIArtGroup alloc] initWithTitle:title key:key type:AAKASCIIArtNormalGroup];
}

/**
 * 指定された名前のグループとキーを持つAAKASCIIArtGroupオブジェクトを生成する．
 * @param title グループの名前．
 * @param key グループを示すキー
 * @param number グループを並べるときの順番を示すキー
 * @return 指定された値を持つAAKASCIIArtGroupオブジェクト．
 **/
+ (AAKASCIIArtGroup*)groupWithTitle:(NSString*)title key:(NSInteger)key number:(NSInteger)number {
	AAKASCIIArtGroup *obj = [[AAKASCIIArtGroup alloc] initWithTitle:title key:key type:AAKASCIIArtNormalGroup];
	obj.number = number;
	return obj;
}

/**
 * 履歴を意味するグループオブジェクトを生成する．
 * @return グループが履歴であることを示すAAKASCIIArtGroupオブジェクト．
 **/
+ (AAKASCIIArtGroup*)historyGroup {
	return [[AAKASCIIArtGroup alloc] initWithTitle:@"history" key:-1 type:AAKASCIIArtHistoryGroup];
}

#pragma mark - Instance method

/**
 * 指定されたパラメータでAAKASCIIArtGroupオブジェクトを初期化する．
 * @param title グループ名．
 * @param key グループを一意に識別するキー．
 * @param type グループのタイプ．AAKASCIIArtGroupTypeで指定する．
 * @return 指定されたパラメータで初期化されたAAKASCIIArtGroupオブジェクト．
 **/
- (instancetype)initWithTitle:(NSString*)title key:(NSInteger)key type:(AAKASCIIArtGroupType)type {
	if (self = [super init]) {
		_title = title;
		_key = key;
		_type = type;
		_number = -1;
	}
	return self;
}

#pragma mark - Override

- (instancetype)init {
	self = [super init];
	if (self) {
		_title = nil;
		_type = AAKASCIIArtNormalGroup;
		_key = -1;
		_number = -1;
	}
	return self;
}

@end
