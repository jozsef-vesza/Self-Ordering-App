//
//  NSArray+removeDuplicateOrders.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 20/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Helper category for array cleanup
 */
@interface NSArray (removeDuplicateOrders)

/**
 *  Merges duplicates in the user's cart
 *
 *  @param aClass  the type of object to merge
 *  @param anArray the array to be sorted
 *
 *  @return the merged array
 */
+ (instancetype)checkForDuplicatesForType:(Class)aClass inArray:(NSArray *)anArray;

@end
