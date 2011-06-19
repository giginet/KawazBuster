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
  KawazTanStateDamaged,
  KawazTanStateInvinsible,
  KawazTanStateDisable
} KawazTanState;

@interface KawazTan : KWSprite{
 @private
  int type_;
  KawazTanState state_;
  int score_;
}

- (id)initWithPosition:(CGPoint)point;
- (BOOL)start;
- (BOOL)isMoving;

@property(readonly) int score;
@end
