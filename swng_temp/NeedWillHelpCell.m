//
//  NeedWillHelpCell.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/9/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "NeedWillHelpCell.h"

@implementation NeedWillHelpCell

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

- (IBAction)switchedEventType:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch (selectedSegment) {
        case TASK_NEED_HELP:
            NSLog(@"Need help");
            _needWillHelpString = @"needHelp";
            break;
        case TASK_WILL_HELP:
            NSLog(@"Will help");
            _needWillHelpString = @"willHelp";
            break;
    }
}

@end
