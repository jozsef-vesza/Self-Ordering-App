//
//  SOMealImageController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 12/04/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOMealImageController.h"

@interface SOMealImageController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mealImageScrollView;
@property (nonatomic,strong) UIImageView *mealImageView;

@end

@implementation SOMealImageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mealImageScrollView.minimumZoomScale=1.0;
    self.mealImageScrollView.maximumZoomScale=6.0;
    self.mealImageScrollView.delegate=self;
    
    self.mealImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mealImageView.image = self.img;
    self.mealImageView.backgroundColor = [UIColor blackColor];
    self.mealImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.mealImageScrollView addSubview:self.mealImageView];
}

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mealImageView;
}

@end
