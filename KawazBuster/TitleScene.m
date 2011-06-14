//
//  TitleScene.m
//  KawazBuster
//
//  Created by giginet on 11/05/27.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "TitleScene.h"

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
		// 画面サイズを取得する
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    // 背景の定義
    KWSprite* background = [KWSprite spriteWithFile:@"title_background.png"];
    background.position = ccp(winSize.width/2, winSize.height/2);
    // ロゴの定義
    /* 
     spriteWithFileで生成すると、このメソッドから抜けたとき、自動的にautoreleaseされてしまう
     logo_はメンバ変数のため、initWithFileを使用して生成することで、autoreleaseされない
     logo_移動させる関係上、他のメソッドでも参照するため、メンバ変数でもたせている
    */
    logo_ = [[KWSprite alloc] initWithFile:@"logo.png"];
    logo_.position = ccp(winSize.width/2, 260);
    // メニューの定義
    CCMenuItemImage* start = [CCMenuItemImage itemFromNormalImage:@"start.png" 
                                                    selectedImage:@"start.png" 
                                                           target:self 
                                                         selector:@selector(pressStartButton:)];
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
    menu.position = ccp(winSize.width/2, 40);
    // レイヤーに追加
    [self addChild:background];
    [self addChild:logo_];
    [self addChild:menu];
  }
	return self;
}

- (void)pressStartButton:(id)sender{
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
