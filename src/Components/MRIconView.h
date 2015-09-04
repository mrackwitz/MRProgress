//
//  MRIconView.h
//  MRProgress
//
//  Created by Marius Rackwitz on 22.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Base class for icons which are given by an UIBezierPath and drawn with a CAShapeLayer.
 Their circular outer border and their line is colored in their tintColor.
 */
@interface MRIconView : UIView

/**
 Duration of an animated progress change.

 Default is 0.0 which means no animation is used. The recommended value is 0.5.
 */
@property (nonatomic, assign) CFTimeInterval animationDuration UI_APPEARANCE_SELECTOR;

/**
 The line width of the outer circle

 Default is 1.0. Must be larger than zero.
 */
@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;

/**
 The line width of the icon

 Default is 1.0. Must be larger than zero.
 */
@property (nonatomic, assign) CGFloat lineWidth UI_APPEARANCE_SELECTOR;

/**
 Inner path.
 */
- (UIBezierPath *)path;

/**
 The line Width of circle

 Default is 1.0. Must be larger than zero.
 */
@property (nonatomic) CGFloat borderWidth UI_APPEARANCE_SELECTOR;

/**
 The line width of icon

 Default is 1.0. Must be larger than zero.
 */
@property (nonatomic) CGFloat lineWidth UI_APPEARANCE_SELECTOR;

@end


/**
 Draws a checkmark.
 */
@interface MRCheckmarkIconView : MRIconView
@end


/**
 Draws a cross.
 */
@interface MRCrossIconView : MRIconView
@end
