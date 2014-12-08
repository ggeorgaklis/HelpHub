//
//  SubmitCell.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/15/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "SubmitCell.h"

@implementation SubmitCell

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

- (void) awakeFromNib {
    _button.layer.borderWidth = 1.0f;
    _button.layer.borderColor = UIColorFromRGB(0x5FC9D3).CGColor;
    _button.layer.cornerRadius = 4.0f;
}

@end
