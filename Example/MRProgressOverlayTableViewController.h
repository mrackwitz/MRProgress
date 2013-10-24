//
//  MRProgressOverlayTableViewController.h
//  MRProgress
//
//  Created by Marius Rackwitz on 09.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MRProgressOverlayTableViewControllerDelegate;


@interface MRProgressOverlayTableViewController : UITableViewController

@property (nonatomic, weak) id<MRProgressOverlayTableViewControllerDelegate> delegate;

@end


@protocol MRProgressOverlayTableViewControllerDelegate <NSObject>

- (UIView *)viewForProgressOverlay;

@end
