//
//  MainScene.m
//  KawazBuster
//
//  Created by giginet on 11/05/28.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "MainScene.h"
#import "KawazTan.h"
#import "SimpleAudioEngine.h"

@interface MainScene()
- (void)popTarget;

@property(readwrite, retain) CCLabelTTF* scoreLabel;
@end

@implementation MainScene
@synthesize scoreLabel=scoreLabel_;

- (id)init{
  self = [super init];
  if(self){
    // コンストラクタ
    score_ = 0;
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
    for(int i=0;i<6;++i){
      KawazTan* kawaztan = [[KawazTan alloc] initWithPosition:CGPointMake(25+50*i, 10)];
      [targets addObject:kawaztan];
      [self addChild:kawaztan z:1001+i];
    }
    for(int i=0;i<3;++i){
      KawazTan* kawaztan = [[KawazTan alloc] initWithPosition:CGPointMake(320+50*i, 70)];
      [targets addObject:kawaztan];
      [self addChild:kawaztan z:1+i];
    }
    targets_ = [[NSArray alloc] initWithArray:targets];
    //　スコアラベルの初期化
    self.scoreLabel = [CCLabelTTF labelWithString:[[NSNumber numberWithInt:score_] stringValue] 
                                         fontName:@"Marker Felt" 
                                         fontSize:24];
    scoreLabel_.position = ccp(100, 280);
    [self addChild:scoreLabel_];
    // 
    SimpleAudioEngine* ae = [SimpleAudioEngine sharedEngine];
    [ae playBackgroundMusic:@"bgm.caf" loop:YES];
    self.isTouchEnabled = YES;
  }
  return self;
}

- (void)dealloc{
  [scoreLabel_ release];
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

-(void) registerWithTouchDispatcher{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
  CGPoint point = [self convertToWorldSpace:[self convertTouchToNodeSpace:touch]];
  for(KawazTan* target in targets_){
    if([target collideWithPoint:point] && target.state == KawazTanStateNormal){
      if([target tap]){
        score_ += target.score;
        NSLog(@"%d", score_);
        [scoreLabel_ setString:[[NSNumber numberWithInt:score_] stringValue]];
      }
      return YES;
    }
  }
  return NO;
}

@end
