//
//  LogoLayer.h
//  KawazBuster
//
//  Created by giginet on 11/05/27.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "KWTimer.h"

@interface LogoLayer : CCLayer {
  CCSprite* logo_;
  KWTimer* timer_;
}

+(CCScene *) scene;

@end
