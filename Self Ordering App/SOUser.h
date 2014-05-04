//
//  SOUser.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 01/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOUser : NSObject

/**
 *  The user's login identifier
 */
@property (nonatomic,copy) NSString *userName;

/**
 *  The user's password
 */
@property (nonatomic,copy) NSString *password;

/**
 *  The ordered tickets of the user
 */
@property (nonatomic,copy) NSArray *eventOrders;

/**
 *  The temporary meal order of the user
 */
@property (nonatomic,copy) NSArray *tempMealOrders;

/**
 *  The final meal order of the user
 */
@property (nonatomic,copy) NSArray *mealOrders;

/**
 *  The list of paid tickets for the user
 */
@property (nonatomic,copy) NSArray *paidEventOrders;

/**
 *  Datastore identifier
 */
@property (nonatomic) NSNumber *identifier;

/**
 *  Convenience constructor
 *
 *  @param anUserName The username of the user
 *  @param aPassword  The password of the user
 *
 *  @return An initialized user instance
 */
+ (instancetype)userWithUserName:(NSString *)anUserName password:(NSString *)aPassword;

/**
 *  Custom initalizer method used during registration
 *
 *  @param aFirstName     First name of the new user
 *  @param aLastName      Last name of the new user
 *  @param anEmailAddress Email address of the new user
 *  @param anUserName     Username of the new user
 *  @param aPassword      Password of the new user
 *
 *  @return An initialized user instance
 */
+ (instancetype)userWithFirstName:(NSString *)aFirstName
                         lastName:(NSString *)aLastName
                     emailAddress:(NSString *)anEmailAddress
                         userName:(NSString *)anUserName
                         password:(NSString *)aPassword;

/**
 *  Custom initializer using a dictionary
 *
 *  @param aDictionary The dictionary containing user data
 *
 *  @return An initialized user instance
 */
- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

@end
