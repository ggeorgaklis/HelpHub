//
//  MessageCell.m
//  HelpHub
//
//  Created by George Georgaklis on 4/15/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib{
    // Initialization code
    [_userLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
    [_timeLabel setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
