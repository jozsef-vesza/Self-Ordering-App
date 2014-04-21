//
//  SOMenuCellConfigurator.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 23/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOMenuCellConfigurator.h"
#import "SOSimpleMealCell.h"
#import "SOExpandedMealCell.h"
#import "SODrinkTVCell.h"
#import "SOMeal.h"
#import "SOMealManager.h"

@implementation SOMenuCellConfigurator

- (NSString *)fetchCellIdentifierForObject:(id)anObject
{
    if ([anObject isKindOfClass:[SOMeal class]]) return @"simpleMealCell";
    return @"expandedMealCell";
}

- (UITableViewCell *)configureCell:(UITableViewCell *)aCell usingObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath
{
    SOMeal *mealInCell = (SOMeal *)anObject;
    
    if ([aCell.reuseIdentifier isEqualToString:@"simpleMealCell"])
    {
        SOSimpleMealCell *simpleCell = (SOSimpleMealCell *)aCell;
        simpleCell.mealNameLabel.text = mealInCell.mealName;
        simpleCell.mealPriceLabel.text = [NSString stringWithFormat:@"%ld Ft", (long)mealInCell.mealPrice];
        simpleCell.mealAmountField.text = [NSString stringWithFormat:@"%ld", (long)mealInCell.numberOfMealsOrdered];
        simpleCell.mealAmountField.userInteractionEnabled = NO;
        return simpleCell;
    }
    
    if ([aCell.reuseIdentifier isEqualToString:@"drinkCell"])
    {
        SODrinkTVCell *drinkCell = (SODrinkTVCell *)aCell;
        drinkCell.rateView.notSelectedImage = [UIImage imageNamed:@"1386029323_star-0.png"];
        drinkCell.rateView.fullSelectedImage = [UIImage imageNamed:@"1386029310_star-4.png"];
        drinkCell.rateView.rating = mealInCell.mealRating;
        drinkCell.rateView.editable = NO;
        drinkCell.rateView.maxRating = 5;
        drinkCell.mealAmountStepper.value = mealInCell.numberOfMealsOrdered;
        drinkCell.mealAmountStepper.minimumValue = 0;
        drinkCell.mealAmountStepper.maximumValue = 99;
        drinkCell.mealAmountStepper.wraps = NO;
        drinkCell.mealAmountStepper.autorepeat = YES;
        drinkCell.mealAmountStepper.continuous = YES;
        
        drinkCell.expandedPath = anIndexPath;
        
        return drinkCell;
    }
    
    SOExpandedMealCell *expandedCell = (SOExpandedMealCell *)aCell;
    expandedCell.mealDescriptionText.text = mealInCell.mealDescription;
    expandedCell.mealDescriptionText.editable = NO;
    expandedCell.expandedPath = anIndexPath;
    expandedCell.mealAmountStepper.value = mealInCell.numberOfMealsOrdered;
    expandedCell.mealAmountStepper.minimumValue = 0;
    expandedCell.mealAmountStepper.maximumValue = 99;
    expandedCell.mealAmountStepper.wraps = NO;
    expandedCell.mealAmountStepper.autorepeat = YES;
    expandedCell.mealAmountStepper.continuous = YES;
    expandedCell.mealRateView.notSelectedImage = [UIImage imageNamed:@"1386029323_star-0.png"];
    expandedCell.mealRateView.fullSelectedImage = [UIImage imageNamed:@"1386029310_star-4.png"];
    expandedCell.mealRateView.rating = mealInCell.mealRating;
    expandedCell.mealRateView.editable = NO;
    expandedCell.mealRateView.maxRating = 5;
    expandedCell.mealImageView.image = mealInCell.mealImage;
    expandedCell.mealImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    imageTapRecognizer.numberOfTapsRequired = 1;
    [expandedCell.mealImageView addGestureRecognizer:imageTapRecognizer];
    
    return expandedCell;
}

- (NSInteger)syncedAmountForMeal:(SOMeal *)aMeal
{
    return [[SOMealManager sharedInstance] findMealinCurrentSelection:aMeal].numberOfMealsOrdered;
}

- (void)imageTapped:(UITapGestureRecognizer *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:mealImageTappedNotification object:sender];
}

@end
