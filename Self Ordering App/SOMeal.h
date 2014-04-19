//
//  SOMeal.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 23/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Representation of a meal
 */
@interface SOMeal : NSObject<NSCoding>

/**
 *  The unique identifier for the meal
 */
@property (nonatomic) NSNumber *identifier;

/**
 *  The type of the meal (e.g.: soup, dessert)
 */
@property (nonatomic,copy) NSString *mealCategory;

/**
 *  The short description of the meal
 */
@property (nonatomic,copy) NSString *mealDescription;

/**
 *  Name of the meal
 */
@property (nonatomic,copy) NSString *mealName;

/**
 *  Price of the meal
 */
@property (nonatomic) NSInteger mealPrice;

/**
 *  Average rating of the meal
 */
@property (nonatomic) float mealRating;

/**
 *  Total number of ratings
 */
@property (nonatomic) NSInteger totalRatings;

/**
 *  Number of portions ordered of the meal
 */
@property (nonatomic) NSInteger numberOfMealsOrdered;

@property (nonatomic,strong) UIImage *mealImage;

/**
 *  Custom initializer method using a dictionary
 *
 *  @param aDictionary dictionary containg the property values for the object
 *
 *  @return an initialized instance of SOMeal
 */
- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

+ (instancetype)mealWithMeal:(SOMeal *)aMeal;

- (NSDictionary *)dictionaryForJSON;

@end
