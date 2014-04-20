//
//  SOMenuTableViewController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 23/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOMenuTableViewController.h"
#import "SOMenuDataSource.h"
#import "SOMealManager.h"
#import "SOMenuCellConfigurator.h"
#import "SOSimpleMealCell.h"
#import "SOExpandedMealCell.h"
#import "SOMealImageController.h"

@interface SOMenuTableViewController ()

@property (nonatomic,strong) SOMealManager *mealManager;
@property (nonatomic,strong) SOMenuDataSource *dataSource;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation SOMenuTableViewController

#pragma mark - View lifecycle and setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mealManager = [SOMealManager sharedInstance];
    [self setupDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupViewElements];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stepperChangeReceived:) name:menuStepperChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mealImageTapped:) name:mealImageTappedNotification object:nil];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self.tableView reloadData];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.hud removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupViewElements
{
    self.tabBarController.navigationItem.title = @"Étlap";
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Összesítés" style:UIBarButtonItemStyleDone target:self action:@selector(orderButtonPressed)];
    NSArray *mealsArray = [self.dataSource selectedItems];
    BOOL selectedMealsExist = mealsArray && [mealsArray count] > 0;
    self.tabBarController.navigationItem.rightBarButtonItem.enabled = selectedMealsExist ? YES : NO;
    self.navigationController.toolbarHidden = YES;
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    
    BOOL poppedToThisViewAfterPurchase = [[SOSessionManager sharedInstance].activeUser.tempMealOrders count] == 0 && [[self.dataSource selectedItems] count] > 0;
    if (poppedToThisViewAfterPurchase)
    {
        [self.dataSource clearSelections];
    }
}

-(void)setupDataSource
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.hud.labelText = @"Elemek frissítése";
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.dimBackground = YES;
        [self.hud show:YES];
    });
    [self.mealManager loadItemsOnComplete:^
    {
        self.dataSource = [[SOMenuDataSource alloc] init];
        self.dataSource.cellConfiguratorDelegate = [[SOMenuCellConfigurator alloc] init];
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

#pragma mark - User interaction

- (void)stepperChangeReceived:(NSNotification *)aNotification
{
    // Identify the sender/receiver cell and the stepper value
    SOExpandedMealCell *senderCell = aNotification.object;
    NSIndexPath *receiverIndexPath = [NSIndexPath indexPathForRow:senderCell.expandedPath.row - 1 inSection:senderCell.expandedPath.section];
    int value = (int)senderCell.mealAmountStepper.value;
    
    SOMenuDataSource *dataSource = self.tableView.dataSource;
    SOMeal *receiverMeal = [dataSource mealAtIndex:receiverIndexPath];
    receiverMeal.numberOfMealsOrdered = value;
    
    NSArray *mealsArray = [self.dataSource selectedItems];
    BOOL selectedMealsExist = mealsArray && [mealsArray count] > 0;
    self.tabBarController.navigationItem.rightBarButtonItem.enabled = selectedMealsExist ? YES : NO;
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[receiverIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)mealImageTapped:(NSNotification *)aNotification
{
    UITapGestureRecognizer *recognizer = aNotification.object;
    UIImageView *imageView = (UIImageView *)recognizer.view;
    UIImage *img = imageView.image;
    [self performSegueWithIdentifier:@"mealImageSegue" sender:img];
}

- (void)orderButtonPressed
{
    [self.mealManager createTemporaryOrderForUser:[SOSessionManager sharedInstance].activeUser withItems:[self.dataSource selectedItems]];
    [self performSegueWithIdentifier:@"tempOrderSeque" sender:self];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tappedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([tappedCell isKindOfClass:[SOExpandedMealCell class]]) return;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SOMenuDataSource *dataSource = self.tableView.dataSource;
    indexPath = [dataSource actualIndexPathForTappedIndexPath:indexPath];
    NSIndexPath *expandedIndexPath = dataSource.expandedIndexPath;
    
    if ([indexPath isEqual:dataSource.simpleIndexPath])
    {
        dataSource.simpleIndexPath = nil;
        dataSource.expandedIndexPath = nil;
    }
    else
    {
        dataSource.simpleIndexPath = indexPath;
        dataSource.expandedIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    }
    
    [tableView beginUpdates];
    
    if (expandedIndexPath)
    {
        [tableView deleteRowsAtIndexPaths:@[expandedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    if (dataSource.expandedIndexPath)
    {
        [tableView insertRowsAtIndexPaths:@[dataSource.expandedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [tableView endUpdates];
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SOMenuDataSource *dataSource = self.tableView.dataSource;
    if (dataSource.expandedIndexPath && [dataSource.expandedIndexPath isEqual:indexPath])
    {
        return 400;
    }
    
    return 44;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mealImageSegue"])
    {
        UIImage *img = sender;
        UINavigationController *navController = [segue destinationViewController];
        SOMealImageController *imageController = (SOMealImageController *)navController.topViewController;
        imageController.img = img;
    }
}

@end
