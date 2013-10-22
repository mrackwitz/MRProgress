//
//  MRNativeNavigationBarProgressView.m
//  MRProgress
//
//  Created by Marius Rackwitz on 20.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRNativeNavigationBarProgressView.h"
#import "MRMessageInterceptor.h"
#import <objc/runtime.h>


@interface UINavigationController (NativeNavigationBarProgressView_Private)

@property (nonatomic, weak) MRNativeNavigationBarProgressView *nativeProgressView;

@end


@implementation UINavigationController (NativeNavigationBarProgressView_Private)

- (void)setNativeProgressView:(MRNativeNavigationBarProgressView *)progressView {
    objc_setAssociatedObject(self, @selector(nativeProgressView), progressView, OBJC_ASSOCIATION_ASSIGN);
}

- (MRNativeNavigationBarProgressView *)nativeProgressView {
    return objc_getAssociatedObject(self, @selector(nativeProgressView));
}

@end



@interface MRNativeNavigationBarProgressView () <UINavigationControllerDelegate>

@end


@implementation MRNativeNavigationBarProgressView

static void *MRNativeNavigationBarProgressViewObservationContext = &MRNativeNavigationBarProgressViewObservationContext;

+ (instancetype)progressViewForNavigationController:(UINavigationController *)navigationController {
    // Try to get existing bar
    MRNativeNavigationBarProgressView *progressView = navigationController.nativeProgressView;
    if (progressView) {
        return progressView;
    }
    
    // Create new bar
    UINavigationBar *navigationBar = navigationController.navigationBar;
    progressView = [MRNativeNavigationBarProgressView new];
    progressView.barView = navigationBar;
    
    progressView.progressTintColor = navigationBar.tintColor
        ?: UIApplication.sharedApplication.delegate.window.tintColor;
    
    // Store bar and add to view hierachy
    navigationController.nativeProgressView = progressView;
    [navigationController.navigationBar addSubview:progressView];
    
    // Observe topItem
    progressView.viewController = navigationController.topViewController;
    id delegate = navigationController.delegate;
    if (delegate) {
        MRMessageInterceptor *messageInterceptor = [[MRMessageInterceptor alloc] initWithMiddleMan:progressView];
        messageInterceptor.receiver = delegate;
        navigationController.delegate = (id<UINavigationControllerDelegate>)messageInterceptor;
    } else {
        navigationController.delegate = progressView;
    }
    
    return progressView;
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

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)commonInit {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.trackTintColor = UIColor.clearColor;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // Check if our controller is still the topViewController or was popped
    NSUInteger index = [navigationController.viewControllers indexOfObject:self.viewController];
    if (index == NSNotFound || index < navigationController.viewControllers.count-1) {
        if ([((id<NSObject>)navigationController.delegate) isKindOfClass:MRMessageInterceptor.class]) {
            // Stop intercepting navigationBar.delegate messages
            id receiver = ((MRMessageInterceptor *)navigationController.delegate).receiver;
            navigationController.delegate = receiver != self ? receiver : nil;
        } else {
            navigationController.delegate = nil;
        }
        
        // Remove reference
        navigationController.nativeProgressView = nil;
        
        // Remove receiver from view hierachy
        [self removeFromSuperview];
    }
}

- (void)setBarView:(UIView *)barView {
    _barView = barView;
    [self layoutSubviews];
}


#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect barFrame = self.barView.frame;
    const CGFloat progressBarHeight = self.frame.size.height;
    
    CGRect frame = CGRectMake(barFrame.origin.x,
                              0,
                              barFrame.size.width,
                              progressBarHeight);
    
    if ([self.barView isKindOfClass:UINavigationBar.class]) {
        frame.origin.y = barFrame.size.height - progressBarHeight;
    }
    
    if (!CGRectEqualToRect(self.frame, frame)) {
        self.frame = frame;
    }
}

@end
