//
//  AAKCloudAAViewController.h
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/17.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>

@interface AAKCloudAAViewController : UICollectionViewController {
	NSMutableArray *_asciiarts;
	NSOperationQueue *_queue;
	CKQueryCursor *_currentCursor;
	CKQuery	*_query;
}

- (void)startQuery;

#pragma mark <IBAction>

- (IBAction)done:(id)sender;

#pragma mark <AAKCloudAAViewController>

- (void)didFailCloudKitQuery;
- (void)didFinishCloudKitQuery;

@end
