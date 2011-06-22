//
//  KWStateManager.m
//  KawazBuster
//
//  Created by  on 11/06/23.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "KWStateManager.h"

@interface KWStateManager()

@property(readwrite, assign) KWState* runningState;
@end

@implementation KWStateManager
@synthesize runningState=runningState_;

- (id)init{
  self = [super init];
  if (self) {
    // Initialization code here.
    runningState_ = nil;
    stateStack_ = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc{
  [stateStack_ release];
  [runningState_ release];
  [super dealloc];
}

- (id)initWithInitialState:(KWState *)state{
  self = [self init];
  if(self){
    self.runningState = state;
    [stateStack_ addObject:state];
  }
  return self;
}

- (void)pushState:(KWState *)state{
  [self pushState:state andArgs:[NSDictionary dictionary]];
}

- (void)pushState:(KWState *)state andArgs:(NSDictionary *)userData{
  self.runningState = state;
  [stateStack_ addObject:state];
  [state setUp:userData];
}

- (void)replaceState:(KWState *)state{
  [self replaceState:state andArgs:[NSDictionary dictionary]];
}

- (void)replaceState:(KWState *)state andArgs:(NSDictionary *)userData{
  [runningState_ tearDown];
  self.runningState = state;
  [stateStack_ removeLastObject];
  [stateStack_ addObject:state];
  [runningState_ setUp:userData];
}

- (void)popState{
  [runningState_ tearDown];
  [stateStack_ removeLastObject];
  self.runningState = [stateStack_ lastObject];
}

@end
