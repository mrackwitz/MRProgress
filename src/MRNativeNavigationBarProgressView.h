//
//  MRNativeNavigationBarProgressView.h
//  MRProgress
//
//  Created by Marius Rackwitz on 20.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 A progress view based on native progress view (recommended for storyboard usage) which can be displayed at the bottom
 edge of the navigation bar like in Messages app or at the top edge of the toolbar like in Safari.
 */
@interface MRNativeNavigationBarProgressView : UIProgressView

@property (nonatomic, weak, readwrite) IBOutlet UIViewController *viewController;
@property (nonatomic, weak, readwrite) IBOutlet UIView *barView;

/**
 Get current progress view or initialize a new for given navigation controller.
 
 The navigationBar will be used to initialize the progress views frame and progressTintColor.
 You can destroy the current instance by using removeFromSuperview.
 */
+ (instancetype)progressViewForNavigationController:(UINavigationController *)navigationController;

@end


@interface UINavigationController (NativeNavigationBarProgressView)

@property (nonatomic, readonly) MRNativeNavigationBarProgressView *nativeProgressView;

@end
