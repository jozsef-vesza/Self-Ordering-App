//
//  SOMenuDataSource.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 23/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "JVTableViewDataSource.h"
@class SOMeal;

@interface SOMenuDataSource : JVTableViewDataSource

@property (nonatomic) NSIndexPath *simpleIndexPath;
@property (nonatomic) NSIndexPath *expandedIndexPath;

- (NSIndexPath *)actualIndexPathForTappedIndexPath:(NSIndexPath *)anIndexPath;
- (SOMeal *)mealAtIndex:(NSIndexPath *)anIndexPath;
- (NSArray *)selectedItems;
- (void)clearSelections;
- (id)mealAtTappedIndex:(NSIndexPath *)anIndexPath;
@end
