//
//  KWTimer.h
//  Kwing
//
//  Created by giginet on 11/03/04.
//  Copyright 2011 Kawaz. All rights reserved.
//

@interface KWTimer : NSObject {
@private
	int time_, max_;
	BOOL flagLoop_, flagActive_;
}

+ (KWTimer*)timer;
+ (KWTimer*)timerWithMax:(int)max;

- (id)init;
- (id)initWithMax:(int)max;

- (void)tick;

- (id)play;
- (id)stop;
- (id)pause;

- (id)reset;

- (void)count;
- (id)move:(int)n;

- (BOOL)isOver;

@property(readonly) BOOL isActive;
@property(getter=isLooping) BOOL looping;
@property(readonly) int now;
@property(setter=set:) int max;
@end
