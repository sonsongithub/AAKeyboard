//
//  AAKKeyboardView.m
//  AAKeyboardApp
//
//  Created by sonson on 2014/10/09.
//  Copyright (c) 2014年 sonson. All rights reserved.
//

#import "AAKKeyboardView.h"
#import "AAKToolbar.h"
#import "AAKContentCell.h"
#import "AAKContentFlowLayout.h"
#import "NSParagraphStyle+keyboard.h"

@interface AAKKeyboardView() <UICollectionViewDataSource, UICollectionViewDelegate, AAKToolbarDelegate> {
	AAKToolbar *_toolbar;
	NSLayoutConstraint	*_toolbarHeightConstraint;
	UICollectionView	*_collectionView;
	AAKContentFlowLayout *_collectionFlowLayout;
	NSArray *_strings;
}
@end

@implementation AAKKeyboardView

- (void)load {
	NSInteger itemsPerPage = 3;
	CGFloat w = CGRectGetWidth(self.bounds);
	NSLog(@"width =	%f", w);
	if (w == 1024) {
		itemsPerPage = 8;
	}
	else if (w == 768) {
		itemsPerPage = 6;
	}
	else if (w == 736) {
		itemsPerPage = 6;
	}
	else if (w == 667) {
		itemsPerPage = 6;
	}
	else if (w == 480) {
		itemsPerPage = 6;
	}
	else if (w == 414) {
		itemsPerPage = 4;
	}
	else if (w == 375) {
		itemsPerPage = 3;
	}
	else if (w == 320) {
		itemsPerPage = 3;
	}
	CGFloat pageWidth = w / itemsPerPage;
	CGFloat h = CGRectGetHeight(_collectionView.bounds);
	_collectionFlowLayout.itemSize = CGSizeMake(pageWidth, h);
	_collectionFlowLayout.numberOfPage = itemsPerPage;
	[_collectionFlowLayout invalidateLayout];
	[_toolbar layout];
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_toolbar = [[AAKToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_toolbar.delegate = self;
		[self addSubview:_toolbar];
		
		_collectionFlowLayout = [[AAKContentFlowLayout alloc] init];
		_collectionFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		_collectionFlowLayout.minimumLineSpacing = 0;
		_collectionFlowLayout.minimumInteritemSpacing = 0;
		_collectionFlowLayout.itemSize = CGSizeMake(100, 140);
		_collectionFlowLayout.sectionInset = UIEdgeInsetsZero;
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionFlowLayout];
		_collectionView.alwaysBounceHorizontal = YES;
		_collectionView.showsHorizontalScrollIndicator = NO;
		_collectionView.backgroundColor = [UIColor colorWithRed:254.0/255.0f green:254.0/255.0f blue:254.0/255.0f alpha:1];
		_collectionView.backgroundColor = [UIColor clearColor];
		[_collectionView registerClass:[AAKContentCell class] forCellWithReuseIdentifier:@"AAKContentCell"];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		[self addSubview:_collectionView];
		
		_toolbar.translatesAutoresizingMaskIntoConstraints = NO;
		_collectionView.translatesAutoresizingMaskIntoConstraints = NO;
		
		NSDictionary *views = NSDictionaryOfVariableBindings(_toolbar, _collectionView);
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_toolbar]-0-|"
																	 options:0 metrics:0 views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-0-|"
																		  options:0 metrics:0 views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-[_toolbar]-0-|"
																		  options:0 metrics:0 views:views]];
		_toolbarHeightConstraint = [NSLayoutConstraint constraintWithItem:_toolbar
																attribute:NSLayoutAttributeHeight
																relatedBy:NSLayoutRelationEqual
																   toItem:nil
																attribute:NSLayoutAttributeNotAnAttribute
															   multiplier:1
																 constant:48];
		
		[_toolbar setCategories:@[@"history", @"やaa夫", @"やらない夫", @"kkk"]];
		
		_strings = @[
					 @"　　　　　∧_∧::\n　　　　 (´Д`)::\n　　　 /⌒　　⌒)::\n　　　/ へ_＿/ /::\n　　 (＿＼＼ﾐ)/::\n　　　 ｜ `-イ::\n　　　 /ｙ　 )::\n　　　/／　／::\n　　 ／　／::\n　　(　く:::\n　　|＼ ヽ:::\n＼　| |＼ ⌒i:\n　＼| |::＼〈:\n　 ノ ):: (_ﾉ:\n　(_／＼\n　　　　＼",
					 @"　 　 　　　＿＿＿_ \n　 　　　／⌒　　⌒＼ \n　　　／（ ●） 　（●）＼ \n　 ／::::::⌒（__人__）⌒::::: ＼\n　 |　　　　　|r┬-|　　　　　| \n　 ＼ 　　 　 `ー'´ 　 　 ／",
					 @"　 　　　＿＿＿_\n　　　／　　 　 　＼ （ ;;;;(\n　 ／　　＿ノ　 ヽ__＼) ;;;;)\n／ 　　 （─） 　（─ /;;／\n|　 　　 　 （__人__） l;;,´\n/　　　 　 ∩ ノ)━・'／\n(　 ＼　／ ＿ノ´.|　 |\n.＼　 \" 　／＿＿|　 |\n　　＼ ／＿＿＿ ／",
					 @"　 　　　　 　　　＿＿＿_ \n　　　　　　　 ／_ノ 　ヽ､_＼ \n　ﾐ　ﾐ　ﾐ　　oﾟ(（●）) (（●）)ﾟo　　　　　　ﾐ　ﾐ　ﾐ\n/⌒)⌒)⌒. ::::::⌒（__人__）⌒:::＼　　　/⌒)⌒)⌒) \n|　/　/　/　　　　 　|r┬-|　　　　|　(⌒)/　/ / /／　　 \n|　:::::::::::(⌒)　　　　|　|　 |　　 ／ 　ゝ　　:::::::::::/ \n|　　　　　ノ　　 　　|　|　 |　 　＼　　/　　）　　/ 　 \nヽ　　　　/　　　　　　`ー'´ 　 　 　ヽ /　　　　／　　　　　 \n　|　　　　|　　 l||l　从人 l||l 　　　　 l||l 从人 l||l　　　バ　　　 \n　ヽ　　　 -一''''''\"～～｀`'ー--､　　　-一'''''''ー-､　ン \n　　ヽ ＿＿＿＿(⌒)(⌒)⌒)　)　　(⌒＿(⌒)⌒)⌒)) バ \n　　　　　　　　　　　　　　　　　　　　　　　　　　　　　ン",
					 @"　　　　　　　　　　　　　　　　　　　 ／\n　　　　　　　　　　　　　　　　　 ,r'´\n　　　　　　　　　　　　　　　　／,ノ\n　　　　　　　　　　 　 　 　　/r' /\n　　　　 　　 　 　 　 　　　　!' /　　　　　　　　　　　　　　　　　　ﾉ　　i\n　　　　　 　 　 　 　 　 　 　 /　　　　　　　　　　　　　　　　　,.r'　　ノ !　|\n　　　　　　　　　　　　　　　 !　　　 　　　　　　　_,..r　　_,..r:〆　,.:イ　 | λ\n　　　ぼうやだからさ　　　i　　　　　　　　　,r '　,. r ' ´ ／,..イ’　　 丿/ '; 、\n　　　　　　　　　　　　　　　|　　　　　　　 ／,／´　　　.i'／　　　　 ノ／　 ヾt､\n　　　　　　 　 　　　 　　 　 !i !　　　　,.: ----- :...,_,......!.,,__ _,.. ::--' ´= :..,,_　'j'ヽ\n　　　　　　　　　　　　　　　 t !　　 /´::::::::::::::::::::::::::ヾ,~｀`'ヽ::::::::::::::::::::::::::::::`'':::..,t,\n　　　　　　　　　　　　　　　　ヾ　　i:::: : : : :..　　 :::::::::!j　 t`:::::: :: : : : : : : :::::::::::::::::':,\n　　　　　　　　　　　　　　　　　':,　 i::: : : : :::: : : : : : :ノ,:　 ゝ ﾐ: : : : : :::: : : : : :::::::::::!\n　　　　　　　　　　　 　 　　 　　 ヽ .'､...;;;;;;;;;;;;;..... ,.ｲ　,'　　　　ヽ : ..:::::: ::.... : : ::::::丿\n　　　　　　　　　　　　　　　__,...r-‐ヽ:ゝ.,,_:::::::,..r'´.　 ;'　　　　　 `: 、::::::::::::::: : ::ノ!\n　　　　　　　　　　　　　　/　! 　 　 　 ヽ｀~t　　　　/　　　　　　　　 `'- =::- ''´ ﾉ\n　　　　　　　　　　　　　 /　|　　　　　　 ）.:-+--‐‐k.、　　　　　　　　　 ゝk,.....イ/\n　　 　 　　　　　 　　　 /　. i　　　 ./='''\"_,,'y.',　　 \"''`ヽ､::　　　　　　ゝ :.,,~,.ノ´\n　　　　　　　　　　　　/　　 .!　　._/,,,,../'--'　 ':.、　　　-='::,=--　　　　 ヽ ,,.._,..イ\n　　　　　　　　　　　　.!　 ／''\"~~　　　~`\"'t--.,,＼　　　 .....'.;　　　　　　　:: ~' : . ,,__\n　　　　　　　　　　 ,r ' !／　　　　　　　　　!...,,丿__＼　 __,,..ノ　　　　　 .:::,..r '　: : :\n　　　　　　　　　　.i　／　　　　 ,......k-'' ‐-‐ '´　 ｀~T~k, . . ;'　　　 _,..:::''´ : : ,.. r:''\"\n　　　　　　　　　　,|.(´ _,,,,,.... -'\"-=`',,k___　　　　,r '\"~~`y''/‐‐ '''\": : :,. r:::''\": : : :\n　　　　　　　　　/ /''\"´　　　　　　　　 ~~`ヽ, ::/ : : : : .ノ.;:'　,..r:'ヽ,,/.,,......,_\n　　　　　　　　 / （　　　　　　　　 　 　　 　 ﾉヾ､: : : ／::;',.／　　　 ~`''‐-:ヽ\n　　　　　　　 ./　 .）　　---=''~~~='''''''', .､_ ゝ.,.ノ ::r': : :;' ´　!　　　　　　　　>,\n　　　　　　　/　　/　　　　　　　　　　　 `''t~~: : / : : ::;'　　　';　　　　　　.／　'.\n　　　　　　./　　 ヽ　　　　　　　 　 　 　 .ﾉ　 `y　: : :/ 　　　'k　　　　 ／　　　ヽ",
					 @"　　　 ∧∧　　／￣￣￣￣￣\n　　　(,,ﾟДﾟ)＜　ゴルァ！\n　　 ⊂　　⊃　＼＿＿＿＿＿\n　　～|　　|\n　,,　　し`J",
					 @"　 　 　　　＿＿＿_ \n　 　　　／　　 　 　＼ \n　　　／　 _ノ 　ヽ､_　 ＼ \n　 ／ 　oﾟ⌒　　　⌒ﾟo　 ＼\n　 |　　　　 （__人__）　　　　|　　 \n　 ＼　　 　 ｀ ⌒´ 　 　 ／ ",
					 @"　 　 　　　＿＿＿_ \n　 　　　／　　 　 　＼ \n　　　／　 _ノ 　ヽ､_　 ＼ \n　 ／ oﾟ(（●）) (（●）)ﾟo ＼\n　 |　　　　 （__人__）　　　　| \n　 ＼　　 　 ｀ ⌒´ 　 　 ／ ",
					 @"　　 ／￣￣＼ \n　／　　 _ノ　　＼ \n　|　　　 （ ●）（●） \n.　|　　　　 （__人__）\n　 |　　　　　｀ ⌒´ﾉ　\n.　 |　　　　　　 　 } \n.　 ヽ　　　　　 　 } \n　　 ヽ　　　　　ノ　　　　　　　　＼ \n　　　/　　　 く　　＼　　　　　　　 ＼ \n　　　|　　　　 ＼ 　 ＼ 　 　　　　　　＼ \n　 　 |　　　　|ヽ、二⌒)､　 　 　　　　　 ＼ \n",
					 @"　　　／￣￣＼ \n　／　　 _ノ　　＼ \n　|　　　（ ●）（●）\n.　|　　　　 （__人__）＿＿＿_ \n　 |　　　　　｀ ⌒／ ─'　'ー＼ \n.　 |　　 　 　　／（ ○） 　（○）＼ \n.　 ヽ　　 　 ／　　⌒（n_人__）⌒ ＼ \n　　 ヽ　　　|、　　　　（　　ヨ　　　　|\n　　　/　　 　`ー─－　　厂　　　／ \n　　　|　　 ､ ＿ 　　__,,／　　　　 ＼",
					 ];
		
		[self addConstraint:_toolbarHeightConstraint];
		
		[self updateConstraints];
	}
	return self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
	return [_strings count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
	AAKContentCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"AAKContentCell" forIndexPath:indexPath];
	cell.label.text = [NSString stringWithFormat:@"%ld", indexPath.item];
	CGFloat fontSize = 15;
	NSString *source = _strings[indexPath.item];
	NSParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyleWithFontSize:fontSize];
	NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:[UIFont fontWithName:@"Mona" size:fontSize]};
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:source attributes:attributes];
	cell.textView.attributedString = string;
	[cell.label sizeToFit];
	return cell;
}

#pragma mark - AAKToolbarDelegate

- (void)toolbar:(AAKToolbar*)toolbar didSelectCategoryIndex:(NSInteger)index {
}

- (void)toolbar:(AAKToolbar*)toolbar didPushEarthButton:(UIButton*)button {
	[self.delegate keyboardViewDidPushEarthButton:self];
}

- (void)toolbar:(AAKToolbar*)toolbar didPushDeleteButton:(UIButton*)button {
	[self.delegate keyboardViewDidPushDeleteButton:self];
}

@end
