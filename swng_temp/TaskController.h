//
//  TaskDetailsController.h
//  HelpHub
//
//  Created by George Georgaklis on 3/1/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "DetailsLabelCell.h"
#import "TaskDetailsViewController.h"
#import "ProfileViewController.h"
#import "SubmitCell.h"
#import "TwoButtonCell.h"
#import "DetailsMessageSwitcherCell.h"
#import "LabelTableViewCell.h"
#import "TaskListAppDelegate.h"
#import "ReviewTableViewController.h"
#import "ReviewRequestViewController.h"
#import "ChatViewController.h"
#import "NegotiateViewController.h"
#import "MapViewController.h"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define TASK_DELETE 0
#define TASK_REQUEST 1
#define TASK_CLOSED 2

#define TASK_DETAILS 0
#define TASK_MESSAGES 1

#define LEFT_BUTTON_TAG 0
#define RIGHT_BUTTON_TAG 1

@interface TaskController : UITableViewController <UIAlertViewDelegate>//PFQueryTableViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *headerSegmentedControl;

@property (strong, nonatomic) NSString *taskID;
@property (strong, nonatomic) PFObject *currentTask;
@property (strong, nonatomic) PFUser *posterUser;
@property (strong, nonatomic) PFUser *acceptorUser;

@property (strong, nonatomic) PFUser *potentialUser;

@property (strong, nonatomic) NSString *userText;
@property (strong, nonatomic) NSString *categoryText;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSString *costText;
@property (strong, nonatomic) NSString *tipText;
@property (strong, nonatomic) NSString *locationText;
@property (strong, nonatomic) NSString *startTimeText;
@property (strong, nonatomic) NSString *endTimeText;
@property (strong, nonatomic) NSString *detailsText;
@property (strong, nonatomic) NSString *needWillHelpText;
@property (strong, nonatomic) NSString *headerTitle;

@property (strong, nonatomic) CLLocation *locationCoord;
@property (strong, nonatomic) NSMutableArray *locationArray;
@property (strong, nonatomic) NSMutableArray *taskIDArray;

@property (strong, nonatomic) SubmitCell *submitButtonCell;
@property (strong ,nonatomic) TwoButtonCell *twoButtonCell;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;

@property NSInteger taskDisplayButtonType;
@property NSInteger detailsOrMessage;
@property bool requireHeader;
@property bool alreadyAccepted;
@property bool fromYourTasksPage;
@property bool shouldShowCells;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) UILabel *activityLabel;


@end
