//
//  MRProgressOverlayView+AFNetworking.h
//  MRProgress
//
//  Created by Marius Rackwitz on 12.03.14.
//  Copyright (c) 2014 Marius Rackwitz. All rights reserved.
//

#import <MRProgress/MRProgress.h>

#import <Availability.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import <UIKit/UIKit.h>

@class AFURLConnectionOperation;

/**
 This category adds methods to the MRProgress library's `MRProgressOverlayView` class. The methods in this category provide support for automatically dismissing, setting the mode and the progresss depending on the loading state of a request operation or session task.
 */
@interface MRProgressOverlayView (AFNetworking)

///----------------------------------
/// @name Animating for Session Tasks
///----------------------------------

/**
 Binds the animating state to the state of the specified task.
 
 @param task The task. If `nil`, automatic updating from any previously specified operation will be disabled.
 */
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
- (void)setModeAndProgressWithStateOfTask:(NSURLSessionTask *)task;
#endif

///---------------------------------------
/// @name Animating for Request Operations
///---------------------------------------

/**
 Binds the animating state to the execution state of the specified operation.
 
 @param operation The operation. If `nil`, automatic updating from any previously specified operation will be disabled.
 */
- (void)setModeAndProgressWithStateOfOperation:(AFURLConnectionOperation *)operation;

@end

#endif
