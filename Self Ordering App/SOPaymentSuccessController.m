//
//  SOPaymentSuccessController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 30/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOPaymentSuccessController.h"
#import "JVTableViewDataSource.h"
#import "SOMealRatingCellConfigurator.h"
#import "SORateView.h"
#import "SOMeal.h"
#import "SOMealManager.h"

@interface SOPaymentSuccessController ()

@property (weak, nonatomic) IBOutlet UITableView *ordersTableView;
@property (nonatomic,strong) JVTableViewDataSource *dataSource;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation SOPaymentSuccessController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ratingChanged:) name:ratingChangedNotification object:nil];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.hud removeFromSuperview];
}

- (void)setupDataSource
{
    self.dataSource = [[JVTableViewDataSource alloc] initWithItems:[SOSessionManager sharedInstance].activeUser.mealOrders];
    self.dataSource.cellConfiguratorDelegate = [[SOMealRatingCellConfigurator alloc] init];
    self.ordersTableView.dataSource = self.dataSource;
}

- (IBAction)confirmButtonPressed:(UIBarButtonItem *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.hud.labelText = @"Értékelés elküldése";
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.dimBackground = YES;
        [self.hud show:YES];
    });
    for (SOMeal *meal in self.dataSource.items)
    {
        NSLog(@"%@ %d", meal.mealName,(int)meal.mealRating);
    }
    [[SOMealManager sharedInstance] sendRatingForMeals:self.dataSource.items onComplete:^
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.hud.mode = MBProgressHUDModeCustomView;
            self.hud.labelText = @"Értékelés elküldve!";
            [self.hud hide:YES afterDelay:1.0];
        });
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    onError:^(NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hud.mode = MBProgressHUDModeCustomView;
            self.hud.labelText = @"Hibaüzenet";
            [self.hud hide:YES afterDelay:1.0];
        });
        NSLog(@"Error: %@", error);
    }];
}

- (void)ratingChanged:(NSNotification *)aNotification
{
    NSLog(@"BOOYAH");
    SORateView *rateview = aNotification.object;
    SOMeal *ratedMeal = (SOMeal *)self.dataSource.items[rateview.indexPath.row];
    ratedMeal.mealRating = rateview.rating;
    NSLog(@"%@ %d", ratedMeal.mealName,(int)ratedMeal.mealRating);
    NSLog(@"%d", (int)rateview.rating);
}

@end
