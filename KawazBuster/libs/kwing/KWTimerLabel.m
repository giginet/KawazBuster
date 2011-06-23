//
//  KWTimerLabel.m
//  KawazBuster
//
//  Created by  on 11/06/21.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "KWTimerLabel.h"
#import "GameConfig.h"

@interface KWTimerLabel()
- (void)tick:(ccTime)dt;
- (NSString*)humalize;
- (Time)convertToTime:(NSTimeInterval)second;
- (NSTimeInterval)convertToSecond:(Time)time;
@end

@implementation KWTimerLabel
@synthesize displayMiliSecond=displayMiliSecond_;

- (id)init{
  self = [super init];
  if (self) {
    active_ = NO;
    displayMiliSecond_ = NO;
    onFinishListener_ = nil;
    onFinishSelector_ = nil;
    [self setTime:0 minute:0 second:0];
    [self setString:[self humalize]];
  }
  return self;
}

- (void)dealloc{
  [super dealloc];
}

- (NSString*)humalize{
  int hour = current_.hour;
  int minute = current_.minute;
  int second = current_.second;
  NSMutableString* string = [NSMutableString string];
  if (initial_.hour == 0) {
    if(initial_.minute < 10){
      string = [NSMutableString stringWithFormat:@"%d:%02d", minute, second];
    }else{
      string = [NSMutableString stringWithFormat:@"%02d:%02d", minute, second];
    }
  }else if(initial_.minute == 0){
    string = [NSMutableString stringWithFormat:@"%02d", second];
  }else{
    string = [NSMutableString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
  }
  if(displayMiliSecond_){
    [string appendFormat:@":%03d", current_.milisecond];
  }
  return string;
}

- (void)play{
  active_ = YES;
  [self schedule:@selector(tick:) interval:1.0/FPS];
}

- (void)stop{
  active_ = NO;
  [self unschedule:@selector(tick:)];
}

- (void)setTime:(int)hour minute:(int)minute second:(int)second{
  current_.hour = hour;
  current_.minute = minute;
  current_.second = second;
  current_.milisecond = 0;
  initial_.hour = hour;
  initial_.minute = minute;
  initial_.second = second;
  initial_.milisecond = 0;
  [self setString:[self humalize]];
}

- (BOOL)isActive{
  return active_;
}

- (int)leaveSecond{
  return [self convertToSecond:current_];
}

- (void)tick:(ccTime)dt{
  if([self leaveSecond] > 0){
    if(active_){
      NSTimeInterval second = [self convertToSecond:current_];
      second -= dt;
      current_ = [self convertToTime:second];
    }
  }else{
    if (onFinishSelector_ && active_) {
      [onFinishListener_ performSelector:onFinishSelector_];
    }	
    active_ = NO;
  }
  [self setString:[self humalize]];
}

- (Time)convertToTime:(NSTimeInterval)second{
  Time t;
  t.hour = second/3600;
  t.minute = (second - t.hour*3600)/60;
  t.second = second - t.hour*3600 - t.minute*60;
  t.milisecond = (second - floor(second))*1000;
  return t;
}

- (NSTimeInterval)convertToSecond:(Time)time{
  float ms = (double)(time.milisecond)/1000.0;
  return 3600*time.hour + 60*time.minute + time.second + ms;
}

- (void)setTimerCompletionListener:(id)listener selector:(SEL)selector{
  onFinishListener_ = listener;
  onFinishSelector_ = selector;
}

@end
