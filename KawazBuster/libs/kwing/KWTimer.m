//
//  KWTimer.m
//  Kwing
//
//  Created by giginet on 11/03/04.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import "KWTimer.h"


@implementation KWTimer
@synthesize isActive=flagActive_, looping=flagLoop_;
@synthesize now=time_;
@synthesize max=max_;

+ (KWTimer*)timer{
  return [[[KWTimer alloc] init] autorelease];
}

+ (KWTimer*)timerWithMax:(int)max{
  return [[[KWTimer alloc] initWithMax:max] autorelease];
}

- (id)init{
	[super init];
	max_ = 0;
	time_ = 0;
	flagLoop_ = NO;
	flagActive_ = NO;
	return self;
}

- (id)initWithMax:(int)max{
	[self init];
	[self set:max];
	return self;
}

- (void)tick{
	[self count];
	if([self isOver]){
		if(flagLoop_){
			[self reset];
		}
	}
}

- (id)play{
	flagActive_ = YES;
	return self;
}

- (id)stop{
	[self pause];
	[self reset];
	return self;
}

- (id)pause{
	flagActive_ = NO;
	return self;
}

- (id)reset{
	time_ = 0;
	return self;
}

- (void)count{
	if(flagActive_) time_ += 1;
}

- (id)move:(int)n{
	time_ +=n;
	if([self isOver] && flagLoop_){
		time_ = time_ % max_;
	}
	return self;
}

- (BOOL)isOver{
	return time_ >= max_;
}

- (int)max{
  return max_;
}

- (void)set:(int)max{
  max_ = max;
}

- (BOOL)isLooping{
  return flagLoop_;
}

- (void)setLooping:(BOOL)loop{
  flagLoop_ = loop;
}

@end
