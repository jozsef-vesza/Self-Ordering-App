//
//  SOUser.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 01/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOUser : NSObject

/** The user's login identifier */
@property (nonatomic,copy) NSString *userName;

/** The user's login password */
@property (nonatomic,copy) NSString *password;

@property (nonatomic,copy) NSArray *eventOrders;

@property (nonatomic,copy) NSArray *tempMealOrders;

@property (nonatomic,copy) NSArray *mealOrders;

@property (nonatomic,copy) NSArray *paidEventOrders;

@property (nonatomic) NSNumber *identifier;

/** Convenience constructor */
+ (instancetype)userWithUserName:(NSString *)anUserName password:(NSString *)aPassword;

/** Custom initializer method should be used when registering a new user */
+ (instancetype)userWithFirstName:(NSString *)aFirstName
                         lastName:(NSString *)aLastName
                     emailAddress:(NSString *)anEmailAddress
                         userName:(NSString *)anUserName
                         password:(NSString *)aPassword;

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

@end
