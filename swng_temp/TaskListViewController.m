//
//  TaskListViewController.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/23/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "TaskListViewController.h"

@interface TaskListViewController ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation TaskListViewController

int needWillHelp = TASK_NEED_HELP;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //Set Up Header Cell
    
    _taskNeedOrWillHelp = 0;
    _timesLoaded = 0;
    
    static NSString *CellIdentifier = @"MyNeedWillHelpCell";
    NeedWillHelpCell *cell = (NeedWillHelpCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NeedWillHelpCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (NeedWillHelpCell *)currentObject;
                _headerSegmentedControl = cell.headerSegmentedControl;
                [_headerSegmentedControl addTarget:self action:@selector(switchedEventType:) forControlEvents:UIControlEventValueChanged];
                break;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableHeaderView = cell;
    self.tableView.tableFooterView = [UIView new];
    
    //initialize bar stuff
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Futura" size:17],
      NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    UIBarButtonItem *newTaskItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newTaskButtonPressed:)];
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(mapButtonPressed:)];
    
    UIImage* image = [UIImage imageNamed:@"helphub_nav_icon_22px_v5.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *tempButton = [[UIButton alloc] initWithFrame:frame];
    [tempButton setBackgroundImage:image forState:UIControlStateNormal];
    [tempButton setTintColor: [UIColor clearColor]];
    [tempButton addTarget:self action: @selector(yourTaskListButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [tempButton setSelected:YES];
    UIBarButtonItem *currentTasksItem = [[UIBarButtonItem alloc] initWithCustomView:tempButton];
    
    NSArray *actionButtonItems = @[newTaskItem, currentTasksItem, mapButton];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"MMM d - h:mm a"];
    
}

-(void)startActivityView {
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
-(void)stopActivityView {
    [self.activityIndicator removeFromSuperview];
    [self.overlayView removeFromSuperview];
}

- (void) viewWillAppear: (BOOL) animated{
    [super viewWillAppear:(BOOL) animated];
    if(_timesLoaded != 0){
        _timesLoaded = 1;
    }
    [self loadObjects];
}

-(void)viewDidAppear:(BOOL)animated{
    TaskListAppDelegate *appDelegate = (TaskListAppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDelegate.didRecieveNotificationWhileClosed) {
        if([appDelegate.potentialUserID isEqualToString:@"taskCompleted"]){
            //push sent to other user needing to complete task
            _currentTaskID = appDelegate.taskID;
            [self performSegueWithIdentifier:@"TaskSegue" sender:self];
        }
        else if(![appDelegate.potentialUserID isEqualToString:@"none"]){
            //if poster is opening task request notification
            _currentTaskID = appDelegate.taskID;
            _potentialUserID = appDelegate.potentialUserID;
            _newtip = appDelegate.newtip;
            [self getUser:_potentialUserID];
            appDelegate.didRecieveNotificationWhileClosed = NO;
        }
        else{
            //if acceptor is opening notification
            _currentTaskID = appDelegate.taskID;
            [self performSegueWithIdentifier:@"TaskSegue" sender:self];
        }
    }
}

- (PFQuery *)queryForTable {
    _locationArray = [[NSMutableArray alloc] init];
    _taskIDArray = [[NSMutableArray alloc] init];
    [self startActivityView];
    PFQuery *query = [PFQuery queryWithClassName: self.parseClassName];
    if (needWillHelp == TASK_NEED_HELP){
        [query whereKey:@"needWillHelp" equalTo:@"needHelp"];
        [query whereKey:@"accepted" equalTo:[NSNumber numberWithBool:NO]];
        [query whereKey:@"poster" notEqualTo:[PFUser currentUser]];
        [query whereKey:@"startTime" greaterThan:[NSDate date]];
        [query whereKey:@"requested" equalTo:[NSNumber numberWithBool:NO]];
    } else if (needWillHelp == TASK_WILL_HELP){
        [query whereKey:@"needWillHelp" equalTo:@"willHelp"];
        [query whereKey:@"accepted" equalTo:[NSNumber numberWithBool:NO]];
        [query whereKey:@"poster" notEqualTo:[PFUser currentUser]];
        [query whereKey:@"startTime" greaterThan:[NSDate date]];
        [query whereKey:@"requested" equalTo:[NSNumber numberWithBool:NO]];
    }
    [query orderByAscending: @"endTime"];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [self stopActivityView];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    // Usual cell reuse dance
    static NSString *CellIdentifier = @"MySimpleTaskCell";
    
    SimpleTaskCell *cell = (SimpleTaskCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SimpleTaskCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (SimpleTaskCell *)currentObject;
                break;
            }
        }
    }
    
    // Configure the cell
    PFObject *task = object;
    cell.taskCategoryView.text = task[@"category"];
    cell.taskDescriptionView.text = task[@"description"];
    cell.taskLocationView.text = task[@"location"];
    cell.taskCostView.text = task[@"tip"];
    NSDate *startTime = task[@"startTime"];
    NSDate *endTime = task[@"endTime"];
    NSString *formattedStartDateString = [_dateFormatter stringFromDate:startTime];
    NSString *formattedEndDateString = [_dateFormatter stringFromDate:endTime];
    cell.taskTimeStartView.text = formattedStartDateString;
    cell.taskTimeEndView.text = formattedEndDateString;
    cell.taskID = [task objectId];
    
    //add location to array
    NSString *latString = task[@"locationLat"];
    NSString *longString = task[@"locationLong"];
    double lat = [latString doubleValue];
    double longitude = [longString doubleValue];
    
    if([task[@"requested"] isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        //NSLog(@"not requested");
        CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:longitude];
        bool inArray = NO;
        for(CLLocation *loc in _locationArray) {
            if([loc.description isEqualToString:location.description])
                inArray = YES;
        }
        if(!inArray){
            [_locationArray addObject:location];
            //NSLog(@"adding location");
        }
        
        //add task id to array
        NSString *taskID = [task objectId];
        if(![_taskIDArray containsObject:taskID]){
            [_taskIDArray addObject:taskID];
            //NSLog(@"adding taskID");
        }
    }
    
    return cell;
    
}

