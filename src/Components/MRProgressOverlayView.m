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
#import "MRIconView.h"
#import "MRProgressHelper.h"


const CGFloat MRProgressOverlayViewCornerRadius = 7;
const CGFloat MRProgressOverlayViewMotionEffectExtent = 10;


@interface MRProgressOverlayView ()

@property (nonatomic, weak, readwrite) UIView *dialogView;
@property (nonatomic, weak, readwrite) UIView *blurView;

@property (nonatomic, weak, readwrite) UILabel *titleLabel;

@property (nonatomic, weak, readwrite) MRActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak, readwrite) MRActivityIndicatorView *smallActivityIndicatorView;
@property (nonatomic, weak, readwrite) UIActivityIndicatorView *smallDefaultActivityIndicatorView;
@property (nonatomic, weak, readwrite) MRCircularProgressView *circularProgressView;
@property (nonatomic, weak, readwrite) UIProgressView *horizontalBarProgressView;
@property (nonatomic, weak, readwrite) MRIconView *checkmarkIconView;
@property (nonatomic, weak, readwrite) MRIconView *crossIconView;

@end


@implementation MRProgressOverlayView

+ (instancetype)showOverlayAddedTo:(UIView *)view animated:(BOOL)animated {
    MRProgressOverlayView *overlayView = [self new];
	[view addSubview:overlayView];
	[overlayView show:animated];
	return overlayView;
}

+ (BOOL)dismissOverlayForView:(UIView *)view animated:(BOOL)animated {
    MRProgressOverlayView *overlayView = [self overlayForView:view];
	if (overlayView != nil) {
		[overlayView dismiss:animated];
		return YES;
	}
	return NO;
}

+ (NSUInteger)dismissAllOverlaysForView:(UIView *)view animated:(BOOL)animated {
    NSArray *views = [self allOverlaysForView:view];
	for (MRProgressOverlayView *overlayView in views) {
		[overlayView dismiss:YES];
		return YES;
	}
	return views.count;
}

+ (instancetype)overlayForView:(UIView *)view {
    NSEnumerator *subviewsEnum = view.subviews.reverseObjectEnumerator;
	for (UIView *subview in subviewsEnum) {
		if ([subview isKindOfClass:self]) {
			return (MRProgressOverlayView *)subview;
		}
	}
	return nil;
}

+ (NSArray *)allOverlaysForView:(UIView *)view {
    NSMutableArray *overlays = [NSMutableArray new];
	NSArray *subviews = view.subviews;
	for (UIView *view in subviews) {
		if ([view isKindOfClass:self]) {
			[overlays addObject:view];
		}
	}
	return overlays;
}

- (id)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (UIView *)initializeBlurView {
    UIView *blurView = [MRBlurView new];
    blurView.alpha = 0.98;
    [self.dialogView addSubview:blurView];
    
    return blurView;
}

- (void)commonInit {
    self.hidden = YES;
    
    // Container with blured background
    UIView *dialogView = [UIView new];
    [self addSubview:dialogView];
    self.dialogView = dialogView;
    
    [self applyMotionEffects];
    
    const CGFloat cornerRadius = MRProgressOverlayViewCornerRadius;
    
    // Create blurView
    self.blurView = [self initializeBlurView];
    self.blurView.layer.cornerRadius = cornerRadius;
    
    // Style the dialog to match the iOS7 UIAlertView
    dialogView.backgroundColor = UIColor.clearColor;
    dialogView.layer.cornerRadius = cornerRadius;
    dialogView.layer.shadowRadius = cornerRadius + 5;
    dialogView.layer.shadowOpacity = 0.1f;
    dialogView.layer.shadowOffset = CGSizeMake(-(cornerRadius+5)/2.0f, -(cornerRadius+5)/2.0f);
    
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
        MRActivityIndicatorView *smallActivityIndicatorView = [MRActivityIndicatorView new];
        self.smallActivityIndicatorView = smallActivityIndicatorView;
        smallActivityIndicatorView.hidesWhenStopped = YES;
        [dialogView addSubview:smallActivityIndicatorView];
        
        // Create small default activity indicator for text mode
        UIActivityIndicatorView *smallDefaultActivityIndicatorView = [UIActivityIndicatorView new];
        self.smallDefaultActivityIndicatorView = smallDefaultActivityIndicatorView;
        smallDefaultActivityIndicatorView.hidesWhenStopped = YES;
        smallDefaultActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [dialogView addSubview:smallDefaultActivityIndicatorView];
        
        // Create circular progress view for determinate circular mode
        MRCircularProgressView *circularProgressView = [MRCircularProgressView new];
        self.circularProgressView = circularProgressView;
        [dialogView addSubview:circularProgressView];
        
        // Create horizontal progress bar for determinate horizontal bar mode
        UIProgressView *horizontalBarProgressView = [UIProgressView new];
        self.horizontalBarProgressView = horizontalBarProgressView;
        [dialogView addSubview:horizontalBarProgressView];
        
        // Create checkmark icon view for checkmark mode
        MRCheckmarkIconView *checkmarkIconView = [MRCheckmarkIconView new];
        self.checkmarkIconView = checkmarkIconView;
        [dialogView addSubview:checkmarkIconView];
        
        // Create cross icon view for cross mode
        MRCrossIconView *crossIconView = [MRCrossIconView new];
        self.crossIconView = crossIconView;
        [dialogView addSubview:crossIconView];
    }
    
    [self hideAllModeViews];
    [self showCurrentModeView];
}


