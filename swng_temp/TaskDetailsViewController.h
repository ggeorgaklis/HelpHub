//
//  TaskDetailsViewController.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 3/9/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskDetailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *detailsTextView;
@property (strong, nonatomic) IBOutlet UITextView *detailsText;
@property (strong, nonatomic) NSString *detailsString;
@end
