//
//  SORateView.h
//  Self-Ordering App
//
//  Created by József Vesza on 02/12/13.
//  Copyright (c) 2013 Jozsef Vesza. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SORateView;

@protocol SORateViewDelegate

- (void)rateView:(SORateView *)rateView ratingDidChange:(float)rating;

@end

@interface SORateView : UIView

@property (nonatomic) UIImage *notSelectedImage;

@property (nonatomic) UIImage *halfSelectedImage;

@property (nonatomic) UIImage *fullSelectedImage;

@property (assign, nonatomic) float rating;

@property (assign) BOOL editable;

@property NSMutableArray * imageViews;

@property (assign, nonatomic) int maxRating;

@property (assign) int midMargin;

@property (assign) int leftMargin;

@property (assign) CGSize minImageSize;

@property (assign) id <SORateViewDelegate> delegate;

@property (nonatomic) NSInteger row;

@property (nonatomic) NSIndexPath *indexPath;

@end