- (void) showTableAnimated {
    NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
    for (int i = 0; i < [self.objects count]; i++){
        indexPaths[i] = [NSIndexPath indexPathForRow: i inSection:0];
    }
    switch (_taskNeedOrWillHelp) {
        case TASK_NEED_HELP:
            [self.tableView reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:UITableViewRowAnimationLeft];
            break;
        case TASK_WILL_HELP:
            [self.tableView reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:UITableViewRowAnimationRight];
            break;
    }
    
    static NSString *CellIdentifier = @"MyNeedWillHelpCell";
    NeedWillHelpCell *cell = (NeedWillHelpCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NeedWillHelpCell" owner:self options:nil];
    for (id currentObject in topLevelObjects) {
        if ([currentObject isKindOfClass:[UITableViewCell class]]) {
            cell = (NeedWillHelpCell *)currentObject;
            _headerSegmentedControl = cell.headerSegmentedControl;
            [_headerSegmentedControl addTarget:self action:@selector(switchedEventType:) forControlEvents:UIControlEventValueChanged];
            break;
        }
    }
    switch (_taskNeedOrWillHelp) {
        case TASK_NEED_HELP:
            _headerSegmentedControl.selectedSegmentIndex = 0;
            break;
        case TASK_WILL_HELP:
            _headerSegmentedControl.selectedSegmentIndex = 1;
            break;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableHeaderView = cell;
    self.tableView.tableFooterView = [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SimpleTaskCell *cell = (SimpleTaskCell *)[tableView cellForRowAtIndexPath:indexPath];
    _currentTaskID = cell.taskID;
    
    [self performSegueWithIdentifier:@"TaskSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    NSLog(@"Objects did load");
    if(error){
        NSLog(@"Error retrieving data: %@",error);
        _activityLabel.text = @"Error Loading Data";
        [self.activityIndicator removeFromSuperview];
    }else{
        if (_timesLoaded > 1) {
            [self showTableAnimated];
        }
        _timesLoaded ++;
        [self stopActivityView];
    }
}

-(void)newTaskButtonPressed:(id)sender {
    NSLog(@"Create new task");
    [self performSegueWithIdentifier:@"NewTaskSegue" sender:sender];
}

-(void)yourTaskListButtonPressed:(id)sender {
    NSLog(@"View your task list");
    [self performSegueWithIdentifier:@"YourTaskListSegue" sender:sender];
}

-(void)mapButtonPressed:(id)sender {
    NSLog(@"View Task Map");
    [self performSegueWithIdentifier:@"TaskMapSegue" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:nil action:nil];
    TaskListAppDelegate *appDelegate = (TaskListAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([segue.identifier isEqualToString:@"TaskSegue"]) {
        if(!appDelegate.didRecieveNotificationWhileClosed){
            TaskController *controller = (TaskController *)segue.destinationViewController;
            controller.taskID = _currentTaskID;
            controller.taskDisplayButtonType = TASK_REQUEST;
            controller.fromYourTasksPage = NO;
        }
        else{
            if([appDelegate.potentialUserID isEqualToString:@"taskCompleted"]){
                //push sent to other user needing to complete task
                TaskController *controller = (TaskController *)segue.destinationViewController;
                controller.taskID = _currentTaskID;
                controller.taskDisplayButtonType = TASK_COMPLETE;
                controller.fromYourTasksPage = YES;
            }
            else{
                //push sent to acceptor
                TaskController *controller = (TaskController *)segue.destinationViewController;
                controller.taskID = _currentTaskID;
                controller.taskDisplayButtonType = TASK_COMPLETE;
                controller.fromYourTasksPage = YES;
                appDelegate.didRecieveNotificationWhileClosed = NO;
            }
        }
    }
    else if([segue.identifier isEqualToString:@"ReviewRequestSegue"]) {
        ReviewRequestViewController *controller = (ReviewRequestViewController *)segue.destinationViewController;
        controller.taskID = _currentTaskID;
        controller.potentialUser = _potentialUser;
        controller.newtip = _newtip;
    }
    else if([segue.identifier isEqualToString:@"TaskMapSegue"]) {
        TaskMapViewController *controller = (TaskMapViewController *)segue.destinationViewController;
        controller.locationArray = _locationArray;
        controller.taskIDArray = _taskIDArray;
        
    }
    [[self navigationItem] setBackBarButtonItem:backButton];
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



- (IBAction)switchedEventType:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch (selectedSegment) {
        case TASK_NEED_HELP:
            NSLog(@"Need help: TaskListViewController");
            needWillHelp = TASK_NEED_HELP;
            break;
        case TASK_WILL_HELP:
            NSLog(@"Will help: TaskListViewController");
            needWillHelp = TASK_WILL_HELP;
            break;
    }
    _taskNeedOrWillHelp = 1 - _taskNeedOrWillHelp;
    [self loadObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
