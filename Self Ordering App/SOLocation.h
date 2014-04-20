//
//  SOLocation.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 06/04/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOLocation : NSObject<NSCoding>

@property (nonatomic) NSNumber *identifier;
@property (nonatomic,copy) NSString *name;
@property (nonatomic) double stageCenterX;
@property (nonatomic) double stageCenterY;
@property (nonatomic) double stageWidth;
@property (nonatomic) double stageHeight;
@property (nonatomic,copy) NSArray *tables;
@property (strong, nonatomic) UIImage *locationImage;

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

@end
