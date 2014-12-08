//
//  LoginViewController.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/17/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLogInViewController.h"
#import "MySignUpViewController.h"

@interface LoginViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end
