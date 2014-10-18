//
//  ChildViewController.m
//  CustomInteractiveTransitioning
//
//  Created by Konstantin Golenkov on 09.10.14.
//  Copyright (c) 2014 golenkovkostya. All rights reserved.
//

#import "ChildViewController.h"

static NSString *const pictureDescription = @"Some description about this picture.";

@interface ChildViewController () {
    NSString *imageName;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation ChildViewController

+ (instancetype)childViewControllerWithImageName:(NSString *)imageName {
    ChildViewController *vc = [[self alloc] initWithNibName:@"ChildViewController" bundle:[NSBundle mainBundle]];
    vc->imageName = imageName;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.image = [UIImage imageNamed:imageName];
    self.TitleLabel.text = [NSString stringWithString:imageName];
    self.descriptionLabel.text = pictureDescription;
}

- (UIImageView *)imageView {
    return _imageView;
}

- (UIView *)textView {
    return _textView;
}

@end
