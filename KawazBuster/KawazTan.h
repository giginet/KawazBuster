//
//  KawazTan.h
//  KawazBuster
//
//  Created by  on 11/06/14.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "kwing.h"
#import "CCTouchDelegateProtocol.h"

// かわずたんクラス

// かわずたんの現在の状況を表すenum型
typedef enum{
  KawazTanStateNormal,     // 通常状態。攻撃可能
  KawazTanStateWaiting,    // 待機状態。草の下にいるとき。当たり判定無し
  KawazTanStateMoving,     // 移動中、上下に移動している。当たり判定あり、攻撃不可
  KawazTanStateDamaged,    // ダメージを受けているとき。当たり判定あり、攻撃不可
  KawazTanStateInvinsible, // 無敵状態。当たり判定あり。攻撃不可。一応作ったけど使ってない
  KawazTanStateDisable     // 無効状態。当たり判定無し。これも使ってない
} KawazTanState;


// かわずたんの種類を表すenum型
typedef enum{
  KawazTanTypeNormal, // 通常。以下２つはグラの違い以外は無し
  KawazTanTypeSmile,  // 笑い
  KAwazTanTypeDeride, // からかい
  KawazTanTypeBomb    // 爆弾
} KawazTanType;

@interface KawazTan : KWSprite{
 @private
  KawazTanType type_;   // かわずたんの種類
  KawazTanState state_; // かわずたんの状態
  int score_;           // このかわずたんを倒したときに発生するスコア
}

- (id)initWithPosition:(CGPoint)point; // 初期位置を指定してリセットするコンストラクタ
- (BOOL)start:(ccTime)waitTime;        // かわずたんを待機状態から動かして一連の動作をさせる。
                                       // 引数は何秒間攻撃を受ける状態になるか.動けたかどうかを返す
- (BOOL)isMoving;                      // かわずたんが移動中かどうか
- (BOOL)tap;                           // かわずたんをタッチしたときに起きる処理。叩けたかどうかを返す
- (BOOL)canTouch;                      // かわずたんに触れるかどうか

// プロパティ、score, state, typeのゲッターを生成する
@property(readonly) int score;
@property(readonly) KawazTanState state;
@property(readonly) KawazTanType type;
@end
