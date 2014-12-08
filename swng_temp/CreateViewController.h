//
//  CreateViewController.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/24/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "NeedWillHelpCell.h"
#import "PickCategoryCell.h"
#import "PickCategoryTextCell.h"
#import "ShortTextEntryCell.h"
#import "PickDateCell.h"
#import "PickDateTextCell.h"
#import "LongTextEntryCell.h"
#import "SubmitCell.h"
#import "SearchMapViewController.h"
#import "TaskListAppDelegate.h"

#define TASK_NEED_HELP 0
#define TASK_WILL_HELP 1

@interface CreateViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>
@property (strong, nonatomic) NeedWillHelpCell *needWillHelpCell;
@property (strong, nonatomic) NSString *needWillHelpString;
@property (strong, nonatomic) PickCategoryTextCell *pickCategoryTextCell;
@property (strong, nonatomic) PickCategoryCell *pickCategoryCell;
@property (strong, nonatomic) UITextField *descriptionTextField;
@property (strong, nonatomic) UITextField *costTextField;
@property (strong, nonatomic) UITextField *tipTextField;
@property (strong, nonatomic) UITextField *locationTextField;
@property (strong, nonatomic) CLLocation *locationCoord;
@property (strong, nonatomic) PickDateTextCell *pickStartDateTextCell;
@property (strong, nonatomic) PickDateCell *pickStartDateCell;
@property (strong, nonatomic) PickDateTextCell *pickEndDateTextCell;
@property (strong, nonatomic) PickDateCell *pickEndDateCell;
@property (strong, nonatomic) UITextView *detailsTextView;
@property (strong, nonatomic) SubmitCell *submitButtonCell;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property BOOL categoryPickerIsShowing;
@property BOOL startDatePickerIsShowing;
@property BOOL endDatePickerIsShowing;
@property BOOL madeCells;
@property BOOL didAppear;
@property BOOL didSearch;
@end
