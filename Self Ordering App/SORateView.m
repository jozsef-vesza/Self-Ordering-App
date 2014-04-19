//
//  SORateView.m
//  Self-Ordering App
//
//  Created by József Vesza on 02/12/13.
//  Copyright (c) 2013 Jozsef Vesza. All rights reserved.
//

#import "SORateView.h"

@implementation SORateView

- (void)baseInit
{
    _notSelectedImage = nil;
    _halfSelectedImage = nil;
    _fullSelectedImage = nil;
    _rating = 0;
    _editable = NO;
    _imageViews = [[NSMutableArray alloc] init];
    _maxRating = 5;
    _midMargin = 5;
    _leftMargin = 0;
    _minImageSize = CGSizeMake(5, 5);
    _delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self baseInit];
    }
    return self;
}

- (void)refresh
{
    for(int i = 0; i < self.imageViews.count; ++i)
    {
        UIImageView *imageView = self.imageViews[i];
        if (self.rating >= i+1)
        {
            imageView.image = self.fullSelectedImage;
        }
        else if (self.rating > i)
        {
            imageView.image = self.halfSelectedImage;
        }
        else
        {
            imageView.image = self.notSelectedImage;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.notSelectedImage == nil)
        return;
    
    float desiredImageWidth = (self.frame.size.width - (self.leftMargin*2) - (self.midMargin*self.imageViews.count)) / self.imageViews.count;
    float imageWidth = MAX(self.minImageSize.width, desiredImageWidth);
    float imageHeight = MAX(self.minImageSize.height, self.frame.size.height);
    
    for (int i = 0; i < self.imageViews.count; ++i)
    {
        
        UIImageView *imageView = self.imageViews[i];
        CGRect imageFrame = CGRectMake(self.leftMargin + i*(self.midMargin+imageWidth), 0, imageWidth, imageHeight);
        imageView.frame = imageFrame;
        
    }    
    
}


- (void)setMaxRating:(int)maxRating
{
    _maxRating = maxRating;
    
    // Remove old image views
    for(int i = 0; i < self.imageViews.count; ++i)
    {
        UIImageView *imageView = (UIImageView *) self.imageViews[i];
        [imageView removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
    
    // Add new image views
    for(int i = 0; i < maxRating; ++i)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageViews addObject:imageView];
        [self addSubview:imageView];
    }
    
    // Relayout and refresh
    [self setNeedsLayout];
    [self refresh];
}

- (void)setNotSelectedImage:(UIImage *)image
{
    _notSelectedImage = image;
    [self refresh];
}

- (void)setHalfSelectedImage:(UIImage *)image
{
    _halfSelectedImage = image;
    [self refresh];
}

- (void)setFullSelectedImage:(UIImage *)image
{
    _fullSelectedImage = image;
    [self refresh];
}

- (void)setRating:(float)rating
{
    _rating = rating;
    [self refresh];
}

- (void)handleTouchAtLocation:(CGPoint)touchLocation
{
    if (!self.editable) return;
    
    int newRating = 0;
    for(int i = self.imageViews.count - 1; i >= 0; i--)
    {
        UIImageView *imageView = self.imageViews[i];
        if (touchLocation.x > imageView.frame.origin.x)
        {
            newRating = i+1;
            break;
        }
    }
    
    self.rating = newRating;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //TODO: refactor trateview to use notifications
    [[NSNotificationCenter defaultCenter] postNotificationName:ratingChangedNotification object:self];
    [self.delegate rateView:self ratingDidChange:self.rating];
}

@end
