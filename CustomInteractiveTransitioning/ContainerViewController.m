//
//  ViewController.m
//  CustomInteractiveTransitioning
//
//  Created by Konstantin Golenkov on 09.10.14.
//  Copyright (c) 2014 golenkovkostya. All rights reserved.
//

#import "ContainerViewController.h"
#import "ChildViewController.h"
#import "CustomAnimator.h"
#import "CustomInteractiveTransitioning.h"
#import "CustomContextTransitioning.h"

static CGFloat const finishedInteraction = 0.35;

@interface ContainerViewController () {
    NSArray *viewControllers;
    BOOL panDirectionLeftToRight;
    CustomInteractiveTransitioning *interactiveTransitioning;
    CustomAnimator *animator;
    NSInteger curentIndex;
    BOOL startAnimation;
    UIView *containerView;
}

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    containerView = [[UIView alloc] init];
    [self.view insertSubview:containerView atIndex:0];
    [containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:containerView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:containerView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:containerView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:containerView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    
    
    
    viewControllers = @[[ChildViewController childViewControllerWithImageName:@"mushroom 1"],
                        [ChildViewController childViewControllerWithImageName:@"mushroom 2"],
                        [ChildViewController childViewControllerWithImageName:@"mushroom 3"],
                        [ChildViewController childViewControllerWithImageName:@"flower 1"]];
    
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        [self addChildViewController:obj];
        [obj didMoveToParentViewController:self];
    }];
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = viewControllers.count;
    
    animator = [CustomAnimator new];
    interactiveTransitioning = [[CustomInteractiveTransitioning alloc] initWithAnimator:animator];
    startAnimation = NO;
    
    [self showViewControllerByIndex:0 animated:NO interactive:NO];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)showViewControllerByIndex:(NSUInteger)index animated:(BOOL)animated interactive:(BOOL)interactive {
    ChildViewController *toViewController = viewControllers[index];
    
    [toViewController.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    toViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [toViewController.textView setTranslatesAutoresizingMaskIntoConstraints:YES];
    toViewController.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (animated) {
        startAnimation = YES;
        ChildViewController *fromViewController = viewControllers[curentIndex];
        CustomContextTransitioning *transitioningContext = [[CustomContextTransitioning alloc] initWithFromViewController:fromViewController
                                                                                                   toViewController:toViewController
                                                                                                      containerView:containerView
                                                                                                         goingRight:panDirectionLeftToRight];
        transitioningContext.animated = YES;
        transitioningContext.interactive = interactive;
        
        __weak typeof(self) weakSelf = self;
        transitioningContext.completionBlock = ^(BOOL complete) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                if (complete) {
                    [fromViewController.view removeFromSuperview];
                    strongSelf->curentIndex = [strongSelf->viewControllers indexOfObject:toViewController];
                    strongSelf.pageControl.currentPage = strongSelf->curentIndex;
                } else {
                    [toViewController.view removeFromSuperview];
                }
                strongSelf->containerView.userInteractionEnabled = YES;
                strongSelf->startAnimation = NO;
            }
        };
        
        if (interactive) {
            [interactiveTransitioning startInteractiveTransition:transitioningContext];
        } else {
            [animator animateTransition:transitioningContext];
        }
        
    } else {
        toViewController.view.frame = containerView.bounds;
        [containerView addSubview:toViewController.view];
    }
}

- (IBAction)pageControlDidChangePage:(UIPageControl *)sender {
    [self showViewControllerByIndex:sender.currentPage animated:YES interactive:NO];
}

- (IBAction)panGestureAction:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            panDirectionLeftToRight = [sender velocityInView:sender.view].x > 0;
            if (!panDirectionLeftToRight && curentIndex < viewControllers.count - 1) {
                [self showViewControllerByIndex:curentIndex + 1 animated:YES interactive:YES ];
            } else if (panDirectionLeftToRight && curentIndex > 0) {
                [self showViewControllerByIndex:curentIndex - 1 animated:YES interactive:YES];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [sender translationInView:sender.view];
            CGFloat d = translation.x / CGRectGetWidth(sender.view.bounds);
            if (!panDirectionLeftToRight) {
                d *= -1;
            }
            [interactiveTransitioning updateInteractiveTransition:d];
            break;
        }
        case UIGestureRecognizerStateEnded:
            if (startAnimation) {
                containerView.userInteractionEnabled = NO;
            }
            if (interactiveTransitioning.percentComplete >= finishedInteraction) {
                [interactiveTransitioning finishInteractiveTransition];
            } else {
                [interactiveTransitioning cancelInteractiveTransition];
            }
            break;
        default:
            if (startAnimation) {
                containerView.userInteractionEnabled = NO;
            }
            [interactiveTransitioning cancelInteractiveTransition];
            break;
    }
}

@end
