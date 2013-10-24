//
//  MRMessageInterceptor.h
//  MRProgress
//
//  Created by Marius Rackwitz on 10.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 A message interceptor can be used if you want to intercept an existent delegate.
 You can set your intercepting delegate as middleMan and the original delegate as receiver.
 The new delegate will be the MRMessageInterceptor instance.
 You have to forwad manually intercepted messages to the receiver.
 */
@interface MRMessageInterceptor : NSObject

/**
 Middle man is the instance which should intercept calls on receiver.
 */
@property (nonatomic, weak) id middleMan;

/**
 Receiver is the instance which should receive all calls, which are not intercepted or which should be forwared manually
 after interception by the middleMan.
 */
@property (nonatomic, weak) id receiver;

/**
 Init a new instance with given middle man.
 
 @param middleMan Favored forward target for all received selectors.
 */
- (id)initWithMiddleMan:(id)middleMan;

@end
