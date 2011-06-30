//
//  TitleScene.m
//  KawazBuster
//
//  Created by giginet on 11/05/27.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "SimpleAudioEngine.h"

#import "TitleScene.h"
#import "MainScene.h"
#import "HowtoScene.h"
#import "CreditScene.h"
#import "KWMusicManager.h"
/*
 無名カテゴリ
 Objective-Cでは、privateなメソッドを定義できないので
 無名なカテゴリを実装ファイルに記述し、そこに定義してやれば、外部から隠蔽して、
 あたかもprivateメソッドのように振る舞わせることができる
 （しかし、実際は見えないだけで、外部からメソッドコールしても実行される）
 */
@interface TitleScene()
- (void)pressStartButton:(id)sender; // "はじめる"ボタンを押したときに呼ばれるメソッド
- (void)pressCreditButton:(id)sender;// "くれじっと！"ボタンを押したときに呼ばれるメソッド
- (void)pressHowtoButton:(id)sender; // "あそびかた"ボタンを押したときに呼ばれるメソッド
@end

@implementation TitleScene

-(id)init{
	if( (self=[super init])) {
		played_ = NO;
    // 背景を宣言
    KWSprite* background = [KWSprite spriteWithFile:@"title_background.png"];
    background.position = ccp(winSize_.width/2, winSize_.height/2);
    // ロゴを宣言
    KWSprite* logo = [KWSprite spriteWithFile:@"logo.png"];
    logo.position = ccp(winSize_.width/2, 260);
    // メニューの定義
    CCMenuItemImage* start = [CCMenuItemImage itemFromNormalImage:@"start.png" // 通常時の画像 
                                                    selectedImage:@"start_selected.png" // 押したときの画像
                                                           target:self         // 押したときに呼び出すメソッドがどこにあるか
                                                         selector:@selector(pressStartButton:)]; // 押したときに呼び出すメソッド
    CCMenuItemImage* credit  = [CCMenuItemImage itemFromNormalImage:@"credit.png" 
                                                      selectedImage:@"credit_selected.png" 
                                                             target:self 
                                                           selector:@selector(pressCreditButton:)];
    CCMenuItemImage* howto = [CCMenuItemImage itemFromNormalImage:@"howto.png" 
                                                    selectedImage:@"howto_selected.png" 
                                                           target:self 
                                                         selector:@selector(pressHowtoButton:)];
    CCMenu* menu = [CCMenu menuWithItems:howto, start, credit, nil]; // 生成した各MenuItemからメニューを作る
    [menu alignItemsHorizontally]; // メニューを横並びにする
    menu.position = ccp(winSize_.width/2, 40); // メニューの中心位置を設定
    // レイヤーに追加
    [self addChild:background];
    [self addChild:logo];
    [self addChild:menu];
  }
	return self;
}

- (void)pressStartButton:(id)sender{
  [[SimpleAudioEngine sharedEngine] playEffect:@"pico.caf"];
  CCTransitionFade* transition = [CCTransitionPageTurn transitionWithDuration:0.5f scene:[MainScene scene]];
  [[CCDirector sharedDirector] replaceScene:transition];
  KWMusicManager* mm = [KWMusicManager sharedManager];
  [mm fadeout:0.5];
}

- (void)pressCreditButton:(id)sender{
  [[SimpleAudioEngine sharedEngine] playEffect:@"pico.caf"];
  CCTransitionFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5f scene:[CreditScene scene]];
  [[CCDirector sharedDirector] pushScene:transition];
}

- (void)pressHowtoButton:(id)sender{
  [[SimpleAudioEngine sharedEngine] playEffect:@"pico.caf"];
  CCTransitionFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5f scene:[HowtoScene scene]];
  [[CCDirector sharedDirector] pushScene:transition];
}

- (void)onEnterTransitionDidFinish{
  // トランジションが終了したときに呼び出されるメソッド
  // タイトル音楽の再生
  if(!played_){
    KWMusicManager* mm = [KWMusicManager sharedManager];
    [mm playMusic:@"title.caf" loop:NO];
    played_ = YES;
  }
}

@end
