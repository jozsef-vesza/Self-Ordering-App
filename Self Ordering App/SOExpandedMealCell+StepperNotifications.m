//
//  SOExpandedMealCell+StepperNotifications.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 25/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOExpandedMealCell+StepperNotifications.h"

@implementation SOExpandedMealCell (StepperNotifications)

- (IBAction)stepperValueChanged:(UIStepper *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:menuStepperChangedNotification object:self];
}



@end
