//
//  SOMultiEventTableViewCell+SelectionHandler.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 03/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOMultiEventTableViewCell+SelectionHandler.h"

@implementation SOMultiEventTableViewCell (SelectionHandler)

- (IBAction)leftButtonPressed:(id)sender
{
    NSDictionary *indexInfoDictionary = @{@"selectedIndex" : @0};
    [self configureAndPostNotificationWithDictionary:indexInfoDictionary];
}

- (IBAction)rightButtonPressed:(id)sender
{
    NSDictionary *indexInfoDictionary = @{@"selectedIndex" : @1};
    [self configureAndPostNotificationWithDictionary:indexInfoDictionary];
}

- (void)configureAndPostNotificationWithDictionary:(NSDictionary *)aDictionary
{
    [[NSNotificationCenter defaultCenter] postNotificationName:multiCellSelectionNotification object:self userInfo:aDictionary];
}

@end
