//
//  SORegularEventTableViewCell.h
//  Self-Ordering App
//
//  Created by Jozsef Vesza on 10/10/13.
//  Copyright (c) 2013 Jozsef Vesza. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Custom Table View Cell to populate the list of events */
@interface SORegularEventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
