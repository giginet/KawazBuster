//
//  KawazTan.m
//  KawazBuster
//
//  Created by  on 11/06/14.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "KawazTan.h"
#import "GameConfig.h"
#import "SimpleAudioEngine.h"

// プライベートメソッド
@interface KawazTan()
- (void)onBacked; // かわずたんが戻ってきたときに行う処理
@end

@implementation KawazTan
@synthesize score=score_, state=state_, type=type_;

- (id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect{
  // コンストラクタ
  // ドキュメントより、CCSpriteのサブクラスを作るときはこのコンストラクタをオーバーライドしてやる
  self = [super initWithTexture:texture rect:rect];
  if (self) {
    type_ = rand()%3; 
    score_ = KAWAZTAN_SCORE;
    state_ = KawazTanStateWaiting;
  }
  return self;
}

- (id)initWithPosition:(CGPoint)point{
  //　コンストラクタ。タイプを乱数で決めて、それをもとにSpriteを生成
  type_ = rand()%3;
  NSString* filename = [NSString stringWithFormat:@"kawaz%d.png", type_];
  self = [super initWithFile:filename];
  if(self){
    self.position = ccp(point.x, point.y);
  }
  return self;
}

- (BOOL)start:(ccTime)waitTime{
  // かわずたんをうごかす処理
  if(![self isMoving]){
    if (type_ == KawazTanTypeBomb) waitTime *= 1.5;
    state_ = KawazTanStateMoving; // 現在の状態を移動状態にする
    CGPoint point = self.position;
    CCFiniteTimeAction* go = [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.25f 
                                                                             position:ccp(point.x, point.y + contentSize_.height*0.8)] 
                                                    rate:0.5]; // 0.25秒で上に飛び出す
    // CCCallBlockは、ブロックの中に書かれた処理を即座に実行するAction
    // 無名関数を引数として渡しているのと同様
    CCFiniteTimeAction* normal = [CCCallBlock actionWithBlock:^{
      state_ = KawazTanStateNormal;
      if(type_ == KawazTanTypeBomb){
        SimpleAudioEngine* ae = [SimpleAudioEngine sharedEngine];
        [ae playEffect:@"fire.caf"];
      }
    }]; // 待機状態から通常状態にする
    CCFiniteTimeAction* wait = [CCMoveBy actionWithDuration:waitTime]; // waitTime秒だけ何もしない
    CCFiniteTimeAction* move = [CCCallBlock actionWithBlock:^{
      state_ = KawazTanStateMoving;
    }]; // 通常状態から移動中にする
    CCFiniteTimeAction* back = [CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.25f 
                                                                              position:ccp(point.x, point.y)] 
                                                     rate:0.5]; // 0.25秒でかわずたんを引っ込める
    CCFiniteTimeAction* change = [CCCallFunc actionWithTarget:self selector:@selector(onBacked)]; // onBackedを実行する
    CCSequence* seq = [CCSequence actions:go, normal, wait, move, back, change, nil]; // 以上6つのイベントを元にシーケンスを生成
    [self runAction:seq]; // そのシーケンスを適応してやる
    return YES;
  }
  return NO;
}

- (BOOL)isMoving{
  // 移動中かどうか
  // 何らかのアクションが自分にセットされているかどうかを調べる
  return [self numberOfRunningActions] != 0;
}

- (BOOL)tap{
  // 叩いたときの処理
  // グラフィックを差し替えてやる
  if(state_ == KawazTanStateNormal){
    state_ = KawazTanStateDamaged;
    CCTexture2D* damageTexture;
    SimpleAudioEngine* ae = [SimpleAudioEngine sharedEngine];
    if(type_ == KawazTanTypeBomb){
      // 爆弾の時、爆発させる
      damageTexture = [[CCTextureCache sharedTextureCache] addImage:@"bomb_effect.png"];
      [ae playEffect:@"bomb.caf"];
    }else{
      // それ以外の時、ダメージを受けた処理に
      damageTexture = [[CCTextureCache sharedTextureCache] addImage:@"damage.png"];
      [ae playEffect:@"pico.caf"];
    }
    CCSpriteFrame* damaged = [CCSpriteFrame frameWithTexture:damageTexture 
                                                        rect:CGRectMake(0, 0, 
                                                                        damageTexture.contentSize.width, 
                                                                        damageTexture.contentSize.height)];
    [self setDisplayFrame:damaged]; // グラフィックを適用する
    return YES;
  }
  return NO;
}

- (BOOL)canTouch{
  // かわずたんに当たり判定があるかどうか
  return state_ == KawazTanStateNormal || state_ == KawazTanStateInvinsible || state_ == KawazTanStateDamaged;
}

- (void)onBacked{
  // かわずたんが戻ってきたときの処理
  // 戻ってきたときに、かわずたんを別の種類に変える
  state_ = KawazTanStateWaiting; // 待機状態に
  NSString* filename = [NSString string];
  int r = rand()%100;
  if(r < 100.0*BOMB_RATE){
    // 乱数を発生させて、BOMB_RATE以下なら爆弾にする
    type_ = KawazTanTypeBomb;
    filename = @"bomb.png";
    score_ = BOMB_SCORE;
  }else{
    // それ以外ならもう一度種類を決定してどれかにする
    type_ = rand()%3;
    filename = [NSString stringWithFormat:@"kawaz%d.png", type_];
    score_ = KAWAZTAN_SCORE;
  }
  CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:filename]; // テクスチャー生成
  CCSpriteFrame* sprite = [CCSpriteFrame frameWithTexture:texture 
                                                      rect:CGRectMake(0, 0, 
                                                                      texture.contentSize.width, 
                                                                      texture.contentSize.height)];
  [self setDisplayFrame:sprite]; // グラフィックを適用する
}

@end
