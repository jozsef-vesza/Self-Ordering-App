//
//  SOEventCellConfigurator.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 01/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOEventCellConfigurator.h"
#import "SOEvent.h"
#import "SORegularEventTableViewCell.h"
#import "SOMultiEventTableViewCell.h"
#import "SOPromotedEventTableViewCell.h"

@implementation SOEventCellConfigurator

- (NSString *)fetchCellIdentifierForObject:(id)anObject
{
    static NSString *regularId = @"regularCell";
    static NSString *promotedId = @"promotedCell";
    static NSString *multiId = @"multiCell";
    
    if ([anObject isKindOfClass:[NSArray class]]) return multiId;
    else
    {
        SOEvent *eventInCell = (SOEvent *)anObject;
        if (eventInCell.priority == 1) return promotedId;
        else return regularId;
    }
}

- (UITableViewCell *)configureCell:(UITableViewCell *)aCell usingObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath
{
    if ([anObject isKindOfClass:[SOEvent class]])
    {
        SOEvent *eventInCell = (SOEvent *)anObject;
        if (eventInCell.priority == 1)
        {
            // Configure promoted event
            SOPromotedEventTableViewCell *promotedCell = (SOPromotedEventTableViewCell *)aCell;
            [promotedCell.promotedEventButton setBackgroundImage:eventInCell.eventImage forState:UIControlStateNormal];
            return promotedCell;
        }
    }
    else if ([anObject isKindOfClass:[NSArray class]])
    {
        // Configure multicell event
        SOMultiEventTableViewCell *multiCell = (SOMultiEventTableViewCell *)aCell;
        SOEvent *leftEvent = (SOEvent *)anObject[0];
        SOEvent *rightEvent = (SOEvent *)anObject[1];
        [multiCell.leftEventButton setBackgroundImage:leftEvent.eventImage forState:UIControlStateNormal];
        [multiCell.rightEventButton setBackgroundImage:rightEvent.eventImage forState:UIControlStateNormal];
        return multiCell;
    }
    
    // Default scenario
    SOEvent *eventInCell = (SOEvent *)anObject;
    SORegularEventTableViewCell *regularCell = (SORegularEventTableViewCell *)aCell;
    regularCell.titleLabel.text = eventInCell.eventTitle;
    return regularCell;
}

@end
