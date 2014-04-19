//
//  SOSessionManager.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 26/02/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOSessionManager.h"
#import "SONetworkingManager.h"
#import "SOUser.h"

@interface SOSessionManager ()

@property (nonatomic,strong) SONetworkingManager *networkingManager;

@end

@implementation SOSessionManager

#pragma mark - Singleton function and setup

+ (id)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _networkingManager = [SONetworkingManager sharedInstance];
    }
    return self;
}

#pragma mark - User management

- (void)registerUserWithFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName emailAddress:(NSString *)anEmailAddress userName:(NSString *)anUserName password:(NSString *)aPassword onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;
{
    SOUser *newUser = [SOUser userWithFirstName:aFirstName lastName:aLastName emailAddress:anEmailAddress userName:anUserName password:aPassword];
    [self.networkingManager registerUser:newUser onComplete:^(SOUser *user)
    {
        self.activeUser = user;
        aCompletionHandler();
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
    
}

- (void)loginUserWithUserName:(NSString *)anUserName password:(NSString *)aPassword onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *))anErrorHandler
{
    SOUser *newUser = [SOUser userWithUserName:anUserName password:aPassword];

    [self.networkingManager loginUser:newUser onComplete:^(SOUser *user)
    {
        self.activeUser = user;
        aCompletionHandler();
    }
    onError:^(NSError *error)
    {
        anErrorHandler(error);
    }];
    
}

- (void)logoutOnComplete:(void (^)())aCompletionHandler;
{
    [self saveUserData];
    [self clearSessionCache];
    self.activeUser = nil;
    aCompletionHandler();
}

#pragma mark - Data management

//TODO: check cache!
- (void)saveDownloadedItems:(NSArray *)items to:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = paths[0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:path];
    
    [NSKeyedArchiver archiveRootObject:items toFile:filePath];
}

- (NSArray *)loadSavedItemsFromPath:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:path];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSArray *contents = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        if (contents)
        {
            return contents;
        }
    }
    
    return nil;
}

- (void)deleteSavedItemsFromPath:(NSString *)aPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:aPath];
    NSError *error;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
    if (error)
    {
        NSLog(@"Error while deleting from cache: %@",error);
    }
}

- (void)clearSessionCache
{
    [self deleteSavedItemsFromPath:eventsKeyPath];
    [self deleteSavedItemsFromPath:starterKey];
    [self deleteSavedItemsFromPath:soupKey];
    [self deleteSavedItemsFromPath:mainKey];
    [self deleteSavedItemsFromPath:dessertsKey];
    [self deleteSavedItemsFromPath:drinkKey];
    [self deleteSavedItemsFromPath:alcoholicKey];
}

- (void)saveUserData
{
    NSArray *orderedEvents = self.activeUser.eventOrders;
    BOOL activeUserHasUnpaidItems = [orderedEvents count] > 0;
    if (activeUserHasUnpaidItems)
    {
        [self saveDownloadedItems:orderedEvents to:userEventsKey];
    }
}

@end
