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

- (id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect{
  self = [super initWithTexture:texture rect:rect];
  if(self){
    hitArea_ = CGRectMake(0, 
                          0, 
                          self.contentSize.width, 
                          self.contentSize.height);
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
    return CGRectContainsRect(self.absoluteHitArea, sprite.absoluteHitArea);
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
  CGPoint origin = [self convertToWorldSpaceAR:hitArea_.origin];
  return CGRectMake(origin.x - hitArea_.size.width/2, 
                    origin.y - hitArea_.size.height/2, 
                    hitArea_.size.width, 
                    hitArea_.size.height);
}

- (CGPoint)center{
  return CGPointMake(position_.x + contentSize_.width/2, position_.y + contentSize_.height/2);
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

@end
