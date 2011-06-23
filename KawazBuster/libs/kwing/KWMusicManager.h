//
//  KWMusicManager.h
//  Kwing
//
//  Created by  on 11/06/21.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "cocos2d.h"
#import "KWSingleton.h"
#import "CDAudioManager.h"

@interface KWMusicManager : KWSingleton{
  BOOL loop_;
  BOOL nextLoop_;
  NSString* introMusic_;
  NSString* loopMusic_;
  NSString* nextIntroMusic_;
  NSString* nextLoopMusic_;
  SEL introMusicCompletionSelector_;
	id introMusicCompletionListener_;
}

+ (id)sharedManager;

- (void)playMusic:(NSString*)file intro:(NSString*)introFile loop:(BOOL)loop;
- (void)playMusic:(NSString*)file loop:(BOOL)loop;
- (void)stopMusic;
- (void)fadeout:(ccTime)s;
- (void)setIntroMusicCompletionListener:(id)listener selector:(SEL)selector;
- (void)changeMusic:(NSString*)file intro:(NSString*)introFile loop:(BOOL)loop fadeout:(ccTime)s;

@property(readonly) CDLongAudioSource* music;
@end
