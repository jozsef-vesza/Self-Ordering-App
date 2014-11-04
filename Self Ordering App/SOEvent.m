//
//  SOEvent.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 01/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOEvent.h"

@implementation SOEvent

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary
{
    self = [super init];
    if (self)
    {
        _eventTitle = aDictionary[@"eventTitle"];
        _eventDate = [self parseDate:aDictionary[@"eventDate"]];
        _ticketsLeft = [aDictionary[@"ticketsLeft"] integerValue];
        NSDictionary *descriptionDict = aDictionary[@"eventDescription"];
        _eventDescription = descriptionDict[@"value"];
        _ticketPrice = [aDictionary[@"ticketPrice"] integerValue];
        _location = [self parseLocationFromResponse:aDictionary[@"location"]];
        _eventDuration = [aDictionary[@"eventDuration"] integerValue];
        _priority = [aDictionary[@"priority"] integerValue];
        NSNumber *idNum = aDictionary[@"identifier"];
        _identifier = idNum ? idNum : nil;
        _isPaid = [aDictionary[@"isPaid"] boolValue];
        _numberOfTicketsOrdered = [aDictionary[@"ticketsPurchased"] integerValue];
        _selectedTable = [self parseSelectedTableFromResponse:aDictionary[@"selectedTable"]];
    }
    
    return self;
}

- (instancetype)initWithEvent:(SOEvent *)anEvent
{
    self = [super init];
    if (self)
    {
        _eventTitle = anEvent.eventTitle;
        _eventDate = anEvent.eventDate;
        _ticketsLeft = anEvent.ticketsLeft;
        _eventDescription = anEvent.eventDescription;
        _ticketPrice = anEvent.ticketPrice;
        _location = anEvent.location;
        _priority = anEvent.priority;
        _identifier = anEvent.identifier;
        _isPaid = anEvent.isPaid;
        _selectedTable = anEvent.selectedTable;
    }
    return self;
}

+ (instancetype)eventWithEvent:(SOEvent *)anEvent
{
    SOEvent *event = [[SOEvent alloc] initWithEvent:anEvent];
    return event;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.eventTitle = [aDecoder decodeObjectForKey:@"eventTitle"];
        self.eventDate = [aDecoder decodeObjectForKey:@"eventDate"];
        self.ticketsLeft = [aDecoder decodeIntegerForKey:@"ticketsLeft"];
        self.eventDescription = [aDecoder decodeObjectForKey:@"description"];
        self.ticketPrice = [aDecoder decodeIntegerForKey:@"price"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.eventDuration = [aDecoder decodeIntegerForKey:@"eventDuration"];
        self.priority = [aDecoder decodeIntegerForKey:@"priority"];
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.isPaid = [aDecoder decodeBoolForKey:@"isPaid"];
        self.selectedTable = [aDecoder decodeObjectForKey:@"selectedTable"];
        self.eventImage = [aDecoder decodeObjectForKey:@"eventImage"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.eventTitle forKey:@"eventTitle"];
    [aCoder encodeObject:self.eventDate forKey:@"eventDate"];
    [aCoder encodeInteger:self.ticketsLeft forKey:@"ticketsLeft"];
    [aCoder encodeObject:self.eventDescription forKey:@"description"];
    [aCoder encodeInteger:self.ticketPrice forKey:@"price"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeInteger:self.eventDuration forKey:@"eventDuration"];
    [aCoder encodeInteger:self.priority forKey:@"priority"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeBool:self.isPaid forKey:@"isPaid"];
    [aCoder encodeObject:self.selectedTable forKey:@"selectedTable"];
    [aCoder encodeObject:self.eventImage forKey:@"eventImage"];
}

- (NSDate *)parseDate:(NSString *)aString
{
    NSDate *parsedDate = [[NSDate alloc] init];
    
    NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
    inFormat.dateFormat = @"MMM dd, yyyy hh:mm:ss a";
    parsedDate = [inFormat dateFromString:aString];
    
    return parsedDate;
}

- (NSString *)prettyDate
{
    NSDateFormatter *outFormat = [[NSDateFormatter alloc] init];
    outFormat.dateFormat = @"YYYY.MM.dd. HH:mm";
    NSString *prettyString = [outFormat stringFromDate:self.eventDate];
    return prettyString;
}

- (SOLocation *)parseLocationFromResponse:(id)aResponse
{
    return [[SOLocation alloc] initWithDictionary:aResponse];
}

- (SOTable *)parseSelectedTableFromResponse:(id)aResponse
{
    return [[SOTable alloc] initWithDictionary:aResponse];
}

@end
