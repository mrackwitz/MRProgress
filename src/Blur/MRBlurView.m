//
//  MRBlurView.m
//  MRProgress
//
//  Created by Marius Rackwitz on 10.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRBlurView.h"
#import "UIImage+MRImageEffects.h"
#import "MRProgressHelper.h"


@interface MRBlurView ()

@end


@implementation MRBlurView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.image = [[self snapshot] mr_applyBlurWithRadius:30.0 tintColor:[UIColor colorWithWhite:0.97 alpha:0.82] saturationDeltaFactor:1.0 maskImage:nil];
}


#pragma mark - Image helper

- (UIImage *)snapshot {
    CGPoint origin = [self convertPoint:self.frame.origin toView:self.window];
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    CGSize size = self.frame.size;
    
    // Begin context (with device scale)
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    const CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    // Rotate according to device orientation
    CGContextRotateCTM(context, 2*M_PI - MRRotationForStatusBarOrientation());
    
    // Translate to draw at the absolute origin of the receiver
    CGContextTranslateCTM(context, -origin.x, -origin.y);
    
    // Draw the window
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
    
    // Capture the image and exit context
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
