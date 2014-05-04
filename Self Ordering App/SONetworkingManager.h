//
//  SONetworkingManager.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 26/02/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOUser.h"
#import "SOEvent.h"
#import "SOLocation.h"

/**
 *  Class to encapsulate network operations
 */
@interface SONetworkingManager : NSObject

/**
 *  Singleton function
 *
 *  @return a shared instance
 */
+ (instancetype)sharedInstance;

/**
 *  Perform a login operation
 *
 *  @param anUser             The user to login
 *  @param aCompletionHandler Block to be executed upon completion
 *  @param anErrorHandler     Block to be executed in case of error
 */
- (void)loginUser:(SOUser *)anUser onComplete:(void (^)(SOUser *user))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Perform a registration operation
 *
 *  @param anUser             The user to register
 *  @param aCompletionHandler Block to be executed upon completion
 *  @param anErrorHandler     Block to be executed in case of error
 */
- (void)registerUser:(SOUser *)anUser onComplete:(void (^)(SOUser *user))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Download the list of events
 *
 *  @param aCompletionHandler Block to be executed upon completion
 *  @param anErrorHandler     Block to be executed in case of error
 */
- (void)downloadEventsOnComplete:(void (^)(NSArray *events))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Send an event order
 *
 *  @param anEvent            The ordered event
 *  @param anUser             The active user
 *  @param aCompletionHandler Block to be executed upon completion
 *  @param anErrorHandler     Block to be executed in case of error
 */
- (void)sendOrderForEvent:(SOEvent *)anEvent forUser:(SOUser *)anUser onComplete:(void (^)(SOEvent *event))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Delete a paid event from the user's list
 *
 *  @param anEvent            The event to be deleted
 *  @param anUser             The active user
 *  @param aCompletionHandler Block to be executed upon completion
 *  @param anErrorHandler     Block to be executed in case of error
 */
- (void)deleteEventOrder:(SOEvent *)anEvent forUser:(SOUser *)anUser onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Method to retreive QR code for an ordered item
 *
 *  @param anEvent            The currently selected item
 *  @param anUser             The active user
 *  @param aCompletionHandler Block to be executed upon completion
 *  @param anErrorHandler     Block to be executed in case of error
 */
- (void)downloadQRCodeForEvent:(SOEvent *)anEvent andUser:(SOUser *)anUser onComplete:(void (^)(UIImage *image))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Download the menu
 *
 *  @param aCompletionHandler Block to be executed upon completion
 *  @param anErrorHandler     Block to be executed in case of error
 */
- (void)downloadMealsOnComplete:(void (^)(NSArray *menu))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Send a meal order
 *
 *  @param aMeals             The meals to be ordered
 *  @param anUser             The active user
 *  @param aCompletionHandler Block to be executed upon completion
 *  @param anErrorHandler     Block to be executed in case of error
 */
- (void)orderMeals:(NSArray *)aMeals forUser:(SOUser *)anUser onComplete:(void (^)(NSArray *order))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Pay for ordered meals
 *
 *  @param aMeals             The ordered meals
 *  @param aTip               An optional tip
 *  @param anUser             The active user
 *  @param aCompletionHandler Block to be executed upon completion
 *  @param anErrorHandler     Block to be executed in case of error
 */
- (void)payForMeals:(NSArray *)aMeals withTip:(NSInteger)aTip forUser:(SOUser *)anUser onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Send rating for ordered meals
 *
 *  @param aMeals             The meals to be rated
 *  @param aCompletionHandler Block to excute upon completion
 *  @param anErrorHandler     Block to execute in case of error
 */
- (void)sendRatingForMeals:(NSArray *)aMeals onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

@end
