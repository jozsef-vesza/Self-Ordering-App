//
//  SOEventManager.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 01/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOEvent.h"
#import "SOLocation.h"

/**
 *  Class to encapsulate event-related operations
 */
@interface SOEventManager : NSObject

/**
 *  Property to access the currently selected event
 */
@property (nonatomic,strong) SOEvent *selectedEvent;

/**
 *  The array of available items
 */
@property (nonatomic,copy) NSArray *eventsArray;

/**
 *  Singleton function
 *
 *  @return a shared instance of SOEventManager
 */
+ (instancetype)sharedInstance;

/**
 *  Load the events for the current session
 *
 *  @param aCompletionHandler block to perform upon completion
 *  @param anErrorHandler     block to perform in case of error
 */
- (void)loadItemsOnComplete:(void (^)(NSArray *items))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

- (void)clearItemsOnComplete:(void (^)())aCompletionHandler;

/**
 *  Add event to the cart for the active user
 *
 *  @param anEvent            the event to add
 *  @param aTimes             the number of tickets ordered
 *  @param anUser             the active user
 *  @param aCompletionHandler block to perform upon completion
 */
- (void)addEventToCart:(SOEvent *)anEvent times:(int)aTimes forUser:(SOUser *)anUser onComplete:(void (^)())aCompletionHandler;

/**
 *  Remove an event from the user's cart
 *
 *  @param anEvent            the event to remove
 *  @param anUser             the active user
 *  @param aCompletionHandler block to perform upon completion
 */
- (void)removeEventFromCart:(SOEvent *)anEvent forUser:(SOUser *)anUser onComplete:(void (^)())aCompletionHandler;

/**
 *  Send the order request to the backend
 *
 *  @param anEvent            the ordered event
 *  @param anUser             the active user
 *  @param aCompletionHandler block to perform upon completion
 *  @param anErrorHandler     block to perform in case of error
 */
- (void)sendOrderForEvent:(SOEvent *)anEvent forUser:(SOUser *)anUser onComplete:(void (^)(SOEvent *event))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Add event to the user's calendar
 *
 *  @param anEvent            the event to add
 *  @param aCompletionHandler block to perform upon completion
 *  @param anErrorHandler     block to perform in case of error
 */
- (void)addEventToCalendar:(SOEvent *)anEvent onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Load the QR ticket for the current event
 *
 *  @param aCompletionHandler block to perform upon completion
 *  @param anErrorHandler     block to perform in case of error
 */
- (void)loadQRImageForCurrentEventOnComplete:(void (^)(UIImage *image))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

@end
