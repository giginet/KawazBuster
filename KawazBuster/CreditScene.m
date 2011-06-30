//
//  CreditScene.m
//  KawazBuster
//
//  Created by giginet on 11/06/30.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "SimpleAudioEngine.h"

#import "CreditScene.h"
#import "GameConfig.h"

@interface CreditScene()
- (void)pressBackButton:(id)sender; // おーけーボタンを押したとき
@end

@implementation CreditScene

- (id)init{
  self = [super init];
  if (self) {
    KWSprite* bg = [KWSprite spriteWithFile:@"credit_background.png"];
    CCLayerColor* layer = [CCLayerColor layerWithColor:ccc4(128, 128, 128, 200)];
    // KWAnimationで簡単にアニメーションを作成。ドキュメントは後で書く
    KWSprite* credit = [KWAnimation spriteWithFiles:[NSArray arrayWithObjects:@"credit0.png", @"credit1.png", nil] andAPS:15.0/FPS];
    bg.position = ccp(winSize_.width/2, winSize_.height/2);
    credit.position = ccp(winSize_.width/2, winSize_.height/2);
    CCMenuItemImage* back = [CCMenuItemImage itemFromNormalImage:@"credit_button.png" // 通常時の画像 
                                                   selectedImage:@"credit_button_selected.png" // 押したときの画像
                                                          target:self         // 押したときに呼び出すメソッドがどこにあるか
                                                        selector:@selector(pressBackButton:)]; // 押したときに呼び出すメソッド
    CCMenu* menu = [CCMenu menuWithItems:back, nil]; // 生成した各MenuItemからメニューを作る
    menu.position = ccp(388, 34);
    [self addChild:bg];
    [self addChild:layer];
    [self addChild:credit];
    [self addChild:menu];
  }
  return self;
}

- (void)pressBackButton:(id)sender{
  // おーけーボタンを押したとき
  [[SimpleAudioEngine sharedEngine] playEffect:@"pico.caf"];
  [[CCDirector sharedDirector] popScene];
}

@end