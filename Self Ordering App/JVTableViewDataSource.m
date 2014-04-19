//
//  JVTableViewDataSource.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 28/02/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "JVTableViewDataSource.h"

@interface JVTableViewDataSource ()

@end

@implementation JVTableViewDataSource

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self)
    {
        _items = items;
    }
    
    return self;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.items count])
    {
        return [self.items count];
    }
    
    NSLog(@"numberOfRowsInSection could not be determined. self.items is nil or empty.");
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id itemAtIndexPath = self.items[indexPath.row];
    UITableViewCell *cellAtIndexPath = nil;
    
    // Individual cell configuration is done using a delegate
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

@end
