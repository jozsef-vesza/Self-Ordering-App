//
//  SORatingCell.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 30/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SORateView.h"

@interface SORatingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mealNameLabel;
@property (weak, nonatomic) IBOutlet SORateView *mealRateView;


@end
