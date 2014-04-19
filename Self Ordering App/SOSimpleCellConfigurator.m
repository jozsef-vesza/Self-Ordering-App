//
//  SOSimpleCellConfigurator.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 18/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOSimpleCellConfigurator.h"
#import "SOEvent.h"
#import "SORegularEventTableViewCell.h"

@implementation SOSimpleCellConfigurator

- (NSString *)fetchCellIdentifierForObject:(id)anObject
{
    return @"simpleCell";
}

- (UITableViewCell *)configureCell:(UITableViewCell *)aCell usingObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath
{
    UITableViewCell *simpleCell = [[[NSBundle mainBundle] loadNibNamed:@"EmbeddedTableView" owner:self options:nil] lastObject];
    
    SOEvent *eventInCell = (SOEvent *)anObject;
    simpleCell.textLabel.text = eventInCell.eventTitle;
    simpleCell.detailTextLabel.text = [NSString stringWithFormat:@"%@",eventInCell.eventDate];
    
    if (eventInCell.isPaid)
    {
        simpleCell.textLabel.textColor = [UIColor grayColor];
        simpleCell.detailTextLabel.textColor = [UIColor grayColor];
    }

    return simpleCell;
}

@end
