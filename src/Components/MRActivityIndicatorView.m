//
//  MRActivityIndicatorView.m
//  MRProgress
//
//  Created by Marius Rackwitz on 10.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MRActivityIndicatorView.h"


NSString *const MRActivityIndicatorViewSpinAnimationKey = @"MRActivityIndicatorViewSpinAnimationKey";


@interface MRActivityIndicatorView ()

@end


@implementation MRActivityIndicatorView

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

+ (Class)layerClass {
    return CAShapeLayer.class;
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (void)commonInit {
    self.hidesWhenStopped = YES;
    
    self.layer.borderWidth = 0;
    self.shapeLayer.lineWidth = 2.0f;
    self.shapeLayer.fillColor = UIColor.clearColor.CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    if (frame.size.width != frame.size.height) {
        // Ensure that we have a square frame
        CGFloat s = MAX(frame.size.width, frame.size.height);
        frame.size.width = s;
        frame.size.height = s;
        self.frame = frame;
    }
    
    self.shapeLayer.path = [self layoutPath].CGPath;
}

- (UIBezierPath *)layoutPath {
    const double TWO_M_PI = 2.0*M_PI;
    double startAngle = 0.75 * TWO_M_PI;
    double endAngle = startAngle + TWO_M_PI * 0.9;
    
    CGFloat width = self.bounds.size.width;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f)
                                          radius:width/2.2f
                                      startAngle:startAngle
                                        endAngle:endAngle
                                       clockwise:YES];
}


#pragma mark - Hook tintColor

- (void)tintColorDidChange  {
    [super tintColorDidChange];
    self.shapeLayer.strokeColor = self.tintColor.CGColor;
}


#pragma mark - Control animation

- (void)startAnimating {
    _animating = YES;
    
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue        = @(1*2*M_PI);
    spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    spinAnimation.duration       = 1.0;
    spinAnimation.repeatCount    = INFINITY;
    [self.layer addAnimation:spinAnimation forKey:MRActivityIndicatorViewSpinAnimationKey];
    
    if (self.hidesWhenStopped) {
        self.hidden = NO;
    }
}

- (void)stopAnimating {
    _animating = NO;
    
    [self.layer removeAnimationForKey:MRActivityIndicatorViewSpinAnimationKey];
    
    if (self.hidesWhenStopped) {
        self.hidden = YES;
    }
}

- (BOOL)isAnimating {
    return _animating;
}

@end
