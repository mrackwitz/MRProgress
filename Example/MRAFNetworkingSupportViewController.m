//
//  MRAFNetworkingSupportViewController.m
//  Example
//
//  Created by Marius Rackwitz on 16.07.14.
//  Copyright (c) 2014 Marius Rackwitz. All rights reserved.
//

#import "MRAFNetworkingSupportViewController.h"
#import "AFNetworking.h"
#import "MRActivityIndicatorView.h"
#import "MRCircularProgressView.h"
#import "MRActivityIndicatorView+AFNetworking.h"
#import "MRProgressView+AFNetworking.h"


@interface MRAFNetworkingSupportViewController ()

@property (weak, nonatomic) IBOutlet MRActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet MRCircularProgressView *circularProgressView;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end


@implementation MRAFNetworkingSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://httpbin.org/"]];
    self.manager = sessionManager;
}

- (IBAction)onGo:(id)sender {
    NSProgress *downloadProgress = nil;
    
    NSURLSessionDownloadTask *task = [self.manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]
                                                                  progress:&downloadProgress
                                                               destination:nil
                                                         completionHandler:nil];
    [self.activityIndicatorView setAnimatingWithStateOfTask:task];
    [self.circularProgressView setProgressWithDownloadProgressOfTask:task animated:YES];
}

@end
