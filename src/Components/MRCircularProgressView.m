//
//  MRCircularProgressView.m
//  MRProgress
//
//  Created by Marius Rackwitz on 10.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MRCircularProgressView.h"
#import "MRProgressHelper.h"
#import "MRWeakProxy.h"


@interface MRCircularProgressView ()

@property (nonatomic, strong, readwrite) NSNumberFormatter *numberFormatter;

@property (nonatomic, weak, readwrite) UILabel *valueLabel;
@property (nonatomic, weak, readwrite) UIView *stopView;

@property (nonatomic, assign, readwrite) float fromProgress;
@property (nonatomic, assign, readwrite) float toProgress;
@property (nonatomic, assign, readwrite) CFTimeInterval startTime;
@property (nonatomic, strong, readwrite) CADisplayLink *displayLink;

@end


@implementation MRCircularProgressView

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
    self.animationDuration = 0.3;
    self.progress = 0;
    
    [self addTarget:self action:@selector(didTouchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    self.numberFormatter = numberFormatter;
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    numberFormatter.locale = NSLocale.currentLocale;
    
    self.layer.borderWidth = 2.0f;
    
    self.shapeLayer.lineWidth = 2.0f;
    self.shapeLayer.fillColor = UIColor.clearColor.CGColor;
    
    UILabel *valueLabel = [UILabel new];
    self.valueLabel = valueLabel;
    valueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    valueLabel.textColor = UIColor.blackColor;
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:valueLabel];
    
    UIControl *stopView = [UIControl new];
    self.stopView = stopView;
    [self addSubview:stopView];
    
    [self mayStopDidChange];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat offset = 4;
    CGRect valueLabelRect = self.bounds;
    valueLabelRect.origin.x += offset;
    valueLabelRect.size.width -= offset;
    self.valueLabel.frame = valueLabelRect;
    
    self.layer.cornerRadius = self.frame.size.width / 2.0f;
    self.shapeLayer.path = [self layoutPath].CGPath;
    
    CGFloat stopViewSizeValue = MIN(self.bounds.size.width, self.bounds.size.height);
    CGSize stopViewSize = CGSizeMake(stopViewSizeValue, stopViewSizeValue);
    const CGFloat stopViewSizeRatio = 0.35;
    CGRect stopViewFrame = CGRectInset(MRCenterCGSizeInCGRect(stopViewSize, self.bounds),
                                       self.bounds.size.width * stopViewSizeRatio,
                                       self.bounds.size.height * stopViewSizeRatio);
    if (self.tracking && self.touchInside) {
        stopViewFrame = CGRectInset(stopViewFrame,
                                    self.bounds.size.width * 0.033,
                                    self.bounds.size.height * 0.033);
    }
    self.stopView.frame = stopViewFrame;
}

- (UIBezierPath *)layoutPath {
    const double TWO_M_PI = 2.0 * M_PI;
    const double startAngle = 0.75 * TWO_M_PI;
    const double endAngle = startAngle + TWO_M_PI * self.progress;
    
    CGFloat width = self.frame.size.width;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f)
                                          radius:width/2.0f - 2.5f
                                      startAngle:startAngle
                                        endAngle:endAngle
                                       clockwise:YES];
}


#pragma mark - Hook tintColor

- (void)tintColorDidChange {
    [super tintColorDidChange];
    UIColor *tintColor = self.tintColor;
    self.shapeLayer.strokeColor = tintColor.CGColor;
    self.layer.borderColor = tintColor.CGColor;
    self.valueLabel.textColor = tintColor;
    self.stopView.backgroundColor = tintColor;
}


#pragma mark - May stop implementation

- (void)setMayStop:(BOOL)mayStop {
    _mayStop = mayStop;
    [self mayStopDidChange];
}

- (void)mayStopDidChange {
    self.enabled = self.mayStop;
    self.stopView.hidden = !self.mayStop;
    self.valueLabel.hidden = self.mayStop;
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

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self.stopView) {
        // Allow hits inside stop view
        return self;
    } else if (hitView == self) {
        // Ignore hits inside whole circular view
        return nil;
    }
    // Allow all other subviews (external?)
    return hitView;
}


#pragma mark - Control progress

- (void)setProgress:(float)progress {
    NSParameterAssert(progress >= 0 && progress <= 1);
    
    // Stop running animation
    if (self.displayLink) {
        [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        self.displayLink = nil;
    }
    
    _progress = progress;
    
    [self updateProgress];
}

- (void)updateProgress {
    [self updatePath];
    [self updateLabel];
}

- (void)updatePath {
    self.shapeLayer.path = [self layoutPath].CGPath;
}

- (void)updateLabel {
    self.valueLabel.text = [self.numberFormatter stringFromNumber:@(self.progress)];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    if (animated) {
        if (self.progress == progress) {
            return;
        }
        
        if (self.displayLink) {
            // Reuse current display link and manipulate animation params
            self.startTime = CACurrentMediaTime();
            self.fromProgress = self.progress;
            self.toProgress = progress;
        } else {
            [self animateToProgress:progress];
        }
    } else {
        self.progress = progress;
    }
}

- (void)setAnimationDuration:(CFTimeInterval)animationDuration {
    NSParameterAssert(animationDuration > 0);
    _animationDuration = animationDuration;
}

- (void)animateToProgress:(float)progress {
    self.fromProgress = self.progress;
    self.toProgress = progress;
    self.startTime = CACurrentMediaTime();
    
    [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
    self.displayLink = [CADisplayLink displayLinkWithTarget:[MRWeakProxy weakProxyWithTarget:self] selector:@selector(animateFrame:)];
    [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
}

- (void)animateFrame:(CADisplayLink *)displayLink {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        CGFloat d = (displayLink.timestamp - self.startTime) / self.animationDuration;
        
        if (d >= 1.0) {
            // Order is important! Otherwise concurrency will cause errors, because setProgress: will detect an
            // animation in progress and try to stop it by itself.
            [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
            self.displayLink = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progress = self.toProgress;
            });
            
            return;
        }
        
        _progress = self.fromProgress + d * (self.toProgress - self.fromProgress);
        UIBezierPath *path = [self layoutPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shapeLayer.path = path.CGPath;
            [self updateLabel];
        });
    });
}

@end
