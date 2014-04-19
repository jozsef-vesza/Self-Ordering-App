//
//  SOTempOrderCell+StepperNotifications.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 25/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOTempOrderCell+StepperNotifications.h"

@implementation SOTempOrderCell (StepperNotifications)

- (IBAction)tempAmountChanged:(UIStepper *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:tempStepperChangedNotification object:self];
}

@end
