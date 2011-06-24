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
- (void)playMusic;                    // 音楽を流す
- (void)startGame;                    // ゲームを開始する
- (void)hurryUp;                      // 急げ！状態にする
- (void)endGame;                      // ゲームを終了する
- (void)showResult;                   // 結果表示画面に移行する
- (void)popTarget;                    // ターゲットを沸かせる
- (void)shakeScreen;                  // 画面全体を揺らす
- (void)getScore:(int)score;          // 点数を取得する
- (void)pressRetryButton:(id)sender;  // リトライボタンを押したとき
- (void)pressReturnButton:(id)sender; // タイトルボタンを押したとき
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
    highScore_ =  [ud integerForKey:@"highScore"]; // iOS中から"highScore"というキーのデータを取ってくる
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
    // かわずたんの出現位置が固定なため、最初から全てのかわずたんを配置しておいて、出したり引っ込めたりする
    NSMutableArray* targets = [NSMutableArray array]; // 変更可能な配列を作る
    // 前列
    for(int i=0;i<6;++i){
      KawazTan* kawaztan = [[KawazTan alloc] initWithPosition:CGPointMake(25+50*i, 10)];
      [targets addObject:kawaztan];
      [self addChild:kawaztan z:1001+(6-i)];
    }
    // 後列
    for(int i=0;i<3;++i){
      KawazTan* kawaztan = [[KawazTan alloc] initWithPosition:CGPointMake(320+50*i, 70)];
      [targets addObject:kawaztan];
      [self addChild:kawaztan z:1+(3-i)];
    }
    targets_ = [[NSArray alloc] initWithArray:targets]; //変更不可配列にキャストして、メンバー変数に格納
    
    //　各種ラベルを初期化して配置
    [timerLabel_ setTime:0 minute:1 second:0]; // TimerLabelの初期化。俺俺ライブラリ。APIドキュメントはそのうち書く･･････。
    CCLabelTTF* scoreLabel = [CCLabelTTF labelWithString:@"Score" 
                                                fontName:@"Marker Felt" 
                                                fontSize:24];
    CCLabelTTF* highScoreLabel = [CCLabelTTF labelWithString:@"HighScore" 
                                                    fontName:@"Marker Felt" 
                                                    fontSize:24];
    CCLabelTTF* timeLabel = [CCLabelTTF labelWithString:@"Time" 
                                               fontName:@"Marker Felt" 
                                               fontSize:24];
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
    [self runAction:[CCSequence actions:
                     [CCMoveBy actionWithDuration:1],
                     [CCCallFunc actionWithTarget:self 
                                         selector:@selector(playMusic)],
                     nil]]; // 1秒待ってplayMusic呼び出し
    // タイマー終了時にendGameを実行させる
    // これも俺俺ライブラリ。APIドキュメントはないので、ソースコード参照
    [timerLabel_ setTimerCompletionListener:self selector:@selector(endGame)];
    self.isTouchEnabled = YES; // タッチ操作を有効にする
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
  // 毎フレーム自動実行される処理
  [super update:dt];
  int rate = hurryUp_ ? 10 : 40;
  if(active_ && rand()%rate == 0){ 
    [self popTarget]; // かわずたんを沸かせる
  }
  if([timerLabel_ leaveSecond] <= HURRY_UP_TIME && !hurryUp_){
    [self hurryUp]; // 急げ！状態にする
  }
}

- (void)playMusic{
  // 音楽を鳴らす
  KWMusicManager* mm = [KWMusicManager sharedManager];
  [mm playMusic:@"bgm.caf" intro:@"bgm_int.caf" loop:YES]; // イントロと曲を設定してループ
  [mm setIntroMusicCompletionListener:self selector:@selector(startGame)]; // イントロが終わったら、startGameを実行
  [self unschedule:@selector(playMusic)]; // コンストラクタで設定したスケジュールを削除
  // れでぃー　の文字を表示させる
  KWSprite* ready = [KWSprite spriteWithFile:@"ready.png"];
  ready.scale = 0; // 初期の大きさを0にする
  ready.position = ccp(winSize_.width/2, winSize_.height/2);
  id appear = [CCEaseExponentialIn actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:1.0]]; // 飛び出してくるアクション
  [ready runAction:appear];
  [self addChild:ready z:5000 tag:1]; // タグを1に設定して、readyを画面に配置
}

