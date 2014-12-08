//
//  SimpleTaskCell.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/9/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "SimpleTaskCell.h"

@implementation SimpleTaskCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
