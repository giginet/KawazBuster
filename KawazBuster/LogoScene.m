//
//  LogoScene.m
//  KawazBuster
//
//  Created by giginet on 11/05/27.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "LogoScene.h"
#import "TitleScene.h"
#import "SimpleAudioEngine.h"

// プライベートメソッドであるため、無名カテゴリに宣言する
@interface LogoScene()
  -(void)goToTitle; // タイトル画面へ移動するメソッド
@end

@implementation LogoScene

-(id) init{
	backgroundColor_ = ccc4(255, 255, 255, 255); // 背景色を白に設定
  if( (self=[super init])) {
    KWSprite* logo = [KWSprite spriteWithFile:@"kawaz.png"]; // ロゴを生成
    logo.position = ccp(winSize_.width/2, winSize_.height/2); // ロゴの位置を中心座標にする
    logo.opacity = 0; // ロゴの透明度を0にして非表示にする（初期状態）
    /* ロゴのイベントを設定
    // 2秒かけてフェードイン
    // 2秒間何もしない
    // 2秒かけてフェードアウト
    // 終わったらgoToTitleを呼び出す
    */
    id fadeIn = [CCFadeIn actionWithDuration:2];
    id wait = [CCMoveBy actionWithDuration:2];
    id fadeOut = [CCFadeOut actionWithDuration:2];
    id toTitle = [CCCallFunc actionWithTarget:self selector:@selector(goToTitle)];
    CCSequence* seq = [CCSequence actions:fadeIn, wait, fadeOut, toTitle, nil]; // Sequenceの作成
    [logo runAction:seq]; // ロゴにSequenceを適用
    [self addChild:logo]; // ロゴをSceneに追加
    SimpleAudioEngine* ae = [SimpleAudioEngine sharedEngine];
    [ae preloadBackgroundMusic:@"title.caf"]; // タイトル画面の曲をあらかじめ読み込んでおく
    self.isTouchEnabled = YES; // タッチパネルを有効にする
  }
	return self;
}

-(void) registerWithTouchDispatcher{
  // タッチを受け付けるようにするためのおまじない
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                   priority:0 
                                            swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
  // タッチされたときの処理。タッチを受け付けるので無条件でYESを返してなにもしない
  return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
  // タッチされた指が離されたときの処理
  [self goToTitle]; // タイトル画面へ移動する
}

- (void)goToTitle{
  // タイトル画面に移動するメソッド（プライベート）
  CCScene* titleScene = [TitleScene scene]; // タイトルシーンを生成
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f scene:titleScene]; // トランジションの設定。0.5秒でフェードする。
  [[CCDirector sharedDirector] replaceScene:transition]; // シーンを置き換える
}

@end
