//
//  MRCircularProgressView.h
//  MRProgress
//
//  Created by Marius Rackwitz on 10.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <UIKit/UIKit.h>

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
 
 If you set a lower value then the current progess the animation bounces.
 If you set a higher value then the current progress the animation eases out.
 
 @param progress The new progress value.
 
 @param animated Wether the change should been animated or not.
 */
- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
