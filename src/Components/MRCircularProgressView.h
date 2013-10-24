//
//  MRCircularProgressView.h
//  MRProgress
//
//  Created by Marius Rackwitz on 10.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 You use the MRCircularProgressView class to depict the progress of a task over time.
 */
@interface MRCircularProgressView : UIControl

/**
 A Boolean value that controls whether the receiver shows a stop button.
 
 If the value of this property is NO (the default), the receiver doesnot show a stop button. If the mayStop property is
 YES a stop button will be shown. You can catch fired events like known from UIControl.
 */
@property (nonatomic, assign) BOOL mayStop;

/**
 Current progress.
 
 Use associated setter for non animated changes. Otherwises use setProgress:aniamted:.
 */
@property (nonatomic, assign) float progress;

/**
 Duration of an animated progress change.
 
 Default is 0.3s. Must be larger than zero.
 */
@property (nonatomic, assign) CFTimeInterval animationDuration;

/**
 Change progress animated.
 
 The animation will be always linear.
 
 @param progress The new progress value.
 
 @param animated Specify YES to animate the change or NO if you do not want the change to be animated.
 */
- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
