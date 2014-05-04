//
//  SOTable.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 06/04/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOTable : NSObject<NSCoding>

/**
 *  Datastore identifier
 */
@property (nonatomic) NSNumber *identifier;

/**
 *  X-coordinate on location map
 */
@property (nonatomic) double xPoint;

/**
 *  Y-coordinate on location map
 */
@property (nonatomic) double yPoint;

/**
 *  Number of seats at the table
 */
@property (nonatomic) NSInteger numberOfSeats;

/**
 *  Reservation status indicator
 */
@property (nonatomic) BOOL free;

/**
 *  Custom initializer using a dictionary
 *
 *  @param aDictionary Dictionary containing table data
 *
 *  @return An initialized instance of SOTable
 */
- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

@end
