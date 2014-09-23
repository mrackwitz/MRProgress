//
//  MRAppearanceViewController.m
//  Example
//
//  Created by Marius Rackwitz on 21.07.14.
//  Copyright (c) 2014 Marius Rackwitz. All rights reserved.
//

#import "MRAppearanceViewController.h"
#import <MRProgress/MRActivityIndicatorView.h>
#import <MRProgress/MRCircularProgressView.h>
#import <MRProgress/MRProgressOverlayView.h>


@interface MRAppearanceViewController ()

@property (weak, nonatomic) IBOutlet MRActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet MRCircularProgressView *circularProgressView;
@property (weak, nonatomic) IBOutlet UIView *overlayContainerView;

@end


@implementation MRAppearanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        id apperance = [MRActivityIndicatorView appearanceWhenContainedIn:MRAppearanceViewController.class, nil];
        [apperance setLineWidth:20.0];
    }
    {
        id apperance = [MRActivityIndicatorView appearanceWhenContainedIn:MRProgressOverlayView.class, MRAppearanceViewController.class, nil];
        [apperance setLineWidth:1.0];
        
        self.circularProgressView.layer.borderColor = UIColor.redColor.CGColor;
    }
    //[self.activityIndicatorView startAnimating];
    
	{
        id apperance = [MRCircularProgressView appearanceWhenContainedIn:MRAppearanceViewController.class, nil];
        [apperance setLineWidth:10.0];
        [apperance setBorderWidth:5.0];
        [apperance setAnimationDuration:6.0];
        
        [self.circularProgressView setProgress:0.33];
    }
    {
        id apperance = [MRProgressOverlayView appearanceWhenContainedIn:MRAppearanceViewController.class, nil];
        [apperance setTitleLabelText:@"Testing …"];
        
        MRProgressOverlayView *view = [MRProgressOverlayView showOverlayAddedTo:self.overlayContainerView animated:NO];
        
        // Stop animation
        ((MRActivityIndicatorView *)view.modeView).hidesWhenStopped = NO;
        [((MRActivityIndicatorView *)view.modeView) stopAnimating];
    }
}

@end
