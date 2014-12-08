//
//  TwoButtonCell.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 3/10/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "TwoButtonCell.h"

@implementation TwoButtonCell

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
    _buttonLeft.layer.borderWidth = 1.0f;
    _buttonLeft.layer.borderColor = UIColorFromRGB(0x5FC9D3).CGColor;
    _buttonLeft.layer.cornerRadius = 4.0f;
    _buttonRight.layer.borderWidth = 1.0f;
    _buttonRight.layer.borderColor = UIColorFromRGB(0x5FC9D3).CGColor;
    _buttonRight.layer.cornerRadius = 4.0f;
}

@end
