//
//  SOLoginViewController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 26/02/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOLoginViewController.h"
#import "SOUser.h"

@interface SOLoginViewController () <UITextFieldDelegate>

@property (nonatomic,strong) SOSessionManager *sessionManager;

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UISwitch *rememberSwitch;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation SOLoginViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sessionManager = [SOSessionManager sharedInstance];
    self.userNameField.delegate = self;
    self.passwordField.delegate = self;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    
    if (self.sessionManager.activeUser)
    {
        self.userNameField.text = self.sessionManager.activeUser.userName;
        self.passwordField.text = self.sessionManager.activeUser.password;
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    else
    {
        self.userNameField.text = nil;
        self.passwordField.text = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.hud removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - User interaction

- (IBAction)loginButtonPressed:(UIBarButtonItem *)sender
{
    self.hud.labelText = @"Bejelentkezés";
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.dimBackground = YES;
    [self.hud show:YES];
    [self.sessionManager loginUserWithUserName:self.userNameField.text password:self.passwordField.text onComplete:^
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.hud.mode = MBProgressHUDModeCustomView;
            self.hud.labelText = @"Sikeres bejelentkezés";
            [self.hud hide:YES afterDelay:1.0];
        });
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    onError:^(NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.hud.mode = MBProgressHUDModeCustomView;
            self.hud.labelText = @"Hibaüzenet";
            [self.hud hide:YES afterDelay:1.0];
        });
    }];
}

- (IBAction)registerButtonPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"registerSegue" sender:self];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

#pragma mark - Text field management

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.userNameField])
    {
        [self.passwordField becomeFirstResponder];
    }
    if ([textField isEqual:self.passwordField])
    {
        [textField resignFirstResponder];
        [self loginButtonPressed:nil];
    }
    return YES;
}

@end
