//
//  SODrinkTVCell.h
//  Self Ordering App
//
//  Created by Jozsef Vesza on 20/04/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SORateView.h"
#import "SOExpandedMealCell.h"

@interface SODrinkTVCell : SOExpandedMealCell
@property (weak, nonatomic) IBOutlet SORateView *rateView;
@property (weak, nonatomic) IBOutlet UIStepper *mealAmountStepper;

@end
