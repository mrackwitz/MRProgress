//
//  MRProgressOverlayView+AFNetworking.m
//  MRProgress
//
//  Created by Marius Rackwitz on 12.03.14.
//  Copyright (c) 2014 Marius Rackwitz. All rights reserved.
//

#import "MRProgressOverlayView+AFNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>
#import "MRActivityIndicatorView+AFNetworking.h"
#import "MRProgressView+AFNetworking.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    #import "AFURLSessionManager.h"
#endif


static void * MRTaskCountOfBytesSentContext     = &MRTaskCountOfBytesSentContext;
static void * MRTaskCountOfBytesReceivedContext = &MRTaskCountOfBytesReceivedContext;

@interface AFURLConnectionOperation (_UIProgressView)
// Implemented in AFURLConnectionOperation
@property (readwrite, nonatomic, copy) void (^uploadProgress)(NSUInteger bytes, NSInteger totalBytes, NSInteger totalBytesExpected);
@property (readwrite, nonatomic, copy) void (^downloadProgress)(NSUInteger bytes, NSInteger totalBytes, NSInteger totalBytesExpected);
@end


@interface MRProgressOverlayView (_AFNetworking)

@property (readwrite, nonatomic, retain) NSURLSessionTask *sessionTask;
@property (readwrite, nonatomic, retain) AFURLConnectionOperation *operation;

@end


@implementation MRProgressOverlayView (AFNetworking)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(observeValueForKeyPath:ofObject:change:context:);
        SEL swizzledSelector = @selector(mr_observeValueForKeyPath:ofObject:change:context:);
        
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark -

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000

- (void)setModeAndProgressWithStateOfTask:(NSURLSessionTask *)task {
    self.sessionTask = task;
    
    [self mr_unregisterObserver];
    
    if (task) {
        if (task.state != NSURLSessionTaskStateCompleted) {
            if (task.state == NSURLSessionTaskStateRunning) {
                if (self.isHidden) {
                    [self show:YES];
                }
            } else {
                [self dismiss:YES];
            }
            
            // Observe state
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter addObserver:self selector:@selector(mr_show:) name:AFNetworkingTaskDidResumeNotification   object:task];
            [notificationCenter addObserver:self selector:@selector(mr_hide:) name:AFNetworkingTaskDidCompleteNotification object:task];
            [notificationCenter addObserver:self selector:@selector(mr_hide:) name:AFNetworkingTaskDidSuspendNotification  object:task];
            
            // Observe progress
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
            [task addObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesSent))     options:0 context:MRTaskCountOfBytesSentContext];
            [task addObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesReceived)) options:0 context:MRTaskCountOfBytesReceivedContext];
#pragma clang diagnostic pop
        } else {
            [self dismiss:YES];
        }
    }
}

- (void)setStopBlockForTask:(__weak NSURLSessionTask *)task {
    if (task) {
        self.stopBlock = ^(MRProgressOverlayView *self){
            [self mr_unregisterObserver];
            
            [self dismiss:YES];
            [task cancel];
        };
    } else {
        self.stopBlock = nil;
    }
}

#endif

#pragma mark -

- (void)setModeAndProgressWithStateOfOperation:(AFURLConnectionOperation *)operation {
    self.operation = operation;
    
    [self mr_unregisterObserver];
    
    if (operation) {
        if (![operation isFinished]) {
            if ([operation isExecuting]) {
                if (self.isHidden) {
                    [self show:YES];
                }
            } else {
                [self dismiss:YES];
            }
            
            // Observe state
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter addObserver:self selector:@selector(mr_show:) name:AFNetworkingOperationDidStartNotification  object:operation];
            [notificationCenter addObserver:self selector:@selector(mr_hide:) name:AFNetworkingOperationDidFinishNotification object:operation];
    
            // Observe progress
            __weak __typeof(self)weakSelf = self;
            
            void (^originalUploadProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) = [operation.uploadProgress copy];
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                if (originalUploadProgressBlock) {
                    originalUploadProgressBlock(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
                }
                
                // Set mode
                [weakSelf mr_showUploading];
                
                // Unregister
                [weakSelf.operation setUploadProgressBlock:originalUploadProgressBlock];
            }];
            
            void (^originalDownloadProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) = [operation.downloadProgress copy];
            [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                if (originalDownloadProgressBlock) {
                    originalDownloadProgressBlock(bytesRead, totalBytesRead, totalBytesExpectedToRead);
                }
                
                // Set mode
                [weakSelf mr_showDownloading];
                
                // Unregister
                [weakSelf.operation setDownloadProgressBlock:originalDownloadProgressBlock];
            }];
        } else {
            [self dismiss:YES];
        }
    }
}

