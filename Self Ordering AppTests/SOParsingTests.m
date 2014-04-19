//
//  SOParsingTests.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 03/04/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSJSONSerialization+parseObjectArray.h"
#import "SOEvent.h"
#import "SOMeal.h"

@interface SOParsingTests : XCTestCase

@property (nonatomic,strong) NSData *userFileData;
@property (nonatomic,strong) NSData *eventFileData;
@property (nonatomic,strong) NSData *mealFileData;

@end

@implementation SOParsingTests

- (void)setUp
{
    [super setUp];
    
    // User data setup from bundle
    NSString *userFileLocation = [[NSBundle mainBundle] pathForResource:@"mockUser" ofType:@"json"];
    XCTAssertNotNil(userFileLocation, @"User test file not found");
    self.userFileData = [NSData dataWithContentsOfFile:userFileLocation];
    XCTAssertNotNil(self.userFileData, @"User test data not created");
    
    // Event data setup from bundle
    NSString *eventFileLocation = [[NSBundle mainBundle] pathForResource:@"mockEvents" ofType:@"json"];
    XCTAssertNotNil(eventFileLocation, @"Event test file not found");
    self.eventFileData = [NSData dataWithContentsOfFile:eventFileLocation];
    XCTAssertNotNil(self.eventFileData, @"Event test data not created");
    
    // Meal data setup from bundle
    NSString *mealFileLocation = [[NSBundle mainBundle] pathForResource:@"mockMeals" ofType:@"json"];
    XCTAssertNotNil(mealFileLocation, @"Meal test file not found");
    self.mealFileData = [NSData dataWithContentsOfFile:mealFileLocation];
    XCTAssertNotNil(self.mealFileData, @"Meal test data not created");
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testUserParsing
{
    NSError *error;
    NSDictionary *userJSON = [NSJSONSerialization JSONObjectWithData:self.userFileData options:kNilOptions error:&error];
    XCTAssertNil(error, @"Error while loading user JSON");
    SOUser *parsedUser = [[SOUser alloc] initWithDictionary:userJSON];
    XCTAssertNotNil(parsedUser, @"User parsing unsuccessful");
}

- (void)testEventParsing
{
    NSError *error;
    NSDictionary *eventJson = [NSJSONSerialization JSONObjectWithData:self.eventFileData options:kNilOptions error:&error];
    XCTAssertNil(error, @"Error while loading event JSON");
    [NSJSONSerialization parseObjectInArray:eventJson executeOnEachItem:^(id item)
    {
        SOEvent *parsedEvent = [[SOEvent alloc] initWithDictionary:item];
        XCTAssertNotNil(parsedEvent, @"Event parsing unsuccessful");
    }
    onError:^(NSError *error)
    {
        XCTAssertNotNil(error, @"There should be an error");
    }];
}

- (void)testMealParsing
{
    NSError *error;
    NSDictionary *mealJSON = [NSJSONSerialization JSONObjectWithData:self.mealFileData options:kNilOptions error:&error];
    XCTAssertNil(error, @"Error while loading meal JSON");
    [NSJSONSerialization parseObjectInArray:mealJSON executeOnEachItem:^(id item)
    {
        SOMeal *parsedMeal = [[SOMeal alloc] initWithDictionary:item];
        XCTAssertNotNil(parsedMeal, @"Meal parsing unsuccesful");
    }
    onError:^(NSError *error)
    {
        XCTAssertNotNil(error, @"There should be an error");
    }];
}

@end
