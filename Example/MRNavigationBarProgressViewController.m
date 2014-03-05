//
//  MRNavigationBarProgressViewController.m
//  MRProgress
//
//  Created by Marius Rackwitz on 09.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import "MRNavigationBarProgressViewController.h"
#import "MRNavigationBarProgressView.h"


const NSInteger MRProgessSteps = 10;


@interface MRNavigationBarProgressViewController ()

@end


@implementation MRNavigationBarProgressViewController


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return MRProgessSteps+1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Actions";
    } else {
        return @"Set progress:";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Deeper";
        } else {
            cell.textLabel.text = @"Simulate";
        }
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%.1f", [self progressForRowAtIndexPath:indexPath]];
    }
    return cell;
}

- (float)progressForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row / (double)MRProgessSteps;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:@"NavigationBarProgress"] animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        MRNavigationBarProgressView *progressView = [MRNavigationBarProgressView progressViewForNavigationController:self.navigationController];
        [self performBlock:^{
            [progressView setProgress:0.2 animated:YES];
            [self performBlock:^{
                [progressView setProgress:0.3 animated:YES];
                [self performBlock:^{
                    [progressView setProgress:0.5 animated:YES];
                    [self performBlock:^{
                        [progressView setProgress:0.4 animated:YES];
                        [self performBlock:^{
                            [progressView setProgress:0.8 animated:YES];
                            [self performBlock:^{
                                [progressView setProgress:1.0 animated:YES];
                            } afterDelay:0.33];
                        } afterDelay:0.2];
                    } afterDelay:0.1];
                } afterDelay:0.1];
            } afterDelay:0.5];
        } afterDelay:0.33];
    } else {
        float progress = [self progressForRowAtIndexPath:indexPath];
        [[MRNavigationBarProgressView progressViewForNavigationController:self.navigationController] setProgress:progress animated:YES];
    }
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end
