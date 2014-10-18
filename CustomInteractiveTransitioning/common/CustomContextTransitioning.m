//
//  CustomContextTransitioning.m
//  CustomInteractiveTransitioning
//
//  Created by Konstantin Golenkov on 09.10.14.
//  Copyright (c) 2014 golenkovkostya. All rights reserved.
//

#import "CustomContextTransitioning.h"

@interface CustomContextTransitioning()

@property (nonatomic, strong) NSDictionary *viewControllers;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic) CGRect privateDisappearingFromRect;
@property (nonatomic) CGRect privateAppearingFromRect;
@property (nonatomic) CGRect privateDisappearingToRect;
@property (nonatomic) CGRect privateAppearingToRect;
@property (nonatomic) UIModalPresentationStyle presentationStyle;

@end

@implementation CustomContextTransitioning

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController
toViewController:(UIViewController *)toViewController
containerView:(UIView *)containerView
goingRight:(BOOL)panDirectionLeftToRight {

if (self = [super init]) {
self.presentationStyle = UIModalPresentationCustom;
self.containerView = containerView;
_transitionWasCancelled = NO;
self.viewControllers = @{UITransitionContextFromViewControllerKey:fromViewController,
UITransitionContextToViewControllerKey:toViewController};

CGFloat travelDistance = panDirectionLeftToRight ? -self.containerView.bounds.size.width : self.containerView.bounds.size.width;

self.privateDisappearingFromRect = self.privateAppearingToRect = self.containerView.bounds;

self.privateDisappearingToRect = CGRectOffset(self.containerView.bounds, travelDistance, 0);
self.privateAppearingFromRect = CGRectOffset(self.containerView.bounds, -travelDistance, 0);
}
return self;
}

- (void)completeTransition:(BOOL)didComplete {
    if (self.completionBlock) {
        self.completionBlock(didComplete);
    }
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
}

- (void)finishInteractiveTransition {
    _transitionWasCancelled = NO;
}

- (void)cancelInteractiveTransition {
    _transitionWasCancelled = YES;
}


- (UIViewController *)viewControllerForKey:(NSString *)key {
    return self.viewControllers[key];
}

- (CGRect)initialFrameForViewController:(UIViewController *)vc {
    return (vc == [self viewControllerForKey:UITransitionContextFromViewControllerKey] ?
            self.privateDisappearingFromRect : self.privateDisappearingToRect);
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc {
    return (vc == [self viewControllerForKey:UITransitionContextFromViewControllerKey] ?
            self.privateAppearingFromRect : self.privateAppearingToRect);
}

@end
