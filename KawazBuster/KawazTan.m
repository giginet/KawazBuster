//
//  KawazTan.m
//  KawazBuster
//
//  Created by  on 11/06/14.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "KawazTan.h"

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
  }
  return self;
}

- (BOOL)tap{
  if(state_ == KawazTanStateNormal){
    state_ = KawazTanStateDamaged;
    CCTexture2D* damageTexture = [[CCTextureCache sharedTextureCache] addImage:@"danage.png"];
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
    CCSequence* seq = [CCSequence actions:go, wait, back, nil];
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

- (void)onEnter{
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:self.zOrder swallowsTouches:YES];
  [super onEnter];
}

- (void)onExit{
  [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
  [super onExit];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
  CCLOG(@"hoge");
  return YES;
}

@end
