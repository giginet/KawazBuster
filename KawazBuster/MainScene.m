//
//  MainScene.m
//  KawazBuster
//
//  Created by giginet on 11/05/28.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "SimpleAudioEngine.h"
#import <AudioToolbox/AudioServices.h>

#import "MainScene.h"
#import "TitleScene.h"
#import "KawazTan.h"
#import "GameConfig.h"

@interface MainScene()
- (void)playMusic;
- (void)startGame;
- (void)hurryUp;
- (void)endGame;
- (void)showResult;
- (void)popTarget;
- (void)shakeScreen;
- (void)getScore:(int)score;
- (void)pressRetryButton:(id)sender;
- (void)pressReturnButton:(id)sender;
@end

@implementation MainScene

- (id)init{
  // コンストラクタ
  self = [super init];
  if(self){
    // メンバ変数の初期化
    score_ = 0;
    active_ = NO;
    hurryUp_ = NO;
    // ハイスコアの読み込み
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; // iOSの保存データを読み込む
    highScore_ =  [ud integerForKey:@"highScore"]; // iOS中から"highScore"というデータを取ってくる
    NSMutableArray* targets = [NSMutableArray array];
    scoreLabel_ = [[CCLabelTTF labelWithString:[[NSNumber numberWithInt:score_] stringValue] 
                                      fontName:@"Marker Felt" 
                                      fontSize:24] retain];
    highScoreLabel_ = [[CCLabelTTF labelWithString:[[NSNumber numberWithInt:highScore_] stringValue] 
                                          fontName:@"Marker Felt" 
                                          fontSize:24] retain];
    timerLabel_ = [[KWTimerLabel labelWithString:@"0"
                                        fontName:@"Marker Felt" 
                                        fontSize:24] retain];
    // 画面の配置
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
    [timerLabel_ setTime:0 minute:1 second:0];
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
    //1秒後に音楽を鳴らす
    [self schedule:@selector(playMusic) interval:1.0];
    // タイマー終了時にendGameを実行させる
    [timerLabel_ setTimerCompletionListener:self selector:@selector(endGame)];
    self.isTouchEnabled = YES;
  }
  return self;
}

- (void)dealloc{
  [targets_ release];
  [scoreLabel_ release];
  [highScoreLabel_ release];
  [timerLabel_ release];
  [super dealloc];
}

- (void)update:(ccTime)dt{
  [super update:dt];
  int rate = hurryUp_ ? 10 : 40;
  if(active_ && rand()%rate == 0){
    [self popTarget];
  }
  if([timerLabel_ leaveSecond] <= HURRY_UP_TIME && !hurryUp_){
    [self hurryUp];
  }
}

- (void)playMusic{
  KWMusicManager* mm = [KWMusicManager sharedManager];
  [mm setIntroMusicCompletionListener:self selector:@selector(startGame)];
  [mm playMusic:@"bgm.caf" intro:@"bgm_int.caf" loop:YES];
  [self unschedule:@selector(playMusic)];
  KWSprite* ready = [KWSprite spriteWithFile:@"ready.png"];
  ready.scale = 0;
  ready.position = ccp(winSize_.width/2, winSize_.height/2);
  id appear = [CCEaseExponentialIn actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:1.0]];
  [ready runAction:appear];
  [self addChild:ready z:5000 tag:1];
}

- (void)startGame{
  KWSprite* ready = (KWSprite*)[self getChildByTag:1];
  KWSprite* go = [KWSprite spriteWithFile:@"go.png"];
  go.scale = 0;
  go.position = ccp(winSize_.width/2, winSize_.height/2);
  id appear = [CCEaseExponentialIn actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:1.0]];
  id wait = [CCMoveBy actionWithDuration:0.5];
  id disapper = [CCEaseExponentialOut actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:0]];
  id spin = [CCSpawn actionOne:[CCRotateBy actionWithDuration:0.5 angle:720]
                               two:[CCMoveTo actionWithDuration:0.5 position:ccp(winSize_.width*1.5, winSize_.height*1.5)]];
  id suicide = [CCCallBlockN actionWithBlock:
                ^(CCNode *n) {
                  [self removeChild:n cleanup:YES];
                }];
  CCSequence* seq = [CCSequence actions:appear, wait, spin, suicide, nil];
  [ready runAction:[CCSequence actions:disapper, suicide, nil]];
  [go runAction:seq];
  [self addChild:go z:5000 tag:2];
  active_ = YES;
  [timerLabel_ play];
  [self unschedule:@selector(startGame)];
}