- (void)setStopBlockForOperation:(__weak AFURLConnectionOperation *)operation {
    if (operation) {
        self.stopBlock = ^(MRProgressOverlayView *self){
            [self mr_unregisterObserver];
            
            [self dismiss:YES];
            [operation cancel];
        };
    } else {
        self.stopBlock = nil;
    }
}


#pragma mark - Getter and setter for Configuration

- (void)setSessionTask:(NSURLSessionTask *)sessionTask {
    objc_setAssociatedObject(self, @selector(sessionTask), sessionTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURLSessionTask *)sessionTask {
    return objc_getAssociatedObject(self, @selector(sessionTask));
}

- (void)setOperation:(AFURLConnectionOperation *)operation {
    objc_setAssociatedObject(self, @selector(operation), operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AFURLConnectionOperation *)operation {
    return objc_getAssociatedObject(self, @selector(operation));
}


#pragma mark - Helper methods to dispatch UI changes on main queue

- (void)mr_show:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hidden) {
            [self show:YES];
        }
    });
}

- (void)mr_hide:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self mr_unregisterObserver];
        
        if (self.sessionTask.error || self.operation.error || note.userInfo[AFNetworkingTaskDidCompleteErrorKey]) {
            self.titleLabelText = NSLocalizedString(@"Error", @"Progress overlay view text when network operation fails");
            self.mode = MRProgressOverlayViewModeCross;
        } else {
            self.titleLabelText = NSLocalizedString(@"Success", @"Progress overlay view text when network operation succeeds");
            self.mode = MRProgressOverlayViewModeCheckmark;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss:YES];
        });
    });
}

- (void)mr_unregisterObserver {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    // Unregister observer for NSURLSessionTask-based interface
    #if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        [notificationCenter removeObserver:self name:AFNetworkingTaskDidResumeNotification   object:nil];
        [notificationCenter removeObserver:self name:AFNetworkingTaskDidSuspendNotification  object:nil];
        [notificationCenter removeObserver:self name:AFNetworkingTaskDidCompleteNotification object:nil];
    
        @try {
            [self.sessionTask removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesSent))];
            [self.sessionTask removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesReceived))];
        }
        @catch (NSException * __unused exception) {}
    #endif
    
    // Unregister observer for AFURLConnectionOperation-based interface
    [notificationCenter removeObserver:self name:AFNetworkingOperationDidStartNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingOperationDidFinishNotification object:nil];
}

- (void)mr_showUploading {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Set mode to upload
        self.titleLabelText = NSLocalizedString(@"Uploading …", @"Progress overlay view text when upload progress happens");
        self.mode = MRProgressOverlayViewModeDeterminateCircular;
        if (self.sessionTask) {
            [(MRProgressView *)self.modeView setProgressWithUploadProgressOfTask:(NSURLSessionUploadTask *)self.sessionTask animated:YES];
        } else if (self.operation) {
            [(MRProgressView *)self.modeView setProgressWithUploadProgressOfOperation:self.operation animated:YES];
        }
    });
}

- (void)mr_showDownloading {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Set mode to download
        self.titleLabelText = NSLocalizedString(@"Loading …", @"Progress overlay view text when download progess happens");
        self.mode = MRProgressOverlayViewModeDeterminateCircular;
        if (self.sessionTask) {
            [(MRProgressView *)self.modeView setProgressWithDownloadProgressOfTask:(NSURLSessionDownloadTask *)self.sessionTask animated:YES];
        } else if (self.operation) {
            [(MRProgressView *)self.modeView setProgressWithDownloadProgressOfOperation:self.operation animated:YES];
        }
    });
}


#pragma mark - NSKeyValueObserving

- (void)mr_observeValueForKeyPath:(NSString *)keyPath
                         ofObject:(id)object
                           change:(NSDictionary *)change
                          context:(void *)context
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    if (context == MRTaskCountOfBytesSentContext || context == MRTaskCountOfBytesReceivedContext) {
        // Set mode
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(countOfBytesSent))]) {
            if ([object countOfBytesExpectedToSend] > 0) {
                [self mr_showUploading];
                
                // Unregister
                @try {
                    [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesSent))];
                }
                @catch (NSException * __unused exception) {}
            }
        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(countOfBytesReceived))]) {
            if ([object countOfBytesExpectedToReceive] > 0) {
                [self mr_showDownloading];
                
                // Unregister
                @try {
                    [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesReceived))];
                }
                @catch (NSException * __unused exception) {}
            }
        }
        return;
    }
#endif
    [self mr_observeValueForKeyPath:keyPath ofObject:object change:change context:context]; // Call original method
}

@end
