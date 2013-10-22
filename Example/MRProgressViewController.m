//
//  MRProgressViewController.m
//  MRProgress
//
//  Created by Marius Rackwitz on 09.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRProgressViewController.h"
#import "MRProgressOverlayView.h"


@interface MRProgressViewController ()

@end


@implementation MRProgressViewController

- (IBAction)onShowIndeterminteProgressView:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView new];
    [self.view addSubview:progressView];
    [progressView show];
    [self performBlock:^{
        [progressView hide];
    } afterDelay:2.0];
}

- (IBAction)onShowDeterminateCircularProgressView:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView new];
    progressView.mode = MRProgressOverlayViewModeDeterminateCircular;
    [self.view addSubview:progressView];
    [self simulateProgressView:progressView];
}

- (IBAction)onShowDeterminateHorizontalBarProgressView:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView new];
    progressView.mode = MRProgressOverlayViewModeDeterminateHorizontalBar;
    [self.view addSubview:progressView];
    [self simulateProgressView:progressView];
}

- (IBAction)onShowTextProgress:(id)sender {
    MRProgressOverlayView *progressView = [MRProgressOverlayView new];
    progressView.mode = MRProgressOverlayViewModeIndeterminateSmall;
    [self.view addSubview:progressView];
    [progressView show];
    [self performBlock:^{
        [progressView hide];
    } afterDelay:2.0];
}

- (IBAction)onShowAlertView:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Native Alert View" message:@"Just to compare blur effects." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)simulateProgressView:(MRProgressOverlayView *)progressView {
    [progressView show];
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
                                [progressView hide];
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
