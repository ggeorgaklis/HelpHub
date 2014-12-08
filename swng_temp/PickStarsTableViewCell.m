//
//  PickStarsTableViewCell.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 4/7/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "PickStarsTableViewCell.h"

@implementation PickStarsTableViewCell

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
