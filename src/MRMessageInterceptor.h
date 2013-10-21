//
//  MRMessageInterceptor.h
//  MRProgress
//
//  Created by Marius Rackwitz on 10.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MRMessageInterceptor : NSObject

@property (nonatomic, weak) id middleMan;
@property (nonatomic, weak) id receiver;

- (id)initWithMiddleMan:(id)middleMan;

@end
