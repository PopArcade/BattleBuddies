//
//  BBBattleDismissalController.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBBattleDismissalController.h"

@implementation BBBattleDismissalController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 10.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = toViewController.view;//[transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *containerView = [transitionContext containerView];
    
    [toView setFrame:containerView.bounds];
    [containerView addSubview:toView];
    
    [containerView insertSubview:toView atIndex:0];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        [fromView setTransform:CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(containerView.bounds))];
    } completion:^(BOOL finished) {
        [fromView removeFromSuperview];
        [transitionContext completeTransition:finished];
        
        [fromView.window setRootViewController:toViewController];
    }];
    
}
@end
