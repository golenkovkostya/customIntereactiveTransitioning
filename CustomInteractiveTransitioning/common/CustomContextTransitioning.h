//
//  CustomContextTransitioning.h
//  CustomInteractiveTransitioning
//
//  Created by Konstantin Golenkov on 09.10.14.
//  Copyright (c) 2014 golenkovkostya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomContextTransitioning : NSObject<UIViewControllerContextTransitioning>

@property (nonatomic, getter=isAnimated) BOOL animated;
@property (nonatomic, getter=isInteractive) BOOL interactive;
@property (nonatomic, readonly) BOOL transitionWasCancelled;
@property (nonatomic, strong) void (^completionBlock)(BOOL didComplete);


- (instancetype)initWithFromViewController:(UIViewController *)fromViewController
                          toViewController:(UIViewController *)toViewController
                             containerView:(UIView *)containerView
                                goingRight:(BOOL)panDirectionLeftToRight;

@end
