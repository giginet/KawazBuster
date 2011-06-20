//
//  KWSprite.h
//  Kwing
//
//  Created by giginet on 11/05/30.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCTouchDelegateProtocol.h"

@interface KWSprite : CCSprite {
  // relative hitarea from 'anchor point'.
  CGRect hitArea_;
}

- (BOOL)collideWithPoint:(CGPoint)point;
- (BOOL)collideWithSprite:(KWSprite*)sprite;
- (BOOL)collideWithCircle:(CGPoint)center:(CGFloat)radius;

- (CGFloat)distance:(KWSprite*)sprite;

@property(readwrite) CGRect hitArea;
@property(readonly) CGRect absoluteHitArea;
@property(readonly) CGPoint center;
@property(readwrite) double x;
@property(readwrite) double y;
@end
