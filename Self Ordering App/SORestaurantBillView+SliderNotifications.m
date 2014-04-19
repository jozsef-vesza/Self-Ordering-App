//
//  SORestaurantBillView+SliderNotifications.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 30/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SORestaurantBillView+SliderNotifications.h"

@implementation SORestaurantBillView (SliderNotifications)

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:tipSliderChangedNotification object:nil];
}

@end
