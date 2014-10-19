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

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) AAKASCIIArtGroupType type;
@property (nonatomic, readonly) NSInteger key;

+ (AAKASCIIArtGroup*)groupWithTitle:(NSString*)title key:(NSInteger)key;

@end
