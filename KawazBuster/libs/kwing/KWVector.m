//
//  KWVector.m
//  Kwing
//
//  Created by giginet on 10/12/08.
//  Copyright 2010 Kawaz. All rights reserved.
//

#import "KWVector.h"


@implementation KWVector

@synthesize x=x_, y=y_;

+ (KWVector*)vector{
  return [[[KWVector alloc] init] autorelease];
}

+ (KWVector*)vectorWithPoint:(CGPoint)point{
  return [[[KWVector alloc] initWithPoint:point] autorelease];
}

- (id)init{
	[super init];
	x_ = 0;
	y_ = 0;
	return self;
}

- (id)initWithPoint:(CGPoint)point{
	x_ = point.x;
	y_ = point.y;
	return self;
}

- (KWVector*)set:(CGPoint)point{
	x_ = point.x;
	y_ = point.y;
	return self;
}

- (KWVector*)clone{
	return [[KWVector alloc] initWithPoint:CGPointMake(x_, y_)];
}

- (KWVector*)add:(KWVector *)v{
	x_ += v.x;
	y_ += v.y;
	return self;
}

- (KWVector*)sub:(KWVector *)v{
	x_ -= v.x;
	y_ -= v.y;
	return self;
}

- (CGFloat)scalar:(KWVector *)v{
	return x_*v.x+y_*v.y;
}

- (CGFloat)cross:(KWVector *)v{
	return x_*v.y-y_*v.x;
}

- (KWVector*)scale:(CGFloat)n{
	x_ *= n;
	y_ *= n;
	return self;
}

- (CGFloat)length{
	return hypotf(x_, y_);
}

- (KWVector*)normalize{
	if([self length]==0){
		x_ = 0;
		y_ = 0;
		return self;
	}else{
		return [self scale:1/[self length]];
	}
}

- (KWVector*)resize:(CGFloat)n{
	return [[self normalize] scale:n];
}

- (CGFloat)angle{
	return atan2(y_, x_);
}

- (KWVector*)rotate:(CGFloat)deg{
	CGFloat rad = M_PI*deg/180;
	CGFloat tmpx = x_;
	x_ = sin(rad)*y_+cos(rad)*x_;
	y_ = cos(rad)*y_-sin(rad)*tmpx;
	return self;
}

- (KWVector*)reverse{
	x_ *=-1;
	y_ *=-1;
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

- (BOOL)isEqual:(id)object{
  KWVector* v = (KWVector*)object;
  return v.x == x_ && v.y == y_;
}

- (NSString*)description{
  return [NSString stringWithFormat:@"(%f, %f)", x_, y_];
}

@end
