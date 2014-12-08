//
//  ReviewRequestViewController.m
//  HelpHub
//
//  Created by George Georgaklis on 3/30/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "ReviewRequestViewController.h"

@interface ReviewRequestViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ReviewRequestViewController


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)startActivityView {
    _overlayView = [[UIView alloc] init];
    _overlayView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];
    _overlayView.frame = self.view.bounds;
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
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query includeKey:@"poster"];
    [query getObjectInBackgroundWithId:_taskID block:^(PFObject *object, NSError *error) {
        if(!error) {
            _currentTask = object;
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
            if([_detailsText compare: @" "]){
                _detailsText = @"None";
            }
            
            [self stopActivityView];
            [self.tableView reloadData];
        }
        else{
            NSLog(@"Error retrieving data: %@",error);
            _activityLabel.text = @"Error Loading Data";
            [self.activityIndicator removeFromSuperview];
        }
    }];
    
    [self startActivityView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(IS_IPHONE5){
        return 49.0;
    } else {
        return 40.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 9:{
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
            [cell.buttonLeft setTitle: @"Accept" forState:UIControlStateNormal];
            [cell.buttonRight setTitle: @"Decline" forState:UIControlStateNormal];
            
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
                    if([_needWillHelpText isEqualToString:@"needHelp"]){
                        _needWillHelpText = @" - will help";
                    } else {
                        _needWillHelpText = @" - needs help";
                    }
                    [cell.detailsLabel setText:@"User:"];
                    userInfotext = [_potentialUser.username stringByAppendingString:_needWillHelpText];
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
                    [cell.detailsLabel setText:@"Will Cost:"];
                    [cell.detailsContent setText:_costText];
                    break;
                case 4:
                    [cell.detailsLabel setText:@"Will Pay:"];
                    if(_newtip == NULL){
                        [cell.detailsContent setText:_tipText];
                    }
                    else{
                        [cell.detailsContent setText:_newtip];
                        [cell.detailsContent setTextColor:[UIColor colorWithRed:95/255.0 green:201/255.0 blue:211/255.0 alpha:1.0]];
                    }
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
        controller.user = _potentialUser;
    }
    [[self navigationItem] setBackBarButtonItem:backButton];
}

- (void) pressButton: (id)sender {
    UIButton *button = sender;
    NSLog(@"Accept or Decline Task");
    switch (button.tag) {
        case LEFT_BUTTON_TAG:{
            NSLog(@"Accepting task");
            _currentTask[@"accepted"] = @YES;
            _currentTask[@"acceptor"] = _potentialUser;
            [_currentTask saveInBackground];
            
            NSString *potentialUserID = @"none";
            NSDictionary *data = @{
                                   @"alert": @"Your request has been accepted!",
                                   @"taskID": _taskID, @"potentialUserID":potentialUserID
                                   };
            NSLog(@"pushing");
            NSString* channelID = @"acceptorChannelID_";
            channelID = [channelID stringByAppendingString:[_currentTask objectId]];
            PFPush *push = [[PFPush alloc] init];
            [push setData:data];
            [push setChannel:channelID];
            [push sendPushInBackground];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
        case RIGHT_BUTTON_TAG:{
            NSLog(@"Declining task");
            _currentTask[@"accepted"] = @NO;
            _currentTask[@"requested"] = @NO;
            [_currentTask saveInBackground];
            
            NSString *potentialUserID = @"rejected";
            NSDictionary *data = @{
                                   @"alert": @"We are sorry but your request has been rejected",
                                   @"taskID": _taskID, @"potentialUserID":potentialUserID
                                   };
            NSLog(@"pushing");
            NSString* channelID = @"acceptorChannelID_";
            channelID = [channelID stringByAppendingString:[_currentTask objectId]];
            PFPush *push = [[PFPush alloc] init];
            [push setData:data];
            [push setChannel:channelID];
            [push sendPushInBackground];
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
