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

@property (copy,nonatomic) NSArray *startersArray;

@property (copy,nonatomic) NSArray *soupsArray;

@property (copy,nonatomic) NSArray *mainDishesArray;

@property (copy,nonatomic) NSArray *drinksArray;

@property (copy,nonatomic) NSArray *dessertsArray;

@property (copy,nonatomic) NSArray *alcoholicDrinksArray;

@property (nonatomic, copy) NSArray *selectedMeals;

+ (instancetype)sharedInstance;

- (void)loadItemsOnComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

- (void)addToSelectedMeals:(SOMeal *)aMeal times:(int)aTimes;

- (SOMeal *)findMealinCurrentSelection:(SOMeal *)aMeal;

- (void)createTemporaryOrderForUser:(SOUser *)anUser withItems:(NSArray *)anItems;

- (void)sendOrder:(NSArray *)anOrder forUser:(SOUser *)anUser onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

//TODO: send this shit
- (void)sendPaymentForOrder:(NSArray *)anOrder withTip:(NSInteger)aTip onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

- (void)sendRatingForMeals:(NSArray *)aMeals onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

@end
