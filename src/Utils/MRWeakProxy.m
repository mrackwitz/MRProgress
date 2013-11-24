//
//  MRWeakProxy.m
//  MRProgress
//
//  Created by Marius Rackwitz on 22.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRWeakProxy.h"


@implementation MRWeakProxy

+ (instancetype)weakProxyWithTarget:(id)target {
    MRWeakProxy *proxy = [self alloc];
    proxy.target = target;
    return proxy;
}

- (BOOL)respondsToSelector:(SEL)sel {
    return [_target respondsToSelector:sel] || [super respondsToSelector:sel];
}

- (id)forwardingTargetForSelector:(SEL)sel {
    return _target;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [_target methodSignatureForSelector:sel];
}

@end
