//
//  SONetworkingManager.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 26/02/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SONetworkingManager.h"
#import "NSJSONSerialization+parseObjectArray.h"
#import "SOEvent.h"
#import "SOMeal.h"
#import "AFNetworking.h"

typedef enum
{
    GET,
    PUT,
    POST,
    DELETE
}networkOperationType;

@implementation SONetworkingManager

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

#pragma mark - User operations

- (void)loginUser:(SOUser *)anUser onComplete:(void (^)(SOUser *user))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler
{
    NSDictionary *bodyParams = @{
                                 @"username" : anUser.userName,
                                 @"password" : anUser.password
                                 };
    
    [self networkRequestForUrlPath:@"usermanager" withOperationType:GET withParameters:bodyParams onComplete:^(NSDictionary *response)
    {
        SOUser *loggedInUser = [[SOUser alloc] initWithDictionary:response];
        aCompletionHandler(loggedInUser);
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
}

- (void)registerUser:(SOUser *)anUser onComplete:(void (^)(SOUser *user))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler
{
    NSDictionary *bodyParams = @{
                                 @"username" : anUser.userName,
                                 @"password" : anUser.password
                                 };
    
    [self networkRequestForUrlPath:@"usermanager" withOperationType:POST withParameters:bodyParams onComplete:^(NSDictionary *response)
    {
        SOUser *newUser = [[SOUser alloc] initWithDictionary:response];
        aCompletionHandler(newUser);
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
}

#pragma mark - Event operations

- (void)downloadEventsOnComplete:(void (^)(NSArray *))aCompletionHandler onError:(void (^)(NSError *))anErrorHandler
{
    [self networkRequestForUrlPath:@"eventmanager" withOperationType:GET withParameters:nil onComplete:^(NSDictionary *response)
    {
        NSMutableArray *tempArray = [NSMutableArray array];
        id eventData = response;
        
        dispatch_group_t group = dispatch_group_create();
        
        [NSJSONSerialization parseObjectInArray:eventData executeOnEachItem:^(id item)
        {
            SOEvent *event = [[SOEvent alloc] initWithDictionary:item];
            
            if (event)
            {
                [tempArray addObject:event];
            }
            
        }
        onError:^(NSError *error)
        {
            anErrorHandler(error);
        }];
        
        for (SOEvent *event in tempArray)
        {
            dispatch_group_enter(group);
            [self imageRequestForUrlPath:@"locationimageservice" withParameters:@{@"identifier" : event.identifier} onComplete:^(UIImage *response)
            {
                event.location.locationImage = response;
                dispatch_group_leave(group);
            }
            onError:^(NSError *error)
            {
                dispatch_group_leave(group);
            }];
        }
        
        for (SOEvent *event in tempArray)
        {
            dispatch_group_enter(group);
            [self imageRequestForUrlPath:@"eventimageservice" withParameters:@{@"identifier" : event.identifier} onComplete:^(UIImage *response)
            {
                event.eventImage = response;
                dispatch_group_leave(group);
            }
            onError:^(NSError *error)
            {
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^
        {
            BOOL eventsAreValid = tempArray != nil;
            if (eventsAreValid)
            {
                aCompletionHandler(tempArray);
            }
            else
            {
                NSError *error = [NSError errorWithDomain:@"Nem sikerült az elemek letöltése" code:0 userInfo:nil];
                anErrorHandler(error);
            }
        });
        
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
}

- (void)sendOrderForEvent:(SOEvent *)anEvent forUser:(SOUser *)anUser onComplete:(void (^)(SOEvent *event))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler
{
    id selectedTableId = anEvent.selectedTable.identifier ? anEvent.selectedTable.identifier : [NSNull null];
    NSDictionary *bodyParams = @{
                                 @"event" : anEvent.identifier,
                                 @"user" : anUser.identifier,
                                 @"amount" : @(anEvent.numberOfTicketsOrdered),
                                 @"table" : selectedTableId
                                 };
    [self networkRequestForUrlPath:@"eventmanager" withOperationType:PUT withParameters:bodyParams onComplete:^(NSDictionary *response)
    {
        SOEvent *orderedEvent = [[SOEvent alloc] initWithDictionary:response];
        aCompletionHandler(orderedEvent);
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
}

- (void)deleteEventOrder:(SOEvent *)anEvent forUser:(SOUser *)anUser onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler
{
    NSDictionary *bodyParams = @{
                                 @"event" : anEvent.identifier,
                                 @"user" : anUser.identifier
                                 };
    [self networkRequestForUrlPath:@"eventmanager" withOperationType:DELETE withParameters:bodyParams onComplete:^(NSDictionary *response)
    {
        aCompletionHandler();
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
}

- (void)downloadQRCodeForEvent:(SOEvent *)anEvent andUser:(SOUser *)anUser onComplete:(void (^)(UIImage *image))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler
{
    NSString *userString = [NSString stringWithFormat:@"Felhasználó azonosító: %@", anUser.identifier];
    NSString *paramString = [userString stringByAppendingString:[NSString stringWithFormat:@"\nElőadás: %@", anEvent.eventTitle]];
    NSString *urlPath = @"http://zxing.org/w/chart";
    NSDictionary *urlParams = @{
                                @"cht" : @"qr",
                                @"chs" : @"300x300",
                                @"chld" : @"M",
                                @"choe" : @"UTF-8",
                                @"chl" : paramString
                                };
    [self imageRequestForUrlPath:urlPath withParameters:urlParams onComplete:^(UIImage *response)
    {
        aCompletionHandler(response);
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
}

#pragma mark - Meal operations

- (void)downloadMealsOnComplete:(void (^)(NSArray *menu))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler
{
    [self networkRequestForUrlPath:@"mealmanager" withOperationType:GET withParameters:nil onComplete:^(NSDictionary *response)
    {
        NSMutableArray *tempArray = [NSMutableArray array];
        id mealData = response;
        
        dispatch_group_t group = dispatch_group_create();
        
        [NSJSONSerialization parseObjectInArray:mealData executeOnEachItem:^(id item)
        {
            SOMeal *meal = [[SOMeal alloc] initWithDictionary:item];
            if (item[@"image"])
            {
                dispatch_group_enter(group);
                [self imageRequestForUrlPath:@"mealimageservice" withParameters:@{@"identifier" : meal.identifier} onComplete:^(UIImage *response)
                {
                    meal.mealImage = response;
                    dispatch_group_leave(group);
                }
                onError:^(NSError *error)
                {
                    NSLog(@"Error while downloading images: %@", error);
                    dispatch_group_leave(group);
                }];
            }
            if (meal)
            {
                [tempArray addObject:meal];
            }
        }
        onError:^(NSError *error)
        {
            anErrorHandler(error);
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^
        {
            BOOL mealsAreValid = tempArray != nil;
            if (mealsAreValid) aCompletionHandler(tempArray);
            else
            {
                NSError *error = [NSError errorWithDomain:@"Nem sikerült az elemek letöltése" code:0 userInfo:nil];
                anErrorHandler(error);
            }
        });
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
}

- (void)orderMeals:(NSArray *)aMeals forUser:(SOUser *)anUser onComplete:(void (^)(NSArray *order))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler
{
    NSMutableArray *meals = [NSMutableArray array];
    for (SOMeal *meal in aMeals)
    {
        [meals addObject:[meal dictionaryForJSON]];
    }
    
    NSDictionary *bodyParams = @{
                                 @"user": anUser.identifier,
                                 @"meals" : meals
                                 };
    
    [self networkRequestForUrlPath:@"mealmanager" withOperationType:PUT withParameters:bodyParams onComplete:^(NSDictionary *response)
    {
        NSMutableArray *tempDict = [NSMutableArray array];
        id mealData = response[@"orderedMeals"];
        [NSJSONSerialization parseObjectInArray:mealData executeOnEachItem:^(id item)
        {
            SOMeal *meal = [[SOMeal alloc] initWithDictionary:item];
            if (meal)
            {
                [tempDict addObject:meal];
            }
        }
        onError:^(NSError *error)
        {
            anErrorHandler(error);
        }];
        
        aCompletionHandler(tempDict);
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
}

- (void)payForMeals:(NSArray *)aMeals withTip:(NSInteger)aTip forUser:(SOUser *)anUser onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *))anErrorHandler
{
    NSMutableArray *meals = [NSMutableArray array];
    for (SOMeal *meal in aMeals)
    {
        [meals addObject:[meal dictionaryForJSON]];
    }
    
    NSDictionary *bodyParams = @{
                                 @"user" : anUser.identifier,
                                 @"tip" : @(aTip)
                                 };
    
    [self networkRequestForUrlPath:@"mealpaymentmanager" withOperationType:DELETE withParameters:bodyParams onComplete:^(NSDictionary *response)
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
    NSMutableArray *meals = [NSMutableArray array];
    for (SOMeal *meal in aMeals)
    {
        [meals addObject:[meal dictionaryForJSON]];
    }
    
    NSDictionary *bodyParams = @{
                                 @"meals" : meals
                                 };
    [self networkRequestForUrlPath:@"mealratingmanager" withOperationType:PUT withParameters:bodyParams onComplete:^(NSDictionary *response)
    {
        aCompletionHandler();
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
}

#pragma mark - Netrwork operation

- (NSString *)serverUrl
{
    return @"http://verdant-upgrade-554.appspot.com/soservices";
//    return @"http://localhost:8080/soservices";
}

- (void)networkRequestForUrlPath:(NSString *)anUrlPath withOperationType:(networkOperationType )anOperationType withParameters:(NSDictionary *)aParameters onComplete:(void (^)(NSDictionary *response))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", [self serverUrl], anUrlPath];
    
    AFHTTPRequestOperationManager *requestManager = [[AFHTTPRequestOperationManager alloc] init];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestManager.responseSerializer.acceptableContentTypes = [requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    requestManager.requestSerializer = requestSerializer;
    
    switch (anOperationType)
    {
        case GET:
        {
            [requestManager GET:urlString parameters:aParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"%@", responseObject);
                aCompletionHandler(responseObject);
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"error: %@", error);
                anErrorHandler(error);
            }];
            break;
        }
        case PUT:
        {
            [requestManager PUT:urlString parameters:aParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"%@", responseObject);
                aCompletionHandler(responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error: %@", error);
                anErrorHandler(error);
            }];
        }
        case POST:
        {
            [requestManager POST:urlString parameters:aParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"%@", responseObject);
                aCompletionHandler(responseObject);
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"error: %@", error);
                anErrorHandler(error);
            }];
            break;
        }
        case DELETE:
        {
            [requestManager DELETE:urlString parameters:aParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"%@", responseObject);
                aCompletionHandler(responseObject);
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"error: %@", error);
                anErrorHandler(error);
            }];
        }
        default:
            break;
    }
}

- (void)imageRequestForUrlPath:(NSString *)anUrlPath withParameters:(NSDictionary *)aParameters onComplete:(void (^)(UIImage *response))aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler
{
    AFHTTPRequestOperationManager *requestManager = [[AFHTTPRequestOperationManager alloc] init];
    AFImageResponseSerializer *responseSerializer = [AFImageResponseSerializer serializer];
    requestManager.responseSerializer = responseSerializer;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", [self serverUrl], anUrlPath];
    
    [requestManager GET:urlString parameters:aParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        aCompletionHandler(responseObject);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        anErrorHandler(error);
    }];
}

@end
