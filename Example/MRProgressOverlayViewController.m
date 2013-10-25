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

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end


@implementation MRProgressOverlayViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ProgressOverlayTable"]) {
        MRProgressOverlayTableViewController *tableVC = (MRProgressOverlayTableViewController *)segue.destinationViewController;
        tableVC.delegate = self;
    }
}

- (UIView *)viewForProgressOverlay {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            return self.view;
        case 1:
            return self.view.window;
        case 2:
            return self.imageView;
    }
    return nil;
}

@end
