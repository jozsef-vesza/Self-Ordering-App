//
//  SOLocation.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 06/04/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOLocation.h"
#import "SOTable.h"
#import "NSJSONSerialization+parseObjectArray.h"

@implementation SOLocation

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary
{
    self = [super init];
    if (self)
    {
        _identifier = aDictionary[@"identifier"];
        _name = aDictionary[@"name"];
        _tables = [self parseTablesFromResponse:aDictionary[@"tables"]];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _identifier = [aDecoder decodeObjectForKey:@"identifier"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _tables = [aDecoder decodeObjectForKey:@"tables"];
        _locationImage = [aDecoder decodeObjectForKey:@"locationImage"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.tables forKey:@"tables"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.locationImage forKey:@"locationImage"];
}

- (NSArray *)parseTablesFromResponse:(id)aResponse
{
    NSMutableArray *parsedItems = [NSMutableArray array];
    [NSJSONSerialization parseObjectInArray:aResponse executeOnEachItem:^(id item)
    {
        SOTable *table = [[SOTable alloc] initWithDictionary:item];
        if (table)
        {
            [parsedItems addObject:table];
        }
    }
    onError:^(NSError *error)
    {
        NSLog(@"Error while parsing tables: %@", error);
    }];
    
    return parsedItems;
}

@end
