//
//  UIViewController+Rotate.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/15.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "UIViewController+Rotate.h"

@implementation UIViewController(Rotate)

- (NSUInteger)supportedInterfaceOrientations {
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
		return  UIInterfaceOrientationMaskPortrait;
	return UIInterfaceOrientationMaskAll;
}

@end
