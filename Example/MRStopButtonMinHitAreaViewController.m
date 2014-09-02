//
//  MRStopButtonMinHitAreaViewController.m
//  Example
//
//  Created by Marius Rackwitz on 02/09/14.
//  Copyright (c) 2014 Marius Rackwitz. All rights reserved.
//

#import "MRStopButtonMinHitAreaViewController.h"
#import <MRProgress/MRProgress.h>


@interface MRStopButtonMinHitAreaViewController ()

@property (weak, nonatomic) IBOutlet MRActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet MRCircularProgressView *circularProgressView;

@end


@implementation MRStopButtonMinHitAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicatorView.mayStop = YES;
    self.circularProgressView.mayStop = YES;
    
    [self.activityIndicatorView.stopButton addTarget:self action:@selector(onStop:) forControlEvents:UIControlEventTouchUpInside];
    [self.circularProgressView.stopButton addTarget:self action:@selector(onStop:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onStop:(UIButton *)button {
    NSLog(@"Did triggered.");
}

@end
