//
//  MRProgressView+AFNetworking.m
//  MRProgress
//
//  Created by Marius Rackwitz on 12.03.14.
//
//  This implementation is based on AFNetworking's UIKit additions.
//  So the following copyright notice and permission notice must be included:
//
// Copyright (c) 2013 AFNetworking (http://afnetworking.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MRProgressView+AFNetworking.h"
#import "MRMethodCopier.h"

#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation MRProgressView (AFNetworking)

+ (void)load {
    MRMethodCopier *copier = [MRMethodCopier copierFromClass:UIProgressView.class toClass:self];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    [copier copyInstanceMethod:@selector(setProgressWithUploadProgressOfTask:animated:)];
    [copier copyInstanceMethod:@selector(setProgressWithDownloadProgressOfTask:animated:)];
#endif
    
    [copier copyInstanceMethod:@selector(setProgressWithUploadProgressOfOperation:animated:)];
    [copier copyInstanceMethod:@selector(setProgressWithDownloadProgressOfOperation:animated:)];
    
    // Internal methods
    [copier copyInstanceMethod:NSSelectorFromString(@"af_uploadProgressAnimated")];
    [copier copyInstanceMethod:NSSelectorFromString(@"af_setUploadProgressAnimated:")];
    [copier copyInstanceMethod:NSSelectorFromString(@"af_downloadProgressAnimated")];
    [copier copyInstanceMethod:NSSelectorFromString(@"af_setDownloadProgressAnimated:")];
    [copier copyInstanceMethod:@selector(observeValueForKeyPath:ofObject:change:context:)];
}

@end
