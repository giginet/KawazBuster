//
//  TitleScene.m
//  KawazBuster
//
//  Created by giginet on 11/05/27.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "TitleScene.h"
#import "MainScene.h"
#import "SimpleAudioEngine.h"

/*
 無名カテゴリ
 Objective-Cでは、privateなメソッドを定義できないので
 無名なカテゴリを実装ファイルに記述し、そこに定義してやれば、外部から隠蔽して、
 あたかもprivateメソッドのように振る舞わせることができる
 （しかし、実際は見えないだけで、外部からメソッドコールしても実行される）
 */
@interface TitleScene()
- (void)pressStartButton:(id)sender; // "はじめる"ボタンを押したときに呼ばれるメソッド
- (void)pressExitButton:(id)sender;  // "おわる"ボタンを押したときに呼ばれるメソッド
- (void)pressHowtoButton:(id)sender; // "あそびかた"ボタンを押したときに呼ばれるメソッド
@end

@implementation TitleScene

-(id)init{
	if( (self=[super init])) {
		// 背景の定義
    KWSprite* background = [KWSprite spriteWithFile:@"title_background.png"];
    background.position = ccp(winSize_.width/2, winSize_.height/2);
    // ロゴの定義
    /* 
     spriteWithFileで生成すると、このメソッドから抜けたとき、自動的にautoreleaseされてしまう
     logo_はメンバ変数のため、initWithFileを使用して生成することで、autoreleaseされない
     logo_移動させる関係上、他のメソッドでも参照するため、メンバ変数でもたせている
    */
    logo_ = [[KWSprite alloc] initWithFile:@"logo.png"];
    logo_.position = ccp(winSize_.width/2, 260);
    // メニューの定義
    CCMenuItemImage* start = [CCMenuItemImage itemFromNormalImage:@"start.png" // 通常時の画像 
                                                    selectedImage:@"start.png" // 押したときの画像
                                                           target:self         // 押したときに呼び出すメソッドがどこにあるか
                                                         selector:@selector(pressStartButton:)]; // 押したときに呼び出すメソッド
    CCMenuItemImage* exit  = [CCMenuItemImage itemFromNormalImage:@"exit.png" 
                                                    selectedImage:@"exit.png" 
                                                           target:self 
                                                         selector:@selector(pressExitButton:)];
    CCMenuItemImage* howto = [CCMenuItemImage itemFromNormalImage:@"howto.png" 
                                                    selectedImage:@"howto.png" 
                                                           target:self 
                                                         selector:@selector(pressHowtoButton:)];
    CCMenu* menu = [CCMenu menuWithItems:howto, start, exit, nil]; // 生成した各MenuItemからメニューを作る
    [menu alignItemsHorizontally]; // メニューを横並びにする
    menu.position = ccp(winSize_.width/2, 40); // メニューの中心位置を設定
    // レイヤーに追加
    [self addChild:background];
    [self addChild:logo_];
    [self addChild:menu];
    // タイトル音楽の再生
    SimpleAudioEngine* ae = [SimpleAudioEngine sharedEngine];
    [ae playBackgroundMusic:@"title.wav" loop:NO];
  }
	return self;
}

- (void)pressStartButton:(id)sender{
  CCScene* mainScene = [MainScene scene];
  CCTransitionFade* transition = [CCTransitionZoomFlipAngular transitionWithDuration:0.5f scene:mainScene];
  [[CCDirector sharedDirector] replaceScene:transition];
  SimpleAudioEngine* ae = [SimpleAudioEngine sharedEngine];
  [ae stopBackgroundMusic];
}

- (void)pressExitButton:(id)sender{
}

- (void)pressHowtoButton:(id)sender{
}

- (void) dealloc{
  [logo_ release];
  [super dealloc];
}
@end
