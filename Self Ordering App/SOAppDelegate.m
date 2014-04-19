//
//  SOAppDelegate.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 26/02/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOAppDelegate.h"
#import "SOEventManager.h"

@implementation SOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[SOSessionManager sharedInstance] clearSessionCache];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveUserData];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"Terminating");
    [self saveUserData];
    [[SOSessionManager sharedInstance] clearSessionCache];
}

- (void)saveUserData
{
    NSArray *orderedEvents = [SOSessionManager sharedInstance].activeUser.eventOrders;
    BOOL activeUserHasUnpaidItems = [orderedEvents count] > 0;
    if (activeUserHasUnpaidItems)
    {
        [[SOSessionManager sharedInstance] saveDownloadedItems:orderedEvents to:userEventsKey];
    }
//    NSArray *orderedMeals = [SOSessionManager sharedInstance].activeUser.tempMealOrders;
//    BOOL activeUserHasTempEvents = [orderedMeals count] > 0;
//    if (activeUserHasTempEvents)
//    {
//        [[SOSessionManager sharedInstance] saveDownloadedItems:orderedMeals to:userMealsKey];
//    }
}

@end
