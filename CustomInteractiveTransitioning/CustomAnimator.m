//
//  CustomAnimator.m
//  CustomInteractiveTransitioning
//
//  Created by Konstantin Golenkov on 09.10.14.
//  Copyright (c) 2014 golenkovkostya. All rights reserved.
//

#import "CustomAnimator.h"
#import "ChildViewController.h"

@implementation CustomAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.7;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    ChildViewController *toViewController =
        (ChildViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    ChildViewController *fromViewController =
        (ChildViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    CGRect initialFrameTo = [transitionContext initialFrameForViewController:toViewController];
    CGRect finalFrameTo = [transitionContext finalFrameForViewController:toViewController];
    
    BOOL panDirectionLeftToRight = (initialFrameTo.origin.x < finalFrameTo.origin.x);
    
    CGFloat travelDistance = [transitionContext containerView].bounds.size.width;
    
    CGAffineTransform travel = CGAffineTransformMakeTranslation (panDirectionLeftToRight ? travelDistance : -travelDistance, 0);
    
    toViewController.view.frame = transitionContext.containerView.bounds;
    
    [transitionContext.containerView addSubview:toViewController.view];
    
    toViewController.imageView.alpha = 0;
    toViewController.textView.transform = CGAffineTransformInvert (travel);
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext]
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionLayoutSubviews | UIViewKeyframeAnimationOptionCalculationModePaced
                              animations:^{
                                  fromViewController.textView.transform = travel;
                                  toViewController.textView.transform = CGAffineTransformIdentity;
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.2
                                                                animations:^{
                                                                    fromViewController.imageView.alpha = 0.9;
                                                                    toViewController.imageView.alpha = 0.1;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.2
                                                                animations:^{
                                                                    fromViewController.imageView.alpha = 0.8;
                                                                    toViewController.imageView.alpha = 0.2;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.2
                                                                animations:^{
                                                                    fromViewController.imageView.alpha = 0.7;
                                                                    toViewController.imageView.alpha = 0.3;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:0.1
                                                                animations:^{
                                                                    fromViewController.imageView.alpha = 0.6;
                                                                    toViewController.imageView.alpha = 0.4;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.1
                                                                animations:^{
                                                                    fromViewController.imageView.alpha = 0.4;
                                                                    toViewController.imageView.alpha = 0.6;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2
                                                                animations:^{
                                                                    fromViewController.imageView.alpha = 0.0;
                                                                    toViewController.imageView.alpha = 1.0;
                                                                }];
                              }
                              completion:^(BOOL finished) {
                                  fromViewController.textView.transform = CGAffineTransformIdentity;
                                  fromViewController.imageView.alpha = 1;
                                  
                                  [transitionContext completeTransition:finished && ![transitionContext transitionWasCancelled]];
                              }];
}

@end