#pragma mark - Title label text

- (void)setTitleLabelText:(NSString *)titleLabelText {
    self.titleLabel.text = titleLabelText;
    [self initialLayoutSubviews];
}

- (NSString *)titleLabelText {
    return self.titleLabel.text;
}


#pragma mark - Tint color

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
    self.checkmarkIconView.tintColor = self.tintColor;
    self.crossIconView.tintColor = self.tintColor;
}


#pragma mark - Mode

- (void)setMode:(MRProgressOverlayViewMode)mode {
    UIView *oldView = [self viewForMode:self.mode];
    oldView.hidden = YES;
    if ([oldView respondsToSelector:@selector(stopAnimating)]) {
        [oldView performSelector:@selector(stopAnimating)];
    }
    
    _mode = mode;
    
    [self showCurrentModeView];
    
    if (!self.hidden) {
        [self initialLayoutSubviews];
    }
}

- (void)showCurrentModeView {
    UIView *newView = [self viewForMode:self.mode];
    newView.hidden = NO;
    if ([newView respondsToSelector:@selector(startAnimating)]) {
        [newView performSelector:@selector(startAnimating)];
    }
}

- (void)hideAllModeViews {
    [self.activityIndicatorView stopAnimating];
    [self.smallActivityIndicatorView stopAnimating];
    self.circularProgressView.hidden = YES;
    self.horizontalBarProgressView.hidden = YES;
    self.checkmarkIconView.hidden = YES;
    self.crossIconView.hidden = YES;
}

- (UIView *)viewForMode:(MRProgressOverlayViewMode)mode {
    switch (mode) {
        case MRProgressOverlayViewModeIndeterminate:
            return self.activityIndicatorView;
            
        case MRProgressOverlayViewModeIndeterminateSmall:
            return self.smallActivityIndicatorView;
            
        case MRProgressOverlayViewModeIndeterminateSmallDefault:
            return self.smallDefaultActivityIndicatorView;
            
        case MRProgressOverlayViewModeDeterminateCircular:
            return self.circularProgressView;
            
        case MRProgressOverlayViewModeDeterminateHorizontalBar:
            return self.horizontalBarProgressView;
            
        case MRProgressOverlayViewModeCheckmark:
            return self.checkmarkIconView;
            
        case MRProgressOverlayViewModeCross:
            return self.crossIconView;
    }
    return nil;
}


#pragma mark - Transitions

- (void)show:(BOOL)animated {
    [self initialLayoutSubviews];
    
    __weak UIView *dialogView = self.dialogView;
    if (animated) {
        dialogView.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
        dialogView.alpha = 0.5f;
        self.backgroundColor = UIColor.clearColor;
    }
    
    self.hidden = NO;
    
    void(^animBlock)() = ^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
        dialogView.transform = CGAffineTransformIdentity;
        dialogView.alpha = 1.0f;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:animBlock
                         completion:nil];
    } else {
        animBlock();
    }
}

- (void)dismiss:(BOOL)animated {
    [self hide:animated completion:^{
        [self removeFromSuperview];
    }];
}

- (void)hide:(BOOL)animated {
    [self hide:animated completion:nil];
}

