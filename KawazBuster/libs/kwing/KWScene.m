//
//  KWScene.m
//  Kwing
//
//  Created by giginet on 11/05/30.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "KWScene.h"


@implementation KWScene

- (id)init{
  if( (self = [super init]) ){
    winSize_ = [[CCDirector sharedDirector] winSize];
    CCLayerColor* bg = [CCColorLayer layerWithColor:backgroundColor_
                                              width:winSize_.width
                                             height:winSize_.height];
    [self addChild:bg];
    [self schedule:@selector(update:)];
  }
  return self;
}

+ (CCScene*)scene{
  CCScene* scene = [CCScene node];
  CCLayer* layer = [[self class] node];
  [scene addChild:layer];
  return scene;
}

-(void) registerWithTouchDispatcher{ 
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                   priority:0 
                                            swallowsTouches:YES];
}

- (void)update:(ccTime)dt{
}

@end
