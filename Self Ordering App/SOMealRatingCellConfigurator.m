//
//  SOMealRatingCellConfigurator.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 30/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOMealRatingCellConfigurator.h"
#import "SORatingCell.h"
#import "SOMeal.h"

@implementation SOMealRatingCellConfigurator

- (NSString *)fetchCellIdentifierForObject:(id)anObject
{
    return @"rateableCell";
}

- (UITableViewCell *)configureCell:(UITableViewCell *)aCell usingObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath
{
    SORatingCell *currentCell = (SORatingCell *)aCell;
    SOMeal *mealInCell = (SOMeal *)anObject;
    currentCell.mealNameLabel.text = mealInCell.mealName;
    currentCell.mealRateView.notSelectedImage = [UIImage imageNamed:@"1386029323_star-0.png"];
    currentCell.mealRateView.fullSelectedImage = [UIImage imageNamed:@"1386029310_star-4.png"];
    currentCell.mealRateView.rating = 0;
    currentCell.mealRateView.editable = YES;
    currentCell.mealRateView.maxRating = 5;
    currentCell.mealRateView.indexPath = anIndexPath;
    return currentCell;
}

@end
