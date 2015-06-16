//
//  MJAlertControllerTransitionManager.m
//  AlertController
//
//  Created by Joan Martin on 05/06/15.
//  Copyright (c) 2015 Mobile Jazz. All rights reserved.
//

#import "MJAlertControllerTransitionManager.h"

#import "MJAlertController_Private.h"

@implementation MJAlertControllerTransitionManager

#pragma mark - Protocols
#pragma mark UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.15;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView* containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromView.frame = initialFrame;
    toView.frame = initialFrame;
    
    MJAlertController *alertController = nil;
    if (_transitionTo == MJAlertControllerTransitionToInitial)
        alertController = (id)fromVC;
    else
        alertController = (id)toVC;
    
    if (![alertController isKindOfClass:MJAlertController.class])
    {
        [[NSException exceptionWithName:NSInvalidArgumentException
                                 reason:@"Transition controller did not find an MJAlertController to animate"
                               userInfo:nil] raise];
    }
    
    [containerView addSubview:alertController.view];
    
    if (alertController.preferredStyle == MJAlertControllerStyleAlert)
    {
        [self mjz_animateAlertTransitionWithAlert:alertController
                                        duration:[self transitionDuration:transitionContext]
                                 completionBlock:^{
                                     [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                                 }];
    }
    else if (alertController.preferredStyle == MJAlertControllerStyleActionSheet)
    {
        [self mjz_animateSheetTransitionWithAlert:alertController
                                        duration:[self transitionDuration:transitionContext]
                                 completionBlock:^{
                                     [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                                 }];
    }
    else
    {
        [[NSException exceptionWithName:NSInvalidArgumentException
                                 reason:@"Cannot perform transition with the selected alert style"
                               userInfo:nil] raise];
    }
}

- (void)mjz_animateAlertTransitionWithAlert:(MJAlertController*)alertController
                                  duration:(NSTimeInterval)duration
                           completionBlock:(void (^)())completionBlock
{
    CGAffineTransform initialTransform;
    CGAffineTransform finalTransform;
    CGFloat initialBackgroundViewAlpha;
    CGFloat finalBackgroundViewAlpha;
    CGFloat initialAlpha;
    CGFloat finalAlpha;
    UIViewAnimationOptions animationOptions = 0;
    
    if (_transitionTo == MJAlertControllerTransitionToInitial)
    {
        initialAlpha = 1.0;
        finalAlpha = 0.0;
        
        initialBackgroundViewAlpha = 1.0;
        finalBackgroundViewAlpha = 0.0;
        
        initialTransform = CGAffineTransformIdentity;
        finalTransform = CGAffineTransformIdentity;
        
        animationOptions = 6 << 16;
    }
    else //if (_transitionTo == MJAlertControllerTransitionToModal)
    {
        initialAlpha = 1.0;
        finalAlpha = 1.0;
        
        initialBackgroundViewAlpha = 0.0;
        finalBackgroundViewAlpha = 1.0;
        
        initialTransform = CGAffineTransformMakeScale(1.14, 1.14);
        finalTransform = CGAffineTransformIdentity;
        
        animationOptions = 7 << 16;
    }
    
    alertController.view.alpha = initialAlpha;
    alertController.backgroundView.alpha = initialBackgroundViewAlpha;
    alertController.contentView.transform = initialTransform;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:animationOptions
                     animations:^{
                         alertController.view.alpha = finalAlpha;
                         alertController.contentView.transform = finalTransform;
                         alertController.backgroundView.alpha = finalBackgroundViewAlpha;
                     } completion:^(BOOL finished) {
                         completionBlock();
                     }];
}

- (void)mjz_animateSheetTransitionWithAlert:(MJAlertController*)alertController
                                  duration:(NSTimeInterval)duration
                           completionBlock:(void (^)())completionBlock
{
    CGFloat initialBackgroundViewAlpha;
    CGFloat finalBackgroundViewAlpha;
    
    CGAffineTransform initialTransform;
    CGAffineTransform finalTransform;
    
    UIViewAnimationOptions animationOptions = 0;
    
    [alertController.view setNeedsLayout];
    [alertController.view layoutIfNeeded];
    
    CGFloat sheetHeight = alertController.contentView.frame.size.height;
    
    if (_transitionTo == MJAlertControllerTransitionToInitial)
    {
        initialBackgroundViewAlpha = 1.0;
        finalBackgroundViewAlpha = 0.0;
        
        initialTransform = CGAffineTransformIdentity;
        finalTransform = CGAffineTransformMakeTranslation(0, sheetHeight);
        
        animationOptions = 6 << 16;
    }
    else //if (_transitionTo == MJAlertControllerTransitionToModal)
    {
        initialBackgroundViewAlpha = 0.0;
        finalBackgroundViewAlpha = 1.0;
        
        initialTransform = CGAffineTransformMakeTranslation(0, sheetHeight);
        finalTransform = CGAffineTransformIdentity;
        
        animationOptions = 7 << 16;
    }
    
    alertController.backgroundView.alpha = initialBackgroundViewAlpha;
    alertController.contentView.transform = initialTransform;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:animationOptions
                     animations:^{
                         alertController.backgroundView.alpha = finalBackgroundViewAlpha;
                         alertController.contentView.transform = finalTransform;
                     } completion:^(BOOL finished) {
                         completionBlock();
                     }];
}

@end