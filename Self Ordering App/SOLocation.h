//
//  SOLocation.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 06/04/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOLocation : NSObject<NSCoding>

/**
 *  Datastore identifier
 */
@property (nonatomic) NSNumber *identifier;

/**
 *  Name of the location
 */
@property (nonatomic,copy) NSString *name;

/**
 *  Tables available at location
 */
@property (nonatomic,copy) NSArray *tables;

/**
 *  Layout image of the location
 */
@property (strong, nonatomic) UIImage *locationImage;

/**
 *  Custom initializer using dictionary
 *
 *  @param aDictionary A dictionary containing location data
 *
 *  @return An initialized SOLocation instance
 */
- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

@end
