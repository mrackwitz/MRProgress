//
//  MRAFNetworkingSupportOperationViewController.m
//  Example
//
//  Created by Marius Rackwitz on 18.07.14.
//  Copyright (c) 2014 Marius Rackwitz. All rights reserved.
//

#import "MRAFNetworkingSupportOperationViewController.h"
#import "AFNetworking.h"
#import "MRActivityIndicatorView.h"
#import "MRCircularProgressView.h"
#import "MRNavigationBarProgressView.h"
#import "MRActivityIndicatorView+AFNetworking.h"
#import "MRProgressView+AFNetworking.h"
#import "MRProgressOverlayView+AFNetworking.h"


@interface MRAFNetworkingSupportOperationViewController ()

@property (weak, nonatomic) IBOutlet MRActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet MRCircularProgressView *circularProgressView;

@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@end


@implementation MRAFNetworkingSupportOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicatorView.hidesWhenStopped = NO;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    AFHTTPRequestOperationManager *operationManger = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://httpbin.org/"]];
    operationManger.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.operationManager = operationManger;
}

- (AFHTTPRequestOperation *)get:(NSString *)path {
    AFHTTPRequestOperation *operation = [self.operationManager GET:path
                                                        parameters:nil
                                                           success:nil
                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                               NSLog(@"Operation completed with error: %@", error);
                                                           }];
    return operation;
}

- (IBAction)onActivityIndicatorGo:(id)sender {
    AFHTTPRequestOperation *operation = [self get:@"/delay/3"];
    [self.activityIndicatorView setAnimatingWithStateOfOperation:operation];
}

- (IBAction)onCircularProgressViewGo:(id)sender {
    AFHTTPRequestOperation *operation = [self get:@"/bytes/1000000"];
    [self.circularProgressView setProgressWithDownloadProgressOfOperation:operation animated:YES];
}

- (IBAction)onOverlayViewGo:(id)sender {
    AFHTTPRequestOperation *operation = [self.operationManager GET:@"/delay/2"
                                                        parameters:nil
                                                           success:nil
                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                               if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
                                                                   NSLog(@"Operation was cancelled by user.");
                                                               } else {
                                                                   NSLog(@"Operation %@ failed with error: %@", operation, error);
                                                               }
                                                           }];
    
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Do an expensive background operation, before observing the operation
        sleep(2);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [overlayView setModeAndProgressWithStateOfOperation:operation];
            [overlayView setStopBlockForOperation:operation];
        });
    });
}

- (IBAction)onOverlayViewUpload:(id)sender {
    NSString *fileName = @"aquarium-fish1.jpg";
    NSString *filePath = [NSBundle.mainBundle pathForResource:fileName.stringByDeletingPathExtension ofType:fileName.pathExtension];
    
    // Create a multipart form request.
    void (^constructingBodyBlock)(id<AFMultipartFormData>) = ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath]
                                   name:@"file"
                               fileName:fileName
                               mimeType:@"image/jpeg"
                                  error:nil];
    };
    
    AFHTTPRequestOperation *operation = [self.operationManager POST:@"/post"
                                                         parameters:nil
                                          constructingBodyWithBlock:constructingBodyBlock
                                                            success:nil
                                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                NSLog(@"Operation %@ failed with error: %@", operation, error);
                                                            }];
    
    [[MRProgressOverlayView showOverlayAddedTo:self.view animated:YES] setModeAndProgressWithStateOfOperation:operation];
}

- (IBAction)onOverlayViewError:(id)sender {
    AFHTTPRequestOperation *operation = [self.operationManager GET:@"/status/418"
                                                        parameters:nil
                                                           success:nil
                                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                               NSLog(@"Operation %@ failed, as expected, with error: %@", operation, error);
                                                           }];
    [[MRProgressOverlayView showOverlayAddedTo:self.view animated:YES] setModeAndProgressWithStateOfOperation:operation];
}

- (IBAction)onNavigationBarProgressViewGo:(id)sender {
    AFHTTPRequestOperation *operation = [self get:@"/bytes/1000000"];
    [[MRNavigationBarProgressView progressViewForNavigationController:self.navigationController]
     setProgressWithDownloadProgressOfOperation:operation animated:YES];
}

@end
