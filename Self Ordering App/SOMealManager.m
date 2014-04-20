//
//  SOMealManager.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 23/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOMealManager.h"
#import "SONetworkingManager.h"
#import "NSArray+removeDuplicateOrders.h"

@interface SOMealManager ()

@property (nonatomic,strong) SONetworkingManager *networkingManager;

@end

@implementation SOMealManager

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _networkingManager = [SONetworkingManager sharedInstance];
    }
    return self;
}

- (NSArray *)startersArray
{
    if (!_startersArray) _startersArray = [NSArray array];
    return _startersArray;
}

- (NSArray *)soupsArray
{
    if (!_soupsArray) _soupsArray = [NSArray array];
    return _soupsArray;
}

- (NSArray *)mainDishesArray
{
    if (!_mainDishesArray) _mainDishesArray = [NSArray array];
    return _mainDishesArray;
}

- (NSArray *)dessertsArray
{
    if (!_dessertsArray) _dessertsArray = [NSArray array];
    return _dessertsArray;
}

- (NSArray *)drinksArray
{
    if (!_drinksArray) _drinksArray = [NSArray array];
    return _drinksArray;
}

- (NSArray *)alcoholicDrinksArray
{
    if (!_alcoholicDrinksArray) _alcoholicDrinksArray = [NSArray array];
    return _alcoholicDrinksArray;
}

- (NSArray *)selectedMeals
{
    if (!_selectedMeals) _selectedMeals = [NSArray array];
    return _selectedMeals;
}

- (void)loadItemsOnComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *))anErrorHandler
{
    [self loadMenu];
    BOOL noCachedItems = [self.startersArray count] == 0 && [self.soupsArray count] == 0 && [self.mainDishesArray count] == 0 && [self.dessertsArray count] == 0 && [self.drinksArray count] == 0 && [self.alcoholicDrinksArray count] == 0;
    if (noCachedItems)
    {
        [self.networkingManager downloadMealsOnComplete:^(NSArray *menu)
        {
            
            self.startersArray = [self sortArray:menu forMealCategory:@"starter"];
            self.soupsArray = [self sortArray:menu forMealCategory:@"soup"];
            self.mainDishesArray = [self sortArray:menu forMealCategory:@"main"];
            self.dessertsArray = [self sortArray:menu forMealCategory:@"dessert"];
            self.drinksArray = [self sortArray:menu forMealCategory:@"drink"];
            self.alcoholicDrinksArray = [self sortArray:menu forMealCategory:@"alcoholic"];
            
            [self saveMenu];
            
            aCompletionHandler();
        }
        onError:^(NSError *error)
        {
            anErrorHandler(error);
        }];
    }
    else
    {
        aCompletionHandler();
    }
}

- (void)saveMenu
{
    [[SOSessionManager sharedInstance] saveDownloadedItems:self.startersArray to:starterKey];
    [[SOSessionManager sharedInstance] saveDownloadedItems:self.soupsArray to:soupKey];
    [[SOSessionManager sharedInstance] saveDownloadedItems:self.mainDishesArray to:mainKey];
    [[SOSessionManager sharedInstance] saveDownloadedItems:self.dessertsArray to:dessertsKey];
    [[SOSessionManager sharedInstance] saveDownloadedItems:self.drinksArray to:drinkKey];
    [[SOSessionManager sharedInstance] saveDownloadedItems:self.alcoholicDrinksArray to:alcoholicKey];
}

- (void)loadMenu
{
    self.startersArray = [[SOSessionManager sharedInstance] loadSavedItemsFromPath:starterKey];
    self.soupsArray = [[SOSessionManager sharedInstance] loadSavedItemsFromPath:soupKey];
    self.mainDishesArray = [[SOSessionManager sharedInstance] loadSavedItemsFromPath:mainKey];
    self.dessertsArray = [[SOSessionManager sharedInstance] loadSavedItemsFromPath:dessertsKey];
    self.drinksArray = [[SOSessionManager sharedInstance] loadSavedItemsFromPath:drinkKey];
    self.alcoholicDrinksArray = [[SOSessionManager sharedInstance] loadSavedItemsFromPath:alcoholicKey];
}

- (void)sendOrder:(NSArray *)anOrder forUser:(SOUser *)anUser onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler
{
    [self.networkingManager orderMeals:anOrder forUser:anUser onComplete:^(NSArray *order)
    {
        [self updateOrdersWithArray:order];
        aCompletionHandler();
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
}

- (void)sendPaymentForOrder:(NSArray *)anOrder withTip:(NSInteger)aTip onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *))anErrorHandler
{
    [self.networkingManager payForMeals:anOrder withTip:aTip forUser:[SOSessionManager sharedInstance].activeUser onComplete:^
    {
        aCompletionHandler();
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
}

- (void)sendRatingForMeals:(NSArray *)aMeals onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *))anErrorHandler
{
    [self.networkingManager sendRatingForMeals:aMeals onComplete:^
    {
        [SOSessionManager sharedInstance].activeUser.mealOrders = nil;
        aCompletionHandler();
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
}

- (NSArray *)sortArray:(NSArray *)anArray forMealCategory:(NSString *)aCategory
{
    NSPredicate *category = [NSPredicate predicateWithFormat:@"mealCategory == %@", aCategory];
    return [anArray filteredArrayUsingPredicate:category];
}

- (void)addToSelectedMeals:(SOMeal *)aMeal times:(int)aTimes
{
    SOMeal *mealToBeAdded = [SOMeal mealWithMeal:aMeal];
    mealToBeAdded.numberOfMealsOrdered = 1;
    NSMutableArray *tempMeals = [self.selectedMeals mutableCopy];
    
    if ([self.selectedMeals count] > 0)
    {
        int numOfItems = 0;
        // Check for the number of objects already available in the temp array
        for (SOMeal *meal in self.selectedMeals)
        {
            if ([meal.mealName isEqualToString:mealToBeAdded.mealName])
            {
                numOfItems++;
            }
        }
        // Removal necessary
        if (numOfItems > aTimes)
        {
            for (int i = 0; i < numOfItems - aTimes; ++i)
            {
                [tempMeals removeObject:mealToBeAdded];
            }
        }
        // Addition necessary
        else
        {
            for (int i = 0; i < aTimes - numOfItems; ++i)
            {
                [tempMeals addObject:mealToBeAdded];
            }
        }
        
    }
    else
    {
        for (int i = 0; i < aTimes; i++)
        {
            [tempMeals addObject:mealToBeAdded];
        }
    }
}

- (SOMeal *)findMealinCurrentSelection:(SOMeal *)aMeal
{
    for (SOMeal *meal in self.selectedMeals)
    {
        if ([aMeal.mealName isEqualToString:meal.mealName])
        {
            return meal;
        }
    }
    
    return nil;
}

- (void)createTemporaryOrderForUser:(SOUser *)anUser withItems:(NSArray *)anItems
{
    NSArray *tempArray = [NSArray checkForDuplicatesForType:[SOMeal class] inArray:anItems];
    anUser.tempMealOrders = [NSArray arrayWithArray:tempArray];
    self.selectedMeals = nil;
}

- (void)updateOrdersWithArray:(NSArray *)anArray
{
    [SOSessionManager sharedInstance].activeUser.tempMealOrders = nil;
    NSMutableArray *mealArrays = [[SOSessionManager sharedInstance].activeUser.mealOrders mutableCopy];
    [mealArrays addObjectsFromArray:anArray];
    [SOSessionManager sharedInstance].activeUser.mealOrders = [NSArray checkForDuplicatesForType:[SOMeal class] inArray:mealArrays];
}

@end
