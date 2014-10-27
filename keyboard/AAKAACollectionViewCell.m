//
//  AAKAACollectionViewCell.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/23.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKAACollectionViewCell.h"

#import "AAKKeyboardDataManager.h"

@implementation AAKAACollectionViewCell

- (IBAction)delete:(id)sender {
	[[AAKKeyboardDataManager defaultManager] deleteASCIIArt:_asciiart];
}

@end
