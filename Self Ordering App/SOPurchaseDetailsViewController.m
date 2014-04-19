//
//  SOPurchaseDetailsViewController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 23/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOPurchaseDetailsViewController.h"
#import "SOEventManager.h"

@interface SOPurchaseDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *barcodeImage;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation SOPurchaseDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.hud.labelText = @"Jegy betöltése";
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.dimBackground = YES;
        [self.hud show:YES];
    });
    
    [[SOEventManager sharedInstance] loadQRImageForCurrentEventOnComplete:^(UIImage *image)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.barcodeImage.image = image;
            [self.hud hide:YES];
        });
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.hud removeFromSuperview];
}

#pragma mark - User interaction

- (IBAction)saveToCalButtonTapped:(UIBarButtonItem *)sender
{
    SOEventManager *eventManager = [SOEventManager sharedInstance];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.hud.labelText = @"Mentés a naptárba";
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.dimBackground = YES;
        [self.hud show:YES];
    });
    [eventManager addEventToCalendar:eventManager.selectedEvent onComplete:^
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.hud.mode = MBProgressHUDModeCustomView;
            self.hud.labelText = @"Sikeres mentés!";
            [self.hud hide:YES afterDelay:1.0];
        });
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

- (IBAction)dismissButtonTapped:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
