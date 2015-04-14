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
