//
//  YourTaskListViewController.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 3/8/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "YourTaskListViewController.h"

@interface YourTaskListViewController ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic) NSInteger needHelpCount;
@property (nonatomic) NSInteger willHelpCount;
@end

@implementation YourTaskListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.tableFooterView = [UIView new];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"MMM d - h:mm a"];
}

-(void)viewDidAppear:(BOOL)animated{
    TaskListAppDelegate *appDelegate = (TaskListAppDelegate*)[[UIApplication sharedApplication] delegate];

    if(appDelegate.didRecieveNotificationWhileInBackground) {
        if([appDelegate.potentialUserID isEqualToString:@"taskCompleted"]){
            _currentTaskID = appDelegate.taskID;
            _currentTaskAccepted = YES;
            [self performSegueWithIdentifier:@"TaskSegue" sender:self];
            appDelegate.didRecieveNotificationWhileInBackground = NO;
        }
        else if(![appDelegate.potentialUserID isEqualToString:@"none"]){
            //poster is opening notification
            _currentTaskID = appDelegate.taskID;
            _potentialUserID = appDelegate.potentialUserID;
            _newtip = appDelegate.newtip;
            [self getUser:_potentialUserID];
            appDelegate.didRecieveNotificationWhileInBackground = NO;
        }
        else{
            //acceptor is opening notification
            _currentTaskID = appDelegate.taskID;
            _currentTaskAccepted = YES;
            [self performSegueWithIdentifier:@"TaskSegue" sender:self];
            appDelegate.didRecieveNotificationWhileInBackground = NO;
        }
    }
    if(appDelegate.didDeleteTask){
        appDelegate.didDeleteTask = NO;
        NSLog(@"reload data");
        [self.tableView reloadData];
    }
}

- (void) viewWillAppear: (BOOL) animated{
    [super viewWillAppear:(BOOL) animated];
    // NSLog(@"View Will Appear");
    [self startActivityView];
    [self loadObjects];
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

- (PFQuery *)queryForTable {
    PFQuery *acceptorQuery = [PFQuery queryWithClassName: self.parseClassName];
    PFQuery *posterQuery = [PFQuery queryWithClassName: self.parseClassName];
    [acceptorQuery whereKey:@"acceptor" equalTo:[PFUser currentUser]];
    [acceptorQuery whereKey:@"acceptorCompleted" equalTo:[NSNumber numberWithBool:NO]];
    [posterQuery whereKey:@"poster" equalTo:[PFUser currentUser]];
    [posterQuery whereKey:@"posterCompleted" equalTo:[NSNumber numberWithBool:NO]];

    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[posterQuery, acceptorQuery]];
    [query orderByAscending:@"needWillHelp"];
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
    NSString *boolString = task[@"accepted"];
    cell.taskAccepted = [boolString boolValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return _needHelpCount;
    } else {
        return _willHelpCount;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return @"You Need Help With";
    } else {
        return @"You Will Help With";
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *titleString =[self tableView: tableView titleForHeaderInSection: section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:titleString];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:95/255.0 green:201/255.0 blue:211/255.0 alpha:1.0]];
    return view;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    if(error){
        NSLog(@"Error retrieving data: %@",error);
        _activityLabel.text = @"Error Loading Data";
        [self.activityIndicator removeFromSuperview];
    }else{
        [self stopActivityView];
    }
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    _needHelpCount = 0;
    _willHelpCount = 0;
    NSString *currentUser = [PFUser currentUser].username;
    NSLog(@"Current User: %@", currentUser);
    for (PFObject *object in self.objects) {
        NSString *posterUser = [[object objectForKey:@"poster"] description];
        posterUser = [posterUser substringWithRange: NSMakeRange(8, 10)];
        NSLog(@"needwillhelp: %@",object[@"needWillHelp"]);
        NSLog(@"category: %@",object[@"category"]);
        if([object[@"needWillHelp"] isEqualToString:@"willHelp"]){
            _willHelpCount++;
        } else {
            _needHelpCount++;
        }
    }
    NSLog(@"Will Help Count: %ld", (long)_willHelpCount);
    NSLog(@"Need Help Count: %ld", (long)_needHelpCount);
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    if([self.objects count] == 0){
        return NULL;
    }
    if(indexPath.row >= [self.objects count]){
        return NULL;
    }
    int section = indexPath.section;
    if(section == 0){
        return [self.objects objectAtIndex: indexPath.row];
    } else {
        return [self.objects objectAtIndex: indexPath.row + _needHelpCount];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"index path %d",indexPath.row);
    SimpleTaskCell *cell = (SimpleTaskCell *)[tableView cellForRowAtIndexPath:indexPath];
    _currentTaskID = cell.taskID;
    _currentTaskAccepted = cell.taskAccepted;
    
    [self performSegueWithIdentifier:@"TaskSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:nil action:nil];
    if ([segue.identifier isEqualToString:@"TaskSegue"]) {
        TaskController *controller = (TaskController *)segue.destinationViewController;
        controller.taskID = _currentTaskID;
        controller.fromYourTasksPage = YES;
        if(_currentTaskAccepted == YES){
            controller.taskDisplayButtonType = TASK_COMPLETE;
        } else{
            controller.taskDisplayButtonType = TASK_DELETE;
        }
    }
    else if([segue.identifier isEqualToString:@"ReviewRequestSegue"]) {
        ReviewRequestViewController *controller = (ReviewRequestViewController *)segue.destinationViewController;
        controller.taskID = _currentTaskID;
        controller.potentialUser = _potentialUser;
        controller.newtip = _newtip;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end