//
//  MRActivityIndicatorView+AFNetworking.m
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

#import "MRActivityIndicatorView+AFNetworking.h"
#import "MRMethodCopier.h"

#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation MRActivityIndicatorView (AFNetworking)

+ (void)load {
    MRMethodCopier *copier = [MRMethodCopier copierFromClass:UIActivityIndicatorView.class toClass:self];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    [copier copyInstanceMethod:@selector(setAnimatingWithStateOfTask:)];
#endif
    
    [copier copyInstanceMethod:@selector(setAnimatingWithStateOfOperation:)];
    
    // Internal methods
    [copier copyInstanceMethod:NSSelectorFromString(@"af_startAnimating")];
    [copier copyInstanceMethod:NSSelectorFromString(@"af_stopAnimating")];
}

@end
