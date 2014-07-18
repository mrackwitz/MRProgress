//
//  MRMethodCopier.h
//  MRProgress
//
//  Created by Marius Rackwitz on 31.05.14.
//  Copyright (c) 2014 Marius Rackwitz. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MRMethodCopier : NSObject

@property (nonatomic, assign) Class originClass;
@property (nonatomic, assign) Class targetClass;

/**
 Instantiate a new method copier
 
 @param originClass origin class, where implementation will be linked to
 @param targetClass target class, where the new methods will be added
 
 @return MRMethodCopier
 */
+ (instancetype)copierFromClass:(Class)originClass toClass:(Class)targetClass;

/**
 Copy an instance method from the receivers originClass to targetClass
 
 @param selector the given selector where the method is found and will be found
 */
- (void)copyInstanceMethod:(SEL)selector;

@end
