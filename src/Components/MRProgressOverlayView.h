//
//  MRProgressOverlayView.h
//  MRProgress
//
//  Created by Marius Rackwitz on 09.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    /** Progress is shown using a large round activity indicator view. (MRActivityIndicatorView) This is the default. */
    MRProgressOverlayViewModeIndeterminate,
    /** Progress is shown using a round, pie-chart like, progress view. (MRCircularProgressView) */
    MRProgressOverlayViewModeDeterminateCircular,
    /** Progress is shown using a horizontal progress bar. (UIProgressView) */
    MRProgressOverlayViewModeDeterminateHorizontalBar,
    /** Shows primarily a label. Progress is shown using a small activity indicator. (MRActivityIndicatorView) */
    MRProgressOverlayViewModeIndeterminateSmall,
    /** Shows primarily a label. Progress is shown using a small activity indicator. (UIActivityIndicatorView in UIActivityIndicatorViewStyleGray) */
    MRProgressOverlayViewModeIndeterminateSmallDefault,
    /** Shows a checkmark. (MRCheckmarkIconView) */
    MRProgressOverlayViewModeCheckmark,
    /** Shows a cross. (MRCrossIconView) */
    MRProgressOverlayViewModeCross,
} MRProgressOverlayViewMode;


/**
 Progress HUD to be shown over a whole view controller's view or window.
 Similar look to UIAlertView.
 */
@interface MRProgressOverlayView : UIView

/**
 Allows customization of blur effect.
 
 If you override this method, you are responsible for adding the view to hierachy.
 The view will not be retained.
 The cornerRadius of the layer of the returnValue will be initialized.
 */
- (UIView *)initializeBlurView;

/**
 Visualisation mode.
 
 How the progress should be visualised.
 */
@property (nonatomic, assign) MRProgressOverlayViewMode mode;

/**
 Current progress.
 
 Use associated setter for non animated changes. Otherwises use setProgress:aniamted:.
 */
@property (nonatomic, assign) float progress;

/**
 Change the tint color of the mode views.
 
 Redeclared to document usage, internally ```tintColorDidChange``` is used.
 
 @param tintColor The new tint color
 */
- (void)setTintColor:(UIColor *)tintColor;

/**
 Change progress animated.
 
 If you set a lower value then the current progess the animation bounces.
 If you set a higher value then the current progress the animation eases out.
 
 @param progress The new progress value.
 
 @param animated Wether the change should been animated or not.
 */
- (void)setProgress:(float)progress animated:(BOOL)animated;

/**
 Show the progress view.
 */
- (void)show;

/**
 Hide the progress view.
 */
- (void)hide;

@end
