//
//  KWVector.h
//  Kwing
//
//  Created by giginet on 10/12/08.
//  Copyright 2010 Kawaz. All rights reserved.
//

#import "math.h"
@interface KWVector : NSObject {
	CGFloat x_,y_;
}
@property(assign, readwrite) CGFloat x;
@property(assign, readwrite) CGFloat y;

+ (KWVector*)vector;
+ (KWVector*)vectorWithPoint:(CGPoint)point;

- (id)init;
- (id)initWithPoint:(CGPoint)point;

- (KWVector*)set:(CGPoint)point;
- (KWVector*)clone;
- (KWVector*)add:(KWVector*)v;
- (KWVector*)sub:(KWVector*)v;
- (CGFloat)scalar:(KWVector*)v;
- (CGFloat)cross:(KWVector*)v;
- (KWVector*)scale:(CGFloat)n;
- (KWVector*)normalize;
- (KWVector*)resize:(CGFloat)n;
- (KWVector*)rotate:(CGFloat)deg;
- (KWVector*)reverse;
- (KWVector*)zero;
- (KWVector*)max:(CGFloat)max;
- (KWVector*)min:(CGFloat)min;

@property(readonly) CGFloat length;
@property(readonly) CGFloat angle;
@end
