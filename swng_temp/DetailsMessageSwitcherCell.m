//
//  DetailsMessageSwitcherCell.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 3/12/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "DetailsMessageSwitcherCell.h"

@implementation DetailsMessageSwitcherCell

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

- (IBAction)switchTaskInfo:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch (selectedSegment) {
        case TASK_DETAILS:
            NSLog(@"Task Details");
            break;
        case TASK_MESSAGES:
            NSLog(@"Task Messages");
            break;
    }
}

@end
