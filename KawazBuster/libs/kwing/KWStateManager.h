//
//  KWStateManager.h
//  KawazBuster
//
//  Created by  on 11/06/23.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "KWState.h"

@interface KWStateManager : NSObject{
  NSMutableArray* stateStack_;
  KWState* runningState_;
}

- (id)initWithInitialState:(KWState*)state;
- (id)initWithInitialState:(KWState *)state andArgs:(NSDictionary*)userData;

- (void)pushState:(KWState*)state;
- (void)pushState:(KWState*)state andArgs:(NSDictionary*)userData;
- (void)replaceState:(KWState*)state;
- (void)replaceState:(KWState*)state andArgs:(NSDictionary*)userData;
- (void)popState;

@property(readonly, assign) KWState* runningState;
@end
