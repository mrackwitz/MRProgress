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
    NSAssert(originImplementation != NULL, @"Didn't found method %@ on origin class %@.", NSStringFromSelector(selector), self.originClass);
    const char *methodTypes = method_getTypeEncoding(originMethod);
#if defined(NS_BLOCK_ASSERTIONS)
    __attribute__((__unused__)) BOOL success;
#else
    BOOL success;
#endif
    success = class_addMethod(self.targetClass, selector, originImplementation, methodTypes);
    NSAssert(success, @"Failed to copy method %@ from origin class %@ to target class %@.", NSStringFromSelector(selector), self.originClass, self.targetClass);
}

@end
