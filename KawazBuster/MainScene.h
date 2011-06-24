//
//  MainScene.h
//  KawazBuster
//
//  Created by giginet on 11/05/28.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "kwing.h"
#import "CDAudioManager.h"

// ゲーム本編を管理するシーン

@interface MainScene : KWScene{
  int score_;                   // 現在のスコア
  int highScore_;               // ハイスコア
  BOOL active_;                 // ゲーム中かどうか
  BOOL hurryUp_;                // 急げ！状態かどうか
  NSArray* targets_;            // かわずたんを格納しておくコンテナ
  CCLabelTTF* scoreLabel_;      // スコア表示するラベル
  CCLabelTTF* highScoreLabel_;  // ハイスコア表示するラベル
  KWTimerLabel* timerLabel_;    // タイマー表示するラベル
}

@end