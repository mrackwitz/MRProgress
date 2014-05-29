//
//  MRStopButton.h
//  MRProgress
//
//  Created by Marius Rackwitz on 27.12.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 Stop button used by progress views to stop the related and visualised running task.
 */
@interface MRStopButton : UIButton

/**
 Inset size ratio
 
 The ratio by which the size of the click area will be resized, while touch is tracked inside.
 A positive value means that the stop button will be shrinked.
 A negative value means that the stop button will be enlagred.
 
 */
@property (nonatomic, assign) CGFloat insetSizeRatio;

/**
 Asks the view to calculate and return the frame to be displayed in its parent.
 
 @param parentSize   size of the parent node in the view hierachy
 */
- (CGRect)frameThatFits:(CGRect)parentSize;

@end
