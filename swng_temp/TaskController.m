//
//  TaskDetailsController.m
//  HelpHub
//
//  Created by George Georgaklis on 3/1/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "TaskController.h"

@interface TaskController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation TaskController


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)startActivityView{
    _overlayView = [[UIView alloc] init];
    _overlayView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];
    _overlayView.frame = self.view.frame;
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect frame = _overlayView.frame;
    _activityLabel = [[UILabel alloc] init];
    _activityLabel.text = @"Loading";
    [_activityLabel setTextAlignment:NSTextAlignmentCenter];
    _activityLabel.textColor = [UIColor grayColor];
    _activityLabel.frame = CGRectMake(0, 3, 180, 25);
    _activityLabel.center = CGPointMake(frame.size.width/2, (frame.size.height/2)-100);
    _activityIndicator.color = [UIColor grayColor];
    _activityIndicator.center = CGPointMake(frame.size.width/2, (frame.size.height/2)-60);
    //////////60?
    [_overlayView addSubview:_activityIndicator];
    [_overlayView addSubview:_activityLabel];
    [_activityIndicator startAnimating];
    [self.view addSubview:_overlayView];
}
-(void)stopActivityView{
    [self.activityIndicator removeFromSuperview];
    [self.overlayView removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query getObjectInBackgroundWithId:_taskID block:^(PFObject *object, NSError *error) {
        if(!error) {
            _currentTask = object;
        }
        else{
            NSLog(@"%@",error);
        }
    }];
}

-(void)getUser:(NSString*)userID{
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:userID]; // find all the women
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            _potentialUser = [objects objectAtIndex:0];
            [self performSegueWithIdentifier:@"ReviewRequestSegue" sender:self];
        }
        else{
            NSLog(@"%@",error);
        }
    }];
}


