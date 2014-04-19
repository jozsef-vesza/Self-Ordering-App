//
//  SONetworkingTests.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 03/04/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SONetworkingManager.h"
#import "SOEvent.h"

@interface SONetworkingTests : XCTestCase

@property (nonatomic,strong) SONetworkingManager *networkingManager;
@property (nonatomic,strong) SOUser *unregisteredUser;
@property (nonatomic,strong) SOUser *registeredUser;
@property (nonatomic,strong) SOEvent *testEvent;
@property (nonatomic,strong) SOEvent *eventToDelete;

@end

@implementation SONetworkingTests

- (void)setUp
{
    [super setUp];
    self.networkingManager = [SONetworkingManager sharedInstance];
    
    // Dummy user setup
    NSString *randomUserName = [NSString stringWithFormat:@"user%d%d", arc4random_uniform(100) + 1, arc4random_uniform(1000) + 1];
    self.unregisteredUser = [SOUser userWithFirstName:@"FirstName" lastName:@"LastName" emailAddress:@"eMail" userName:randomUserName password:@"password"];
    self.registeredUser = [SOUser userWithFirstName:nil lastName:nil emailAddress:nil userName:@"test" password:@"test"];
    self.registeredUser.identifier = @(5946158883012608);
    
    // Dummy event setup
    self.testEvent = [[SOEvent alloc] init];
    self.testEvent.numberOfTicketsOrdered =  1 + arc4random_uniform(10);
    self.testEvent.identifier = @(4644337115725824);
    
    self.eventToDelete = [[SOEvent alloc] init];
    self.eventToDelete.identifier = @(2512269859817004635);
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testUserRegistration
{
    [self.networkingManager registerUser:self.unregisteredUser onComplete:^(SOUser *user)
    {
        XCTAssertNotNil(user, @"User registration failed");
        XCTAssertEqual(user.userName, self.unregisteredUser.userName, @"Usernames should be equal");
    }
    onError:^(NSError *error)
    {
        XCTAssertNotNil(error, @"There should be an error");
        NSLog(@"Error: %@", error);
    }];
}

- (void)testUserLogin
{
    [self.networkingManager loginUser:self.registeredUser onComplete:^(SOUser *user)
    {
        XCTAssertNotNil(user, @"User login failed");
        XCTAssertEqual(user.userName, self.registeredUser.userName, @"Usernames should be equal");
    }
    onError:^(NSError *error)
    {
        XCTAssertNotNil(error, @"There should be an error");
        NSLog(@"Error: %@", error);
    }];
}

- (void)testEventList
{
    [self.networkingManager downloadEventsOnComplete:^(NSArray *events)
    {
        XCTAssertNotNil(events, @"Event download failed");
        XCTAssertNotEqual(events.count, 0, @"No events downloaded");
    }
    onError:^(NSError *error)
    {
        XCTAssertNotNil(error, @"There should be an error");
        NSLog(@"Error: %@", error);
    }];
}

- (void)testEventOrder
{
    [self.networkingManager sendOrderForEvent:self.testEvent forUser:self.registeredUser onComplete:^(SOEvent *event)
    {
        XCTAssertNotNil(event, @"Event order failed");
        self.eventToDelete = event;
    }
    onError:^(NSError *error)
    {
        XCTAssertNotNil(error, @"There should be an error");
        NSLog(@"Error: %@", error);
    }];
}

- (void)testEventDeletion
{
    [self.networkingManager deleteEventOrder:self.eventToDelete forUser:self.registeredUser onComplete:^
    {
        NSPredicate *itemPredicate = [NSPredicate predicateWithFormat:@"eventTitle == %@", self.eventToDelete.eventTitle];
        NSArray *deletedEvent = [self.registeredUser.eventOrders filteredArrayUsingPredicate:itemPredicate];
        XCTAssertEqual([deletedEvent count], 0, @"Array cannot contain given item");
    }
    onError:^(NSError *error)
    {
        XCTAssertNotNil(error, @"There should be an error");
        NSLog(@"Error: %@", error);
    }];
}

- (void)testEventDownload
{
    [self.networkingManager downloadQRCodeForEvent:self.testEvent andUser:self.registeredUser onComplete:^(UIImage *image)
    {
        XCTAssertNotNil(image, @"QR Download failed");
    }
    onError:^(NSError *error)
    {
        XCTAssertNotNil(error, @"There should be an error");
        NSLog(@"Error: %@", error);
    }];
}

@end
