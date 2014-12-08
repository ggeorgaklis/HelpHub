//
//  ReviewTableViewController.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 3/30/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DetailsLabelCell.h"
#import "SubmitCell.h"
#import "ExtraLongTextEntryCell.h"
#import "PickStarsTableViewCell.h"
#import "StarSliderTableViewCell.h"
#import "ExtraLongText4EntryCell.h"
#import "TaskListViewController.h"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@interface ReviewTableViewController : UITableViewController <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) NSString *navigationTitle;
@property (strong, nonatomic) PFUser *userToReview;
@property (strong, nonatomic) UIProgressView *starProgressView;
@property (strong, nonatomic) UITextView *entryTextView;
@property  float starPercentage;

@end
