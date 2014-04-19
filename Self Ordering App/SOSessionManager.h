//
//  SOSessionManager.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 26/02/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOUser.h"

/**
 *  Class to encapsulate session operations
 */
@interface SOSessionManager : NSObject

/**
 *  Property to keep track of active user
 */
@property (nonatomic,strong) SOUser *activeUser;

/**
 *  A singleton object should be used for keeping track of he logged user during the full application lifecycle
 *
 *  @return A shared instance
 */
+ (instancetype)sharedInstance;

/**
 *  Register a new user with given attributes
 *
 *  @param aFirstName         First name of the user
 *  @param aLastName          Last name of the user
 *  @param anEmailAddress     E-mail address of the user
 *  @param anUserName         Username of the user
 *  @param aPassword          Password of the user
 *  @param aCompletionHandler Block to execute upon completion
 *  @param anErrorHandler     Block to execute in case of error
 */
- (void)registerUserWithFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName emailAddress:(NSString *)anEmailAddress userName:(NSString *)anUserName password:(NSString *)aPassword onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Perform a login with given credentials
 *
 *  @param anUserName         Username of the user
 *  @param aPassword          Password of te user
 *  @param aCompletionHandler Block to execute upon completion
 *  @param anErrorHandler     Block to execute in case of error
 */
- (void)loginUserWithUserName:(NSString *)anUserName password:(NSString *)aPassword onComplete:(void (^)())aCompletionHandler onError:(void (^)(NSError *error))anErrorHandler;

/**
 *  Perform a logout action for currently active user
 *
 *  @param aCompletionHandler Block to execute upon completion
 */
- (void)logoutOnComplete:(void (^)())aCompletionHandler;

/**
 *  Method to save downloaded data
 *
 *  @param items Array of items to save
 *  @param path  Save path
 */
- (void)saveDownloadedItems:(NSArray *)items to:(NSString *)path;

/**
 *  Load the previously saved user data
 *
 *  @param path Load path
 *
 *  @return An array of loaded objects
 */
- (NSArray *)loadSavedItemsFromPath:(NSString *)path;

- (void)deleteSavedItemsFromPath:(NSString *)aPath;

/**
 *  Delete cached file when application terminates
 */
- (void)clearSessionCache;

- (void)saveUserData;

@end
