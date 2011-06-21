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

@interface KawazTan()
- (void)onBacked;
- (void)toNormal;
- (void)toMoving;
@end

@implementation KawazTan
@synthesize score=score_, state=state_, type=type_;

- (id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect{
  self = [super initWithTexture:texture rect:rect];
  if (self) {
    
  }
  return self;
}

- (id)initWithPosition:(CGPoint)point{
  type_ = rand()%3;
  NSString* filename = [NSString stringWithFormat:@"kawaz%d.png", type_];
  self = [super initWithFile:filename];
  if(self){
    score_ = KAWAZTAN_SCORE;
    self.position = ccp(point.x, point.y);
    state_ = KawazTanStateWaiting;
  }
  return self;
}

- (BOOL)tap{
  if(state_ == KawazTanStateNormal){
    state_ = KawazTanStateDamaged;
    CCTexture2D* damageTexture;
    SimpleAudioEngine* ae = [SimpleAudioEngine sharedEngine];
    if(type_ == KawazTanTypeBomb){
      damageTexture = [[CCTextureCache sharedTextureCache] addImage:@"bomb_effect.png"];
      [ae playEffect:@"bomb.caf"];
    }else{
      damageTexture = [[CCTextureCache sharedTextureCache] addImage:@"damage.png"];
      [ae playEffect:@"pico.caf"];
    }
    CCSpriteFrame* damaged = [CCSpriteFrame frameWithTexture:damageTexture 
                                                        rect:CGRectMake(0, 0, 
                                                                        damageTexture.contentSize.width, 
                                                                        damageTexture.contentSize.height)];
    [self setDisplayFrame:damaged];
    return YES;
  }
  return NO;
}

- (BOOL)start{
  if(![self isMoving]){
    state_ = KawazTanStateMoving;
    CGPoint point = self.position;
    CCFiniteTimeAction* go = [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.5f 
                                                                             position:ccp(point.x, point.y + contentSize_.height*0.8)] 
                                                    rate:0.5];
    CCFiniteTimeAction* normal = [CCCallFunc actionWithTarget:self selector:@selector(toNormal)];
    CCFiniteTimeAction* wait = [CCMoveBy actionWithDuration:1.0f position:CGPointMake(0, 0)];
    CCFiniteTimeAction* move = [CCCallFunc actionWithTarget:self selector:@selector(toMoving)];
    CCFiniteTimeAction* back = [CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.5f 
                                                                              position:ccp(point.x, point.y)] 
                                                     rate:0.5];
    CCFiniteTimeAction* change = [CCCallFunc actionWithTarget:self selector:@selector(onBacked)];
    CCSequence* seq = [CCSequence actions:go, normal, wait, move, back, change, nil];
    [self runAction:seq];
    return YES;
  }
  return NO;
}

- (BOOL)isMoving{
  return [self numberOfRunningActions] != 0;
}

- (void)draw{
  [super draw];
}

- (void)onBacked{
  state_ = KawazTanStateWaiting;
  NSString* filename = [NSString string];
  int r = rand()%100;
  if(r < 100.0*BOMB_RATE){
    type_ = KawazTanTypeBomb;
    filename = @"bomb.png";
    score_ = BOMB_SCORE;
  }else{
    type_ = rand()%3;
    filename = [NSString stringWithFormat:@"kawaz%d.png", type_];
    score_ = KAWAZTAN_SCORE;
  }
  CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:filename];
  CCSpriteFrame* sprite = [CCSpriteFrame frameWithTexture:texture 
                                                      rect:CGRectMake(0, 0, 
                                                                      texture.contentSize.width, 
                                                                      texture.contentSize.height)];
  [self setDisplayFrame:sprite];
}

- (void)toNormal{
  state_ = KawazTanStateNormal;
  if(type_ == KawazTanTypeBomb){
    SimpleAudioEngine* ae = [SimpleAudioEngine sharedEngine];
    [ae playEffect:@"fire.caf"];
  }
}

- (void)toMoving{
  state_ = KawazTanStateMoving;
}


@end
