//
//  KWState.h
//  KawazBuster
//
//  Created by  on 11/06/23.
//  Copyright 2011 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWState : NSObject{
}

+ (id)state;

- (void)setUp:(NSDictionary*)userData;
- (void)update;
- (void)draw;
- (void)tearDown;

@end
