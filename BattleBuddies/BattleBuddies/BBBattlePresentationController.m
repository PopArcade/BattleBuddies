//
//  BBBattlePresentationController.m
//  BattleBuddies
//
//  Created by Ryan Poolos on 11/23/14.
//  Copyright (c) 2014 Frozen Fire Studios, Inc. All rights reserved.
//

#import "BBBattlePresentationController.h"

@interface BBBattlePresentationController ()
{
    UIViewController *fromViewController;
    UIViewController *toViewController;
    
    id <UIViewControllerContextTransitioning> currentContext;
}
@end

@implementation BBBattlePresentationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    currentContext = transitionContext;
    
    fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    [toViewController.view setFrame:containerView.bounds];
//    [toViewController.view setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
//    [toViewController.view setTransform:CGAffineTransformRotate(toViewController.view.transform, M_PI * 5.0)];
    [containerView addSubview:toViewController.view];
    
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(M_PI * 8.0);
    rotationAnimation.toValue = @0.0;
    
    CABasicAnimation *growXAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    growXAnimation.fromValue = @0.0;
    growXAnimation.toValue = @1.0;
    
    CABasicAnimation *growYAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    growYAnimation.fromValue = @0.0;
    growYAnimation.toValue = @1.0;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[growXAnimation, growYAnimation, rotationAnimation];
    group.delegate = self;
    group.duration = [self transitionDuration:transitionContext];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.removedOnCompletion = YES;
    
    [toViewController.view.layer addAnimation:group forKey:@"transition"];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [fromViewController.view removeFromSuperview];
    [currentContext completeTransition:flag];
}

@end
