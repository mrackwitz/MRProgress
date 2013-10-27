//
//  MRBlurView.h
//  MRProgress
//
//  Created by Marius Rackwitz on 10.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 Blur implementation, which displays a blurred image screenshot of the window cropped to its absolute frame.
 */
@interface MRBlurView : UIImageView

/**
 Force redraw
 */
- (void)redraw;

@end
