//
//  ProfileViewController.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 3/12/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "QuartzCore/QuartzCore.h"
#import "Review.h"
#import "ReviewTableViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *averageRatingLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *starProgressView;
@property (strong, nonatomic) IBOutlet UIView *starImageView;
@property (strong, nonatomic) IBOutlet UITableView *ratingTableView;
@property (strong, nonatomic) NSString *parseClassName;
@property (strong, nonatomic) NSArray *reviewArray;
@property (strong, nonatomic) ReviewTableViewCell *prototypeCell;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) UILabel *activityLabel;
@end
