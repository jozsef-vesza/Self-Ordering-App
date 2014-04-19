//
//  SOEventOrderDataSource.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 20/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOEventOrderDataSource.h"
#import "SOEventTabBarController.h"

@implementation SOEventOrderDataSource

- (instancetype)initWithPaidItems:(NSArray *)aPaidItems unpaidItems:(NSArray *)anUnpaidItems
{
    self = [super init];
    if (self)
    {
        _unpaidArray = anUnpaidItems;
        _paidArray = aPaidItems;
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    BOOL userHasPaidEvents = [self.paidArray count] > 0;
    if (userHasPaidEvents) return 2;
    else return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 1:
            return [self.paidArray count];
            break;
        default:
            return [self.unpaidArray count];
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id itemAtIndexPath = nil;
    UITableViewCell *cellAtIndexPath = nil;
    
    switch (indexPath.section)
    {
        case 1:
            itemAtIndexPath = self.paidArray[indexPath.row];
            break;
            
        default:
            itemAtIndexPath = self.unpaidArray[indexPath.row];
            break;
    }
    
    if ([self.cellConfiguratorDelegate conformsToProtocol:@protocol(JVCellConfiguratorDelegate)])
    {
        NSString *cellIdentifier = [self.cellConfiguratorDelegate fetchCellIdentifierForObject:itemAtIndexPath];
        cellAtIndexPath = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (itemAtIndexPath)
        {
            cellAtIndexPath = [self.cellConfiguratorDelegate configureCell:cellAtIndexPath usingObject:itemAtIndexPath atIndexPath:indexPath];
        }
    }
    
    return cellAtIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL userWantsToDelete = editingStyle == UITableViewCellEditingStyleDelete;
    if (userWantsToDelete)
    {
        switch (indexPath.section)
        {
            case 1:
                [[NSNotificationCenter defaultCenter] postNotificationName:eventOrderRemovedNotification object:self.paidArray[indexPath.row]];
                break;
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:eventOrderRemovedNotification object:self.unpaidArray[indexPath.row]];
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            tableView.editing = NO;
        });
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 1:
            return @"Fizetett rendelések";
            break;
        default:
            return @"Új rendelések";
            break;
    }
}

@end
