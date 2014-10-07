//
//  ViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/06.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "ViewController.h"
#import "AAKCategorySelectViewController.h"

@interface ViewController () {
	AAKCategorySelectViewController *_con;
}
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_con = [[AAKCategorySelectViewController alloc] init];
	[self.view addSubview:_con.view];
	
	UIView *collectionView = _con.view;
//	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	NSDictionary *views = NSDictionaryOfVariableBindings(collectionView);
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[collectionView]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[collectionView(==40)]-(==0)-|"
																		 options:0 metrics:0 views:views]];
	[self.view updateConstraints];
	
	[_con setCategories:@[@"hoge", @"hoooo",@"hoge", @"hoooo",@"hoge", @"hoooo",@"hoge"]];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
