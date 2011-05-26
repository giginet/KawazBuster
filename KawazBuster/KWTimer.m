//
//  KWTimer.m
//  Kwing
//
//  Created by giginet on 11/03/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KWTimer.h"


@implementation KWTimer
@synthesize isActive=_flagActive, looping=_flagLoop;
@synthesize now=_time;
@synthesize max=_max;

- (id)init{
	[super init];
	_max = 0;
	_time = 0;
	_flagLoop = NO;
	_flagActive = NO;
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
		if(_flagLoop){
			[self reset];
		}
	}
}

- (id)play{
	_flagActive = YES;
	return self;
}

- (id)stop{
	[self pause];
	[self reset];
	return self;
}

- (id)pause{
	_flagActive = NO;
	return self;
}

- (id)reset{
	_time = 0;
	return self;
}

- (void)count{
	if(_flagActive) _time += 1;
}

- (id)move:(int)n{
	_time +=n;
	if([self isOver] && _flagLoop){
		_time = _time % _max;
	}
	return self;
}

- (BOOL)isOver{
	return _time >= _max;
}

- (int)max{
  return _max;
}

- (void)set:(int)max{
  _max = max;
}

- (BOOL)isLooping{
  return _flagLoop;
}

- (void)setLooping:(BOOL)loop{
  _flagLoop = loop;
}

@end
