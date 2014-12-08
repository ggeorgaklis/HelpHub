//
//  NegotiateViewController.h
//  HelpHub
//
//  Created by George Georgaklis on 10/15/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NegotiateViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *taskID;

@property (strong, nonatomic) PFObject *currentTask;

@property (strong, nonatomic) IBOutlet UITextField *tipTextField;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)pressedSubmit;


@end
