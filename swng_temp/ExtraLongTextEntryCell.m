//
//  ExtrLongTextEntryCell.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 3/30/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "ExtraLongTextEntryCell.h"

@implementation ExtraLongTextEntryCell

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
    // Initialization code
    [_entryTextView.layer setCornerRadius:8.0f];
    [_entryTextView setBackgroundColor:[UIColor whiteColor]];
    [_entryTextView.layer setBorderColor:UIColorFromRGB(0xE1E1E1).CGColor];
    [_entryTextView.layer setBorderWidth:.8];
}

@end
