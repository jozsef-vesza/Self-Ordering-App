//
//  SOTempMealCellConfigurator.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 25/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOTempMealCellConfigurator.h"
#import "SOMeal.h"
#import "SOTempOrderCell.h"

@implementation SOTempMealCellConfigurator

- (NSString *)fetchCellIdentifierForObject:(id)anObject
{
    if ([anObject isKindOfClass:[SOMeal class]])
    {
        return @"tempOrderCell";
    }
    
    return nil;
}

- (UITableViewCell *)configureCell:(UITableViewCell *)aCell usingObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath
{
    SOTempOrderCell *currentCell = (SOTempOrderCell *)aCell;
    SOMeal *orderInCell = (SOMeal *)anObject;
    
    currentCell.mealNameLabel.text = orderInCell.mealName;
    currentCell.mealAmountField.text = [NSString stringWithFormat:@"%d", orderInCell.numberOfMealsOrdered];
    currentCell.mealAmountField.userInteractionEnabled = NO;
    currentCell.mealPriceLabel.text = [NSString stringWithFormat:@"%d Ft/db", orderInCell.mealPrice];
    currentCell.mealAmountStepper.value = orderInCell.numberOfMealsOrdered;
    currentCell.mealAmountStepper.minimumValue = 0;
    currentCell.mealAmountStepper.maximumValue = 99;
    currentCell.mealAmountStepper.wraps = NO;
    currentCell.mealAmountStepper.autorepeat = YES;
    currentCell.mealAmountStepper.continuous = YES;
    currentCell.indexPath = anIndexPath;
    
    return currentCell;
}

@end
