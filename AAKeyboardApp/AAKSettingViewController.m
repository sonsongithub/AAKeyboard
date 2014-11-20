//
//  AAKSettingViewController.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/11/19.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKSettingViewController.h"

@interface AAKSettingViewController () {
	IBOutlet UILabel *_versionLabel;
	IBOutlet UILabel *_buildLabel;
}
@end

@implementation NSBundle(Core2ch)

+ (id)infoValueFromMainBundleForKey:(NSString*)key {
	if ([[[self mainBundle] localizedInfoDictionary] objectForKey:key])
		return [[[self mainBundle] localizedInfoDictionary] objectForKey:key];
	return [[[self mainBundle] infoDictionary] objectForKey:key];
}

@end

@implementation AAKSettingViewController

- (IBAction)done:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)openSettingApp:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Keyboard"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 2) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
	}
}

- (NSString*)version {
	return [NSBundle infoValueFromMainBundleForKey:@"CFBundleShortVersionString"];
}

- (NSString*)versionAndBuildCondition {
	NSString *buildCharacter = @"";
#if defined(_TESTFLIGHT)
	buildCharacter = @"(TestFlight)";
#elif defined(_DEMO)
	buildCharacter = @"(Demo)";
#elif defined(_DEBUG)
	buildCharacter = @"(Debug)";
#endif
	return [NSString stringWithFormat:@"%@%@", [NSBundle infoValueFromMainBundleForKey:@"CFBundleShortVersionString"], buildCharacter];
}

- (NSString*)revision {
	return [NSBundle infoValueFromMainBundleForKey:@"GitRevision"];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_versionLabel.text = [self versionAndBuildCondition];
	_buildLabel.text = [self revision];
}

@end