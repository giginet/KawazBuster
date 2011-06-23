//
//  KWTimerLabel.h
//  KawazBuster
//
//  Created by  on 11/06/21.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "kwing.h"

typedef struct{
  int hour;
  int minute;
  int second;
  int milisecond;
} Time;

@interface KWTimerLabel : CCLabelTTF{
  BOOL active_;
  BOOL displayMiliSecond_;
  Time initial_;
  Time current_;
  id onFinishListener_;
  SEL onFinishSelector_;
}

- (void)play;
- (void)stop;
- (void)setTime:(int)hour minute:(int)minute second:(int)second;
- (BOOL)isActive;
- (int)leaveSecond;
- (void)setTimerCompletionListener:(id)listener selector:(SEL)selector;

@property(readwrite) BOOL displayMiliSecond;

@end
