//
//  SOMealOrderCellConfigurator.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 26/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOMealOrderCellConfigurator.h"
#import "SOMeal.h"
#import "SOSimpleMealCell.h"

@implementation SOMealOrderCellConfigurator

- (NSString *)fetchCellIdentifierForObject:(id)anObject
{
    return @"simpleMealCell";
}

- (UITableViewCell *)configureCell:(UITableViewCell *)aCell usingObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath
{
    SOMeal *orderInCell = (SOMeal *)anObject;
    SOSimpleMealCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EmbeddedMeal" owner:self options:nil] lastObject];
    
    cell.mealNameLabel.text = orderInCell.mealName;
    cell.mealAmountField.text = [NSString stringWithFormat:@"%ld", (long)orderInCell.numberOfMealsOrdered];
    cell.mealPriceLabel.text = [NSString stringWithFormat:@"%ld", orderInCell.numberOfMealsOrdered * orderInCell.mealPrice];
    cell.userInteractionEnabled = NO;
    
    return cell;
}

@end
