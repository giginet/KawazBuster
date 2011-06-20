//
//  KawazTan.h
//  KawazBuster
//
//  Created by  on 11/06/14.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "kwing.h"
#import "CCTouchDelegateProtocol.h"

typedef enum{
  KawazTanStateNormal,
  KawazTanStateWaiting,
  KawazTanStateMoving,
  KawazTanStateDamaged,
  KawazTanStateInvinsible,
  KawazTanStateDisable
} KawazTanState;

typedef enum{
  KawazTanTypeNormal,
  KawazTanTypeSmile,
  KAwazTanTypeDeride,
  KawazTanTypeBomb
} KawazTanType;

@interface KawazTan : KWSprite <CCTargetedTouchDelegate>{
 @private
  KawazTanType type_;
  KawazTanState state_;
  int score_;
}

- (id)initWithPosition:(CGPoint)point;
- (BOOL)start;
- (BOOL)isMoving;

@property(readonly) int score;
@property(readonly) KawazTanState state;
@end
