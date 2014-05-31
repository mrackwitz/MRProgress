//
//  MRMethodCopier.m
//  MRProgress
//
//  Created by Marius Rackwitz on 31.05.14.
//  Copyright (c) 2014 Marius Rackwitz. All rights reserved.
//

#import "MRMethodCopier.h"
#import <objc/runtime.h>


@implementation MRMethodCopier

+ (instancetype)copierFromClass:(Class)originClass toClass:(Class)targetClass {
    MRMethodCopier *copier = [self new];
    copier.originClass = originClass;
    copier.targetClass = targetClass;
    return copier;
}

- (void)copyInstanceMethod:(SEL)selector {
    Method originMethod = class_getInstanceMethod(self.originClass, selector);
    IMP originImplementation = method_getImplementation(originMethod);
    const char *methodTypes = method_getTypeEncoding(originMethod);
    class_addMethod(self.targetClass, selector, originImplementation, methodTypes);
}

@end
