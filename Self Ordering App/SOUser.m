//
//  SOUser.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 01/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOUser.h"
#import "SOEvent.h"
#import "SOMeal.h"
#import "NSArray+removeDuplicateOrders.h"

@interface SOUser ()

@property (nonatomic,copy) NSString *firstName;
@property (nonatomic,copy) NSString *lastName;
@property (nonatomic,copy) NSString *emailAddress;

@end

@implementation SOUser

+ (instancetype)userWithUserName:(NSString *)anUserName password:(NSString *)aPassword
{
    SOUser *user = [[self alloc] init];
    user.userName = anUserName;
    user.password = aPassword;
    return user;
}

+ (instancetype)userWithFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName emailAddress:(NSString *)anEmailAddress userName:(NSString *)anUserName password:(NSString *)aPassword
{
    SOUser *user = [[self alloc] init];
    user.userName = anUserName;
    user.password = aPassword;
    user.firstName = aFirstName;
    user.lastName = aLastName;
    user.emailAddress = anEmailAddress;
    return user;
}

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary
{
    self = [super init];
    if (self)
    {
        _userName = aDictionary[@"username"];
        _password = aDictionary[@"password"];
        _paidEventOrders = [self parseEventsFromResponse:aDictionary[@"orderedEvents"]];
        _eventOrders = [[SOSessionManager sharedInstance] loadSavedItemsFromPath:userEventsKey];
        _mealOrders = [self parseMealsFromResponse:aDictionary[@"orderedMeals"]];
        NSNumber *idNum = aDictionary[@"identifier"];
        _identifier = idNum ? idNum : nil;
    }
    return self;
}

- (NSArray *)parseEventsFromResponse:(NSArray *)aResponse
{
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSDictionary *entry in aResponse)
    {
        SOEvent *paidEvent = [[SOEvent alloc] initWithDictionary:entry];
        [tempArray addObject:paidEvent];
    }
    
    return tempArray;
}

- (NSArray *)parseMealsFromResponse:(NSArray *)aResponse
{
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSDictionary *entry in aResponse)
    {
        SOMeal *orderedMeal = [[SOMeal alloc] initWithDictionary:entry];
        [tempArray addObject:orderedMeal];
    }
    
    return tempArray;
}

- (NSArray *)eventOrders
{
    if (!_eventOrders)
    {
        _eventOrders = [NSArray array];
    }
    
    return _eventOrders;
}

- (NSArray *)paidEventOrders
{
    if (!_paidEventOrders)
    {
        _paidEventOrders = [NSArray array];
    }
    
    return _paidEventOrders;
}

- (NSArray *)mealOrders
{
    if (!_mealOrders) _mealOrders = [NSArray array];
    return [NSArray checkForDuplicatesForType:[SOMeal class] inArray:_mealOrders];
}

- (NSArray *)tempMealOrders
{
    if (!_tempMealOrders) _tempMealOrders = [NSArray array];
    return _tempMealOrders;
}

@end
