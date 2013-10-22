//
//  MRProgressOverlayView.m
//  MRProgress
//
//  Created by Marius Rackwitz on 09.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRProgressOverlayView.h"
#import "MRActivityIndicatorView.h"
#import "MRBlurView.h"
#import "MRCircularProgressView.h"
#import "MRProgressHelper.h"


@interface MRProgressOverlayView ()

@property (nonatomic, weak, readwrite) UIView *dialogView;
@property (nonatomic, weak, readwrite) CAGradientLayer *gradientLayer;
@property (nonatomic, weak, readwrite) MRBlurView *blurView;

@property (nonatomic, weak, readwrite) UILabel *titleLabel;

@property (nonatomic, weak, readwrite) MRActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak, readwrite) UIActivityIndicatorView *smallActivityIndicatorView;
@property (nonatomic, weak, readwrite) MRCircularProgressView *circularProgressView;
@property (nonatomic, weak, readwrite) UIProgressView *horizontalBarProgressView;

@end


@implementation MRProgressOverlayView

- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.hidden = YES;
    
    // Container with blured background
    UIView *dialogView = [UIView new];
    [self addSubview:dialogView];
    self.dialogView = dialogView;
    
    [self applyMotionEffects];
    
    const CGFloat cornerRadius = 7;
    
    // Create blurView
    MRBlurView *blurView = [MRBlurView new];
    self.blurView = blurView;
    blurView.alpha = 0.9;
    blurView.layer.cornerRadius = cornerRadius;
    [dialogView addSubview:blurView];
    
    // Style the dialog to match the iOS7 UIAlertView
    dialogView.backgroundColor = UIColor.clearColor;
    dialogView.layer.cornerRadius = cornerRadius;
    dialogView.layer.shadowRadius = cornerRadius + 5;
    dialogView.layer.shadowOpacity = 0.1f;
    dialogView.layer.shadowOffset = CGSizeMake(-(cornerRadius+5)/2.0f, -(cornerRadius+5)/2.0f);
    
    CAGradientLayer *gradientLayer = [CAGradientLayer new];
    self.gradientLayer = gradientLayer;
    gradientLayer.frame = dialogView.bounds;
    gradientLayer.colors = @[
                             (id)[[UIColor colorWithWhite:0.8f alpha:0.8f] CGColor],
                             (id)[[UIColor colorWithWhite:0.9f alpha:0.8f] CGColor],
                             (id)[[UIColor colorWithWhite:0.8f alpha:0.8f] CGColor],
                             ];
    
    gradientLayer.cornerRadius = cornerRadius;
    [dialogView.layer insertSublayer:gradientLayer above:self.blurView.layer];
    
    // Create titleLabel
    UILabel *titleLabel = [UILabel new];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    titleLabel.textColor = UIColor.blackColor;
    titleLabel.text = @"Loading ...";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [dialogView addSubview:titleLabel];
    
    // Create mode dependent subviews
    {
        // Create activity indicator for indeterminate mode
        MRActivityIndicatorView *activityIndicatorView = [MRActivityIndicatorView new];
        self.activityIndicatorView = activityIndicatorView;
        [dialogView addSubview:activityIndicatorView];
        
        // Create small activity indicator for text mode
        UIActivityIndicatorView *smallActivityIndicatorView = [UIActivityIndicatorView new];
        self.smallActivityIndicatorView = smallActivityIndicatorView;
        smallActivityIndicatorView.hidesWhenStopped = YES;
        smallActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [dialogView addSubview:smallActivityIndicatorView];
        
        // Create circular progress view for determinate circular mode
        MRCircularProgressView *circularProgressView = [MRCircularProgressView new];
        self.circularProgressView = circularProgressView;
        [dialogView addSubview:circularProgressView];
        
        // Create horizontal progress bar for determinate horizontal bar mode
        UIProgressView *horizontalBarProgressView = [UIProgressView new];
        self.horizontalBarProgressView = horizontalBarProgressView;
        [dialogView addSubview:horizontalBarProgressView];
    }
    
    [self updateMode];
}

- (void)setTintColor:(UIColor *)tintColor {
    // Implemented to silent warning
    super.tintColor = tintColor;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.activityIndicatorView.tintColor = self.tintColor;
    self.smallActivityIndicatorView.tintColor = self.tintColor;
    self.circularProgressView.tintColor = self.tintColor;
    self.horizontalBarProgressView.tintColor = self.tintColor;
}

- (void)setMode:(MRProgressOverlayViewMode)mode {
    _mode = mode;
    [self updateMode];
}

- (void)updateMode {
    [self.activityIndicatorView stopAnimating];
    [self.smallActivityIndicatorView stopAnimating];
    self.circularProgressView.hidden = YES;
    self.horizontalBarProgressView.hidden = YES;
    
    switch (self.mode) {
        case MRProgressOverlayViewModeIndeterminate:
            [self.activityIndicatorView startAnimating];
            break;
            
        case MRProgressOverlayViewModeIndeterminateSmall:
            [self.smallActivityIndicatorView startAnimating];
            break;
            
        case MRProgressOverlayViewModeDeterminateCircular:
            self.circularProgressView.hidden = NO;
            break;
            
        case MRProgressOverlayViewModeDeterminateHorizontalBar:
            self.horizontalBarProgressView.hidden = NO;
            break;
            
        default:
            // Nothing to do.
            break;
    }
}

