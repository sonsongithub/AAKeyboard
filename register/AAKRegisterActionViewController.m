//
//  AAKRegisterActionViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/24.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKRegisterActionViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>

#import "AAKShared.h"

@interface AAKRegisterActionViewController ()

@property (nonatomic, strong) NSString *jsString;

@end

@implementation AAKRegisterActionViewController

- (void)update {
	dispatch_async(dispatch_get_main_queue(), ^{
		if ([self.jsString length] > 0) {
			self.AATextView.text = self.jsString;
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
	});
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	//	_group = @"Default";
	
	for (NSExtensionItem *item in self.extensionContext.inputItems) {
		NSLog(@"%@", item);
		for (NSItemProvider *itemProvider in item.attachments) {
			if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
				
				__weak AAKRegisterActionViewController *sself = self;
				
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

- (IBAction)cancel:(id)sender {
	[self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
}

- (IBAction)registerAA:(id)sender {
	[[AAKKeyboardDataManager defaultManager] insertNewASCIIArt:self.AATextView.text groupKey:self.group.key];
	[self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
}

@end