- (void)hurryUp{
  //hurryUp_ = YES;
  //KWMusicManager* mm = [KWMusicManager sharedManager];
  //[mm changeMusic:@"hurry.caf" intro:@"hurry_int.caf" loop:YES fadeout:1.0];
}

- (void)endGame{
  SimpleAudioEngine* ae = [SimpleAudioEngine sharedEngine];
  [ae playEffect:@"time_up.caf"];
  KWSprite* finish = [KWSprite spriteWithFile:@"finish.png"];
  finish.scale = 0;
  finish.position = ccp(winSize_.width/2, winSize_.height/2);
  id appear = [CCEaseExponentialIn actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:1.0]];
  id wait = [CCMoveBy actionWithDuration:1.0f];
  id disapper = [CCEaseExponentialOut actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:0]];
  id suicide = [CCCallBlockN actionWithBlock:
                ^(CCNode *n) {
                  [n removeChild:self cleanup:YES];
                }];
  CCSequence* seq = [CCSequence actions:appear, wait, disapper, suicide, nil];
  [finish runAction:seq];
  [self addChild:finish z:5000];
  KWMusicManager* mm = [KWMusicManager sharedManager];
  [mm fadeout:2.0f];
  active_ = NO;
  [self runAction:[CCSequence actions:
                   [CCMoveBy actionWithDuration:2],
                   [CCCallBlock actionWithBlock:^{
    [self schedule:@selector(showResult) interval:4.0f];
    [mm playMusic:@"game_over.caf" loop:NO];  
  }],
                   nil]];
}

- (void)showResult{
  CCMenuItemImage* retry = [CCMenuItemImage itemFromNormalImage:@"retry_button.png" // 通常時の画像 
                                                  selectedImage:@"retry_button.png" // 押したときの画像
                                                         target:self         // 押したときに呼び出すメソッドがどこにあるか
                                                       selector:@selector(pressRetryButton:)]; // 押したときに呼び出すメソッド
  CCMenuItemImage* title  = [CCMenuItemImage itemFromNormalImage:@"return_button.png" 
                                                   selectedImage:@"return_button.png" 
                                                          target:self 
                                                        selector:@selector(pressReturnButton:)];
  CCMenu* menu = [CCMenu menuWithItems:retry, title, nil]; // 生成した各MenuItemからメニューを作る
  menu.position = ccp(winSize_.width/2, 40); // メニューの中心位置を設定
  [menu alignItemsHorizontally]; // メニューを横並びにする
  [self addChild:menu z:5000];
  [self unschedule:@selector(showResult)];
  // ハイスコア判定
  if(score_ > highScore_){
    KWMusicManager* mm = [KWMusicManager sharedManager];
    [mm playMusic:@"high_score.caf" loop:NO];
    highScore_ = score_;
    [highScoreLabel_ setString:[[NSNumber numberWithInt:highScore_] stringValue]];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:highScore_ forKey:@"highScore"];
  }
}

- (void)popTarget{
  // ターゲット（かわずたん）を沸かせる処理
  int n = rand()%[targets_ count];
  ccTime wait = 1.0;
  if(hurryUp_){
    wait = [timerLabel_ leaveSecond] * 0.008 + 0.5;
  }else{
    wait = [timerLabel_ leaveSecond] * 0.01 + 0.2;
  }
  [(KawazTan*)[targets_ objectAtIndex:n] start:wait];
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

- (void)pressRetryButton:(id)sender{
  CCTransitionFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5f scene:[MainScene scene]];
  [[CCDirector sharedDirector] replaceScene:transition];
}

- (void)pressReturnButton:(id)sender{
  CCTransitionFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5f scene:[TitleScene scene]];
  [[CCDirector sharedDirector] replaceScene:transition];
}

-(void) registerWithTouchDispatcher{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                   priority:0 
                                            swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
  if(!active_) return NO;
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
