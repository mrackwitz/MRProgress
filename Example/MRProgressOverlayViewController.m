//
//  MRProgressOverlayViewController.m
//  Example
//
//  Created by Marius Rackwitz on 24.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRProgressOverlayViewController.h"
#import "MRProgressOverlayTableViewController.h"


@interface MRProgressOverlayViewController () <MRProgressOverlayTableViewControllerDelegate>

@end


@implementation MRProgressOverlayViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ProgressOverlayTable"]) {
        MRProgressOverlayTableViewController *tableVC = (MRProgressOverlayTableViewController *)segue.destinationViewController;
        tableVC.delegate = self;
    }
}

- (UIView *)viewForProgressOverlay {
    return self.view;
}

@end
