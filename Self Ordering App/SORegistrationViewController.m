//
//  SORegistrationViewController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 27/02/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SORegistrationViewController.h"

@interface SORegistrationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation SORegistrationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

#pragma mark - User interaction

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    self.hud.labelText = @"Regisztráció";
    self.hud.dimBackground = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^
    {
        [[SOSessionManager sharedInstance] registerUserWithFirstName:self.firstNameField.text lastName:self.lastNameField.text emailAddress:self.emailField.text userName:self.userNameField.text password:self.passwordField.text onComplete:^
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                self.hud.mode = MBProgressHUDModeText;
                self.hud.labelText = @"Sikeres regisztráció";
                [self.hud hide:YES afterDelay:0.5];
            });
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        onError:^(NSError *error)
        {
            //TODO: error handling
            dispatch_async(dispatch_get_main_queue(), ^
            {
                self.hud.mode = MBProgressHUDModeText;
                self.hud.labelText = @"Hibaüzenet";
                [self.hud hide:YES afterDelay:1.0];
            });
        }];
    });
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

@end
