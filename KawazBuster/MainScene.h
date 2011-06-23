//
//  MainScene.h
//  KawazBuster
//
//  Created by giginet on 11/05/28.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "kwing.h"
#import "CDAudioManager.h"

@interface MainScene : KWScene{
  int score_;
  int highScore_;
  BOOL active_;
  NSArray* targets_;
  CCLabelTTF* scoreLabel_;
  CCLabelTTF* highScoreLabel_;
  KWTimerLabel* timerLabel_;
  KWStateManager* stateMgr_;
}

@end

@interface ReadyState : KWState
@end

@interface MainState : KWState
@end

@interface ResultState : KWState
@end