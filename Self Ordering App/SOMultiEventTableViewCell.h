//
//  SOMultiEventTableViewCell.h
//  Self-Ordering App
//
//  Created by Jozsef Vesza on 10/16/13.
//  Copyright (c) 2013 Jozsef Vesza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOMultiEventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *leftEventButton;
@property (weak, nonatomic) IBOutlet UIButton *rightEventButton;

@end
