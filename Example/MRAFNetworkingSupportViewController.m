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
#import "MRNavigationBarProgressView.h"
#import "MRActivityIndicatorView+AFNetworking.h"
#import "MRProgressView+AFNetworking.h"
#import "MRProgressOverlayView+AFNetworking.h"


@interface MRAFNetworkingSupportViewController ()

@property (weak, nonatomic) IBOutlet MRActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet MRCircularProgressView *circularProgressView;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end


@implementation MRAFNetworkingSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicatorView.hidesWhenStopped = NO;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://httpbin.org/"] sessionConfiguration:config];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.sessionManager = sessionManager;
}

- (NSURLSessionDownloadTask *)bytesDownloadTask {
    NSURLSessionDownloadTask *task = [self.sessionManager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"/bytes/1000000" relativeToURL:self.sessionManager.baseURL]]
                                                                         progress:nil
                                                                      destination:nil
                                                                completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error){
                                                                    NSLog(@"Task completed with error: %@", error);
                                                                }];
    [task resume];
    return task;
}

- (IBAction)onActivityIndicatorGo:(id)sender {
    NSURLSessionDataTask *task = [self.sessionManager GET:@"/delay/3"
                                               parameters:nil
                                                 progress:nil
                                                  success:nil
                                                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                      NSLog(@"Task %@ failed with error: %@", task, error);
                                                  }];
    [self.activityIndicatorView setAnimatingWithStateOfTask:task];
}

- (IBAction)onCircularProgressViewGo:(id)sender {
    NSURLSessionDownloadTask *task = [self bytesDownloadTask];
    [self.circularProgressView setProgressWithDownloadProgressOfTask:task animated:YES];
}

- (IBAction)onOverlayViewGo:(id)sender {
    NSURLSessionDataTask *task = [self.sessionManager GET:@"/delay/2"
                                               parameters:nil
                                                 progress:nil
                                                  success:nil
                                                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                   if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
                                                       NSLog(@"Task was cancelled by user.");
                                                   } else {
                                                       NSLog(@"Task %@ failed with error: %@", task, error);
                                                   }
                                               }];
    
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    [overlayView setModeAndProgressWithStateOfTask:task];
    [overlayView setStopBlockForTask:task];
}

- (IBAction)onOverlayViewUpload:(id)sender {
    // See [AFNetworking/AFNetworking#2128](https://github.com/AFNetworking/AFNetworking/issues/2128)
    NSString *fileName = @"aquarium-fish1.jpg";
    NSString *filePath = [NSBundle.mainBundle pathForResource:fileName.stringByDeletingPathExtension ofType:fileName.pathExtension];
    
    // Prepare a temporary file to store the multipart request prior to sending it to the server due to an alleged
    // bug in NSURLSessionTask.
    NSString* tmpFilename = [NSString stringWithFormat:@"%f", NSDate.timeIntervalSinceReferenceDate];
    NSURL* tmpFileUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tmpFilename]];
    
    // Create a multipart form request.
    NSMutableURLRequest *multipartRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                                       URLString:[[NSURL URLWithString:@"/post" relativeToURL:self.sessionManager.baseURL] absoluteString]
                                                                                                      parameters:nil
                                                                                       constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                           [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath]
                                                                                                                      name:@"file"
                                                                                                                  fileName:fileName
                                                                                                                  mimeType:@"image/jpeg" error:nil];
                                                                                       } error:nil];
    
    // Dump multipart request into the temporary file.
    [AFHTTPRequestSerializer.serializer requestWithMultipartFormRequest:multipartRequest
                                            writingStreamContentsToFile:tmpFileUrl
                                                      completionHandler:^(NSError *error) {
                                                          // Once the multipart form is serialized into a temporary file, we can initialize
                                                          // the actual HTTP request using session manager.
                                                           
                                                          // Create default session manager.
                                                          AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
                                                            
                                                          // Here note that we are submitting the initial multipart request. We are, however,
                                                          // forcing the body stream to be read from the temporary file.
                                                          NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:multipartRequest
                                                                                                                     fromFile:tmpFileUrl
                                                                                                                     progress:nil
                                                                                                            completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                                                                                // Cleanup: remove temporary file.
                                                                                                                [NSFileManager.defaultManager removeItemAtURL:tmpFileUrl error:nil];
                                                                                                                  
                                                                                                                NSLog(@"Task completed with error: %@", error);
                                                                                                            }];
                                                            
                                                          // Start the file upload.
                                                          [uploadTask resume];
                                                           
                                                          [[MRProgressOverlayView showOverlayAddedTo:self.view animated:YES] setModeAndProgressWithStateOfTask:uploadTask];
                                                      }];
}

- (IBAction)onOverlayViewError:(id)sender {
    NSURLSessionDataTask *task = [self.sessionManager GET:@"/status/418"
                                               parameters:nil
                                                 progress:nil
                                                  success:nil
                                                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                      NSLog(@"Task %@ failed, as expected, with error: %@", task, error);
                                                  }];
    [[MRProgressOverlayView showOverlayAddedTo:self.view animated:YES] setModeAndProgressWithStateOfTask:task];
}

- (IBAction)onNavigationBarProgressViewGo:(id)sender {
    NSURLSessionDownloadTask *task = [self bytesDownloadTask];
    [[MRNavigationBarProgressView progressViewForNavigationController:self.navigationController]
     setProgressWithDownloadProgressOfTask:task animated:YES];
}

@end
