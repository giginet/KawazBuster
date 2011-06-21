//
//  MainScene.m
//  KawazBuster
//
//  Created by giginet on 11/05/28.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "MainScene.h"
#import "KawazTan.h"
#import "KWMusicManager.h"
#import "GameConfig.h"
#import <AudioToolbox/AudioServices.h>

@interface MainScene()
- (void)popTarget;
- (void)shakeScreen;
- (void)getScore:(int)score;
@end

@implementation MainScene

- (id)init{
  self = [super init];
  if(self){
    // コンストラクタ
    score_ = 0;
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    highScore_ =  [ud integerForKey:@"highScore"];
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
      [self addChild:kawaztan z:1001+(6-i)];
    }
    for(int i=0;i<3;++i){
      KawazTan* kawaztan = [[KawazTan alloc] initWithPosition:CGPointMake(320+50*i, 70)];
      [targets addObject:kawaztan];
      [self addChild:kawaztan z:1+(3-i)];
    }
    targets_ = [[NSArray alloc] initWithArray:targets];
    //　スコアラベルの初期化
    // メンバ変数に格納しているので、retainして参照カウンタを1上げている
    
    scoreLabel_ = [[CCLabelTTF labelWithString:[[NSNumber numberWithInt:score_] stringValue] 
                                      fontName:@"Marker Felt" 
                                      fontSize:24] retain];
    highScoreLabel_ = [[CCLabelTTF labelWithString:[[NSNumber numberWithInt:highScore_] stringValue] 
                                         fontName:@"Marker Felt" 
                                         fontSize:24] retain];
    timerLabel_ = [[GameTimer labelWithString:@"0"
                                      fontName:@"Marker Felt" 
                                      fontSize:24] retain];
    [timerLabel_ setTime:0 minute:1 second:0];
    [timerLabel_ play];
    CCLabelTTF* scoreLabel = [CCLabelTTF labelWithString:@"Score" fontName:@"Marker Felt" fontSize:24];
    CCLabelTTF* highScoreLabel = [CCLabelTTF labelWithString:@"HighScore" fontName:@"Marker Felt" fontSize:24];
    CCLabelTTF* timeLabel = [CCLabelTTF labelWithString:@"Time" fontName:@"Marker Felt" fontSize:24];
    scoreLabel.position = ccp(50, 300);
    scoreLabel_.position = ccp(50, 270);
    highScoreLabel.position = ccp(400, 300);
    highScoreLabel_.position = ccp(400, 270);
    timeLabel.position = ccp(winSize_.width/2, 300);
    timerLabel_.position = ccp(winSize_.width/2, 270);
    [self addChild:scoreLabel];
    [self addChild:scoreLabel_];
    [self addChild:highScoreLabel];
    [self addChild:highScoreLabel_];
    [self addChild:timeLabel];
    [self addChild:timerLabel_];
    //
    KWMusicManager* mm = [KWMusicManager sharedManager];
    [mm playMusic:@"bgm.caf" intro:@"bgm_int.caf" loop:YES];
    self.isTouchEnabled = YES;
  }
  return self;
}

- (void)dealloc{
  [targets_ release];
  [scoreLabel_ release];
  [super dealloc];
}

- (void)update:(ccTime)dt{
  [super update:dt];
  if(rand()%50 == 0){
    [self popTarget];
  }
}

- (void)shakeScreen{
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
  NSMutableArray* actions = [NSMutableArray array];
  for(int i=0;i<FPS;++i){
    CCFiniteTimeAction* move = [CCMoveTo actionWithDuration:1.0/FPS 
                                                   position:ccp(30-rand()%60, 15-rand()%60)];
    [actions addObject:move];
  }
  CCFiniteTimeAction* reset = [CCMoveTo actionWithDuration:1.0/FPS position:ccp(0, 0)];
  [actions addObject:reset];
  [self runAction:[CCSequence actionsWithArray:actions]];
}

- (void)getScore:(int)score{
  score_ += score;
  if(score_ < 0){
    score_ = 0;
  }
  [scoreLabel_ setString:[[NSNumber numberWithInt:score_] stringValue]];
}

- (void)popTarget{
  // ターゲット（かわずたん）を沸かせる処理
  int n = rand()%[targets_ count];
  [(KawazTan*)[targets_ objectAtIndex:n] start];
}

-(void) registerWithTouchDispatcher{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                   priority:0 
                                            swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
  CGPoint point = [self convertToWorldSpace:[self convertTouchToNodeSpace:touch]];
  for(KawazTan* target in targets_){
    if([target collideWithPoint:point] && [target canTouch]){
      if([target tap]){
        [self getScore:target.score];
        if(target.type == KawazTanTypeBomb){
          [self shakeScreen];
        }
        break;
      }
      return YES;
    }
  }
  return NO;
}

@end
