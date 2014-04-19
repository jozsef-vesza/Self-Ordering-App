//
//  SOCircleView.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 07/04/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SOCircleView.h"

@interface SOCircleView ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation SOCircleView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.path = [UIBezierPath bezierPathWithOvalInRect:self.frame];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return [self.path containsPoint:point];
}

@end
