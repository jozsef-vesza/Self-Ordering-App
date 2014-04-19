//
//  SOTable.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 06/04/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOTable : NSObject<NSCoding>

@property (nonatomic) NSNumber *identifier;
@property (nonatomic) double xPoint;
@property (nonatomic) double yPoint;
@property (nonatomic) NSInteger numberOfSeats;
@property (nonatomic) BOOL free;

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

@end
