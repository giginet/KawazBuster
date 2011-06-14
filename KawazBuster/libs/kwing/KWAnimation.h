//
//  KWAnimation.h
//  Kwing
//
//  Created by giginet on 11/05/30.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "kwing.h"

@interface KWAnimation : KWSingleton {
}

+ (id)spriteWithTexture:(CCTexture2D *)texture andSize:(CGSize)size;
+ (id)spriteWithFile:(NSString *)filename andSize:(CGSize)size;

@end
