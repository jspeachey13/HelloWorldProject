//
//  CustomFlipSegue.m
//  
//
//  Created by Peachey, Joseph on 5/27/15.
//
//

#import "CustomFlipSegue.h"

@implementation CustomFlipSegue

- (void) perform {
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    [UIView transitionWithView:src.navigationController.view duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
}


@end
