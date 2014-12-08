//
//  ChatViewController.m
//  HelpHub
//
//  Created by George Georgaklis on 4/13/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "ChatViewController.h"

#define NAVBAR_HEIGHT 20.0f
#define TEXTFIELD_HEIGHT 70.0f
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ChatViewController ()

@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _textFieldEntry.delegate = self;
    _textFieldEntry.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self registerForKeyboardNotifications];
    
    _className = @"Messages";
    _textFieldEntry.placeholder = @"enter message here";
    [_textFieldEntry setReturnKeyType:UIReturnKeySend];
    self.title = _otherUser;
    
    TaskListAppDelegate *appDelegate = (TaskListAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.chatController = self;
    appDelegate.currentlyMessaging = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    _messageData  = [[NSMutableArray alloc] init];
    [self loadLocalChat];
}
-(void)viewWillDisappear:(BOOL)animated{
    TaskListAppDelegate *appDelegate = (TaskListAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.currentlyMessaging = NO;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_messageData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [_messageData count]-[indexPath row]-1;
    //is current user or other user
    if([_username isEqualToString:[[_messageData objectAtIndex:row] objectForKey:@"userName"]]){
        //current user
        static NSString *CellIdentifier = @"messageCellIdentifier2";
        MessageCell2 *cell2 = (MessageCell2*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MessageCell2" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell2 = (MessageCell2 *)currentObject;
                break;
            }
        }
        //initialize cell
        NSString *messageText = [[_messageData objectAtIndex:row] objectForKey:@"text"];
        cell2.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell2.textString.text = messageText;
        [cell2.textString setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
        cell2.textString.textColor = [UIColor colorWithRed:95/255.0 green:201/255.0 blue:211/255.0 alpha:1.0];
        cell2.textString.textAlignment = NSTextAlignmentRight;
        NSDate *theDate = [[_messageData objectAtIndex:row] objectForKey:@"date"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        NSString *timeString = [formatter stringFromDate:theDate];
        cell2.timeLabel.text = timeString;
        cell2.timeLabel.textAlignment = NSTextAlignmentRight;
        cell2.userLabel.text = [[_messageData objectAtIndex:row] objectForKey:@"userName"];
        cell2.userLabel.textAlignment = NSTextAlignmentRight;
        //scroll to row
        if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
            if([_messageData count] > 0 && !_didScroll){
                NSLog(@"scroll to most recent");
                NSIndexPath *path = [NSIndexPath indexPathForRow:([_messageData count] - 1) inSection:0];
                [_chatTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                _didScroll = YES;
            }
        }
        return  cell2;
        
    }else{
        //other user
        static NSString *CellIdentifier = @"messageCellIdentifier";
        MessageCell *cell = (MessageCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (MessageCell *)currentObject;
                break;
            }
        }
        
        NSString *messageText = [[_messageData objectAtIndex:row] objectForKey:@"text"];
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.textString.text = messageText;
        cell.textString.textColor = UIColorFromRGB(0xE05920);
        [cell.textString setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
        NSDate *theDate = [[_messageData objectAtIndex:row] objectForKey:@"date"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        NSString *timeString = [formatter stringFromDate:theDate];
        cell.timeLabel.text = timeString;
        cell.userLabel.text = [[_messageData objectAtIndex:row] objectForKey:@"userName"];
        
        if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
            if([_messageData count] > 0 && !_didScroll){
                NSLog(@"scroll to most recent");
                NSIndexPath *path = [NSIndexPath indexPathForRow:([_messageData count] - 1) inSection:0];
                [_chatTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                _didScroll = YES;
            }
        }
        return cell;
    }
}

- (void)loadLocalChat{
    _didScroll = NO;
    PFQuery *query = [PFQuery queryWithClassName:_className];
    [query whereKey:@"chatroomID" equalTo:_chatRoomID];
    
    __block int totalNumberOfEntries = 0;
    [query orderByDescending:@"createdAt"];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            //The count request succeeded. Log the count
            NSLog(@"There are currently %d entries", number);
            totalNumberOfEntries = number;
            if (totalNumberOfEntries > [_messageData count]) {
                NSLog(@"Retrieving data");
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        // The find succeeded.
                        NSLog(@"Successfully retrieved %lu chats.", (unsigned long)[objects count]);
                        _messageData = objects;
                        [_chatTable reloadData];
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
        } else {
            // The request failed, we'll keep the chatData count?
            number = (int)[_messageData count];
            
        }
    }];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 25) ? NO : YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"the text content%@",_textFieldEntry.text);
    [textField resignFirstResponder];
    
    if (_textFieldEntry.text.length>0) {
        // updating the table immediately
        // going for the parsing
        PFObject *newMessage = [PFObject objectWithClassName:_className];
        [newMessage setObject:_textFieldEntry.text forKey:@"text"];
        [newMessage setObject:_username forKey:@"userName"];
        [newMessage setObject:[NSDate date] forKey:@"date"];
        [newMessage setObject:_chatRoomID forKey:@"chatroomID"];
        [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                // reload the data
                NSLog(@"reload data");
                [self loadLocalChat];
            }
            else{
                NSLog(@"%@",error);
            }
        }];
        
        _textFieldEntry.text = @"";
        NSString *channelID;
        NSString *potentialUserID = @"message";
        NSString *alert = @"Message from ";
        NSString *alertDetails = @"Check your tasks list for message.";
        alert = [alert stringByAppendingString:_username];
        NSDictionary *data = @{
                               @"alert": alert,
                               @"taskID": _taskID, @"potentialUserID":potentialUserID, @"message":alertDetails
                               };
        if([_posterUser isEqualToString: _username]){
            NSLog(@"pushing to acceptor");
            channelID = @"acceptorChannelID_";
        }
        else{
            NSLog(@"pushing to poster");
            channelID = @"posterChannelID_";
        }
        channelID = [channelID stringByAppendingString:_taskID];
        PFPush *push = [[PFPush alloc] init];
        [push setData:data];
        [push setChannel:channelID];
        [push sendPushInBackground];
    }
    
    
    return NO;
}

-(void) registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWasShown:(NSNotification*)aNotification{
    NSLog(@"Keyboard was shown");
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y- keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
    
}

-(void) keyboardWillHide:(NSNotification*)aNotification{
    NSLog(@"Keyboard will hide");
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
}

-(IBAction)dismiss:(id)sender{
    NSLog(@"swipe");
    [_textFieldEntry resignFirstResponder];
}

-(IBAction) textFieldDoneEditing : (id) sender{
    NSLog(@"the text content%@",_textFieldEntry.text);
    [sender resignFirstResponder];
    [_textFieldEntry resignFirstResponder];
}

-(IBAction) backgroundTap:(id) sender{
    [_textFieldEntry resignFirstResponder];
}

@end