-(void)viewDidAppear:(BOOL)animated{
    TaskListAppDelegate *appDelegate = (TaskListAppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDelegate.didRecieveNotificationWhileInBackground) {
        if(![appDelegate.potentialUserID isEqualToString:@"none"] && !([appDelegate.potentialUserID isEqualToString:@"taskCompleted"]) && !([appDelegate.potentialUserID isEqualToString:@"message"]) && ([appDelegate.taskID isEqualToString:_taskID])){
            //poster is opening notification
            NSString *potentialUserID = appDelegate.potentialUserID;
            [self getUser:potentialUserID];
            appDelegate.didRecieveNotificationWhileInBackground = NO;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query includeKey:@"poster"];
    [query includeKey:@"acceptor"];
    [query getObjectInBackgroundWithId:_taskID block:^(PFObject *object, NSError *error) {
        if(!error) {
            _currentTask = object;
            _posterUser = [object objectForKey:@"poster"];
            _alreadyAccepted = [_currentTask[@"accepted"] boolValue];
            _userText = _posterUser.username;
            NSLog(@"already accepted %d",_alreadyAccepted);
            if(_alreadyAccepted){
                _acceptorUser = [object objectForKey:@"acceptor"];
                _userText = _acceptorUser.username;
                NSLog(@"user text: %@",_userText);
                if([_acceptorUser.username isEqualToString:[PFUser currentUser].username]){
                    _userText = _posterUser.username;
                }
                
            } else {
                _userText = _posterUser.username;
            }
            _categoryText = _currentTask[@"category"];
            _descriptionText = _currentTask[@"description"];
            _costText = _currentTask[@"cost"];
            _tipText = _currentTask[@"tip"];
            _locationText = _currentTask[@"location"];
            _dateFormatter = [[NSDateFormatter alloc] init];
            [_dateFormatter setDateFormat:@"MMM d - h:mm a"];
            NSDate *time = _currentTask[@"startTime"];
            NSString *formattedDateString = [_dateFormatter stringFromDate:time];
            _startTimeText = formattedDateString;
            time = _currentTask[@"endTime"];
            formattedDateString = [_dateFormatter stringFromDate:time];
            _endTimeText = formattedDateString;
            _detailsText = _currentTask[@"details"];
            if([_detailsText isEqualToString: @" "]){
                _detailsText = @"None";
            }
            
            NSString *latString = _currentTask[@"locationLat"];
            NSString *longString = _currentTask[@"locationLong"];
            double lat = [latString doubleValue];
            double longitude = [longString doubleValue];
            _locationCoord = [[CLLocation alloc] initWithLatitude:lat longitude:longitude];
            
            [self stopActivityView];
            [self.tableView reloadData];
            
            switch (_taskDisplayButtonType) {
                case TASK_CLOSED:
                    _requireHeader = YES;
                    break;
                case TASK_REQUEST:
                case TASK_DELETE:
                default:
                    _requireHeader = NO;
                    break;
            }
            
            NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
            for (int i = 0; i < 10; i++){
                indexPaths[i] = [NSIndexPath indexPathForRow: i inSection:0];
            }
            _shouldShowCells = true;
            [self.tableView reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:UITableViewRowAnimationNone];
            
            [NSTimer scheduledTimerWithTimeInterval:.18 target:self selector:@selector(showHeader) userInfo:nil repeats:NO];
        }
        else{
            NSLog(@"Error retrieving data: %@",error);
            _activityLabel.text = @"Error Loading Data";
            [self.activityIndicator removeFromSuperview];
        }
    }];
    
    [self startActivityView];
}

- (void) showHeader {
    if(_requireHeader && (_alreadyAccepted && _fromYourTasksPage)){
        //Set Up Header Cell
        static NSString *CellIdentifier = @"MyDetailsMessageSwitcherCell";
        DetailsMessageSwitcherCell *cell = (DetailsMessageSwitcherCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DetailsMessageSwitcherCell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = (DetailsMessageSwitcherCell *)currentObject;
                    _headerSegmentedControl = cell.detailsMessageSegmentedControl;
                    [_headerSegmentedControl addTarget:self action:@selector(switchTaskInfo:) forControlEvents:UIControlEventValueChanged];
                    break;
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.tableHeaderView = cell;
    } else if(_alreadyAccepted && !_fromYourTasksPage){
        //Set Up Header Cell
        static NSString *CellIdentifier = @"MyLabelTableViewCell";
        LabelTableViewCell *cell = (LabelTableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LabelTableViewCell" owner:self options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = (LabelTableViewCell *)currentObject;
                    cell.label.text = @"Task Already Taken";
                    break;
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.tableHeaderView = cell;
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(_alreadyAccepted && !_fromYourTasksPage){
        return 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_shouldShowCells){
        if(_requireHeader){
            if(IS_IPHONE5){
                return 45.0;
            } else {
                return 36.0;
            }
        } else {
            if(IS_IPHONE5){
                return 49.0;
            } else {
                return 40.0;
            }
        }
    }
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 9:{
            switch (_taskDisplayButtonType) {
                case TASK_REQUEST:
                case TASK_DELETE: {
                    static NSString *CellIdentifier = @"MySubmitCell";
                    SubmitCell *cell = (SubmitCell*) [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil) {
                        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SubmitCell" owner:self options:nil];
                        for (id currentObject in topLevelObjects) {
                            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                                cell = (SubmitCell *)currentObject;
                                break;
                            }
                        }
                    }
                    switch (_taskDisplayButtonType) {
                        case TASK_REQUEST:
                            [cell.button setTitle: @"Request Task" forState:UIControlStateNormal];
                            break;
                        case TASK_DELETE:
                            [cell.button setTitle: @"Delete Task" forState:UIControlStateNormal];
                            break;
                        case TASK_CLOSED:
                            [cell.button setTitle: @"Mark Task Complete" forState:UIControlStateNormal];
                            break;
                        default:
                            break;
                    }
                    _submitButton = cell.button;
                    [_submitButton addTarget:self
                                      action:@selector(pressButton:)
                            forControlEvents:UIControlEventTouchUpInside];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    _submitButtonCell = cell;
                    return cell;
                }
                case TASK_CLOSED: {
                    static NSString *CellIdentifier = @"MyTwoButtonCell";
                    TwoButtonCell *cell = (TwoButtonCell*) [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil) {
                        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TwoButtonCell" owner:self options:nil];
                        for (id currentObject in topLevelObjects) {
                            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                                cell = (TwoButtonCell *)currentObject;
                                break;
                            }
                        }
                    }
                    [cell.buttonLeft setTitle: @"Mark Complete" forState:UIControlStateNormal];
                    [cell.buttonRight setTitle: @"Mark Incomplete" forState:UIControlStateNormal];
                    
                    _leftButton = cell.buttonLeft;
                    _rightButton = cell.buttonRight;
                    _leftButton.tag = LEFT_BUTTON_TAG;
                    _rightButton.tag = RIGHT_BUTTON_TAG;
                    [_leftButton addTarget:self
                                    action:@selector(pressButton:)
                          forControlEvents:UIControlEventTouchUpInside];
                    [_rightButton addTarget:self
                                     action:@selector(pressButton:)
                           forControlEvents:UIControlEventTouchUpInside];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    _twoButtonCell = cell;
                    return cell;
                }
            }
        }
        default: {
            static NSString *CellIdentifier = @"MyDetailsLabelCell";
            DetailsLabelCell *cell = (DetailsLabelCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DetailsLabelCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (DetailsLabelCell *)currentObject;
                    }
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSString *userInfotext;
            
            switch (indexPath.row) {
                case 0:
                    _needWillHelpText = _currentTask[@"needWillHelp"];
                    if(!_alreadyAccepted || [_acceptorUser.username isEqualToString:[PFUser currentUser].username]){
                        if([_needWillHelpText isEqualToString:@"needHelp"]){
                            _needWillHelpText = @" - needs help";
                        } else {
                            _needWillHelpText = @" - will help";
                        }
                    } else {
                        if([_needWillHelpText isEqualToString:@"needHelp"]){
                            _needWillHelpText = @" - will help";
                        } else {
                            _needWillHelpText = @" - needs help";
                        }
                    }
                    [cell.detailsLabel setText:@"User:"];
                    userInfotext = [_userText stringByAppendingString:_needWillHelpText];
                    [cell.detailsContent setText:userInfotext];
                    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                    break;
                case 1:
                    [cell.detailsLabel setText:@"Category:"];
                    [cell.detailsContent setText:_categoryText];
                    break;
                case 2:
                    [cell.detailsLabel setText:@"Description:"];
                    [cell.detailsContent setText:_descriptionText];
                    break;
                case 3:
                    [cell.detailsLabel setText:@"Cost:"];
                    [cell.detailsContent setText:_costText];
                    break;
                case 4:
                    [cell.detailsLabel setText:@"Tip:"];
                    [cell.detailsContent setText:_tipText];
                    break;
                case 5:
                    [cell.detailsLabel setText:@"Location:"];
                    [cell.detailsContent setText:_locationText];
                    break;
                case 6:
                    [cell.detailsLabel setText:@"Start At:"];
                    [cell.detailsContent setText:_startTimeText];
                    break;
                case 7:
                    [cell.detailsLabel setText:@"Done By:"];
                    [cell.detailsContent setText:_endTimeText];
                    break;
                case 8:
                    [cell.detailsLabel setText:@"Details:"];
                    [cell.detailsContent setText:_detailsText];
                    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                    break;
                default:
                    break;
            }
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 4){
        NSLog(@"negotiate tip");
        [self performSegueWithIdentifier:@"NegotiateSegue" sender:self];
    }
    if(indexPath.row == 5){
        [self performSegueWithIdentifier:@"MapSegue" sender:self];
    }
    if(indexPath.row == 8){
        [self performSegueWithIdentifier:@"TaskDetailsViewSegue" sender:self];
    } else if (indexPath.row == 0){
        [self performSegueWithIdentifier:@"ProfileSegue" sender:self];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:nil action:nil];
    if([segue.identifier isEqualToString:@"TaskDetailsViewSegue"]){
        TaskDetailsViewController *controller = (TaskDetailsViewController*)segue.destinationViewController;
        controller.detailsString = _detailsText;
    } else if([segue.identifier isEqualToString:@"ProfileSegue"]){
        ProfileViewController *controller = (ProfileViewController *)segue.destinationViewController;
        if(!_alreadyAccepted || [_acceptorUser.username isEqualToString:[PFUser currentUser].username]){
            controller.user = _posterUser;
        }
        else{
            controller.user = _acceptorUser;
        }
    } else if ([segue.identifier isEqualToString:@"ReviewSegue"]) {
        ReviewTableViewController *controller = (ReviewTableViewController *)segue.destinationViewController;
        controller.navigationTitle = _headerTitle;
        if([[PFUser currentUser].username isEqual: _posterUser.username]){
            controller.userToReview = _acceptorUser;
        } else {
            controller.userToReview = _posterUser;
        }
    } else if ([segue.identifier isEqualToString:@"MessageSegue"]) {
        ChatViewController *controller = (ChatViewController *)segue.destinationViewController;
        controller.otherUser = _userText;
        controller.username = [PFUser currentUser].username;
        controller.chatRoomID = [_currentTask objectId];
        controller.posterUser = _posterUser.username;
        controller.taskID = _taskID;
    } else if([segue.identifier isEqualToString:@"ReviewRequestSegue"]) {
        ReviewRequestViewController *controller = (ReviewRequestViewController *)segue.destinationViewController;
        controller.taskID = [_currentTask objectId];
        controller.potentialUser = _potentialUser;
    }
    else if([segue.identifier isEqualToString:@"NegotiateSegue"]) {
        NegotiateViewController *controller = (NegotiateViewController *)segue.destinationViewController;
        controller.taskID = _taskID;
        controller.currentTask = _currentTask;
    }
    else if([segue.identifier isEqualToString:@"MapSegue"]) {
        MapViewController *controller = (MapViewController *)segue.destinationViewController;
        controller.location = _locationCoord;
        controller.locationDesc = _locationText;
    }
    
    
    [[self navigationItem] setBackBarButtonItem:backButton];
}

- (void) pressButton: (id)sender {
    UIButton *button = sender;
    switch (_taskDisplayButtonType) {
        case TASK_REQUEST:{
            NSLog(@"Requsting Task");
            if([_currentTask[@"requested"] boolValue] == NO){
                _currentTask[@"requested"] = @YES;
                [_currentTask saveInBackground];
                
                NSString *potentialUserID = [[PFUser currentUser] objectId];
                NSDictionary *data = @{
                                       @"alert": @"Your task has been requested!",
                                       @"taskID": _taskID, @"potentialUserID":potentialUserID
                                       };
                NSLog(@"pushing");
                NSString* channelID = @"posterChannelID_";
                channelID = [channelID stringByAppendingString:[_currentTask objectId]];
                PFPush *push = [[PFPush alloc] init];
                [push setData:data];
                [push setChannel:channelID];
                [push sendPushInBackground];
                
                //acceptor register for push
                channelID = @"acceptorChannelID_";
                channelID = [channelID stringByAppendingString:[_currentTask objectId]];
                NSLog(@"channel ID: %@",channelID);
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation addObject:channelID forKey:@"channels"];
                [currentInstallation saveInBackground];
                
                for(int i=0; i<[_taskIDArray count]; i++){
                    if([_taskID isEqualToString:[_taskIDArray objectAtIndex:i]]){
                        [_taskIDArray removeObjectAtIndex:i];
                        [_locationArray removeObjectAtIndex:i];
                    }
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                NSLog(@"task already requested");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Task already requested." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        }
        case TASK_DELETE:{
            NSLog(@"Deleting Task");
            //remove push channel for poster
            NSString* channelID = @"posterChannelID_";
            channelID = [channelID stringByAppendingString:[_currentTask objectId]];
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation removeObject:channelID forKey:@"channels"];
            [currentInstallation saveInBackground];
            
            TaskListAppDelegate *appDelegate = (TaskListAppDelegate*)[[UIApplication sharedApplication] delegate];
            appDelegate.didDeleteTask = YES;
            
            [_currentTask deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    NSLog(@"%@",error);
                }
            }];
            break;
        }
        case TASK_CLOSED:{
            NSLog(@"Closing Task");
            PFQuery *query = [PFQuery queryWithClassName:@"Task"];
            [query getObjectInBackgroundWithId:_taskID block:^(PFObject *object, NSError *error) {
                if(!error) {
                    _currentTask = object;
                }
                else{
                    NSLog(@"%@",error);
                }
            }];
            switch (button.tag){
                case LEFT_BUTTON_TAG:
                    NSLog(@"Complete");
                    _headerTitle = @"Complete";
                    [self handleComplete];
                    break;
                case RIGHT_BUTTON_TAG:
                    NSLog(@"Incomplete");
                    _headerTitle = @"Incomplete";
                    [self handleIncomplete];
                    break;
            }
        }
    }
}

-(void)alertUserOfClosedTask{
    BOOL acceptorCompleted = false;
    BOOL posterCompleted = false;
    NSString *channelID;
    NSString *potentialUserID = @"taskCompleted";
    NSDictionary *data = @{
                           @"alert": @"Your task has been completed!",
                           @"taskID": _taskID, @"potentialUserID":potentialUserID, @"sound":@"default"
                           };
    if([_posterUser.username isEqualToString: [PFUser currentUser].username]){
        NSLog(@"poster user is closing task");
        channelID = @"acceptorChannelID_";
        posterCompleted = true;
        if([_currentTask[@"acceptorCompleted"] boolValue] == YES){
            NSLog(@"acceptor has already completed the task");
            acceptorCompleted = true;
        }
    }
    else{
        NSLog(@"acceptor user is closing task");
        channelID = @"posterChannelID_";
        acceptorCompleted = true;
        NSLog(@"%@",[_currentTask objectId]);
        if([_currentTask[@"posterCompleted"] boolValue] == YES){
            NSLog(@"poster has already completed the task");
            posterCompleted = true;
        }
    }
    channelID = [channelID stringByAppendingString:[_currentTask objectId]];
    if(acceptorCompleted && posterCompleted){
        //both have marked task as complete
        NSLog(@"deleting task");
        [_currentTask deleteInBackground];
        NSLog(@"deleting messages");
        PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
        [query whereKey:@"chatroomID" equalTo:_taskID];
        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            NSLog(@"deleting %d messages",number);
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error){
                    for (PFObject *object in objects) {
                        [object deleteInBackground];
                    }
                }
                else{
                    NSLog(@"%@",error);
                }
            }];
            
        }];
    }
    else{
        NSLog(@"pushing alert user of closed task");
        PFPush *push = [[PFPush alloc] init];
        [push setData:data];
        [push setChannel:channelID];
        [push sendPushInBackground];
    }
}

