//
//  MRIconView.m
//  MRProgress
//
//  Created by Marius Rackwitz on 22.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRIconView.h"
#import <QuartzCore/QuartzCore.h>


@implementation MRIconView

+ (void)load {
    [self.appearance setBorderWidth:1.0];
    [self.appearance setLineWidth:1.0];
}

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

- (UIBezierPath *)path {
    return nil;
}

+ (Class)layerClass {
    return CAShapeLayer.class;
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (void)commonInit {
    self.isAccessibilityElement = YES;

    self.shapeLayer.fillColor = UIColor.clearColor.CGColor;
    
    [self tintColorDidChange];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shapeLayer.path = self.path.CGPath;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    UIColor *const tintColor = self.tintColor;
    self.layer.borderColor = tintColor.CGColor;
    self.shapeLayer.strokeColor = tintColor.CGColor;
}

- (void)setFrame:(CGRect)frame {
    super.frame = frame;
    self.layer.cornerRadius = frame.size.width / 2.0;
}

#pragma mark - Properties

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)lineWidth {
    return self.shapeLayer.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.shapeLayer.lineWidth = lineWidth;
}


@end


@implementation MRCheckmarkIconView

- (void)commonInit {
    [super commonInit];
    
    self.accessibilityLabel = NSLocalizedString(@"Checkmark", @"Accessibility label for custom rendered checkmark icon");
}

- (UIBezierPath *)path {
    UIBezierPath *path = [UIBezierPath new];
    
    CGRect bounds = self.bounds;
    [path moveToPoint:CGPointMake(bounds.size.width * 0.2, bounds.size.height * 0.55)];
    [path addLineToPoint:CGPointMake(bounds.size.width * 0.325, bounds.size.height * 0.7)];
    [path addLineToPoint:CGPointMake(bounds.size.width * 0.75, bounds.size.height * 0.3)];
    
    return path;
}

@end


@implementation MRCrossIconView

- (void)commonInit {
    [super commonInit];
    
    self.accessibilityLabel = NSLocalizedString(@"Cross", @"Accessibility label for custom rendered cross icon");
}

- (UIBezierPath *)path {
    UIBezierPath *path = [UIBezierPath new];
    
    const double relativePadding = 0.25;
    CGSize size = self.bounds.size;
    double min = relativePadding;
    double max = 1 - relativePadding;
    [path moveToPoint:CGPointMake(size.width * min, size.height * min)];
    [path addLineToPoint:CGPointMake(size.width * max, size.height * max)];
    [path moveToPoint:CGPointMake(size.width * min, size.height * max)];
    [path addLineToPoint:CGPointMake(size.width * max, size.height * min)];
    
    return path;
}

@end
