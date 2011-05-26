//
//  LogoLayer.m
//  KawazBuster
//
//  Created by giginet on 11/05/27.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "LogoLayer.h"
#import "TitleLayer.h"

@interface LogoLayer()
  -(void)changeToTitle;
@end

@implementation LogoLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LogoLayer *layer = [LogoLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init{
	if( (self=[super init])) {
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    CCLayerColor* bg = [CCColorLayer layerWithColor:ccc4(255, 255, 255, 255) 
                                              width:windowSize.width
                                             height:windowSize.height];
    logo_ = [[CCSprite alloc] initWithFile:@"kawaz.png"];
    logo_.position = ccp(windowSize.width/2, windowSize.height/2);
    logo_.opacity = 0;
    timer_ = [[KWTimer alloc] initWithMax:120];
    [timer_ play];
    [self addChild:bg];
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
  CCScene* titleScene = [TitleLayer scene];
  CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f scene:titleScene];
  [[CCDirector sharedDirector] replaceScene:transition];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc{
	[logo_ release];
	[super dealloc];
}
@end
