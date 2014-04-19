//
//  NSArray+removeDuplicateOrders.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 20/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "NSArray+removeDuplicateOrders.h"
#import "SOEvent.h"
#import "SOMeal.h"

@implementation NSArray (removeDuplicateOrders)

+ (instancetype)checkForDuplicatesForType:(Class)aClass inArray:(NSArray *)anArray
{
    NSMutableSet* existingNames = [NSMutableSet set];
    NSMutableArray* filteredArray = [NSMutableArray array];
    if (aClass == [SOEvent class])
    {
        for (SOEvent *e in anArray)
        {
            if (![existingNames containsObject:[e eventTitle]])
            {
                [existingNames addObject:[e eventTitle]];
                [filteredArray addObject:e];
            } else
            {
                for (int i = 0; i < filteredArray.count; i++)
                {
                    SOEvent *ee = [filteredArray objectAtIndex:i];
                    if ([e.identifier isEqualToNumber:ee.identifier])
                    {
                        ee.numberOfTicketsOrdered += e.numberOfTicketsOrdered;
                    }
                }
            }
        }
        
    }
    else if (aClass == [SOMeal class])
    {
        for (SOMeal *e in anArray)
        {
            if (![existingNames containsObject:[e mealName]])
            {
                [existingNames addObject:[e mealName]];
                [filteredArray addObject:e];
            } else
            {
                for (int i = 0; i < filteredArray.count; i++)
                {
                    SOMeal *ee = [filteredArray objectAtIndex:i];
                    if ([e.mealName isEqualToString:ee.mealName])
                    {
                        ee.numberOfMealsOrdered += e.numberOfMealsOrdered;
                    }
                }
            }
        }
    }
    
    return filteredArray;
}

@end
