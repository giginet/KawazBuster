//
//  KWVector.h
//  Kwing
//
//  Created by giginet on 10/12/08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "math.h"
@interface KWVector : NSObject {
	CGFloat _x,_y;
}
@property(assign, readwrite) CGFloat x;
@property(assign, readwrite) CGFloat y;
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
