//
//  KWStateManager.m
//  KawazBuster
//
//  Created by  on 11/06/23.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "KWStateManager.h"

@interface KWStateManager()

@end

@implementation KWStateManager
@synthesize runningState=runningState_;

- (id)init{
  self = [super init];
  if (self) {
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
  self = [self initWithInitialState:state andArgs:[NSDictionary dictionary]];
  return self;
}

- (id)initWithInitialState:(KWState *)state andArgs:(NSDictionary *)userData{
  self = [self init];
  if(self){
    [runningState_ release];
    runningState_ = [state retain];
    [stateStack_ addObject:state];
    [state setUp:userData];
  }
  return self;
}

- (void)pushState:(KWState *)state{
  [self pushState:state andArgs:[NSDictionary dictionary]];
}

- (void)pushState:(KWState *)state andArgs:(NSDictionary *)userData{
  [runningState_ release];
  runningState_ = [state retain];
  [stateStack_ addObject:state];
  [state setUp:userData];
}

- (void)replaceState:(KWState *)state{
  [self replaceState:state andArgs:[NSDictionary dictionary]];
}

- (void)replaceState:(KWState *)state andArgs:(NSDictionary *)userData{
  [runningState_ tearDown];
  [runningState_ release];
  runningState_ = [state retain];
  [stateStack_ removeLastObject];
  [stateStack_ addObject:state];
  [runningState_ setUp:userData];
}

- (void)popState{
  [runningState_ tearDown];
  [stateStack_ removeLastObject];
  [runningState_ release];
  runningState_ = [[stateStack_ lastObject] retain];
}

@end
