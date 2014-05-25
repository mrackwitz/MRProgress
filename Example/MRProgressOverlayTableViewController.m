//
//  MRProgressOverlayTableViewController.m
//  MRProgress
//
//  Created by Marius Rackwitz on 09.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRProgressOverlayTableViewController.h"
#import "MRProgressOverlayView.h"


@interface MRProgressOverlayTableViewController ()

@end


@implementation MRProgressOverlayTableViewController

+ (void)load {
    [MRProgressOverlayView appearanceWhenContainedIn:UIImageView.class, nil].titleLabelText = @"Waiting ...";
}

- (UIView *)rootView {
    return self.delegate.viewForProgressOverlay;
}

- (IBAction)onShowIndeterminateProgressView:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView new];
    [self.rootView addSubview:progressView];
    [progressView show:YES];
    [self performBlock:^{
        [progressView dismiss:YES];
    } afterDelay:2.0];
}

- (IBAction)onShowIndeterminateMayStopProgressView:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView new];
    progressView.stopBlock = ^(MRProgressOverlayView *view){
        [view dismiss:YES];
    };
    [self.rootView addSubview:progressView];
    [progressView show:YES];
    [self performBlock:^{
        [progressView dismiss:YES];
    } afterDelay:2.0];
}

- (IBAction)onShowIndeterminateNoTextProgressView:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView new];
    progressView.titleLabelText = @"";
    [self.rootView addSubview:progressView];
    [progressView show:YES];
    [self performBlock:^{
        [progressView dismiss:YES];
    } afterDelay:2.0];
}

- (IBAction)onShowDeterminateCircularProgressView:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView new];
    progressView.mode = MRProgressOverlayViewModeDeterminateCircular;
    [self.rootView addSubview:progressView];
    [self simulateProgressView:progressView];
}

- (IBAction)onShowDeterminateCircularMayStopProgressView:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView new];
    progressView.mode = MRProgressOverlayViewModeDeterminateCircular;
    progressView.stopBlock = ^(MRProgressOverlayView *view){
        [view dismiss:YES];
    };
    [self.rootView addSubview:progressView];
    [self simulateProgressView:progressView];
}

- (IBAction)onShowDeterminateCircularNoTextProgressView:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView new];
    progressView.titleLabelText = @"";
    progressView.mode = MRProgressOverlayViewModeDeterminateCircular;
    [self.rootView addSubview:progressView];
    [self simulateProgressView:progressView];
}

- (IBAction)onShowDeterminateHorizontalBarProgressView:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView new];
    progressView.mode = MRProgressOverlayViewModeDeterminateHorizontalBar;
    [self.rootView addSubview:progressView];
    [self simulateProgressView:progressView];
}

- (IBAction)onShowIndeterminateSmallProgressView:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView new];
    progressView.mode = MRProgressOverlayViewModeIndeterminateSmall;
    [self.rootView addSubview:progressView];
    [progressView show:YES];
    [self performBlock:^{
        [progressView dismiss:YES];
    } afterDelay:2.0];
}

- (IBAction)onShowIndeterminateSmallDefaultProgressView:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.rootView animated:YES];
    progressView.mode = MRProgressOverlayViewModeIndeterminateSmallDefault;
    [self performBlock:^{
        [MRProgressOverlayView dismissOverlayForView:self.rootView animated:YES];
    } afterDelay:2.0];
}

- (IBAction)onShowCheckmarkProgressView:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.rootView animated:YES];
    progressView.mode = MRProgressOverlayViewModeCheckmark;
    progressView.titleLabelText = @"Succeed";
    [self performBlock:^{
        [progressView dismiss:YES];
    } afterDelay:2.0];
}

- (IBAction)onShowCrossProgressView:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.rootView animated:YES];
    progressView.mode = MRProgressOverlayViewModeCross;
    progressView.titleLabelText = @"Failed";
    [self performBlock:^{
        [progressView dismiss:YES];
    } afterDelay:2.0];
}

- (IBAction)onShowProgressViewWithLongTitleLabelText:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.rootView animated:YES];
    progressView.titleLabelText = @"Please stay awake!\nDo not press anykey while loading.";
    [self performBlock:^{
        [progressView dismiss:YES];
    } afterDelay:2.0];
}

- (IBAction)onShowSmallProgressViewWithLongTitleLabelText:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.rootView animated:YES];
    progressView.mode = MRProgressOverlayViewModeIndeterminateSmall;
    progressView.titleLabelText = @"Please stay awake!";
    [self performBlock:^{
        [progressView dismiss:YES];
    } afterDelay:2.0];
}

- (IBAction)onShowSmallProgressViewWithoutTitleLabelText:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self.rootView animated:YES];
    progressView.mode = MRProgressOverlayViewModeIndeterminateSmall;
    progressView.titleLabelText = @"";
    [self performBlock:^{
        [progressView dismiss:YES];
    } afterDelay:2.0];
}

- (IBAction)onShowAlertView:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Native Alert View" message:@"Just to compare blur effects." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)simulateProgressView:(MRProgressOverlayView *)progressView {
    static int i=0;
    [progressView show:YES];
    [self performBlock:^{
        [progressView setProgress:0.2 animated:YES];
        [self performBlock:^{
            [progressView setProgress:0.3 animated:YES];
            [self performBlock:^{
                [progressView setProgress:0.5 animated:YES];
                [self performBlock:^{
                    [progressView setProgress:0.4 animated:YES];
                    [self performBlock:^{
                        [progressView setProgress:0.8 animated:YES];
                        [self performBlock:^{
                            [progressView setProgress:1.0 animated:YES];
                            [self performBlock:^{
                                if (++i%2==1) {
                                    progressView.mode = MRProgressOverlayViewModeCheckmark;
                                    if (progressView.titleLabel.text.length > 0) {
                                        progressView.titleLabelText = @"Succeed";
                                    }
                                } else {
                                    progressView.mode = MRProgressOverlayViewModeCross;
                                    if (progressView.titleLabel.text.length > 0) {
                                        progressView.titleLabelText = @"Failed";
                                    }
                                }
                                [self performBlock:^{
                                    [progressView dismiss:YES];
                                } afterDelay:0.5];
                            } afterDelay:1.0];
                        } afterDelay:0.33];
                    } afterDelay:0.2];
                } afterDelay:0.1];
            } afterDelay:0.1];
        } afterDelay:0.5];
    } afterDelay:0.33];
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end
