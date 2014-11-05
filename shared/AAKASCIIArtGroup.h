//
//  AAKASCIIArtGroup.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/13.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum AAKASCIIArtGroupType_ {
	AAKASCIIArtNormalGroup	= 0,
	AAKASCIIArtHistoryGroup	= 1,
}AAKASCIIArtGroupType;

@interface AAKASCIIArtGroup : NSObject

@property (nonatomic, readonly) NSString *title;				/** グループ名 */
@property (nonatomic, readonly) AAKASCIIArtGroupType type;		/** グループのタイプ．AAKASCIIArtGroupTypeで指定する*/
@property (nonatomic, readonly) NSInteger key;					/** グループを一意に識別するキー */

/**
 * デフォルトのグループを返す．
 * @return デフォルト設定であるデフォルトグループを示すAAKASCIIArtGroupオブジェクトを返す．
 **/
+ (AAKASCIIArtGroup*)defaultGroup;

/**
 * 指定された名前のグループとキーを持つAAKASCIIArtGroupオブジェクトを生成する．
 * @param title グループの名前．
 * @param key グループを示すキー
 * @return 指定された値を持つAAKASCIIArtGroupオブジェクト．
 **/
+ (AAKASCIIArtGroup*)groupWithTitle:(NSString*)title key:(NSInteger)key;

/**
 * 履歴を意味するグループオブジェクトを生成する．
 * @return グループが履歴であることを示すAAKASCIIArtGroupオブジェクト．
 **/
+ (AAKASCIIArtGroup*)historyGroup;

@end
