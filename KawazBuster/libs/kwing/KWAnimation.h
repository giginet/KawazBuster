//
//  KWAnimation.h
//  Kwing
//
//  Created by giginet on 11/05/30.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "kwing.h"

@interface KWAnimation : NSObject {
}

+ (id)spriteWithArray:(NSArray*)textures andAPS:(float)aps;
+ (id)spriteWithFiles:(NSArray*)files andAPS:(float)aps;
+ (id)spriteWithFile:(NSString *)filename andSize:(CGSize)size andAPS:(float)aps;
+ (id)spriteWithTextureAtlas:(CCTexture2D *)texture andSize:(CGSize)size andAPS:(float)aps;
+ (id)spriteWithSpriteFrames:(NSArray*)frames andAPS:(float)aps;

@end
