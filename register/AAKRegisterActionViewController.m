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

/**
 * キャンセルボタンを押したときのイベント処理．
 * @param sender メッセージの送信元オブジェクト．
 **/
- (IBAction)cancel:(id)sender {
	// registerの処理コンテキストを終了する
	[self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
}

/**
 * 登録ボタンを押したときのイベント処理．
 * @param sender メッセージの送信元オブジェクト．
 **/
- (IBAction)registerAA:(id)sender {
	// AAを登録してから，registerの処理コンテキストを終了する
	[[AAKKeyboardDataManager defaultManager] insertNewASCIIArt:self.AATextView.text groupKey:self.asciiart.group.key];
	[self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
}

/**
 * Safariのビューで選択されているテキストをUIに反映する．
 * @param sender メッセージの送信元オブジェクト．
 **/
- (void)update {
	dispatch_async(dispatch_get_main_queue(), ^{
		if ([self.jsString length] > 0) {
			self.AATextView.text = self.jsString;
		}
		else {
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
																		   message:NSLocalizedString(@"Any text is not selected.", nil)
																	preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
															 style:UIAlertActionStyleDefault
														   handler:^(UIAlertAction *action) {
															   [self cancel:nil];
														   }];
			[alert addAction:action];
			[self presentViewController:alert animated:YES completion:nil];
		}
	});
}

/**
 * Safari中で選択中のテキストを取得し，成功した場合，updateメソッドをコールする．
 **/
- (void)extractSelectedText {
	for (NSExtensionItem *item in self.extensionContext.inputItems) {
		
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

#pragma mark - Override

- (void)viewDidLoad {
	[super viewDidLoad];
	[self extractSelectedText];
}

@end
