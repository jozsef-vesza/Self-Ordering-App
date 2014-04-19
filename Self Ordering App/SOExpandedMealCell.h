//
//  SOExpandedMealCell.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 23/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SORateView.h"

@interface SOExpandedMealCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIStepper *mealAmountStepper;
@property (weak, nonatomic) IBOutlet UITextView *mealDescriptionText;
@property (weak, nonatomic) IBOutlet SORateView *mealRateView;
@property (nonatomic,strong) NSIndexPath *expandedPath;
@property (weak, nonatomic) IBOutlet UIImageView *mealImageView;

@end
