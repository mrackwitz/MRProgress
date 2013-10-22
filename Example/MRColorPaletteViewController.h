//
//  MRColorPaletteViewController.h
//  MRProgress
//
//  Created by Marius Rackwitz on 20.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MRColorPaletteDelegate;


@interface MRColorPaletteViewController : UICollectionViewController

@property (nonatomic, weak) IBOutlet id<MRColorPaletteDelegate> delegate;

@end


@protocol MRColorPaletteDelegate <NSObject>

- (void)colorPaletteViewController:(MRColorPaletteViewController *)colorPaletteViewController didSelectColor:(UIColor *)color;

@end
