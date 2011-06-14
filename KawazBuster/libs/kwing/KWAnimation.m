//
//  KWAnimation.m
//  Kwing
//
//  Created by giginet on 11/05/30.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "KWAnimation.h"
#import "GameConfig.h"

@implementation KWAnimation

+ (id)spriteWithTexture:(CCTexture2D *)texture andSize:(CGSize)size{
  CGSize texSize = [texture contentSize];
  int col = texSize.width/size.width;
  int row = texSize.height/size.height;
  int frameCount = col * row;
  NSMutableArray* frames = [NSMutableArray arrayWithCapacity:frameCount];
  for(int i=0;i<frameCount;++i){
    CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(i%col, i/col, texSize.width, texSize.height)];
    [frames addObject:frame];
  }
  CCSprite* sprite = [CCSprite spriteWithSpriteFrame:[frames objectAtIndex:0]];
  CCAnimation* animation = [CCAnimation animationWithFrames:frames delay:1/FPS];
  CCAnimate* animate = [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO];
  CCSequence* seq = [CCSequence actions:animate, nil];
  [sprite runAction:[CCRepeatForever actionWithAction:seq]];
  return sprite;
}

+ (id)spriteWithFile:(NSString *)filename andSize:(CGSize)size{
  CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:filename];
  return [KWAnimation spriteWithTexture:texture andSize:size];
}

@end
