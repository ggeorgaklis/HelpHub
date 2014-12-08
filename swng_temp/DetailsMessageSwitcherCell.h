//
//  DetailsMessageSwitcherCell.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 3/12/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TASK_DETAILS 0
#define TASK_MESSAGES 1

@interface DetailsMessageSwitcherCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UISegmentedControl *detailsMessageSegmentedControl;

@end
