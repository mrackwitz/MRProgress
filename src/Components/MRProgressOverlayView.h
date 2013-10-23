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
 Creates a new overlay, adds it to provided view and shows it. The counterpart to this method is hideOverlayForView:animated.
 
 @param view The view that the overlay will be added to
 @param animated Specify YES to animate the transition or NO if you do not want the transition to be animated.
 @return A reference to the created overlay.
 */
+ (instancetype)showOverlayAddedTo:(UIView *)view animated:(BOOL)animated;

/**
 Finds the top-most overlay subview and hides it. The counterpart to this method is showOverlayAddedTo:animated:.
 
 @param view The view that is going to be searched for a overlay subview.
 @param animated Specify YES to animate the transition or NO if you do not want the transition to be animated.
 @return YES if a overlay was found and removed, NO otherwise.
 */
+ (BOOL)hideOverlayForView:(UIView *)view animated:(BOOL)animated;

/**
 Finds all the overlay subviews and hides them.
 
 @param view The view that is going to be searched for overlay subviews.
 @param animated Specify YES to animate the transition or NO if you do not want the transition to be animated.
 @return the number of overlays found and removed.
 */
+ (NSUInteger)hideAllOverlaysForView:(UIView *)view animated:(BOOL)animated;

/**
 Finds the top-most overlay subview and returns it.
 
 @param view The view that is going to be searched.
 @return A reference to the last overlay subview discovered.
 */
+ (instancetype)overlayForView:(UIView *)view;

/**
 Finds all overlay subviews and returns them.
 
 @param view The view that is going to be searched.
 @return All found overlay views (array of MBProgressOverlayView objects).
 */
+ (NSArray *)allOverlaysForView:(UIView *)view;

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
 
 @param animated Specify YES to animate the transition or NO if you do not want the transition to be animated.
 */
- (void)show:(BOOL)animated;

/**
 Hide the progress view.
 
 @param aniamted Specify YES to animate the transition or NO if you do not want the transition to be animated.
 */
- (void)hide:(BOOL)animated;

/**
 Hide the progress view and remove on animation completion from the view hierachy.
 
 @param aniamted Specify YES to animate the transition or NO if you do not want the transition to be animated.
 */
- (void)dismiss:(BOOL)animated;

@end
