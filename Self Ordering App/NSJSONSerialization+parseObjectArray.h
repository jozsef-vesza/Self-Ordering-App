//
//  NSJSONSerialization+parseObjectArray.h
//  Self-Ordering App
//
//  Created by Jozsef Vesza on 10/10/13.
//  Copyright (c) 2013 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Category to enhance JSON parsing by handling empty arrays
 */
@interface NSJSONSerialization (parseObjectArray)

/**
 *  Iterate through a given array with a block
 *
 *  @param array The array to check
 */
+ (void) parseObjectInArray:(id) array executeOnEachItem:(void (^)(id item)) completionBlock onError:(void (^)(NSError* error)) errorBlock;

@end
