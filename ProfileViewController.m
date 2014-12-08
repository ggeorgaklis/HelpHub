//
//  ProfileViewController.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 3/12/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _parseClassName = @"Review";
    PFQuery *reviewsQuery = [PFQuery queryWithClassName:_parseClassName];
    [reviewsQuery whereKey:@"rateeString" equalTo:_user.username];
    [_starProgressView setProgress: 0.0];
    
    
    [reviewsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            float totalRatings = objects.count;
            if(totalRatings > 0){
                NSLog(@"total ratings %.01f",totalRatings);
                float sumRatings = 0.0;
                for(int i=0; i<totalRatings; i++){
                    PFObject *object = [objects objectAtIndex:i];
                    NSNumber *rating = object[@"rating"];
                    float r = [rating floatValue];
                    sumRatings+=r;
                }
                
                float averageRating = sumRatings/totalRatings;
                NSLog(@"average rating: %.01f",averageRating);
                
                NSString *averageRatingString;
                
                averageRatingString = [@"Average Rating: " stringByAppendingString: [NSString stringWithFormat:@"%.01f", averageRating]];
                
                [_averageRatingLabel setText: averageRatingString];
                float ratingPercent = averageRating / 5.0;
                [_starProgressView setProgress: ratingPercent animated:true];
            }
            else{
                NSString *averageRatingString;
                averageRatingString = @"Average Rating: No Ratings Yet";
                [_averageRatingLabel setText: averageRatingString];
                [_starProgressView setProgress: 0];
            }
        }
        else{
            NSLog(@"%@",error);
        }
    }];
    
    [_userNameLabel setText:[_user username]];
    NSLog(@"username: %@",_userNameLabel.text);
    
    _ratingTableView.tableFooterView = [UIView new];
    _ratingTableView.dataSource = self;
    _ratingTableView.delegate = self;
    _ratingTableView.layer.borderWidth = .5;
    _ratingTableView.layer.cornerRadius = 4.0f;
    _ratingTableView.layer.borderColor = UIColorFromRGB(0xE05920).CGColor;
    [self retrieveFromParse];
    
    static NSString *CellIdentifier = @"MyReviewTableViewCell";
    [_ratingTableView registerNib:[UINib nibWithNibName:@"ReviewTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    _prototypeCell = [_ratingTableView dequeueReusableCellWithIdentifier:CellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_reviewArray count];
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
    [self startActivityView];
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"rateeString" equalTo: _user.username];
    if ([_reviewArray count] == 0) {
        //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query orderByDescending:@"createdAt"];
    return query;
}

-(void) retrieveFromParse {
    NSLog(@"retrieving from parse");
    [[self queryForTable] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            NSLog(@"No error retrieving data");
            _reviewArray = [[NSArray alloc] initWithArray:objects];
            [self stopActivityView];
            [_ratingTableView reloadData];
            
            [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(reloadCells) userInfo:nil repeats:NO];
        }
        else{
            NSLog(@"Error retrieving data: %@",error);
            _activityLabel.text = @"Error Loading Data";
            [self.activityIndicator removeFromSuperview];
        }
    }];
}

- (void) reloadCells{
    [_ratingTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Usual cell reuse dance
    static NSString *CellIdentifier = @"MyReviewTableViewCell";
    
    ReviewTableViewCell *cell = (ReviewTableViewCell*) [_ratingTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ReviewTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell = (ReviewTableViewCell *)currentObject;
                break;
            }
        }
    }
    
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
    
    CGFloat headerLabelHeight = [self sizeOfLabel:_prototypeCell.headerLabelView withText:[self headerTextForRow:indexPath.row]].height + 10;
    CGFloat contentLabelHeight = [self sizeOfLabel:_prototypeCell.contentLabelView withText:[self contentTextForRow:indexPath.row]].height;
    
    cell.headerLabelView.frame = CGRectMake(cell.headerLabelView.frame.origin.x, cell.headerLabelView.frame.origin.y, cell.headerLabelView.frame.size.width-25, headerLabelHeight);
    cell.headerLabelView.text = [self headerTextForRow:indexPath.row];
    
    cell.contentLabelView.frame = CGRectMake(cell.contentLabelView.frame.origin.x, cell.contentLabelView.frame.origin.y, cell.contentLabelView.frame.size.width-25, contentLabelHeight);
    cell.contentLabelView.text = [self contentTextForRow:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGSize)sizeOfLabelBig:(UILabel *)label withText:(NSString *)text {
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.font = [UIFont fontWithName:@"Futura" size:16];
    gettingSizeLabel.text = text;
    gettingSizeLabel.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake(280, INFINITY);
    CGSize expectedSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
    return expectedSize;
}

- (CGSize)sizeOfLabel:(UILabel *)label withText:(NSString *)text {
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.font = [UIFont fontWithName:@"Futura" size:12];
    gettingSizeLabel.text = [text stringByAppendingString:@"\n \n"];
    gettingSizeLabel.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake(280, INFINITY);
    CGSize expectedSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
    return expectedSize;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    _prototypeCell.frame = CGRectMake(_prototypeCell.frame.origin.x, _prototypeCell.frame.origin.y, _ratingTableView.frame.size.width, _prototypeCell.frame.size.height);
    CGFloat headerLabelHeight = [self sizeOfLabelBig:_prototypeCell.headerLabelView withText:[self headerTextForRow:indexPath.row]].height;
    CGFloat contentLabelHeight = [self sizeOfLabel:_prototypeCell.contentLabelView withText:[self contentTextForRow:indexPath.row]].height;
    NSLog(@"content %f", contentLabelHeight);
    CGFloat padding = _prototypeCell.headerLabelView.frame.origin.y;
    CGFloat combinedHeight = padding + headerLabelHeight + padding/2 + contentLabelHeight + padding;
    NSLog(@"height %f", combinedHeight);
    return combinedHeight;
}

- (NSString *) headerTextForRow:(int)row {
    PFObject *review = [_reviewArray objectAtIndex:row];
    float rating = [review[@"rating"] floatValue];
    NSString *titleString = review[@"raterString"];
    titleString = [titleString stringByAppendingString: @" - "];
    titleString = [titleString stringByAppendingString: [NSString stringWithFormat:@"%.01f", rating]];
    return titleString;
}

- (NSString *) contentTextForRow:(int)row {
    PFObject *review = [_reviewArray objectAtIndex:row];
    return review[@"review"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end