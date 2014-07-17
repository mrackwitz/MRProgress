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
#import "MRProgressOverlayView+AFNetworking.h"


@interface MRAFNetworkingSupportViewController ()

@property (weak, nonatomic) IBOutlet MRActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet MRCircularProgressView *circularProgressView;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end


@implementation MRAFNetworkingSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicatorView.hidesWhenStopped = NO;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://httpbin.org/"] sessionConfiguration:config];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager = sessionManager;
}

- (IBAction)onActivityIndicatorGo:(id)sender {
    NSURLSessionDataTask *task = [self.manager GET:@"/delay/3"
                                            parameters:nil
                                               success:nil
                                               failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                   NSLog(@"Task %@ failed with error: %@", task, error);
                                               }];
    [self.activityIndicatorView setAnimatingWithStateOfTask:task];
}

- (IBAction)onCircularProgressViewGo:(id)sender {
    NSProgress *downloadProgress = nil;
    NSURLSessionDownloadTask *task = [self.manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"/bytes/1000000" relativeToURL:self.manager.baseURL]]
                                                                  progress:&downloadProgress
                                                               destination:nil
                                                         completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
                                                             NSLog(@"Task completed with error: %@", error);
                                                         }];
    [task resume];
    [self.circularProgressView setProgressWithDownloadProgressOfTask:task animated:YES];
}

- (IBAction)onOverlayViewGo:(id)sender {
    NSURLSessionDataTask *task = [self.manager GET:@"/drip"
                                        parameters:@{ @"numbytes": @100, @"duration": @0.1, @"delay": @2 }
                                           success:nil
                                           failure:^(NSURLSessionDataTask *task, NSError *error) {
                                               NSLog(@"Task %@ failed with error: %@", task, error);
                                           }];
    [[MRProgressOverlayView showOverlayAddedTo:self.view animated:YES] setModeAndProgressWithStateOfTask:task];
}

@end
