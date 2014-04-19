//
//  SOSimpleCellConfigurator.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 18/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVTableViewDataSource.h"

/**
 *  Responsible for configuring a table view cell defined in separate .xib file
 */
@interface SOSimpleCellConfigurator : NSObject<JVCellConfiguratorDelegate>

@end
