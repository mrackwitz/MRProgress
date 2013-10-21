//
//  MRColorPaletteViewController.m
//  MRProgress
//
//  Created by Marius Rackwitz on 20.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRColorPaletteViewController.h"


@interface MRColorPaletteViewController ()

@end


@implementation MRColorPaletteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 18;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCell" forIndexPath:indexPath];
    collectionViewCell.backgroundColor = [self colorForIndexPath:indexPath];
    return collectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate colorPaletteViewController:self didSelectColor:[self colorForIndexPath:indexPath]];
}

- (UIColor *)colorForIndexPath:(NSIndexPath *)indexPath {
    CGFloat hue = indexPath.row / (float)[self.collectionView numberOfItemsInSection:indexPath.section];
    return [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
}

@end
