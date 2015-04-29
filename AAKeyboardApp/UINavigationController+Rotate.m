//
//  UINavigationController+Rotate.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/15.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "UINavigationController+Rotate.h"


@implementation UINavigationController(Rotate)

- (NSUInteger)supportedInterfaceOrientations {
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
		return  UIInterfaceOrientationMaskPortrait;
	return UIInterfaceOrientationMaskAll;
}

@end
