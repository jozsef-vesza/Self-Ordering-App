//
//  SOOrderedTicketsViewController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 28/02/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOOrderedTicketsViewController.h"
#import "SOEventOrderDataSource.h"
#import "SOSimpleCellConfigurator.h"
#import "SOEventManager.h"

@interface SOOrderedTicketsViewController ()<UITableViewDelegate>

@property (nonatomic,strong) SOEventOrderDataSource *dataSource;
@property (nonatomic,strong) SOEventManager *eventManager;
@property (nonatomic,strong) UITableView *ordersTableView;
@property (nonatomic,strong) UIView *noItemsView;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation SOOrderedTicketsViewController

#pragma mark - View lifecycle and setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eventManager = [SOEventManager sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeNotificationReceived:) name:eventOrderRemovedNotification object:nil];
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    [self setupViewElements];
    [self setupDefaultView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.hud removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupViewElements
{
    self.tabBarController.navigationItem.title = @"Kosár";
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Szerkesztés" style:UIBarButtonItemStylePlain target:self action:@selector(editModeToggled:)];
}

- (UITableView *)ordersTableView
{
    if (!_ordersTableView)
    {
        _ordersTableView = [[UITableView alloc] init];
        _ordersTableView.backgroundColor = [UIColor redColor];
        _ordersTableView.contentInset =
        UIEdgeInsetsMake
        (
            CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame),
            0.0f,
            CGRectGetHeight(self.tabBarController.tabBar.frame),
            0.0f
         );
    }
    
    return _ordersTableView;
}

- (UIView *)noItemsView
{
    if (!_noItemsView)
    {
        _noItemsView = [[[NSBundle mainBundle] loadNibNamed:@"NoOrderedEventsView" owner:self options:nil] lastObject];
    }
    
    return _noItemsView;
}

- (void)setupDefaultView
{
    BOOL activeUserHasOrderedEvents = [[SOSessionManager sharedInstance].activeUser.eventOrders count] > 0 || [[SOSessionManager sharedInstance].activeUser.paidEventOrders count] > 0;
    if (activeUserHasOrderedEvents)
    {
        self.dataSource = [[SOEventOrderDataSource alloc] initWithPaidItems:[SOSessionManager sharedInstance].activeUser.paidEventOrders unpaidItems:[SOSessionManager sharedInstance].activeUser.eventOrders];
        self.dataSource.cellConfiguratorDelegate = [[SOSimpleCellConfigurator alloc] init];
        self.ordersTableView.dataSource = self.dataSource;
        self.ordersTableView.delegate = self;
        self.view = self.ordersTableView;
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.ordersTableView reloadData];
        });
    }
    else
    {
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
        self.view = self.noItemsView;
    }
}

#pragma mark - User interaction

- (void)removeNotificationReceived:(NSNotification *)aNotification
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.hud.labelText = @"Elem törlése";
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.dimBackground = YES;
        [self.hud show:YES];
    });
    SOEvent *eventToBeRemoved = (SOEvent *)aNotification.object;
    __weak SOOrderedTicketsViewController *weakSelf = self;
    [self.eventManager removeEventFromCart:eventToBeRemoved forUser:[SOSessionManager sharedInstance].activeUser onComplete:^
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.hud hide:YES];
        });
        __strong SOOrderedTicketsViewController *strongSelf = weakSelf;
        [strongSelf setupDefaultView];
    }];
}

- (void)editModeToggled:(UIBarButtonItem *)sender
{
    [self setEditing:![self isEditing] animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.ordersTableView setEditing:editing animated:animated];
    if (editing)
    {
        self.tabBarController.navigationItem.rightBarButtonItem.title = @"Kész";
        self.tabBarController.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
    }
    else
    {
        self.tabBarController.navigationItem.rightBarButtonItem.title = @"Szerkesztés";
        self.tabBarController.navigationItem.rightBarButtonItem.tintColor = [self.view tintColor];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id currentItem = nil;
    switch (indexPath.section)
    {
        case 1:
            currentItem = self.dataSource.paidArray[indexPath.row];
            break;
        default:
            currentItem = self.dataSource.unpaidArray[indexPath.row];
            break;
    }
    self.eventManager.selectedEvent = currentItem;
    NSLog(@"selected event: %@", self.eventManager.selectedEvent.eventTitle);
    [self performSegueWithIdentifier:@"orderedEventSelectedSegue" sender:self];
}

@end
