//
//  SOTempOrderCell.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 25/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOTempOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mealNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mealPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *mealAmountField;
@property (weak, nonatomic) IBOutlet UIStepper *mealAmountStepper;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end
