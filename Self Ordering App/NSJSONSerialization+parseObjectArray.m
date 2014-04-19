//
//  NSJSONSerialization+parseObjectArray.m
//  Self-Ordering App
//
//  Created by Jozsef Vesza on 10/10/13.
//  Copyright (c) 2013 Jozsef Vesza. All rights reserved.
//

#import "NSJSONSerialization+parseObjectArray.h"

@implementation NSJSONSerialization (parseObjectArray)

+ (void) parseObjectInArray:(id) array executeOnEachItem:(void (^)(id item)) completionBlock onError:(void (^)(NSError* error)) errorBlock
{
    if (array == nil)
    {
        return;
    }
    if ([array isKindOfClass:NSArray.class])
    {
        NSArray* documentsArray = array;
        for (NSDictionary* item in documentsArray)
        {
            completionBlock(item);
        }
    }
    else
    {
        completionBlock(array);
    }
}


@end
