//
//  TitleScene.m
//  KawazBuster
//
//  Created by giginet on 11/05/27.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "TitleScene.h"

@interface TitleScene()

@end

@implementation TitleScene

-(id)init{
	if( (self=[super init])) {
		KWSprite* background = [KWSprite spriteWithFile:@"title_background.png"];
    logo_ = [[KWSprite alloc] initWithFile:@"logo.png"];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    background.position = ccp(winSize.width/2, winSize.height/2);
    logo_.position = ccp(winSize.width/2, 250);
    [self addChild:background];
    [self addChild:logo_];
  }
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc{
  [super dealloc];
}
@end
