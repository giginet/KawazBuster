//
//  HowtoScene.m
//  KawazBuster
//
//  Created by  on 11/06/23.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "HowtoScene.h"
#import "GameConfig.h"

@class MainScene;

@interface HowtoScene()
- (void)pressBackButton:(id)sender;
@end

@implementation HowtoScene

- (id)init{
  self = [super init];
  if (self) {
    KWSprite* bg = [KWSprite spriteWithFile:@"title_background.png"];
    CCLayerColor* layer = [CCLayerColor layerWithColor:ccc4(128, 128, 128, 200)];
    KWSprite* howto = [KWAnimation spriteWithFiles:[NSArray arrayWithObjects:@"howto0.png", @"howto1.png", nil] andAPS:15.0/FPS];
    bg.position = ccp(winSize_.width/2, winSize_.height/2);
    howto.position = ccp(winSize_.width/2, winSize_.height/2);
    howto.opacity = 255;
    CCMenuItemImage* back = [CCMenuItemImage itemFromNormalImage:@"howto_button.png" // 通常時の画像 
                                                    selectedImage:@"howto_button.png" // 押したときの画像
                                                           target:self         // 押したときに呼び出すメソッドがどこにあるか
                                                         selector:@selector(pressBackButton:)]; // 押したときに呼び出すメソッド
    CCMenu* menu = [CCMenu menuWithItems:back, nil]; // 生成した各MenuItemからメニューを作る
    menu.position = ccp(388, 34);
    [self addChild:bg];
    [self addChild:layer];
    [self addChild:howto];
    [self addChild:menu];
  }
  return self;
}

- (void)pressBackButton:(id)sender{
  [[CCDirector sharedDirector] popScene];
}

@end