-(void)handleComplete{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Mark task as Complete?" message: @"Are you sure you want to mark this task as complete?" delegate: self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert show];
}
-(void)handleIncomplete{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Mark task as Incomplete?" message: @"Are you sure you want to mark this task as incomplete?" delegate: self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"pressed Yes");
        NSString* channelID;
        if([_posterUser.username isEqualToString: [PFUser currentUser].username]){
            channelID = @"posterChannelID_";
            _currentTask[@"posterCompleted"] = @YES;
        }
        else{
            channelID = @"acceptorChannelID_";
            _currentTask[@"acceptorCompleted"] = @YES;
        }
        channelID = [channelID stringByAppendingString:[_currentTask objectId]];
        [_currentTask saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                [self alertUserOfClosedTask];
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation removeObject:channelID forKey:@"channels"];
                [currentInstallation saveInBackground];
            }
            else{
                NSLog(@"%@",error);
            }
        }];
        [self performSegueWithIdentifier:@"ReviewSegue" sender:self];
    } else {
        NSLog(@"pressed No");
    }
}

- (IBAction)switchTaskInfo:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch (selectedSegment) {
        case TASK_DETAILS:
            _detailsOrMessage = TASK_DETAILS;
            break;
        case TASK_MESSAGES:;
            _detailsOrMessage = TASK_MESSAGES;
            [self performSegueWithIdentifier:@"MessageSegue" sender:self];
            segmentedControl.selectedSegmentIndex = 0;
            break;
    }
    //[self loadObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
