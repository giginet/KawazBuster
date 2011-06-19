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
- (void)changeType;
@end

@implementation KawazTan
@synthesize score=score_;

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
    self.isTouchEnabled = YES;
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
    state_ = KawazTanStateNormal;
    CGPoint point = self.position;
    CCFiniteTimeAction* go = [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.5f 
                                                                             position:ccp(point.x, point.y + contentSize_.height*0.8)] 
                                                    rate:0.5];
    CCFiniteTimeAction* wait = [CCMoveBy actionWithDuration:1.0f position:CGPointMake(0, 0)];
    CCFiniteTimeAction* back = [CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.5f 
                                                                              position:ccp(point.x, point.y)] 
                                                     rate:0.5];
    CCFiniteTimeAction* change = [CCCallFunc actionWithTarget:self selector:@selector(changeType)];
    CCSequence* seq = [CCSequence actions:go, wait, back, change, nil];
    [self runAction:seq];
    return YES;
  }
  return NO;
}

- (BOOL)isMoving{
  return [self numberOfRunningActions];
}

- (void)draw{
  [super draw];
}

- (void)changeType{
  state_ = KawazTanStateNormal;
  type_ = rand()%3;
  NSString* filename = [NSString stringWithFormat:@"kawaz%d.png", type_];
  CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:filename];
  CCSpriteFrame* sprite = [CCSpriteFrame frameWithTexture:texture 
                                                      rect:CGRectMake(0, 0, 
                                                                      texture.contentSize.width, 
                                                                      texture.contentSize.height)];
  [self setDisplayFrame:sprite];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
  CGPoint point = [self convertToWorldSpace:[self convertTouchToNodeSpace:touch]];
  if([self collideWithPoint:point]){
    [self tap];
    return YES;
  }
  return NO;
}

@end