- (void)show {
    [self initialLayoutSubviews];
    
    UIView *dialogView = self.dialogView;
    dialogView.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
    dialogView.alpha = 0.5f;
    
    self.backgroundColor = UIColor.clearColor;
    self.hidden = NO;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
                         dialogView.transform = CGAffineTransformIdentity;
                         dialogView.alpha = 1.0f;
                     } completion:nil];
}

- (void)hide {
    UIView *dialogView = self.dialogView;
    dialogView.transform = CGAffineTransformIdentity;
    dialogView.alpha = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = UIColor.clearColor;
                         dialogView.transform = CGAffineTransformMakeScale(0.6f, 0.6f);
                         dialogView.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         self.hidden = YES;
                         [self.activityIndicatorView stopAnimating];
                     }];
}

- (void)initialLayoutSubviews {
    self.frame = self.superview.frame;
    
    const CGFloat dialogPaddingY = 7;
    const CGFloat dialogWidth = 150;
    const CGFloat dialogPadding = 15;
    const CGFloat innerViewWidth = dialogWidth - 2*dialogPadding;
    
    CGFloat y = dialogPaddingY;
    
    if (!self.titleLabel.hidden) {
        CGFloat titleLabelMinX = dialogPadding;
        CGFloat titleLabelMaxWidth = innerViewWidth;
        CGFloat offset = 0;
        
        CGSize modeViewSize = [self.smallActivityIndicatorView sizeThatFits:CGSizeMake(dialogWidth, dialogWidth)];
        if (self.mode == MRProgressOverlayViewModeIndeterminateSmall) {
            offset = modeViewSize.width + 7;
        }
        
        titleLabelMinX += offset;
        titleLabelMaxWidth -= offset;
        
        y += 3;
        
        CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(titleLabelMaxWidth, self.frame.size.height)];
        CGPoint titleLabelOrigin = CGPointMake(titleLabelMinX + (titleLabelMaxWidth - titleLabelSize.width) / 2.0f, y);
        self.titleLabel.frame = (CGRect){titleLabelOrigin, titleLabelSize};
        
        if (self.mode == MRProgressOverlayViewModeIndeterminateSmall) {
            CGPoint modeViewOrigin = CGPointMake(titleLabelOrigin.x - offset,
                                                 y + (titleLabelSize.height - modeViewSize.height) / 2.0f);
            self.smallActivityIndicatorView.frame = (CGRect){modeViewOrigin, modeViewSize};
        }
        
        y += CGRectGetMaxY(self.titleLabel.frame);
    }
    
    {
        const CGFloat dialogPadding = 30;
        const CGFloat innerViewWidth = dialogWidth - 2*dialogPadding;
        
        CGRect modeViewFrame = CGRectMake(dialogPadding, y, innerViewWidth, innerViewWidth);
        self.activityIndicatorView.frame = modeViewFrame;
        self.circularProgressView.frame = modeViewFrame;
        
        self.horizontalBarProgressView.frame = CGRectMake(10, y, dialogWidth-20, 5);
        
        if (self.mode == MRProgressOverlayViewModeDeterminateHorizontalBar) {
            y += self.horizontalBarProgressView.frame.size.height + 15;
        } else if (self.mode != MRProgressOverlayViewModeIndeterminateSmall) {
            y += modeViewFrame.size.height + 20;
        }
    }
    
    {
        self.dialogView.frame = MRCenterCGSizeInCGRect(CGSizeMake(dialogWidth, y), self.bounds);
        
        self.blurView.frame = self.dialogView.bounds;
        [self.blurView redraw];
        
        self.gradientLayer.frame = self.dialogView.bounds;
    }
}


#pragma mark - Control progress

- (void)setProgress:(float)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    switch (self.mode) {
        case MRProgressOverlayViewModeDeterminateCircular:
            [self.circularProgressView setProgress:progress animated:animated];
            break;
            
        case MRProgressOverlayViewModeDeterminateHorizontalBar:
            [self.horizontalBarProgressView setProgress:progress animated:animated];
            break;
            
        default:
            NSLog(@"%@: %@ or %@ are only valid to call when receiver is in a determinate mode!",
                  NSStringFromClass(self.class),
                  NSStringFromSelector(@selector(setProgress:)),
                  NSStringFromSelector(_cmd));
            break;
    }
}


#pragma mark - Helper to create UIMotionEffects

- (UIInterpolatingMotionEffect *)motionEffectWithKeyPath:(NSString *)keyPath type:(UIInterpolatingMotionEffectType)type {
    const CGFloat motionEffectExtent = 10;
    UIInterpolatingMotionEffect *effect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:keyPath type:type];
    effect.minimumRelativeValue = @(-motionEffectExtent);
    effect.maximumRelativeValue = @(motionEffectExtent);
    return effect;
}

- (void)applyMotionEffects {
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[[self motionEffectWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis],
                                        [self motionEffectWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis]];
    [self.dialogView addMotionEffect:motionEffectGroup];
}

@end
