//
//  SOEventTabBarController.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 07/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOEventTabBarController.h"

@interface SOEventTabBarController ()

@property (strong,nonatomic) SOSessionManager *sessionManager;

@end

@implementation SOEventTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.tintColor = [UIColor colorWithRed:0 green:0.730596 blue:0.730596 alpha:1];
    self.sessionManager = [SOSessionManager sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTabBadge) name:eventOrderRemovedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateTabBadge];
}

- (void)updateTabBadge
{
    UITabBarItem *cartItem = self.tabBar.items[1];
    if ([self.sessionManager.activeUser.eventOrders count] > 0)
    {
        cartItem.badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)[self.sessionManager.activeUser.eventOrders count]];
    }
    else
    {
        cartItem.badgeValue = nil;
    }
}


@end
