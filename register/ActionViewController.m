//
//  ActionViewController.m
//  register
//
//  Created by sonson on 2014/10/14.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AAKTextView.h"
#import "NSParagraphStyle+keyboard.h"
#import "AAKSQLite.h"

@interface ActionViewController ()


@property (nonatomic, strong) NSString *jsString;
@property (nonatomic) double feetsInMeter;
@property (nonatomic) double metersInFoot;
@property (strong,nonatomic) IBOutlet AAKTextView *textView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_feetsInMeter = 3.2808399;
	_metersInFoot = 0.3048;
	
	AAKSQLite *db = [AAKSQLite sharedInstance];
	
	for (NSExtensionItem *item in self.extensionContext.inputItems) {
		NSLog(@"%@", item);
		for (NSItemProvider *itemProvider in item.attachments) {
			if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
				
				__weak ActionViewController *sself = self;
				
				[itemProvider loadItemForTypeIdentifier: (NSString *) kUTTypePropertyList
												options: 0
									  completionHandler: ^(id<NSSecureCoding> item, NSError *error) {
										  
										  if (item != nil) {
											  
											  NSDictionary *resultDict = (NSDictionary *) item;
											  sself.jsString = resultDict[NSExtensionJavaScriptPreprocessingResultsKey][@"content"];
											  [sself update];
										  }
										  
									  }];
				
			}
		}
	}
}

- (void)update {
	if ([self.jsString length] > 0) {
		CGFloat fontSize = 18;
		NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
		NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
		NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.jsString attributes:attributes];
		_textView.attributedString = string;
	}
	else {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"hoge"
																	   message:@"hoge"
																preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
														 style:UIAlertActionStyleDefault
													   handler:^(UIAlertAction *action) {
														   //[self done];
													   }];
		[alert addAction:action];
		[self presentViewController:alert animated:YES completion:nil];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel {
	NSLog(@"%@", self.jsString);
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
}

- (IBAction)registerNewAA {
	NSLog(@"%@", self.jsString);
	// Return any edited content to the host app.
	// This template doesn't do anything, so we just echo the passed in items.
	[self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	return cell;
}

@end
