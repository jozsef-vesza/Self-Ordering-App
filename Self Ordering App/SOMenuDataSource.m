//
//  SOMenuDataSource.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 23/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOMenuDataSource.h"
#import "SOMealManager.h"

@interface SOMenuDataSource ()

@property (strong,nonatomic) SOMealManager *mealManager;

@end

@implementation SOMenuDataSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _mealManager = [SOMealManager sharedInstance];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section)
    {
        case 1:
            numberOfRows = [self.mealManager.soupsArray count];
            break;
        case 2:
            numberOfRows = [self.mealManager.mainDishesArray count];
            break;
        case 3:
            numberOfRows = [self.mealManager.dessertsArray count];
            break;
        case 4:
            numberOfRows = [self.mealManager.drinksArray count];
            break;
        case 5:
            numberOfRows = [self.mealManager.alcoholicDrinksArray count];
            break;
        default:
            numberOfRows = [self.mealManager.startersArray count];
            break;
    }
    
    if (self.expandedIndexPath && self.expandedIndexPath.section == section) return  numberOfRows + 1;
    else return numberOfRows;
}

- (SOMeal *)mealAtIndex:(NSIndexPath *)anIndexPath
{
    SOMeal *meal = nil;
    switch (anIndexPath.section)
    {
        case 1:
            meal = self.mealManager.soupsArray[anIndexPath.row];
            break;
        case 2:
            meal = self.mealManager.mainDishesArray[anIndexPath.row];
            break;
        case 3:
            meal = self.mealManager.dessertsArray[anIndexPath.row];
            break;
        case 4:
            meal = self.mealManager.drinksArray[anIndexPath.row];
            break;
        case 5:
            meal = self.mealManager.alcoholicDrinksArray[anIndexPath.row];
            break;
        default:
            meal = self.mealManager.startersArray[anIndexPath.row];
            break;
    }
    
    return meal;
}

- (NSArray *)selectedItems
{
    NSMutableArray *selArray = [NSMutableArray array];
    for (SOMeal *meal in self.mealManager.soupsArray)
    {
        if (meal.numberOfMealsOrdered > 0)
        {
            [selArray addObject:meal];
        }
    }
    for (SOMeal *meal in self.mealManager.startersArray)
    {
        if (meal.numberOfMealsOrdered > 0)
        {
            [selArray addObject:meal];
        }
    }
    for (SOMeal *meal in self.mealManager.mainDishesArray)
    {
        if (meal.numberOfMealsOrdered > 0)
        {
            [selArray addObject:meal];
        }
    }
    for (SOMeal *meal in self.mealManager.dessertsArray)
    {
        if (meal.numberOfMealsOrdered > 0)
        {
            [selArray addObject:meal];
        }
    }
    for (SOMeal *meal in self.mealManager.drinksArray)
    {
        if (meal.numberOfMealsOrdered > 0)
        {
            [selArray addObject:meal];
        }
    }
    for (SOMeal *meal in self.mealManager.alcoholicDrinksArray)
    {
        if (meal.numberOfMealsOrdered > 0)
        {
            [selArray addObject:meal];
        }
    }
    return selArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id itemAtIndexPath = nil;
    UITableViewCell *cellAtIndexPath = nil;
    
    if ([indexPath isEqual:self.expandedIndexPath])
    {
        switch (indexPath.section)
        {
            case 1:
                itemAtIndexPath = self.mealManager.soupsArray[[self actualIndexPathForTappedIndexPath:indexPath].row - 1];
                break;
            case 2:
                itemAtIndexPath = self.mealManager.mainDishesArray[[self actualIndexPathForTappedIndexPath:indexPath].row - 1];
                break;
            case 3:
                itemAtIndexPath = self.mealManager.dessertsArray[[self actualIndexPathForTappedIndexPath:indexPath].row - 1];
                break;
            case 4:
                itemAtIndexPath = self.mealManager.drinksArray[[self actualIndexPathForTappedIndexPath:indexPath].row - 1];
                break;
            case 5:
                itemAtIndexPath = self.mealManager.alcoholicDrinksArray[[self actualIndexPathForTappedIndexPath:indexPath].row - 1];
                break;
            default:
                itemAtIndexPath = self.mealManager.startersArray[[self actualIndexPathForTappedIndexPath:indexPath].row - 1];
                break;
        }
        
        cellAtIndexPath = [tableView dequeueReusableCellWithIdentifier:@"expandedMealCell"];
    }
    else
    {
        switch (indexPath.section)
        {
            case 1:
                itemAtIndexPath = self.mealManager.soupsArray[[self actualIndexPathForTappedIndexPath:indexPath].row];
                break;
            case 2:
                itemAtIndexPath = self.mealManager.mainDishesArray[[self actualIndexPathForTappedIndexPath:indexPath].row];
                break;
            case 3:
                itemAtIndexPath = self.mealManager.dessertsArray[[self actualIndexPathForTappedIndexPath:indexPath].row];
                break;
            case 4:
                itemAtIndexPath = self.mealManager.drinksArray[[self actualIndexPathForTappedIndexPath:indexPath].row];
                break;
            case 5:
                itemAtIndexPath = self.mealManager.alcoholicDrinksArray[[self actualIndexPathForTappedIndexPath:indexPath].row];
                break;
            default:
                itemAtIndexPath = self.mealManager.startersArray[[self actualIndexPathForTappedIndexPath:indexPath].row];
                break;
        }
        
        if ([self.cellConfiguratorDelegate conformsToProtocol:@protocol(JVCellConfiguratorDelegate)])
        {
            NSString *cellIdentifier = [self.cellConfiguratorDelegate fetchCellIdentifierForObject:itemAtIndexPath];
            cellAtIndexPath = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        }
    }
    
    
    cellAtIndexPath = [self.cellConfiguratorDelegate configureCell:cellAtIndexPath usingObject:itemAtIndexPath atIndexPath:indexPath];
    return cellAtIndexPath;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Előételek", nil);
            break;
        case 1:
            sectionName = NSLocalizedString(@"Levesek", nil);
            break;
        case 2:
            sectionName = NSLocalizedString(@"Főételek", nil);
            break;
        case 3:
            sectionName = NSLocalizedString(@"Desszertek", nil);
            break;
        case 4:
            sectionName = NSLocalizedString(@"Üdítők", nil);
            break;
        case 5:
            sectionName = NSLocalizedString(@"Alkoholos italok", nil);
            break;
        default:
            break;
    }
    
    return sectionName;
}

- (NSIndexPath *)actualIndexPathForTappedIndexPath:(NSIndexPath *)anIndexPath
{
    if (self.expandedIndexPath && anIndexPath.row > self.expandedIndexPath.row && self.expandedIndexPath.section == anIndexPath.section)
    {
        return [NSIndexPath indexPathForRow:anIndexPath.row - 1 inSection:anIndexPath.section];
    }
    
    return anIndexPath;
}

@end
