//
//  SOMealManager.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 23/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOMeal.h"

@interface SOMealManager : NSObject

/**
 *  Arrays to hold various types of meals
 */
@property (copy,nonatomic) NSArray *startersArray;

@property (copy,nonatomic) NSArray *soupsArray;

@property (copy,nonatomic) NSArray *mainDishesArray;

@property (copy,nonatomic) NSArray *drinksArray;

@property (copy,nonatomic) NSArray *dessertsArray;

@property (copy,nonatomic) NSArray *alcoholicDrinksArray;

/**
 *  Array to hold meals that the user has selected from the menu
 */
@property (nonatomic, copy) NSArray *selectedMeals;

/**
 *  Singleton function
 *
 *  @return a shared instance of SOMealManager
 */
+ (instancetype)sharedInstance;

/**
 *  Load events for the current session
 *
 *  @param aCompletionHandler block to perform upon completion
 *  @param anErrorHandler     block to perform in case of error
 */
- (void)loadItemsOnComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Add meals to the user's temporary cart
 *
 *  @param aMeal  the meal to add
 *  @param aTimes the number of ordered portions
 */
- (void)addToSelectedMeals:(SOMeal *)aMeal times:(int)aTimes;

/**
 *  Find a specific meal within the selected meals of the user
 *
 *  @param aMeal the meal to find
 *
 *  @return the found meal
 */
- (SOMeal *)findMealinCurrentSelection:(SOMeal *)aMeal;

/**
 *  Create a temporary restaurant order for a user
 *
 *  @param anUser  the current user
 *  @param anItems the items which the user wants to order
 */
- (void)createTemporaryOrderForUser:(SOUser *)anUser withItems:(NSArray *)anItems;

/**
 *  Send an order to the backend
 *
 *  @param anOrder            the ordered meals
 *  @param anUser             the current user
 *  @param aCompletionHandler block to perform upon completion
 *  @param anErrorHandler     block to perform in case of error
 */
- (void)sendOrder:(NSArray *)anOrder forUser:(SOUser *)anUser onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Send payment for the ordered meals
 *
 *  @param anOrder            the meals to be paid
 *  @param aTip               an optional tip
 *  @param aCompletionHandler block to perdorm upon completion
 *  @param anErrorHandler     block to perform in case of error
 */
- (void)sendPaymentForOrder:(NSArray *)anOrder withTip:(NSInteger)aTip onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Send rating for ordered meals
 *
 *  @param aMeals             the meals to be rated
 *  @param aCompletionHandler block to perform upon completion
 *  @param anErrorHandler     block to perform in case of error
 */
- (void)sendRatingForMeals:(NSArray *)aMeals onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

@end
