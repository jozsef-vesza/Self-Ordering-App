//
//  SOEventOrderDataSource.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 20/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "JVTableViewDataSource.h"

/**
 *  JVTableViewDataSource sublclass with support for event specific operations
 */
@interface SOEventOrderDataSource : JVTableViewDataSource

/**
 *  Array to hold the unpaid orders
 */
@property (nonatomic, copy) NSArray *unpaidArray;

/**
 *  Array to hold the paid orders
 */
@property (nonatomic, copy) NSArray *paidArray;

/**
 *  Custom initializer method to support separation between paid/unpaid items
 *
 *  @param aPaidItems    array of paid events
 *  @param anUnpaidItems array of unpaid events
 *
 *  @return an initialized instance of SOEventOrderDataSource
 */
- (instancetype)initWithPaidItems:(NSArray *)aPaidItems unpaidItems:(NSArray *)anUnpaidItems;

@end
