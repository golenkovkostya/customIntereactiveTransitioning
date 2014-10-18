//
//  ChildViewController.h
//  CustomInteractiveTransitioning
//
//  Created by Konstantin Golenkov on 09.10.14.
//  Copyright (c) 2014 golenkovkostya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildViewController : UIViewController

+ (instancetype)childViewControllerWithImageName:(NSString *)imageName;

- (UIImageView *)imageView;
- (UIView *)textView;

@end
