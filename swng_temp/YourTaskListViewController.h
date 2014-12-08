//
//  YourTaskListViewController.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 3/8/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SimpleTaskCell.h"
#import "TaskController.h"
#import "TaskListAppDelegate.h"
#import "ReviewRequestViewController.h"

#define TASK_DELETE 0
#define TASK_REQUEST 1
#define TASK_COMPLETE 2

@interface YourTaskListViewController : PFQueryTableViewController
@property (strong, nonatomic) NSString *currentTaskID;
@property (strong, nonatomic) NSString *potentialUserID;
@property (strong, nonatomic) NSString *newtip;
@property (strong, nonatomic) PFUser *potentialUser;
@property BOOL currentTaskAccepted;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) UILabel *activityLabel;
@property (strong,nonatomic) PFQuery *yourTaskListQuery;

@end
