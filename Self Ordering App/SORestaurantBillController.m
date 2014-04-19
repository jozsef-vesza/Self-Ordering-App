//
//  SORestaurantBillController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 26/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SORestaurantBillController.h"
#import "JVTableViewDataSource.h"
#import "SOMealOrderCellConfigurator.h"
#import "SOMeal.h"
#import "SORestaurantBillView.h"
#import "SOMealManager.h"

@interface SORestaurantBillController ()<UITableViewDelegate>

@property (nonatomic,strong) JVTableViewDataSource *dataSource;
@property (nonatomic,strong) UIView *noItemsView;
@property (nonatomic,strong) SORestaurantBillView *billView;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation SORestaurantBillController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderValueChanged) name:tipSliderChangedNotification object:nil];
    [self setupDefaultView];
    [self setupViewElements];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupViewElements
{
    self.tabBarController.navigationItem.title = @"Rendelések";
    if ([self.view isEqual:self.billView])
    {
        self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Fizetés" style:UIBarButtonItemStyleDone target:self action:@selector(payButtonPressed)];
    }
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
}

- (UIView *)noItemsView
{
    if (!_noItemsView)
    {
        _noItemsView = [[[NSBundle mainBundle] loadNibNamed:@"NoOrderedEventsView" owner:self options:nil] lastObject];
    }
    
    return _noItemsView;
}

- (SORestaurantBillView *)billView
{
    if (!_billView)
    {
        _billView = [[[NSBundle mainBundle] loadNibNamed:@"RestaurantBillView" owner:self options:nil] lastObject];
        _billView.ordersTableView.contentInset = UIEdgeInsetsMake
        (
         CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame),
         0.0f,
         CGRectGetHeight(self.tabBarController.tabBar.frame),
         0.0f
         );
    }
    return _billView;
}

- (void)setupDefaultView
{
    BOOL activeUserHasOrderedEvents =  [SOSessionManager sharedInstance].activeUser.mealOrders && [[SOSessionManager sharedInstance].activeUser.mealOrders count] > 0;
    if (activeUserHasOrderedEvents)
    {
        self.dataSource = [[JVTableViewDataSource alloc] initWithItems:[SOSessionManager sharedInstance].activeUser.mealOrders];
        self.dataSource.cellConfiguratorDelegate = [[SOMealOrderCellConfigurator alloc] init];
        [self setupBillView];
        self.view = self.billView;
    }
    else
    {
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
        self.view = self.noItemsView;
    }
}

- (void)setupBillView
{
    self.billView.tipSlider.minimumValue = 0;
    self.billView.tipSlider.maximumValue = 100;
    self.billView.tipSlider.value = 0;
    self.billView.tipPercentageLabel.text = [NSString stringWithFormat:@"%d %%", (int)self.billView.tipSlider.value];
    self.billView.ordersTableView.dataSource = self.dataSource;
    self.billView.ordersTableView.delegate = self;
    self.billView.finalSumLabel.text = [NSString stringWithFormat:@"%ld Ft", [self calculateTotalCost] + (int)([self calculateTotalCost] * self.billView.tipSlider.value/100)];
}

- (NSInteger)calculateTotalCost
{
    NSInteger sum = 0;
    for (SOMeal *meal in self.dataSource.items)
    {
        sum += meal.mealPrice * meal.numberOfMealsOrdered;
    }
    return sum;
}

- (void)sliderValueChanged
{
    self.billView.tipPercentageLabel.text = [NSString stringWithFormat:@"%d %%", (int)self.billView.tipSlider.value];
    self.billView.finalSumLabel.text = [NSString stringWithFormat:@"%ld Ft", [self calculateTotalCost] + (int)([self calculateTotalCost] * self.billView.tipSlider.value/100)];
}

- (void)payButtonPressed
{
    NSInteger tip = self.billView.tipSlider.value * [self calculateTotalCost];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.hud.labelText = @"Fizetés folyamatban";
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.dimBackground = YES;
        [self.hud show:YES];
    });
    [[SOMealManager sharedInstance] sendPaymentForOrder:[SOSessionManager sharedInstance].activeUser.mealOrders withTip:tip onComplete:^
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.hud.mode = MBProgressHUDModeCustomView;
            self.hud.labelText = @"Sikeres fizetés!";
            [self.hud hide:YES afterDelay:1.0];
        });
        [self performSegueWithIdentifier:@"paymentSuccessSegue" sender:self];
    }
    onError:^(NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hud.mode = MBProgressHUDModeCustomView;
            self.hud.labelText = @"Hibaüzenet";
            [self.hud hide:YES afterDelay:1.0];
        });
        
    }];
}

@end
