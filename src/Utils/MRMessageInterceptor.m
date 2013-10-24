//
//  MRMessageInterceptor.m
//  MRProgress
//
//  Created by Marius Rackwitz on 10.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRMessageInterceptor.h"


@implementation MRMessageInterceptor

- (id)initWithMiddleMan:(id)middleMan {
    self = [super init];
    if (self) {
        self.middleMan = middleMan;
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.middleMan respondsToSelector:aSelector]) {
        return self.middleMan;
    }
    if ([self.receiver respondsToSelector:aSelector]) {
        return self.receiver;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.middleMan respondsToSelector:aSelector]) {
        return YES;
    }
    if ([self.receiver respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

@end
