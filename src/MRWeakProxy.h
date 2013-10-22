//
//  MRWeakProxy.h
//  MRProgress
//
//  Created by Marius Rackwitz on 22.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MRWeakProxy : NSProxy

@property (nonatomic, weak) id target;

+ (instancetype)weakProxyWithTarget:(id)target;

@end
