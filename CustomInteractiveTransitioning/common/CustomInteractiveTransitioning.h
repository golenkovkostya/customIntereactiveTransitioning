//
//  CustomInteractiveTransitioning.h
//  CustomInteractiveTransitioning
//
//  Created by Konstantin Golenkov on 09.10.14.
//  Copyright (c) 2014 golenkovkostya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomInteractiveTransitioning : NSObject<UIViewControllerInteractiveTransitioning>

@property (readonly) CGFloat percentComplete;

- (instancetype)initWithAnimator:(id<UIViewControllerAnimatedTransitioning>)animator;

- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)cancelInteractiveTransition;
- (void)finishInteractiveTransition;

@end
