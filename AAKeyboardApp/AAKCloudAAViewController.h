//
//  AAKCloudAAViewController.h
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/17.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>

@interface AAKCloudAAViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AAKSourceCollectionViewControllerProtocol> {
	NSMutableArray *_asciiarts;
	NSOperationQueue *_queue;
	CKQueryCursor *_currentCursor;
	CKQuery	*_query;
}

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIImage *backgroundImage;

- (void)startQuery;

#pragma mark <IBAction>

- (IBAction)done:(id)sender;

#pragma mark <AAKCloudAAViewController>

- (void)didFailCloudKitQuery;
- (void)didFinishCloudKitQuery;

@end
