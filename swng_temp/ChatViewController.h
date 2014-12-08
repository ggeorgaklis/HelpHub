//
//  ChatViewController.h
//  HelpHub
//
//  Created by George Georgaklis on 4/13/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MessageCell.h"
#import "MessageCell2.h"
#import "TaskListAppDelegate.h"
@interface ChatViewController : UIViewController  <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITextField *textFieldEntry;
@property (strong, nonatomic) IBOutlet UITableView *chatTable;
@property (strong, nonatomic) NSArray *messageData;

@property (strong, nonatomic) NSString *chatRoomID;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *otherUser;
@property (strong, nonatomic) NSString *className;
@property (strong, nonatomic) NSString *posterUser;
@property (strong, nonatomic) NSString *taskID;
@property BOOL didScroll;

- (void)loadLocalChat;
@end
