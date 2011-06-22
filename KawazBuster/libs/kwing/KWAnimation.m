//
//  KWAnimation.m
//  Kwing
//
//  Created by giginet on 11/05/30.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "KWAnimation.h"

@implementation KWAnimation

+ (id)spriteWithTextureAtlas:(CCTexture2D *)texture andSize:(CGSize)size andAPS:(float)aps{
  CGSize texSize = [texture contentSize];
  int col = texSize.width/size.width;
  int row = texSize.height/size.height;
  int frameCount = col * row;
  NSMutableArray* frames = [NSMutableArray arrayWithCapacity:frameCount];
  for(int i=0;i<frameCount;++i){
    CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(i%col, i/col, texSize.width, texSize.height)];
    [frames addObject:frame];
  }
  return [KWAnimation spriteWithSpriteFrames:frames andAPS:aps];
}

+ (id)spriteWithSpriteFrames:(NSArray *)frames andAPS:(float)aps{
  KWSprite* sprite = [KWSprite spriteWithSpriteFrame:[frames objectAtIndex:0]];
  CCAnimation* animation = [CCAnimation animationWithFrames:frames delay:aps];
  CCAnimate* animate = [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO];
  CCSequence* seq = [CCSequence actions:animate, nil];
  [sprite runAction:[CCRepeatForever actionWithAction:seq]];
  return sprite;
}

+ (id)spriteWithFile:(NSString *)filename andSize:(CGSize)size andAPS:(float)aps{
  CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:filename];
  return [KWAnimation spriteWithTextureAtlas:texture andSize:size andAPS:aps];
}
 
+ (id)spriteWithArray:(NSArray *)textures andAPS:(float)aps{
  NSMutableArray* frames = [NSMutableArray arrayWithCapacity:[textures count]];
  for(CCTexture2D* texture in textures){
    CGSize texSize = texture.contentSize;
    CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(0, 0, texSize.width, texSize.height)];
    [frames addObject:frame];
  }
  return [KWAnimation spriteWithSpriteFrames:frames andAPS:aps];
}

+ (id)spriteWithFiles:(NSArray *)files andAPS:(float)aps{
  NSMutableArray* sprites = [NSMutableArray arrayWithCapacity:[files count]];
  for(NSString* file in files) {
		CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:file];
    [sprites addObject:texture];
	}
	return [KWAnimation spriteWithArray:sprites andAPS:aps];
}

@end
