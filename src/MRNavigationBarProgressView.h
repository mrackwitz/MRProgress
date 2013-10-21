//
//  MRNavigationBarProgressView.h
//  MRProgress
//
//  Created by Marius Rackwitz on 09.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 A custom progress view which can be displayed at the bottom edge of the navigation bar like in Messages app
 or at the top edge of the toolbar like in Safari.
 */
@interface MRNavigationBarProgressView : UIView

/**
 Tint color of progress bar.
 */
@property (nonatomic, retain) UIColor *progressTintColor;

/**
 Current progress. Use associated setter for non animated changes. Otherwises use setProgress:aniamted:.
 */
@property (nonatomic, assign) float progress;

/**
 Change progress animated.
 
 If you set a lower value then the current progess the animation bounces.
 If you set a higher value then the current progress the animation eases out.
 */
- (void)setProgress:(float)progress animated:(BOOL)animated;

/**
 Get current progress view or initialize a new for given navigation controller.
 
 The navigationBar will be used to initialize the progress views frame and progressTintColor.
 You can destroy the current instance by using removeFromSuperview.
 */
+ (instancetype)progressViewForNavigationController:(UINavigationController *)navigationController;

@end


@interface UINavigationController (NavigationBarProgressView)

@property (nonatomic, readonly) MRNavigationBarProgressView *progressView;

@end
