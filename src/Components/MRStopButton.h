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
 Asks the view to calculate and return the frame to be displayed in its parent.
 
 @param parentSize   size of the parent node in the view hierachy
 */
- (CGRect)frameThatFits:(CGRect)parentSize;

@end
