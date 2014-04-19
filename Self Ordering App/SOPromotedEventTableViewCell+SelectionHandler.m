//
//  SOPromotedEventTableViewCell+SelectionHandler.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 03/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOPromotedEventTableViewCell+SelectionHandler.h"

@implementation SOPromotedEventTableViewCell (SelectionHandler)

- (IBAction)eventButtonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:promotedCellSelectionNotification object:self userInfo:nil];
}

@end
