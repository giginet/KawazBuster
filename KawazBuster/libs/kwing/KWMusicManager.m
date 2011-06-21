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
@end

@implementation KWMusicManager

+ (id)sharedManager{
  return [KWMusicManager instance];
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
  CDAudioManager* am = [CDAudioManager sharedManager];
  introMusic_ = [[NSString alloc] initWithString:introFile];
  loopMusic_ = [[NSString alloc] initWithString:file];
  loop_= loop;
  if(introFile){
    [am preloadBackgroundMusic:file];
    [am playBackgroundMusic:introFile loop:NO];
    [am setBackgroundMusicCompletionListener:self selector:@selector(didFinishIntro)];
  }else{
    [am playBackgroundMusic:file loop:loop];
  }
}

- (void)fadeout:(ccTime)ms{
}

- (void)didFinishIntro{
  CDAudioManager* am = [CDAudioManager sharedManager];
  [am playBackgroundMusic:loopMusic_ loop:loop_];
  [am setBackgroundMusicCompletionListener:nil selector:nil];
}

@end
