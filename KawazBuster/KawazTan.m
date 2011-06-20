//
//  KawazTan.m
//  KawazBuster
//
//  Created by  on 11/06/14.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "KawazTan.h"

@interface KawazTan()
- (BOOL)tap;
- (void)onBacked;
- (void)toNormal;
- (void)toMoving;
@end

@implementation KawazTan
@synthesize score=score_, state=state_;

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
    self.position = ccp(point.x, point.y);
    state_ = KawazTanStateWaiting;
  }
  return self;
}

- (BOOL)tap{
  if(state_ == KawazTanStateNormal){
    state_ = KawazTanStateDamaged;
    CCTexture2D* damageTexture = [[CCTextureCache sharedTextureCache] addImage:@"damage.png"];
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
  type_ = rand()%3;
  NSString* filename = [NSString stringWithFormat:@"kawaz%d.png", type_];
  CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:filename];
  CCSpriteFrame* sprite = [CCSpriteFrame frameWithTexture:texture 
                                                      rect:CGRectMake(0, 0, 
                                                                      texture.contentSize.width, 
                                                                      texture.contentSize.height)];
  [self setDisplayFrame:sprite];
}

- (void)toNormal{
  state_ = KawazTanStateNormal;
}

- (void)toMoving{
  state_ = KawazTanStateMoving;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
  CGPoint point = [self convertToWorldSpace:[self convertTouchToNodeSpace:touch]];
  if([self collideWithPoint:point] && state_ == KawazTanStateNormal){
    [self tap];
    return YES;
  }
  return NO;
}

- (void)onEnter{
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                   priority:2000-self.zOrder 
                                            swallowsTouches:YES];
  [super onEnter];
}

- (void)onExit{
  [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
  [super onExit];
}

@end
