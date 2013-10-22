//
//  MRIconView.h
//  MRProgress
//
//  Created by Marius Rackwitz on 22.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MRIconView : UIView

- (UIBezierPath *)path;

@end


@interface MRCheckmarkIconView : MRIconView

@end


@interface MRCrossIconView : MRIconView

@end
