//
//  MRCircularProgressViewController.m
//  MRProgress
//
//  Created by Marius Rackwitz on 21.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRCircularProgressViewController.h"
#import "MRCircularProgressView.h"


@interface MRCircularProgressViewController ()

@property (weak, nonatomic) IBOutlet MRCircularProgressView *circularProgressView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UISwitch *animatedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *stopButtonSwitch;

@end


@implementation MRCircularProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.circularProgressView.stopButton addTarget:self action:@selector(onCircularProgressViewTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)onProgressSliderValueChanged:(id)sender {
    [self.circularProgressView setProgress:self.progressSlider.value animated:self.animatedSwitch.on];
}

- (IBAction)onStopButtonSwitchValueChanged:(id)sender {
    self.circularProgressView.mayStop = self.stopButtonSwitch.on;
}

- (void)onCircularProgressViewTouchUpInside:(id)sender {
    self.circularProgressView.progress = 0;
}

@end
