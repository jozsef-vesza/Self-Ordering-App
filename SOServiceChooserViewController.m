//
//  SOServiceChooserViewController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 27/02/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOServiceChooserViewController.h"

@interface SOServiceChooserViewController ()

@end

@implementation SOServiceChooserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.toolbarHidden = YES;
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Kilépés" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonPressed)];
    logoutButton.tintColor = [UIColor redColor];
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
