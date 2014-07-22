//
//  MRProgressOverlayView+AFNetworking.h
//  MRProgress
//
//  Created by Marius Rackwitz on 12.03.14.
//  Copyright (c) 2014 Marius Rackwitz. All rights reserved.
//

#import "MRProgressOverlayView.h"

#import <Availability.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import <UIKit/UIKit.h>

@class AFURLConnectionOperation;

/**
 This category adds methods to the MRProgress library's `MRProgressOverlayView` class. The methods in this category provide support for automatically dismissing, setting the mode and the progresss depending on the loading state of a request operation or session task.
 */
@interface MRProgressOverlayView (AFNetworking)

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000

///----------------------------------
/// @name Animating for Session Tasks
///----------------------------------

/**
 Binds the animating state to the state of the specified task.
 
 @param task The task. If `nil`, automatic updating from any previously specified operation will be disabled.
 */
- (void)setModeAndProgressWithStateOfTask:(NSURLSessionTask *)task;
/**
 Sets the `stopBlock` of the receiver, so that it will stop the specified task.
 
 @param task  The task. If `nil`, it clears the `stopBlock`.
 */
- (void)setStopBlockForTask:(NSURLSessionTask *)task;

#endif

///---------------------------------------
/// @name Animating for Request Operations
///---------------------------------------

/**
 Binds the animating state to the execution state of the specified operation.
 
 @param operation The operation. If `nil`, automatic updating from any previously specified operation will be disabled.
 */
- (void)setModeAndProgressWithStateOfOperation:(AFURLConnectionOperation *)operation;

/**
 Sets the `stopBlock` of the receiver, so that it will stop the specified operation.
 
 @param operation The operation. If `nil`, it clears the `stopBlock`.
 */
- (void)setStopBlockForOperation:(AFURLConnectionOperation *)operation;

@end

#endif
