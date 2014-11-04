//
//  SOEvent.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 01/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOLocation.h"
#import "SOTable.h"

/**
 *  Representation of an event
 */
@interface SOEvent : NSObject<NSCoding>

/**
 *  The title of the event
 */
@property (copy,nonatomic) NSString *eventTitle;

/**
 *  The date of the event
 */
@property (copy,nonatomic) NSDate *eventDate;

/** Duration of the event in minutes */
@property (nonatomic) NSInteger eventDuration;

/**
 *  Number of tickets available for purchase
 */
@property (nonatomic) NSInteger ticketsLeft;

/**
 *  Detailed description of the event
 */
@property (copy,nonatomic) NSString *eventDescription;

/**
 *  Price of tickets for the event
 */
@property (nonatomic) NSInteger ticketPrice;

/**
 *  Property to indicate purchase status
 */
@property (nonatomic) BOOL isPaid;

/**
 *  The priority of an event will determine its representation in the events list table view
 */
@property (nonatomic) NSInteger priority;

/**
 *  Unique identifier generated on server side
 */
@property (nonatomic) NSNumber *identifier;

/**
 *  Location of the event
 */
@property (strong,nonatomic) SOLocation *location;

@property (strong, nonatomic) UIImage *eventImage;

/**
 *  Number of tickets ordered by user
 */
@property (nonatomic) NSInteger numberOfTicketsOrdered;

@property (nonatomic,strong) SOTable *selectedTable;

/**
 *  Custom initializer method using a dictionary
 *
 *  @param aDictionary dictionary containg the property values for the object
 *
 *  @return an initialized instance of SOEvent
 */
- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

/**
 *  Method for formatting date into a human-readable style
 *
 *  @return the formatted date
 */
- (NSString *)prettyDate;

/**
 *  Convenience constructor using another event object
 *
 *  @param anEvent the event to help the configuration
 *
 *  @return the configured instance of this class
 */
+ (instancetype)eventWithEvent:(SOEvent *)anEvent;

@end
