//
//  JVTableViewDataSource.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 28/02/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Delegate protocol for configuring table view cells
 */
@protocol JVCellConfiguratorDelegate <NSObject>

/**
 *  Configure the current cell using an object
 *
 *  @param aCell       the cell in current row
 *  @param anObject    the object to use
 *  @param anIndexPath the indexpath of cell
 *
 *  @return a configured table view cell
 */
- (UITableViewCell *)configureCell:(UITableViewCell *)aCell usingObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath;
@optional

/**
 *  Get the reuse identifier for the current table view cell
 *
 *  @param anObject the cell in current row
 *
 *  @return the reuse identifier for cell
 */
- (NSString *)fetchCellIdentifierForObject:(id)anObject;

/**
 *  Calculate the height for a table view cell
 *
 *  @param aCell the cell in current row
 *
 *  @return the height for the cell
 */
- (CGFloat)fetchHeightForCell:(UITableViewCell *)aCell;

@end

/**
 *  Encapsulates common methods of table view datasource and cell configuration 
 */
@interface JVTableViewDataSource : NSObject<UITableViewDataSource>

/**
 *  The array of items to populate the table view
 */
@property (copy,nonatomic) NSArray *items;

/**
 *  The delegate for cell configuration
 */
@property (strong,nonatomic) id<JVCellConfiguratorDelegate> cellConfiguratorDelegate;

/**
 *  Custom initializer with an array of items
 *
 *  @param items array to serve as data source
 *
 *  @return an initialized instance of JVTableViewDataSource
 */
- (instancetype)initWithItems:(NSArray *)items;

@end
