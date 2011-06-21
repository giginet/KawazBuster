//
//  KWMusicManager.h
//  Kwing
//
//  Created by  on 11/06/21.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "kwing.h"
#import "CDAudioManager.h"

@interface KWMusicManager : KWSingleton{
  BOOL loop_;
  NSString* introMusic_;
  NSString* loopMusic_;
}

+ (id)sharedManager;

- (void)playMusic:(NSString*)file intro:(NSString*)introFile loop:(BOOL)loop;
- (void)playMusic:(NSString*)file loop:(BOOL)loop;
- (void)fadeout:(ccTime)ms;

@end
