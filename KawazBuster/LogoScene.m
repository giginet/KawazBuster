//
//  LogoScene.m
//  KawazBuster
//
//  Created by giginet on 11/05/27.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "LogoScene.h"
#import "TitleScene.h"

@interface LogoScene()
  -(void)changeToTitle;
@end

@implementation LogoScene

// on "init" you need to initialize your instance
-(id) init{
	backgroundColor_ = ccc4(255, 255, 255, 255);
  if( (self=[super init])) {
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    logo_ = [[CCSprite alloc] initWithFile:@"kawaz.png"];
    logo_.position = ccp(windowSize.width/2, windowSize.height/2);
    logo_.opacity = 0;
    timer_ = [[KWTimer alloc] initWithMax:120];
    [timer_ play];
    [self addChild:logo_];
    [self schedule:@selector(update:)];
    self.isTouchEnabled = YES;
  }
	return self;
}

-(void) registerWithTouchDispatcher{ 
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                   priority:0 
                                            swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
  return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
  [self changeToTitle];
}

- (void)update:(ccTime)dt{
  [timer_ tick];
  if(timer_.now < 64){
    logo_.opacity += 4;
  }else if(timer_.now < 128){
  }else if(timer_.now < 190){
    logo_.opacity -= 4;
  }else{
    logo_.opacity = 0;
    [self changeToTitle];
  }
}

- (void)changeToTitle{
  CCScene* titleScene = [TitleScene scene];
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f scene:titleScene];
  [[CCDirector sharedDirector] replaceScene:transition];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc{
	[logo_ release];
	[super dealloc];
}
@end
