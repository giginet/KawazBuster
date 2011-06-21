//
//  MainScene.h
//  KawazBuster
//
//  Created by giginet on 11/05/28.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "kwing.h"
#import "CDAudioManager.h"
#import "GameTimer.h"

@interface MainScene : KWScene{
  int score_;
  int highScore_;
  BOOL active_;
  NSArray* targets_;
  CCLabelTTF* scoreLabel_;
  CCLabelTTF* highScoreLabel_;
  GameTimer* timerLabel_;
}

@end
