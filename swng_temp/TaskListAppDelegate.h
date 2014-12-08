//
//  TaskListAppDelegate.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/23/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ChatViewController.h"


@interface TaskListAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *taskID;
@property (strong, nonatomic) NSString *potentialUserID;
@property (strong, nonatomic) NSString *newtip;

@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) CLLocation *selectedLocation;

@property BOOL didRecieveNotificationWhileClosed;
@property BOOL didRecieveNotificationWhileInBackground;
@property BOOL didDeleteTask;
@property (strong, nonatomic) UIViewController *chatController;
@property BOOL currentlyMessaging;


@end
