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
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidResumeNotification   object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidSuspendNotification  object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidCompleteNotification object:nil];
    
    if (task) {
        if (task.state != NSURLSessionTaskStateCompleted) {
            if (task.state == NSURLSessionTaskStateRunning) {
                [self show:YES];
            } else {
                [self dismiss:YES];
            }
            
            // Observe state
            [notificationCenter addObserver:self selector:@selector(mr_show) name:AFNetworkingTaskDidResumeNotification   object:task];
            [notificationCenter addObserver:self selector:@selector(mr_hide) name:AFNetworkingTaskDidCompleteNotification object:task];
            [notificationCenter addObserver:self selector:@selector(mr_hide) name:AFNetworkingTaskDidSuspendNotification  object:task];
            
            // Observe progress
            [task addObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesSent))     options:0 context:MRTaskCountOfBytesSentContext];
            [task addObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesReceived)) options:0 context:MRTaskCountOfBytesReceivedContext];
        }
    }
}
#endif

#pragma mark -

- (void)setModeAndProgressWithStateOfOperation:(AFURLConnectionOperation *)operation {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:AFNetworkingOperationDidStartNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingOperationDidFinishNotification object:nil];
    
    if (operation) {
        if (![operation isFinished]) {
            if ([operation isExecuting]) {
                [self show:YES];
            } else {
                [self dismiss:YES];
            }
            
            // Observe state
            [notificationCenter addObserver:self selector:@selector(mr_show) name:AFNetworkingOperationDidStartNotification  object:operation];
            [notificationCenter addObserver:self selector:@selector(mr_hide) name:AFNetworkingOperationDidFinishNotification object:operation];
    
            // Observe progress
            __weak __typeof(self)weakSelf = self;
            __weak __typeof(operation)weakOperation = operation;
            
            void (^originalUploadProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) = [operation.uploadProgress copy];
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                if (originalUploadProgressBlock) {
                    originalUploadProgressBlock(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
                }
                
                // Set mode
                [weakSelf mr_showUploading];
                
                // Unregister
                [weakOperation setUploadProgressBlock:originalUploadProgressBlock];
            }];
            
            void (^originalDownloadProgressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) = [operation.downloadProgress copy];
            [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                if (originalDownloadProgressBlock) {
                    originalDownloadProgressBlock(bytesRead, totalBytesRead, totalBytesExpectedToRead);
                }
                
                // Set mode
                [weakSelf mr_showDownloading];
                
                // Unregister
                [weakOperation setDownloadProgressBlock:originalDownloadProgressBlock];
            }];
        }
    }
}


#pragma mark - Helper methods to dispatch UI changes on main queue

- (void)mr_show {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show:YES];
    });
}

- (void)mr_hide {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismiss:YES];
    });
}

- (void)mr_showUploading {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Set mode to upload
        self.titleLabelText = NSLocalizedString(@"Uploading …", @"Progress overlay view text when upload progress happens");
        self.mode = MRProgressOverlayViewModeDeterminateCircular;
    });
}

- (void)mr_showDownloading {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Set mode to download
        self.titleLabelText = NSLocalizedString(@"Loading …", @"Progress overlay view text when download progess happens");
        self.mode = MRProgressOverlayViewModeDeterminateCircular;
    });
}


#pragma mark - NSKeyValueObserving

- (void)mr_observeValueForKeyPath:(NSString *)keyPath
                         ofObject:(id)object
                           change:(__unused NSDictionary *)change
                          context:(void *)context
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    if (context == MRTaskCountOfBytesSentContext || context == MRTaskCountOfBytesReceivedContext) {
        // Set mode
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(countOfBytesSent))]) {
            if ([object countOfBytesExpectedToSend] > 0) {
                [self mr_showUploading];
            }
        } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(countOfBytesReceived))]) {
            if ([object countOfBytesExpectedToReceive] > 0) {
                [self mr_showDownloading];
            }
        }
        
        // Unregister
        @try {
            [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
            
            if (context == MRTaskCountOfBytesSentContext) {
                [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesSent))];
            }
            
            if (context == MRTaskCountOfBytesReceivedContext) {
                [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesReceived))];
            }
        }
        @catch (NSException * __unused exception) {}
        
        return;
    }
#endif
    [self mr_observeValueForKeyPath:keyPath ofObject:object change:change context:context]; // Call original method
}

@end
