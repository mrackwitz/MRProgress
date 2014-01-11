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


NSString *const MRCircularProgressViewProgressAnimationKey = @"MRCircularProgressViewProgressAnimationKey";


@interface MRCircularProgressView ()

@property (nonatomic, strong, readwrite) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong, readwrite) NSTimer *valueLabelUpdateTimer;

@property (nonatomic, weak, readwrite) UILabel *valueLabel;
@property (nonatomic, weak, readwrite) UIView *stopView;

@end


@implementation MRCircularProgressView {
    int _valueLabelProgressPercentDifference;
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

+ (Class)layerClass {
    return CAShapeLayer.class;
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (void)commonInit {
    _animationDuration = 0.3;
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
    const double endAngle = startAngle + TWO_M_PI;
    
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
    [self.layer removeAnimationForKey:MRCircularProgressViewProgressAnimationKey];
    
    _progress = progress;
    
    [self updateProgress];
}

- (void)updateProgress {
    [self updatePath];
    [self updateLabel:self.progress];
}

- (void)updatePath {
    self.shapeLayer.strokeEnd = self.progress;
}

- (void)updateLabel:(float)progress {
    self.valueLabel.text = [self.numberFormatter stringFromNumber:@(progress)];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    if (animated) {
        if (self.progress == progress) {
            return;
        }
        
        [self animateToProgress:progress];
    } else {
        self.progress = progress;
    }
}

- (void)setAnimationDuration:(CFTimeInterval)animationDuration {
    NSParameterAssert(animationDuration > 0);
    _animationDuration = animationDuration;
}

- (void)animateToProgress:(float)progress {
    // Stop running animation
    [self.layer removeAnimationForKey:MRCircularProgressViewProgressAnimationKey];
    
    // Add shape animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = self.animationDuration;
    animation.fromValue = @(self.progress);
    animation.toValue = @(progress);
    animation.delegate = self;
    [self.shapeLayer addAnimation:animation forKey:MRCircularProgressViewProgressAnimationKey];
    
    // Add timer to update valueLabel
    _valueLabelProgressPercentDifference = (progress - self.progress) * 100;
    CFTimeInterval timerInterval =  self.animationDuration / ABS(_valueLabelProgressPercentDifference);
    self.valueLabelUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval
                                                                  target:self
                                                                selector:@selector(onValueLabelUpdateTimer:)
                                                                userInfo:nil
                                                                 repeats:YES];
    
    
    _progress = progress;
}

- (void)onValueLabelUpdateTimer:(NSTimer *)timer {
    if (_valueLabelProgressPercentDifference > 0) {
        _valueLabelProgressPercentDifference--;
    } else {
        _valueLabelProgressPercentDifference++;
    }
    
    [self updateLabel:self.progress - (_valueLabelProgressPercentDifference / 100.0f)];
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self updateProgress];
    [self.valueLabelUpdateTimer invalidate];
    self.valueLabelUpdateTimer = nil;
}

@end
