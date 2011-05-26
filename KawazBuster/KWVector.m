//
//  KWVector.m
//  Kwing
//
//  Created by giginet on 10/12/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KWVector.h"


@implementation KWVector

@synthesize x=_x, y=_y;

- (id)init{
	[super init];
	_x = 0;
	_y = 0;
	return self;
}

- (id)initWithPoint:(CGPoint)point{
	_x = point.x;
	_y = point.y;
	return self;
}

- (KWVector*)set:(CGPoint)point{
	_x = point.x;
	_y = point.y;
	return self;
}

- (KWVector*)clone{
	return [[KWVector alloc] initWithPoint:CGPointMake(_x, _y)];
}

- (KWVector*)add:(KWVector *)v{
	_x += v.x;
	_y += v.y;
	return self;
}

- (KWVector*)sub:(KWVector *)v{
	_x -= v.x;
	_y -= v.y;
	return self;
}

- (CGFloat)scalar:(KWVector *)v{
	return _x*v.x+_y*v.y;
}

- (CGFloat)cross:(KWVector *)v{
	return _x*v.y-_y*v.x;
}

- (KWVector*)scale:(CGFloat)n{
	_x *= n;
	_y *= n;
	return self;
}

- (CGFloat)length{
	return sqrt(_x*_x+_y*_y);
}

- (KWVector*)normalize{
	if([self length]==0){
		_x = 0;
		_y = 0;
		return self;
	}else{
		return [self scale:1/[self length]];
	}
}

- (KWVector*)resize:(CGFloat)n{
	return [[self normalize] scale:n];
}

- (CGFloat)angle{
	return atan2(_y, _x);
}

- (KWVector*)rotate:(CGFloat)deg{
	CGFloat rad = M_PI*deg/180;
	CGFloat tmpx = _x;
	_x = sin(rad)*_y+cos(rad)*_x;
	_y = cos(rad)*_y-sin(rad)*tmpx;
	return self;
}

- (KWVector*)reverse{
	_x *=-1;
	_y *=-1;
	return self;
}

- (KWVector*)zero{
	return [self set:CGPointMake(0, 0)];
}

- (KWVector*)max:(CGFloat)max{
	if([self length] > max){
		[self resize:max]; 
	}
	return self;
}

- (KWVector*)min:(CGFloat)min{
	if([self length] < min){
		[self resize:min]; 
	}
	return self;
}
@end
