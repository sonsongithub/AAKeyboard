//
//  AAKASCIIArt.h
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/13.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AAKASCIIArtGroup;

@interface AAKASCIIArt : NSObject

@property (nonatomic, strong) NSString *text;			/** ASCII art データ本体 */
@property (nonatomic, strong) AAKASCIIArtGroup *group;	/** ASCII art データ本体 */
@property (nonatomic, assign) NSInteger key;			/** ASCII artを一意に指定できるキー */
@property (nonatomic, assign) CGFloat ratio;			/** ASCII artの縦横比 */

@end
