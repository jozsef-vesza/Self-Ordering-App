//
//  SOServiceChooserViewController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 27/02/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOServiceChooserViewController.h"

@interface SOServiceChooserViewController ()

@property (weak, nonatomic) IBOutlet UIButton *eventServiceButton;
@property (weak, nonatomic) IBOutlet UIButton *mealServiceButton;

@end

@implementation SOServiceChooserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.toolbarHidden = YES;
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Kilépés" style:UIBarButtonItemStyleDone target:self action:@selector(logoutButtonPressed)];
    [self.eventServiceButton setImage:[[UIImage imageNamed:@"ticket"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.eventServiceButton.imageView.tintColor = [UIColor whiteColor];
    UILabel * eventServiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.eventServiceButton.frame), CGRectGetMaxY(self.eventServiceButton.frame) - 40 , self.eventServiceButton.frame.size.width, 20)];
    eventServiceLabel.textAlignment = NSTextAlignmentCenter;
    eventServiceLabel.textColor = [UIColor whiteColor];
    eventServiceLabel.text = @"Jegyrendelés";
//    [self.view addSubview:eventServiceLabel];
    
    [self.mealServiceButton setImage:[[UIImage imageNamed:@"waiter"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.mealServiceButton.imageView.tintColor = [UIColor whiteColor];
    UILabel * mealServiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.mealServiceButton.frame), CGRectGetMaxY(self.mealServiceButton.frame) - 40 , self.mealServiceButton.frame.size.width, 20)];
    mealServiceLabel.textAlignment = NSTextAlignmentCenter;
    mealServiceLabel.textColor = [UIColor whiteColor];
    mealServiceLabel.text = @"Ételrendelés";
//    [self.view addSubview:mealServiceLabel];
    self.navigationItem.leftBarButtonItem = logoutButton;
}

#pragma mark - User interaction

- (void)logoutButtonPressed
{
    [[SOSessionManager sharedInstance] logoutOnComplete:^
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (IBAction)eventButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"eventListSegue" sender:self];
}

- (IBAction)mealButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"menuSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Vissza" style:UIBarButtonItemStyleBordered target:nil action:nil];
}

@end
