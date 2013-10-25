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
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.window.screen.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextRotateCTM(ctx, MRRotationForStatusBarOrientation());
    CGContextTranslateCTM(ctx, -origin.x, -origin.y);
    [self.window drawViewHierarchyInRect:self.window.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
