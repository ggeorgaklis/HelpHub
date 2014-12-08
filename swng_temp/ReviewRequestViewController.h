//
//  ReviewRequestViewController.h
//  HelpHub
//
//  Created by George Georgaklis on 3/30/14.
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

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define LEFT_BUTTON_TAG 0
#define RIGHT_BUTTON_TAG 1

@interface ReviewRequestViewController : UITableViewController

@property (strong, nonatomic) NSString *taskID;
@property (strong, nonatomic) PFUser *potentialUser;

@property (strong, nonatomic) PFObject *currentTask;
@property (strong, nonatomic) NSString *categoryText;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSString *costText;
@property (strong, nonatomic) NSString *tipText;
@property (strong, nonatomic) NSString *locationText;
@property (strong, nonatomic) NSString *startTimeText;
@property (strong, nonatomic) NSString *endTimeText;
@property (strong, nonatomic) NSString *detailsText;
@property (strong, nonatomic) NSString *needWillHelpText;
@property (strong, nonatomic) NSString *newtip;

@property (strong ,nonatomic) TwoButtonCell *twoButtonCell;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) UILabel *activityLabel;

@end
