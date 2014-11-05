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

+ (AAKASCIIArtGroup*)defaultGroup;
+ (AAKASCIIArtGroup*)historyGroup;
+ (AAKASCIIArtGroup*)groupWithTitle:(NSString*)title key:(NSInteger)key;

@end
