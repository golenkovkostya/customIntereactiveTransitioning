//
//  CustomInteractiveTransitioning.m
//  CustomInteractiveTransitioning
//
//  Created by Konstantin Golenkov on 09.10.14.
//  Copyright (c) 2014 golenkovkostya. All rights reserved.
//

#import "CustomInteractiveTransitioning.h"

static NSInteger const speedFactorForCancelInteraction = 2;

@interface CustomInteractiveTransitioning(){
    id<UIViewControllerAnimatedTransitioning>_animator;
    id<UIViewControllerContextTransitioning> _transitionContext;
    
    CADisplayLink *_displayLink;
}

@property (nonatomic)CGFloat completionSpeed;

@end

@implementation CustomInteractiveTransitioning

- (instancetype)initWithAnimator:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (self = [super init]) {
        _animator = animator;
        self.completionSpeed = 1;
    }
    return self;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;
    _transitionContext.containerView.layer.speed = 0.f;
    
    [_animator animateTransition:_transitionContext];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    self.percentComplete = fmaxf(fminf(percentComplete, 1.f), 0.f);
}

- (void)cancelInteractiveTransition {
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tickCancelAnimation)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_transitionContext cancelInteractiveTransition];
}

- (void)finishInteractiveTransition {
    CALayer *layer = _transitionContext.containerView.layer;
    layer.speed = self.completionSpeed;
    CFTimeInterval pausedTime = layer.timeOffset;
    layer.timeOffset = 0.f;
    layer.beginTime = 0.f;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
    
    [_transitionContext finishInteractiveTransition];
}

- (void)setPercentComplete:(CGFloat)percentComplete {
    _percentComplete = percentComplete;
    
    [self setTimeOffset:percentComplete * [_animator transitionDuration:_transitionContext]];
    
    [_transitionContext updateInteractiveTransition:percentComplete];
}

- (void)tickCancelAnimation {
    NSTimeInterval timeOffset = _transitionContext.containerView.layer.timeOffset - _displayLink.duration/speedFactorForCancelInteraction;
    if (timeOffset < 0) {
        [_displayLink invalidate];
        [_transitionContext containerView].layer.speed = self.completionSpeed;
    } else {
        [self setTimeOffset:timeOffset];
    }
}

- (void)setTimeOffset:(NSTimeInterval)timeOffset {
    [_transitionContext containerView].layer.timeOffset = timeOffset;
}

@end
