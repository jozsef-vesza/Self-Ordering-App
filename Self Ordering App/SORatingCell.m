//
//  SORatingCell.m
//  Self Ordering App
//
//  Created by Jozsef Vesza on 30/03/14.
//  Copyright (c) 2014 Jozsef Vesza. All rights reserved.
//

#import "SORatingCell.h"

@implementation SORatingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
