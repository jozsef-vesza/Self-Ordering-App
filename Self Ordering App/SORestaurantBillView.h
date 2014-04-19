//
//  SORestaurantBillView.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 30/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SORestaurantBillView : UIView

@property (weak, nonatomic) IBOutlet UITableView *ordersTableView;
@property (weak, nonatomic) IBOutlet UISlider *tipSlider;
@property (weak, nonatomic) IBOutlet UILabel *tipPercentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalSumLabel;

@end
