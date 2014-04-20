//
//  SODrinkTVCell+StepperNotifications.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 20/04/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SODrinkTVCell+StepperNotifications.h"

@implementation SODrinkTVCell (StepperNotifications)

- (IBAction)valueChanged:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:menuStepperChangedNotification object:self];
}

@end
