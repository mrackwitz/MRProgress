//
//  MRWeakProxy.h
//  MRProgress
//
//  Created by Marius Rackwitz on 22.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Weak proxy to use in places where parameters will be retained, but should not.
 */
@interface MRWeakProxy : NSProxy

/**
 Target object.
 
 All selectors called on receiver will be redirected to this instance.
 */
@property (nonatomic, weak) id target;

/**
 Return a new weak proxy with given target.
 
 @param target  The target object
 */
+ (instancetype)weakProxyWithTarget:(id)target;

@end
