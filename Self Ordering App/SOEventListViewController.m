//
//  SOEventListViewController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 01/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOEventListViewController.h"
#import "JVTableViewDataSource.h"
#import "SOEventManager.h"
#import "SOEventCellConfigurator.h"

@interface SOEventListViewController ()

@property (nonatomic,strong) JVTableViewDataSource *dataSource;
@property (nonatomic,strong) SOEventManager *eventManager;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation SOEventListViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupViewElements];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMultiCellNotification:) name:multiCellSelectionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedPromotedCellNotification:) name:promotedCellSelectionNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.hud removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initial setup

- (void)setupDataSource
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.hud.labelText = @"Elemek frissítése";
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.dimBackground = YES;
        [self.hud show:YES];
    });
    self.eventManager = [SOEventManager sharedInstance];
    [self.eventManager loadItemsOnComplete:^(NSArray *items)
    {
        self.dataSource = [[JVTableViewDataSource alloc] initWithItems:items];
        self.dataSource.cellConfiguratorDelegate = [[SOEventCellConfigurator alloc] init];
        self.tableView.dataSource = self.dataSource;
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.tableView reloadData];
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

- (void)setupViewElements
{
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.tabBarController.navigationItem.title = @"Műsor";
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed:)];
}

#pragma mark - User interaction

- (IBAction)refreshButtonPressed:(UIBarButtonItem *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.hud.labelText = @"Elemek frissítése";
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.dimBackground = YES;
        [self.hud show:YES];
    });
    [self.eventManager clearItemsOnComplete:^
    {
        [self setupDataSource];
    }];
}

- (void)receivedMultiCellNotification:(NSNotification *)aNotification
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)aNotification.object];
    NSArray *selectedItem = (NSArray *)self.dataSource.items[indexPath.row];
    self.eventManager.selectedEvent = [SOEvent eventWithEvent:selectedItem[[aNotification.userInfo[@"selectedIndex"] integerValue]]];
    NSLog(@"selected event: %@", self.eventManager.selectedEvent.eventTitle);
    [self performSegueWithIdentifier:@"eventSelectedSegue" sender:self];
}

- (void)receivedPromotedCellNotification:(NSNotification *)aNotification
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)aNotification.object];
    id currentItem = self.dataSource.items[indexPath.row];
    self.eventManager.selectedEvent = [SOEvent eventWithEvent:currentItem];
    NSLog(@"selected event: %@", self.eventManager.selectedEvent.eventTitle);
    [self performSegueWithIdentifier:@"eventSelectedSegue" sender:self];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id currentItem = self.dataSource.items[indexPath.row];
    
    // Set custom cell height for different cells
    if ([currentItem isKindOfClass:[SOEvent class]])
    {
        SOEvent *event = currentItem;
        if (event.priority == 1)
        {
            return 200;
        }
    }
    else if ([currentItem isKindOfClass:[NSArray class]])
    {
        return 100;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id currentItem = self.dataSource.items[indexPath.row];
    self.eventManager.selectedEvent = [SOEvent eventWithEvent:currentItem];
    NSLog(@"selected event: %@", self.eventManager.selectedEvent.eventTitle);
    [self performSegueWithIdentifier:@"eventSelectedSegue" sender:self];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc'd", [self class]);
}

@end
