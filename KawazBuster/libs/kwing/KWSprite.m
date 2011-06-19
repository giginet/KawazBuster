//
//  KWSprite.m
//  Kwing
//
//  Created by giginet on 11/05/30.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "KWSprite.h"
#import "KWVector.h"

@implementation KWSprite
@synthesize hitArea=hitArea_;
@synthesize isTouchEnabled=isTouchEnabled_;

- (id)init{
  if((self = [super init])){
  }
  return self;
}

- (BOOL)collideWithPoint:(CGPoint)point{
  if(rotation_ == 0){
    return CGRectContainsPoint(self.absoluteHitArea, point);
  }else{
    /*KWVector* vx = [KWVector vectorWithPoint:CGPointMake(self.absoluteHitArea.size.width, 0)];
    KWVector* vy = [KWVector vectorWithPoint:CGPointMake(0, self.absoluteHitArea.size.height)];
    KWVector* p = [[KWVector vectorWithPoint:point] sub:[KWVector vectorWithPoint:self.absoluteHitArea.origin]];
    [vx rotate:rotation_];
    [vy rotate:rotation_];
    return fabs([vx scalar:p]/[vx scalar:vx]) <= 1 && fabs([vy scalar:p]/[vy scalar:vy]) <= 1;*/
    return YES;
  }
}

- (BOOL)collideWithSprite:(KWSprite*)sprite{
  if(rotation_ == 0){
    return CGRectContainsRect(self.absoluteHitArea, sprite.hitArea);
  }else{
    // have not implemented.
    return YES;
  }  
}

- (BOOL)collideWithCircle:(CGPoint)center:(CGFloat)radius{
  // 後で載せる
  return NO;
}

- (CGFloat)distance:(KWSprite*)sprite{
  KWVector* this = [KWVector vectorWithPoint:self.anchorPoint];
  KWVector* other = [KWVector vectorWithPoint:sprite.anchorPoint];
  return [this sub:other].length;
}

- (CGRect)absoluteHitArea{
  CGPoint origin = [self convertToWorldSpace:hitArea_.origin];
  return CGRectMake(origin.x, origin.y, hitArea_.size.width, hitArea_.size.height);
}

- (CGPoint)center{
  return CGPointMake(position_.x + contentSize_.width/2, position_.y + contentSize_.height/2);
}

- (void)setTextureRectInPixels:(CGRect)rect rotated:(BOOL)rotated untrimmedSize:(CGSize)size{
  [super setTextureRectInPixels:rect rotated:rotated untrimmedSize:size];
  hitArea_ = CGRectMake(self.x, self.y, contentSize_.width, contentSize_.height);
}

- (double)x{
  return position_.x;
}

- (double)y{
  return position_.y;
}

- (void)setX:(double)x{
  position_.x = x;
}

- (void)setY:(double)y{
  position_.y = y;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
  return NO;
}

- (void)onEnter{
  if(isTouchEnabled_){
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                     priority:65535-self.zOrder 
                                              swallowsTouches:YES];
  }
  [super onEnter];
}

- (void)onExit{
  if(isTouchEnabled_){
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
  }
  [super onExit];
}

@end
