//
//  KWMusicManager.m
//  Kwing
//
//  Created by  on 11/06/21.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "KWMusicManager.h"

@interface KWMusicManager()
- (void)didFinishIntro;
- (void)playNextMusic;
- (void)volumeDown:(ccTime)dt;
@end

@implementation KWMusicManager

+ (id)sharedManager{
  return [KWMusicManager instance];
}

- (id)init{
  self = [super init];
  if(self){
    introMusicCompletionListener_ = nil;
    introMusicCompletionSelector_ = nil;
  }
  return self;
}

- (void)dealloc{
  [introMusic_ release];
  [loopMusic_ release];
  [super dealloc];
}

- (void)playMusic:(NSString *)file loop:(BOOL)loop{
  [self playMusic:file intro:nil loop:loop];
}

- (void)playMusic:(NSString *)file intro:(NSString *)introFile loop:(BOOL)loop{
  CCScheduler* ss = [CCScheduler sharedScheduler];
  [ss unscheduleSelector:@selector(playNextMusic) forTarget:self];
  [ss unscheduleSelector:@selector(volumeDown:) forTarget:self];
  CDAudioManager* am = [CDAudioManager sharedManager];
  loopMusic_ = [[NSString alloc] initWithString:file];
  loop_= loop;
  if(introFile){
    introMusic_ = [[NSString alloc] initWithString:introFile];
    [am preloadBackgroundMusic:file];
    [am playBackgroundMusic:introFile loop:NO];
    [am setBackgroundMusicCompletionListener:self selector:@selector(didFinishIntro)];
  }else{
    introMusic_ = nil;
    [am playBackgroundMusic:file loop:loop];
  }
  self.music.volume = 1.0;
  [self setIntroMusicCompletionListener:nil selector:nil];
}

- (void)stopMusic{
  CDAudioManager* am = [CDAudioManager sharedManager];
  [am stopBackgroundMusic];
}

- (void)fadeout:(ccTime)s{
  CCScheduler* ss = [CCScheduler sharedScheduler];
  [ss scheduleSelector:@selector(volumeDown:) forTarget:self interval:s/20.0 paused:NO];
}

- (void)changeMusic:(NSString *)file intro:(NSString *)introFile loop:(BOOL)loop fadeout:(ccTime)s{
  [self fadeout:s];
  nextIntroMusic_ = [NSString stringWithString:introFile];
  nextLoopMusic_ = [NSString stringWithString:file];
  nextLoop_ = loop;
  CCScheduler* ss = [CCScheduler sharedScheduler];
  [ss scheduleSelector:@selector(playNextMusic) forTarget:self interval:s paused:NO];
}

- (void)didFinishIntro{
  CDAudioManager* am = [CDAudioManager sharedManager];
  [am playBackgroundMusic:loopMusic_ loop:loop_];
  [am setBackgroundMusicCompletionListener:nil selector:nil];
  if (introMusicCompletionSelector_ != nil) {
		[introMusicCompletionListener_ performSelector:introMusicCompletionSelector_];
	}
}

- (void)playNextMusic{
  [self playMusic:nextLoopMusic_ intro:nextIntroMusic_ loop:nextLoop_];
  CCScheduler* ss = [CCScheduler sharedScheduler];
  [ss unscheduleSelector:@selector(playNextMusic) forTarget:self];
  [ss unscheduleSelector:@selector(volumeDown:) forTarget:self];
  [self music].volume = 1.0;
}

- (void)volumeDown:(ccTime)dt{
  CDLongAudioSource* music = [self music];
  music.volume -= 1.0/20;
  if(music.volume <= 0){
    CCScheduler* ss = [CCScheduler sharedScheduler];
    [ss unscheduleSelector:@selector(volumeDown:) forTarget:self];
    [self stopMusic];
  }
}

- (void)setIntroMusicCompletionListener:(id)listener selector:(SEL)selector{
  introMusicCompletionListener_ = listener;
  introMusicCompletionSelector_ = selector;
}

- (CDLongAudioSource*)music{
  CDAudioManager* am = [CDAudioManager sharedManager];
  return am.backgroundMusic;
}

@end
