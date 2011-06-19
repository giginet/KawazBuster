//
//  KWScene.h
//  Kwing
//
//  Created by giginet on 11/05/30.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface KWScene : CCLayer {
  ccColor4B backgroundColor_;
  CGSize winSize_;
}

// returns a CCScene that contains this layer as the only child
+ (CCScene*)scene;

- (void)update:(ccTime)dt;

@end
