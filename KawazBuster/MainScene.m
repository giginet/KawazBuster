//
//  MainScene.m
//  KawazBuster
//
//  Created by giginet on 11/05/28.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "MainScene.h"
#import "KawazTan.h"

@interface MainScene()
- (void)popTarget;
@end

@implementation MainScene

- (id)init{
  self = [super init];
  if(self){
    // コンストラクタ
    KWSprite* bg0 = [KWSprite spriteWithFile:@"main_background.png"];
    KWSprite* bg1 = [KWSprite spriteWithFile:@"main_layer0.png"];
    KWSprite* bg2 = [KWSprite spriteWithFile:@"main_layer1.png"];
    bg0.position = ccp(winSize_.width/2, winSize_.height/2);
    bg1.position = ccp(winSize_.width/2, winSize_.height/2);
    bg2.position = ccp(winSize_.width/2, winSize_.height/2);
    [self addChild:bg0 z:0];
    [self addChild:bg1 z:1000];
    [self addChild:bg2 z:2000];
    // かわずたんの設置
    NSMutableArray* targets = [NSMutableArray array];
    for(int i=0;i<9;++i){
      KawazTan* kawaztan = [[KawazTan alloc] initWithPosition:CGPointMake(25+50*i, 10)];
      [targets addObject:kawaztan];
      [self addChild:kawaztan z:1001+i];
    }
    for(int i=0;i<3;++i){
      KawazTan* kawaztan = [[KawazTan alloc] initWithPosition:CGPointMake(320+50*i, 80)];
      [targets addObject:kawaztan];
      [self addChild:kawaztan z:1+i];
    }
    targets_ = [[NSArray alloc] initWithArray:targets];
  }
  return self;
}

- (void)dealloc{
  [targets_ release];
  [super dealloc];
}

- (void)update:(ccTime)dt{
  [super update:dt];
  if(rand()%50 == 0){
    [self popTarget];
  }
}

- (void)popTarget{
  // ターゲット（かわずたん）を沸かせる処理
  int n = rand()%[targets_ count];
  [(KawazTan*)[targets_ objectAtIndex:n] start];
}

@end
