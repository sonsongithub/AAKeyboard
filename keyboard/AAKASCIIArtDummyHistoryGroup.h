//
//  AAKASCIIArtDummyHistoryGroup.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/17.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAKASCIIArtDummyHistoryGroup : NSObject

@property (nonatomic) int64_t order;
@property (nonatomic, retain) NSString * title;
@property (nonatomic) int64_t type;

/**
 * 履歴を意味するグループオブジェクトを生成する．
 * @return グループが履歴であることを示すAAKASCIIArtDummyHistoryGroupオブジェクト．
 **/
+ (AAKASCIIArtDummyHistoryGroup*)historyGroup;

@end
