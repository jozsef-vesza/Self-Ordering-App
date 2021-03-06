//
//  SOSimpleMealCell.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 23/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOSimpleMealCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mealNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mealPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *mealAmountField;

@end
