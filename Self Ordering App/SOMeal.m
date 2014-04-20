//
//  SOMeal.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 23/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOMeal.h"

@implementation SOMeal

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary
{
    self = [super init];
    if (self)
    {
        _mealName = aDictionary[@"name"];
        _mealDescription = aDictionary[@"description"];
        _mealPrice = [aDictionary[@"price"] integerValue];
        _mealRating = [aDictionary[@"rating"] floatValue];
        _totalRatings = [aDictionary[@"totalRatings"] integerValue];
        _mealCategory = aDictionary[@"category"];
        NSNumber *idNum = aDictionary[@"identifier"];
        _identifier = idNum ? idNum : nil;
        _numberOfMealsOrdered = [aDictionary[@"amount"] integerValue];
        _imageUrl = aDictionary[@"image"];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.mealName = [aDecoder decodeObjectForKey:@"name"];
        self.mealDescription = [aDecoder decodeObjectForKey:@"description"];
        self.mealPrice = [aDecoder decodeIntegerForKey:@"price"];
        self.mealRating = [aDecoder decodeFloatForKey:@"rating"];
        self.totalRatings = [aDecoder decodeIntegerForKey:@"totalRatings"];
        self.mealCategory = [aDecoder decodeObjectForKey:@"category"];
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.mealImage = [aDecoder decodeObjectForKey:@"image"];
    }
    
    return self;
}

- (instancetype)initWithMeal:(SOMeal *)aMeal
{
    self = [super init];
    if (self)
    {
        _mealName = aMeal.mealName;
        _mealDescription = aMeal.description;
        _mealPrice = aMeal.mealPrice;
        _mealRating = aMeal.mealRating;
        _totalRatings = aMeal.totalRatings;
        _mealCategory = aMeal.mealCategory;
        _identifier = aMeal.identifier;
    }
    return self;
}

+ (instancetype)mealWithMeal:(SOMeal *)aMeal
{
    SOMeal *meal = [[SOMeal alloc] initWithMeal:aMeal];
    return meal;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.mealName forKey:@"name"];
    [aCoder encodeObject:self.mealDescription forKey:@"description"];
    [aCoder encodeInteger:self.mealPrice forKey:@"price"];
    [aCoder encodeFloat:self.mealRating forKey:@"rating"];
    [aCoder encodeInteger:self.totalRatings forKey:@"totalRatings"];
    [aCoder encodeObject:self.mealCategory forKey:@"category"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.mealImage forKey:@"image"];
}

- (NSDictionary *)dictionaryForJSON
{
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    jsonDict[@"name"] = self.mealName;
    jsonDict[@"amount"] = @(self.numberOfMealsOrdered);
    jsonDict[@"rating"] = @(self.mealRating);
    return jsonDict;
}

@end
