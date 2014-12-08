//
//  ReviewTableViewController.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 3/30/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "ReviewTableViewController.h"

@interface ReviewTableViewController ()

@end

@implementation ReviewTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _navigationTitle;
    _starPercentage = 0.0;
}

- (void) viewDidAppear:(BOOL)animated {
    _entryTextView.delegate = self;
    [self.navigationItem setHidesBackButton:YES animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row){
        case 0:
            if(IS_IPHONE5){
                return 40.0;
            } else {
                return 34.0;
            }
        case 1:
            if(IS_IPHONE5){
                return 50.0;
            } else {
                return 44.0;
            }
        case 2:
            if(IS_IPHONE5){
                return 45.0;
            } else {
                return 45.0;
            }
        case 3:
            if(IS_IPHONE5){
                return 320.0;
            } else {
                return 250.0;
            }
        case 4:
            if(IS_IPHONE5){
                return 40.0;
            } else {
                return 20.0;
            }
    }
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
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
            [cell.detailsLabel setText:@"User:"];
            NSString* userToReviewString = _userToReview.username;
            [cell.detailsContent setText:userToReviewString];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 1: {
            static NSString *CellIdentifier = @"MyPickStarsTableViewCell";
            PickStarsTableViewCell *cell = (PickStarsTableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickStarsTableViewCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (PickStarsTableViewCell *)currentObject;
                    }
                }
            }
            _starProgressView = cell.starProgressView;
            [_starProgressView setProgress: _starPercentage];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 2: {
            static NSString *CellIdentifier = @"MyStarSliderTableViewCell";
            StarSliderTableViewCell *cell = (StarSliderTableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"StarSliderTableViewCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (StarSliderTableViewCell *)currentObject;
                    }
                }
            }
            _slider = cell.slider;
            _slider.continuous = YES;
            [_slider addTarget:self
                       action:@selector(sliderValueChanged:)
             forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 3: {
            if(IS_IPHONE5){
                static NSString *CellIdentifier = @"MyExtraLongTextEntryCell";
                ExtraLongTextEntryCell *cell = (ExtraLongTextEntryCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ExtraLongTextEntryCell" owner:self options:nil];
                    for (id currentObject in topLevelObjects) {
                        if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                            cell = (ExtraLongTextEntryCell *)currentObject;
                        }
                    }
                }
                [cell.titleLabelView setText:@"Review:"];
                _entryTextView = cell.entryTextView;
                [_entryTextView setDelegate:self];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            } else {
                static NSString *CellIdentifier = @"MyExtraLongText4EntryCell";
                ExtraLongText4EntryCell *cell = (ExtraLongText4EntryCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ExtraLongText4EntryCell" owner:self options:nil];
                    for (id currentObject in topLevelObjects) {
                        if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                            cell = (ExtraLongText4EntryCell *)currentObject;
                        }
                    }
                }
                [cell.titleLabelView setText:@"Review:"];
                _entryTextView = cell.entryTextView;
                [_entryTextView setDelegate:self];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        case 4: {
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (![_navigationTitle compare: @"Complete"]){
                [cell.button setTitle: @"Submit" forState:UIControlStateNormal];
            } else {
                [cell.button setTitle: @"Report" forState:UIControlStateNormal];
            }
            [cell.button addTarget:self
                              action:@selector(submit)
                    forControlEvents:UIControlEventTouchUpInside];
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
            [cell.detailsLabel setText:@"User:"];
            NSString* userToReviewString = _userToReview.username;
            [cell.detailsContent setText:userToReviewString];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    [sender setValue:((int)((sender.value + .1) / .2) * .2) animated:NO];
    _starPercentage = sender.value;
    [_starProgressView setProgress: _starPercentage];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)fieldsValid{
    if (_starPercentage == 0){
        NSLog(@"No Rating");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"'Rating' Missing!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    } else if([_entryTextView.text isEqualToString:@""]){
        NSLog(@"No Review");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"'Review' Missing!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void) submit {
    NSLog(@"Submiting Review");
    if([self fieldsValid]){
        NSString *reviewString = _entryTextView.text;
        NSNumber *rating = [NSNumber numberWithFloat: (10 * _starPercentage)/2];
        NSLog(@"Review: %@", reviewString);
        NSLog(@"Rating: %@", rating);
        
        PFObject *review = [PFObject objectWithClassName:@"Review"];
        PFUser *userDoingReview = [PFUser currentUser];
        
       // review[@"rater"] = userDoingReview;
        review[@"raterString"] = userDoingReview.username;
       // review[@"ratee"] = _userToReview;
        review[@"rateeString"] = _userToReview.username;
        review[@"rating"] = rating;
        review[@"review"] = reviewString;
        
       // if (![_userToReview objectForKey:@"totalRatings"]) {
         //   _userToReview[@"totalRatings"] = @0;
           // _userToReview[@"averageRating"] = @0;
        //}
       /*
        float totalRatings = [[_userToReview objectForKey:@"totalRatings"] floatValue];
        float averageRating = [[_userToReview objectForKey:@"averageRating"] floatValue];
        averageRating = averageRating * totalRatings;
        averageRating = averageRating + ((10 * _starPercentage)/2);
        averageRating = averageRating / (totalRatings + 1);
        NSNumber *averageRatingNumber = [NSNumber numberWithFloat: averageRating];
        */
        //_userToReview[@"averageRating"] = averageRatingNumber;
       // [_userToReview incrementKey:@"totalRatings"];
        //[_userToReview saveInBackground];
        [review saveInBackground];
        
        NSArray *viewControllers = [[self navigationController] viewControllers];
        for(int i=0;i<[viewControllers count];i++){
            id obj=[viewControllers objectAtIndex:i];
            if([obj isKindOfClass:[TaskListViewController class]]){
                [[self navigationController] popToViewController:obj animated:YES];
                return;
            }
        }
    }
}

@end
