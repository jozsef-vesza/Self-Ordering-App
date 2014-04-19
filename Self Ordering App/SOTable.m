//
//  SOTable.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 06/04/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOTable.h"

@implementation SOTable

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary
{
    self = [super init];
    if (self)
    {
        _identifier = aDictionary[@"identifier"];
        _xPoint = [aDictionary[@"xPoint"] doubleValue];
        _yPoint = [aDictionary[@"yPoint"] doubleValue];
        _numberOfSeats = [aDictionary[@"numberOfSeats"] integerValue];
        _free = [aDictionary[@"free"] boolValue];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _identifier = [aDecoder decodeObjectForKey:@"identifier"];
        _xPoint = [aDecoder decodeDoubleForKey:@"xPoint"];
        _yPoint = [aDecoder decodeDoubleForKey:@"yPoint"];
        _numberOfSeats = [aDecoder decodeIntegerForKey:@"numberOfSeats"];
        _free = [aDecoder decodeBoolForKey:@"free"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeDouble:self.xPoint forKey:@"xPoint"];
    [aCoder encodeDouble:self.yPoint forKey:@"yPoint"];
    [aCoder encodeInteger:self.numberOfSeats forKey:@"numberOfSeats"];
    [aCoder encodeBool:self.free forKey:@"free"];
}

@end
