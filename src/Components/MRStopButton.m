//
//  MRStopButton.m
//  MRProgress
//
//  Created by Marius Rackwitz on 27.12.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRStopButton.h"
#import "MRProgressHelper.h"


@interface MRStopButton ()

@property (nonatomic, weak, readwrite) CAShapeLayer *shapeLayer;

@end


@implementation MRStopButton

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
    self.sizeRatio = 0.3;
    self.highlightedSizeRatio = 0.9;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    [self.layer addSublayer:shapeLayer];
    self.shapeLayer= shapeLayer;
    
    [self addTarget:self action:@selector(didTouchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    [self tintColorDidChange];
}

- (CGRect)frameThatFits:(CGRect)parentBounds {
    CGFloat sizeValue = MIN(parentBounds.size.width, parentBounds.size.height);
    CGSize viewSize = CGSizeMake(sizeValue, sizeValue);
    const CGFloat insetSizeRatio = (1 - self.sizeRatio) / 2.0;
    return CGRectInset(MRCenterCGSizeInCGRect(viewSize, parentBounds),
                       sizeValue * insetSizeRatio,
                       sizeValue * insetSizeRatio);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    if (self.tracking && self .touchInside) {
        const CGFloat insetSizeRatio = (1 - self.highlightedSizeRatio) / 2.0;
        frame = CGRectInset(frame,
                            frame.size.width * insetSizeRatio,
                            frame.size.height * insetSizeRatio);
    }
    
    self.shapeLayer.frame = frame;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.shapeLayer.backgroundColor = self.tintColor.CGColor;
}

- (void)didTouchDown {
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutSubviews];
    } completion:nil];
}

- (void)didTouchUpInside {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutSubviews];
    } completion:nil];
}

@end
