//
//  SOTempOrderViewController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 25/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOTempOrderViewController.h"
#import "JVTableViewDataSource.h"
#import "SOTempMealCellConfigurator.h"
#import "SOTempOrderCell.h"
#import "SOMeal.h"
#import "SOMealManager.h"

@interface SOTempOrderViewController ()

@property (nonatomic,strong) JVTableViewDataSource *dataSource;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation SOTempOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stepperChanged:) name:tempStepperChangedNotification object:nil];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self setupToolbarView];
        [self.tableView reloadData];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.hud removeFromSuperview];
}

- (void)setupDataSource
{
    self.dataSource = [[JVTableViewDataSource alloc] initWithItems:[SOSessionManager sharedInstance].activeUser.tempMealOrders];
    self.dataSource.cellConfiguratorDelegate = [[SOTempMealCellConfigurator alloc] init];
    self.tableView.dataSource = self.dataSource;
}

- (void)setupToolbarView
{
    NSInteger sumPrice = 0;
    for (SOMeal *meal in self.dataSource.items)
    {
        sumPrice += meal.mealPrice * meal.numberOfMealsOrdered;
    }
    
    NSMutableArray *items = [NSMutableArray array];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [items addObject:spacer];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = [NSString stringWithFormat:@"Összesen: %d Ft", sumPrice];
    item.width = CGRectGetWidth(self.view.frame);
    [items addObject:item];
    
    UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [items addObject:rightSpacer];
    
    self.toolbarItems = items;
    self.navigationController.toolbarHidden = sumPrice != 0 ? NO : YES;
    self.navigationItem.rightBarButtonItem.enabled = sumPrice != 0 ? YES : NO;
}

- (void)stepperChanged:(NSNotification *)aNotification
{
    SOTempOrderCell *senderCell = (SOTempOrderCell *)aNotification.object;
    SOMeal *modifiedMeal = self.dataSource.items[senderCell.indexPath.row];
    modifiedMeal.numberOfMealsOrdered = senderCell.mealAmountStepper.value;
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[senderCell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self setupToolbarView];
}

- (IBAction)orderButtonPressed:(UIBarButtonItem *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.hud.labelText = @"Rendelés folyamatban";
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.dimBackground = YES;
        [self.hud show:YES];
    });
    SOUser *activeUser = [SOSessionManager sharedInstance].activeUser;
    [[SOMealManager sharedInstance] sendOrder:activeUser.tempMealOrders forUser:activeUser onComplete:^
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.hud.mode = MBProgressHUDModeCustomView;
            self.hud.labelText = @"Sikeres rendelés";
            [self.hud hide:YES afterDelay:1.0];
        });
        //TODO: pop this shit
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

@end
