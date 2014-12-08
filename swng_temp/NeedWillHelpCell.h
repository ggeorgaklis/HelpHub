//
//  NeedWillHelpCell.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/9/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TASK_NEED_HELP 0
#define TASK_WILL_HELP 1

@interface NeedWillHelpCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UISegmentedControl *headerSegmentedControl;
@property (strong, nonatomic) NSString *needWillHelpString;
@end
