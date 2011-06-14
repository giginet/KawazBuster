//
//  Kawaz.h
//  KawazBuster
//
//  Created by giginet on 11/05/28.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "KWTimer.h"

@interface Kawaz : CCSprite {
 @private
  KWTimer* timer_;
 @protected
  int score_;
}

@end