- (void)startGame{
  KWSprite* ready = (KWSprite*)[self getChildByTag:1]; // タグが１のnodeを取り出す（れでぃーの文字）
  KWSprite* go = [KWSprite spriteWithFile:@"go.png"];
  go.scale = 0;
  go.position = ccp(winSize_.width/2, winSize_.height/2);
  id appear = [CCEaseExponentialIn actionWithAction:[CCScaleTo actionWithDuration:0.25f scale:1.0]];
  // 飛び出させる
  id wait = [CCMoveBy actionWithDuration:0.5]; // 0.5秒間何もしない
  id disapper = [CCEaseExponentialOut actionWithAction:[CCScaleTo actionWithDuration:0.25f scale:0]];
  // 引っ込ませる
  id spin = [CCSpawn actionOne:[CCRotateBy actionWithDuration:0.5 angle:720]
                               two:[CCMoveTo actionWithDuration:0.5 position:ccp(winSize_.width*1.5, winSize_.height*1.5)]]; // 文字を回転させつつ、右上に吹っ飛ばす
  id suicide = [CCCallBlockN actionWithBlock:
                ^(CCNode *n) {
                  [n removeFromParentAndCleanup:YES];
                }]; // 自分自身を親から削除する処理
  [ready runAction:[CCSequence actions:disapper, suicide, nil]]; // アクションを適用
  [go runAction:[CCSequence actions:appear, wait, spin, suicide, nil]];
  [self addChild:go z:5000 tag:2]; // ごぉー！の文字を配置
  active_ = YES; // 入力受付状態に
  [timerLabel_ play];
}

- (void)hurryUp{
  // 音楽を変える
  hurryUp_ = YES;
  KWMusicManager* mm = [KWMusicManager sharedManager];
  [mm playMusic:@"hurry.caf" intro:@"hurry_int.caf" loop:YES];
}

- (void)endGame{
  // ゲーム終了
  [self stopAllActions]; // 全てのアクションを無効に
  self.position = ccp(0, 0); // たまに爆弾を使った後の位置が補正されないので、ここで補正してやる
  SimpleAudioEngine* ae = [SimpleAudioEngine sharedEngine];
  [ae playEffect:@"time_up.caf"];
  KWSprite* finish = [KWSprite spriteWithFile:@"finish.png"]; //　しゅーりょーの文字を表示
  finish.scale = 0;
  finish.position = ccp(winSize_.width/2, winSize_.height/2);
  // さっきと同様なのでコメント略
  id appear = [CCEaseExponentialIn actionWithAction:[CCScaleTo actionWithDuration:0.25f scale:1.0]];
  id wait = [CCMoveBy actionWithDuration:1.0f];
  id disapper = [CCEaseExponentialOut actionWithAction:[CCScaleTo actionWithDuration:0.25f scale:0]];
  id suicide = [CCCallBlockN actionWithBlock:
                ^(CCNode *n) {
                  [n removeFromParentAndCleanup:YES];
                }];
  [finish runAction:[CCSequence actions:appear, wait, disapper, suicide, nil]];
  [self addChild:finish z:5000];
  // 曲のフェードアウト
  KWMusicManager* mm = [KWMusicManager sharedManager];
  [mm fadeout:2.0f];
  active_ = NO; // 入力を受け付けないように
  [self runAction:[CCSequence actions:
                   [CCMoveBy actionWithDuration:2],
                   [CCCallBlock actionWithBlock:^{
    [self schedule:@selector(showResult) interval:4.0f];
    [mm playMusic:@"game_over.caf" loop:NO];
  }],
                   [CCMoveBy actionWithDuration:4],
                   [CCCallFunc actionWithTarget:self 
                                       selector:@selector(showResult)],
                   nil]]; // 2秒待って、ブロック実行。その後4秒間ってshowResult呼び出し
}