- (void)hide:(BOOL)animated completion:(void(^)())completionBlock {
    __weak UIView *dialogView = self.dialogView;
    dialogView.transform = CGAffineTransformIdentity;
    dialogView.alpha = 1.0f;
    
    void(^animBlock)() = ^{
        self.backgroundColor = UIColor.clearColor;
        dialogView.transform = CGAffineTransformMakeScale(0.6f, 0.6f);
        dialogView.alpha = 0.0f;
    };
    
    void(^animCompletionBlock)(BOOL) = ^(BOOL finished) {
        self.hidden = YES;
        [self.activityIndicatorView stopAnimating];
        if (completionBlock) {
            completionBlock();
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                         animations:animBlock
                         completion:animCompletionBlock];
    } else {
        animBlock();
        animCompletionBlock(YES);
    }
}


#pragma mark - Layout

// Don't overwrite layoutSubviews here. This would cause issues with animation.
- (void)initialLayoutSubviews {
    self.frame = self.superview.frame;
    
    const CGFloat dialogPaddingY = 7;
    const CGFloat dialogWidth = 150;
    const CGFloat dialogPadding = 15;
    const CGFloat innerViewWidth = dialogWidth - 2*dialogPadding;
    
    const BOOL hasSmallIndicator = self.mode == MRProgressOverlayViewModeIndeterminateSmall
                                || self.mode == MRProgressOverlayViewModeIndeterminateSmallDefault;
    
    CGFloat y = dialogPaddingY;
    
    if (!self.titleLabel.hidden) {
        CGFloat titleLabelMinX = dialogPadding;
        CGFloat titleLabelMaxWidth = innerViewWidth;
        CGFloat offset = 0;
        
        CGSize modeViewSize = [self.smallDefaultActivityIndicatorView sizeThatFits:CGSizeMake(dialogWidth, dialogWidth)];
        if (hasSmallIndicator) {
            offset = modeViewSize.width + 7;
        }
        
        titleLabelMinX += offset;
        titleLabelMaxWidth -= offset;
        
        y += 3;
        
        CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(titleLabelMaxWidth, self.frame.size.height)];
        CGPoint titleLabelOrigin = CGPointMake(titleLabelMinX + (titleLabelMaxWidth - titleLabelSize.width) / 2.0f, y);
        self.titleLabel.frame = (CGRect){titleLabelOrigin, titleLabelSize};
        
        if (hasSmallIndicator) {
            CGPoint modeViewOrigin = CGPointMake(titleLabelOrigin.x - offset,
                                                 y + (titleLabelSize.height - modeViewSize.height) / 2.0f);
            CGRect modeViewFrame = {modeViewOrigin, modeViewSize};
            self.smallActivityIndicatorView.frame = modeViewFrame;
            self.smallDefaultActivityIndicatorView.frame = modeViewFrame;
        }
        
        y += CGRectGetMaxY(self.titleLabel.frame);
    }
    
    {
        const CGFloat dialogPadding = 30;
        const CGFloat innerViewWidth = dialogWidth - 2*dialogPadding;
        
        CGRect modeViewFrame = CGRectMake(dialogPadding, y, innerViewWidth, innerViewWidth);
        self.activityIndicatorView.frame = modeViewFrame;
        self.circularProgressView.frame = modeViewFrame;
        
        self.checkmarkIconView.frame = modeViewFrame;
        self.crossIconView.frame = modeViewFrame;
        
        self.horizontalBarProgressView.frame = CGRectMake(10, y, dialogWidth-20, 5);
        
        if (self.mode == MRProgressOverlayViewModeDeterminateHorizontalBar) {
            y += self.horizontalBarProgressView.frame.size.height + 15;
        } else if (!hasSmallIndicator) {
            y += modeViewFrame.size.height + 20;
        }
    }
    
    {
        self.dialogView.frame = MRCenterCGSizeInCGRect(CGSizeMake(dialogWidth, y), self.bounds);
        
        self.blurView.frame = self.dialogView.bounds;
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
    UIInterpolatingMotionEffect *effect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:keyPath type:type];
    effect.minimumRelativeValue = @(-MRProgressOverlayViewMotionEffectExtent);
    effect.maximumRelativeValue = @(MRProgressOverlayViewMotionEffectExtent);
    return effect;
}

- (void)applyMotionEffects {
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[[self motionEffectWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis],
                                        [self motionEffectWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis]];
    [self.dialogView addMotionEffect:motionEffectGroup];
}

@end
