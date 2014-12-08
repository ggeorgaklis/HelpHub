//
//  TaskListViewController.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/23/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SimpleTaskCell.h"
#import "NeedWillHelpCell.h"
#import "TaskController.h"
#import "TaskListAppDelegate.h"
#import "ReviewRequestViewController.h"
#import "TaskMapViewController.h"

#define TASK_NEED_HELP 0
#define TASK_WILL_HELP 1

#define TASK_DELETE 0
#define TASK_REQUEST 1
#define TASK_COMPLETE 2

@interface TaskListViewController : PFQueryTableViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *headerSegmentedControl;
@property (strong, nonatomic) NSString *currentTaskID;
@property (strong, nonatomic) NSString *potentialUserID;
@property (strong, nonatomic) PFUser *potentialUser;
@property (strong, nonatomic) NSString *newtip;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) UILabel *activityLabel;
@property int timesLoaded;
@property int taskNeedOrWillHelp;

@property (strong, nonatomic) NSMutableArray *locationArray;
@property (strong, nonatomic) NSMutableArray *taskIDArray;


@end
 