- (void)showResult{
  // メニューを生成する
  CCMenuItemImage* retry = [CCMenuItemImage itemFromNormalImage:@"retry_button.png" // 通常時の画像 
                                                  selectedImage:@"retry_button_selected.png" // 押したときの画像
                                                         target:self         // 押したときに呼び出すメソッドがどこにあるか
                                                       selector:@selector(pressRetryButton:)]; // 押したときに呼び出すメソッド
  CCMenuItemImage* title  = [CCMenuItemImage itemFromNormalImage:@"return_button.png" 
                                                   selectedImage:@"return_button_selected.png" 
                                                          target:self 
                                                        selector:@selector(pressReturnButton:)];
  CCMenu* menu = [CCMenu menuWithItems:retry, title, nil]; // 生成した各MenuItemからメニューを作る
  menu.position = ccp(winSize_.width/2, 50); // メニューの中心位置を設定
  [menu alignItemsHorizontally]; // メニューを横並びにする
  [self addChild:menu z:5000]; // メニューを配置する
  // ハイスコア判定。超えていたら音楽を鳴らしてハイスコア書き換え
  if(score_ > highScore_){
    KWMusicManager* mm = [KWMusicManager sharedManager];
    [mm playMusic:@"high_score.caf" loop:NO];
    highScore_ = score_;
    [highScoreLabel_ setString:[[NSNumber numberWithInt:highScore_] stringValue]];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:highScore_ forKey:@"highScore"]; // iOSにhighScoreというキーでデータ格納
  }
}

- (void)popTarget{
  // ターゲット（かわずたん）を沸かせる処理
  int n = rand()%[targets_ count];
  ccTime wait = 1.0;
  // 何秒出現するかを残り時間に応じて決めてやる
  if(hurryUp_){
    wait = [timerLabel_ leaveSecond] * 0.008 + 0.5;
  }else{
    wait = [timerLabel_ leaveSecond] * 0.01 + 0.2;
  }
  [(KawazTan*)[targets_ objectAtIndex:n] start:wait];
}

- (void)shakeScreen{
  // 画面を揺らす処理
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); // 本体をバイブ
  NSMutableArray* actions = [NSMutableArray array];
  // 適当な位置に移動するイベントをFPS個分作って実行してやる
  // これで画面が揺れているように見える
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
  // スコアを取得する
  score_ += score;
  if(score_ < 0){
    score_ = 0;
  }
  [scoreLabel_ setString:[[NSNumber numberWithInt:score_] stringValue]];
}

- (void)pressRetryButton:(id)sender{
  // リトライボタンを押したとき
  [[SimpleAudioEngine sharedEngine] playEffect:@"pico.caf"];
  CCTransitionFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5f scene:[MainScene scene]];
  [[CCDirector sharedDirector] replaceScene:transition];
}

- (void)pressReturnButton:(id)sender{
  // タイトルへ戻るボタンを押したとき
  [[SimpleAudioEngine sharedEngine] playEffect:@"pico.caf"];
  CCTransitionFade* transition = [CCTransitionCrossFade transitionWithDuration:0.5f scene:[TitleScene scene]];
  [[CCDirector sharedDirector] replaceScene:transition];
}

-(void) registerWithTouchDispatcher{
  // タッチ操作を登録する
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                   priority:0 
                                            swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
  // タッチされたときの処理
  if(!active_) return NO; // active_状態じゃなければ何もしない
  CGPoint point = [self convertToWorldSpace:[self convertTouchToNodeSpace:touch]]; // タッチした点を座標へ変換
  // 各ターゲットについて
  for(KawazTan* target in targets_){
    // ターゲットと当たっている　かつ　targetに触れるとき
    // collideWithPointはKWSpriteのメソッド。ドキュメントは後で書く
    if([target collideWithPoint:point] && [target canTouch]){
      if([target tap]){
        [self getScore:target.score]; // 点数を獲得
        if(target.type == KawazTanTypeBomb){
          // 爆弾だったとき、画面を揺らす
          [self shakeScreen];
        }
      }
      return YES;
    }
  }
  return NO;
}
@end
