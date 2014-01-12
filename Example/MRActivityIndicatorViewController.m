//
//  MRActivityIndicatorViewController.m
//  MRProgress
//
//  Created by Marius Rackwitz on 20.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRActivityIndicatorViewController.h"
#import "MRActivityIndicatorView.h"
#import "MRColorPaletteViewController.h"


@interface MRActivityIndicatorViewController () <MRColorPaletteDelegate>

@property (weak, nonatomic) IBOutlet MRActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UISwitch *stopButtonSwitch;

@end


@implementation MRActivityIndicatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self.activityIndicatorView startAnimating];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ColorPalette"]) {
        MRColorPaletteViewController *colorPaletteVC = (MRColorPaletteViewController *)segue.destinationViewController;
        colorPaletteVC.delegate = self;
    }
}

- (IBAction)onStopButtonSwitchValueChanged:(id)sender {
    self.activityIndicatorView.mayStop = self.stopButtonSwitch.on;
}

- (void)colorPaletteViewController:(MRColorPaletteViewController *)colorPaletteViewController didSelectColor:(UIColor *)color {
    self.activityIndicatorView.tintColor = color;
}

@end
