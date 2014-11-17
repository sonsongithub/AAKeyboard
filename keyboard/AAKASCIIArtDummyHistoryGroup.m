//
//  AAKASCIIArtDummyHistoryGroup.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/17.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKASCIIArtDummyHistoryGroup.h"

@implementation AAKASCIIArtDummyHistoryGroup

/**
 * 履歴を意味するグループオブジェクトを生成する．
 * @return グループが履歴であることを示すAAKASCIIArtDummyHistoryGroupオブジェクト．
 **/
+ (AAKASCIIArtDummyHistoryGroup*)historyGroup {
	AAKASCIIArtDummyHistoryGroup *obj = [[AAKASCIIArtDummyHistoryGroup alloc] init];
	obj.title = @"history";
	obj.type = AAKASCIIArtHistoryGroup;
	return obj;
}

@end
