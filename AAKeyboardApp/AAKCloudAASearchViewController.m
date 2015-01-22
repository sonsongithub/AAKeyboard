//
//  AAKCloudAASearchViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2015/01/23.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

#import "AAKCloudAASearchViewController.h"

@interface AAKCloudAASearchViewController () <UISearchBarDelegate> {
	UISearchBar *_searchBar;
}
@end

@implementation AAKCloudAASearchViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"Search", nil);
	
	_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 300, 44)];
	_searchBar.delegate = self;
	self.navigationItem.titleView = _searchBar;
}

#pragma mark <AAKCloudAAViewController>

- (void)didFailCloudKitQuery {
	[_searchBar setShowsCancelButton:NO animated:YES];
}

- (void)didFinishCloudKitQuery {
	[_searchBar setShowsCancelButton:YES animated:YES];
	[self.collectionView reloadData];
}

#pragma mark <UISearchBarDelegate>

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[_asciiarts removeAllObjects];
	_currentCursor = nil;
	NSString *temp = [NSString stringWithFormat:@"title BEGINSWITH '%@'", searchBar.text];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:temp];
	CKQuery *query = [[CKQuery alloc] initWithRecordType:@"AAKCloudASCIIArt"
											   predicate:predicate];
	query.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]];
	_query = query;
	[self startQuery];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	_searchBar.text = @"";
	[_asciiarts removeAllObjects];
	_currentCursor = nil;
	[self.collectionView reloadData];
	[_searchBar setShowsCancelButton:NO animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_searchBar resignFirstResponder];
}

@end
