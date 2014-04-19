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
    [[SOSessionManager sharedInstance] saveUserData];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"Terminating");
    [[SOSessionManager sharedInstance] saveUserData];
    [[SOSessionManager sharedInstance] clearSessionCache];
}

@end
