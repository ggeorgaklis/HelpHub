//
//  CreateViewController.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/24/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "CreateViewController.h"

@interface CreateViewController ()

@end

@implementation CreateViewController

typedef enum TextFieldTag : NSInteger TextFieldTag;
enum TextFieldTag : NSInteger {
    DESCRIPTIONFIELDTAG,
    COSTFIELDTAG,
    TIPFIELDTAG,
    LOCATIONFIELDTAG,
    DETAILSFIELDTAG
};

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    if(_didSearch) {
        NSLog(@"did search");
        _didSearch = NO;
        TaskListAppDelegate *appDelegate = (TaskListAppDelegate*)[[UIApplication sharedApplication] delegate];
        [_locationTextField setText:appDelegate.location];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"View did appear");
    _didAppear = YES;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    NSLog(@"View did load");
    [super viewDidLoad];
    _categoryPickerIsShowing = NO;
    _startDatePickerIsShowing = NO;
    _endDatePickerIsShowing = NO;
    _didAppear = NO;
    _madeCells = NO;
    _didSearch = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return 13;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2){
        if(!_categoryPickerIsShowing){
            return 0.0;
        } else {
            return 188.0;
        }
    } else if(indexPath.row == 8){
        if(!_startDatePickerIsShowing){
            return 0.0;
        } else {
            return 188.0;
        }
    } else if(indexPath.row == 10){
        if(!_endDatePickerIsShowing){
            return 0.0;
        } else {
            return 188.0;
        }
    } else if(indexPath.row == 11){
        return 123.0;
    }
    else {
        return 42.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // NSLog(@"cell for row at index path %d",_madeCells);
    switch (indexPath.row) {
        case 0:{
            if(!_madeCells){
                static NSString *CellIdentifier = @"MyNeedWillHelpCell";
                NeedWillHelpCell *cell = (NeedWillHelpCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NeedWillHelpCell" owner:self options:nil];
                    for (id currentObject in topLevelObjects) {
                        if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                            cell = (NeedWillHelpCell *)currentObject;
                            break;
                        }
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                _needWillHelpString = cell.needWillHelpString;
                _needWillHelpCell = cell;
              //  NSLog(@"needwillhelp: %@",_needWillHelpString);
                return cell;
            }
            else{
               // NSLog(@"already made need will help cell");
                return _needWillHelpCell;
            }
        }
        case 1:{
            if(!_madeCells){
                static NSString *CellIdentifier = @"MyPickCategoryTextCell";
                PickCategoryTextCell *cell = (PickCategoryTextCell*) [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickCategoryTextCell" owner:self options:nil];
                    for (id currentObject in topLevelObjects) {
                        if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                            cell = (PickCategoryTextCell *)currentObject;
                            break;
                        }
                    }
                }
                _pickCategoryTextCell = cell;
                return cell;
            }
            else{
                //NSLog(@"already made category text cell");
                return _pickCategoryTextCell;
            }
        }
        case 2:{
            if(_didAppear){
                if(!_madeCells){
                    static NSString *CellIdentifier = @"MyPickCategoryCell";
                    PickCategoryCell *cell = (PickCategoryCell*) [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil) {
                        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickCategoryCell" owner:self options:nil];
                        for (id currentObject in topLevelObjects) {
                            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                                cell = (PickCategoryCell *)currentObject;
                                break;
                            }
                        }
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    _pickCategoryCell = cell;
                    _pickCategoryCell.categoryLabelView = _pickCategoryTextCell.categoryLabelView;
                    _pickCategoryCell.hidden = YES;
                    return cell;
                }
                else{
                    //NSLog(@"already made pick category");
                    return _pickCategoryCell;
                }
            }
        }
        case 3:{
            static NSString *CellIdentifier = @"MyShortTextEntryCell";
            ShortTextEntryCell *cell = (ShortTextEntryCell*) [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShortTextEntryCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (ShortTextEntryCell *)currentObject;
                        break;
                    }
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabelView.text = @"Desciption:";
            _descriptionTextField = cell.inputTextField;
            [_descriptionTextField setDelegate:self];
            [_descriptionTextField setKeyboardType:UIKeyboardTypeAlphabet];
            _descriptionTextField.tag = DESCRIPTIONFIELDTAG;
            return cell;
        }
        case 4:{
            static NSString *CellIdentifier = @"MyShortTextEntryCell";
            ShortTextEntryCell *cell = (ShortTextEntryCell*) [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShortTextEntryCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (ShortTextEntryCell *)currentObject;
                        break;
                    }
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabelView.text = @"Will Cost:";
            _costTextField = cell.inputTextField;
            [_costTextField setDelegate:self];
            [_costTextField setKeyboardType:UIKeyboardTypeDecimalPad];
            _costTextField.tag = COSTFIELDTAG;
            return cell;
        }
        case 5:{
            static NSString *CellIdentifier = @"MyShortTextEntryCell";
            ShortTextEntryCell *cell = (ShortTextEntryCell*) [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShortTextEntryCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (ShortTextEntryCell *)currentObject;
                        break;
                    }
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabelView.text = @"Will Pay:";
            _tipTextField = cell.inputTextField;
            [_tipTextField setDelegate:self];
            [_tipTextField setKeyboardType:UIKeyboardTypeDecimalPad];
            _tipTextField.tag = TIPFIELDTAG;
            return cell;
        }
        case 6:{
            static NSString *CellIdentifier = @"MyShortTextEntryCell";
            ShortTextEntryCell *cell = (ShortTextEntryCell*) [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ShortTextEntryCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (ShortTextEntryCell *)currentObject;
                        break;
                    }
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabelView.text = @"Location:";
            _locationTextField = cell.inputTextField;
            _locationTextField.tag = LOCATIONFIELDTAG;
            [_locationTextField setKeyboardType:UIKeyboardTypeAlphabet];
            [_locationTextField setDelegate:self];
            [_locationTextField setEnabled:NO];
            return cell;
        }
        case 7:{
            if(!_madeCells){
                static NSString *CellIdentifier = @"MyPickDateTextCell";
                PickDateTextCell *cell = (PickDateTextCell*) [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickDateTextCell" owner:self options:nil];
                    for (id currentObject in topLevelObjects) {
                        if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                            cell = (PickDateTextCell *)currentObject;
                            break;
                        }
                    }
                }
                //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                _pickStartDateTextCell = cell;
                _pickStartDateTextCell.startEndLabelView.text = @"Start At:";
                return cell;
            }
            else{
               // NSLog(@"already made end date cell");
                return _pickStartDateTextCell;
            }
        }
        case 8:{
            if(_didAppear){
                if(!_madeCells){
                    static NSString *CellIdentifier = @"MyPickDateCell";
                    PickDateCell *cell = (PickDateCell*) [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil) {
                        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickDateCell" owner:self options:nil];
                        for (id currentObject in topLevelObjects) {
                            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                                cell = (PickDateCell *)currentObject;
                                break;
                            }
                        }
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    _pickStartDateCell = cell;
                    _pickStartDateCell.dateLabelView = _pickStartDateTextCell.dateLabelView;
                    _pickStartDateCell.hidden = YES;
                    //NSLog(@"made a start date cell");
                    return cell;
                }
                else{
                    NSLog(@"already made start date");
                    return _pickStartDateCell;
                }
            }
        }
        case 9:{
            if(!_madeCells){
                static NSString *CellIdentifier = @"MyPickDateTextCell";
                PickDateTextCell *cell = (PickDateTextCell*) [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickDateTextCell" owner:self options:nil];
                    for (id currentObject in topLevelObjects) {
                        if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                            cell = (PickDateTextCell *)currentObject;
                            break;
                        }
                    }
                }
                
                _pickEndDateTextCell = cell;
                _pickEndDateTextCell.startEndLabelView.text = @"Done By:";
                return cell;
            }
            else{
                //NSLog(@"already made end date cell");
                return _pickEndDateTextCell;
            }
        }
        case 10:{
            if(_didAppear){
                if(!_madeCells){
                    static NSString *CellIdentifier = @"MyPickDateCell";
                    PickDateCell *cell = (PickDateCell*) [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil) {
                        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickDateCell" owner:self options:nil];
                        for (id currentObject in topLevelObjects) {
                            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                                cell = (PickDateCell *)currentObject;
                                break;
                            }
                        }
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    _pickEndDateCell = cell;
                    _pickEndDateCell.dateLabelView = _pickEndDateTextCell.dateLabelView;
                    _pickEndDateCell.hidden = YES;
                    _madeCells = YES;
                   // NSLog(@"made an end date cell");
                    return cell;
                }
                else{
                  //  NSLog(@"already made end date");
                    return _pickEndDateCell;                }
            }
        }
        case 11:{
            static NSString *CellIdentifier = @"MyLongTextEntryCell";
            LongTextEntryCell *cell = (LongTextEntryCell*) [self.tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LongTextEntryCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (LongTextEntryCell *)currentObject;
                        break;
                    }
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabelView.text = @"Details:";
            [_detailsTextView setDelegate:self];
            _detailsTextView = cell.entryTextView;
            [_detailsTextView setDelegate:self];
            _detailsTextView.tag = DETAILSFIELDTAG;
            [_detailsTextView setKeyboardType:UIKeyboardTypeAlphabet];
            return cell;
        }
        case 12:{
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
            _submitButton = cell.button;
            [_submitButton addTarget:self
                              action:@selector(createTask)
                    forControlEvents:UIControlEventTouchUpInside];
            _submitButtonCell = cell;
            return cell;
        }
        default:{
            static NSString *CellIdentifier = @"MyNeedWillHelpCell";
            NeedWillHelpCell *cell = (NeedWillHelpCell*) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NeedWillHelpCell" owner:self options:nil];
                for (id currentObject in topLevelObjects) {
                    if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                        cell = (NeedWillHelpCell *)currentObject;
                        break;
                    }
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

#pragma show/hide pickers

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //doing this to connect needWillHelpString since it doesn't work initially
    _needWillHelpString = _needWillHelpCell.needWillHelpString;
    if(indexPath.row == 1) {
        NSLog(@"Pressed PickCategoryTextCell");
        if (_categoryPickerIsShowing){
            [self hideCategoryPickerCell];
        } else {
            [self showCategoryPickerCell];
        }
        if (_startDatePickerIsShowing){
            [self hideStartDatePickerCell];
        }
        if (_endDatePickerIsShowing){
            [self hideEndDatePickerCell];
        }
    } else if(indexPath.row == 6){
         [self performSegueWithIdentifier:@"SearchSegue" sender:self];
    } else if(indexPath.row == 7){
        NSLog(@"Pressed PickStartDateTextCell");
        if (_startDatePickerIsShowing){
            [self hideStartDatePickerCell];
        } else {
            [self showStartDatePickerCell];
        }
        if (_categoryPickerIsShowing){
            [self hideCategoryPickerCell];
        }
        if (_endDatePickerIsShowing){
            [self hideEndDatePickerCell];
        }
    } else if(indexPath.row == 9){
        NSLog(@"Pressed PickEndDateTextCell");
        if (_endDatePickerIsShowing){
            [self hideEndDatePickerCell];
        }else {
            [self showEndDatePickerCell];
        }
        if (self.categoryPickerIsShowing){
            [self hideCategoryPickerCell];
        }
        if (self.startDatePickerIsShowing){
            [self hideStartDatePickerCell];
        }
    } else {
        if (_endDatePickerIsShowing){
            [self hideEndDatePickerCell];
        } else if (_categoryPickerIsShowing){
            [self hideCategoryPickerCell];
        } else if (_startDatePickerIsShowing){
            [self hideStartDatePickerCell];
        }
    }
    [self.view endEditing:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) showCategoryPickerCell {
    _categoryPickerIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    _pickCategoryCell.hidden = NO;
    _pickCategoryCell.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        _pickCategoryCell.alpha = 1.0f;
    }];
}

- (void) hideCategoryPickerCell {
    _categoryPickerIsShowing = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         _pickCategoryCell.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         _pickCategoryCell.hidden = YES;
                     }];
    if([_pickCategoryTextCell.categoryLabelView.text  isEqual: @""]){
        _pickCategoryCell.currentCategory = @"Food Delivery";
        [_pickCategoryTextCell updateLabel:@"Food Delivery"];
    }
}

- (void) showStartDatePickerCell {
    _startDatePickerIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    _pickStartDateCell.hidden = NO;
    _pickStartDateCell.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        _pickStartDateCell.alpha = 1.0f;
    }];
}

- (void) hideStartDatePickerCell {
    if([_pickStartDateCell.dateLabelView.text isEqualToString:@""]){
        [_pickStartDateCell updateDateLabel];
    }
    _startDatePickerIsShowing = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         _pickStartDateCell.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         _pickStartDateCell.hidden = YES;
                     }];
    _startDate = _pickStartDateCell.date;
}

- (void) showEndDatePickerCell {
    _endDatePickerIsShowing = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    _pickEndDateCell.hidden = NO;
    _pickEndDateCell.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        _pickEndDateCell.alpha = 1.0f;
    }];
}

- (void) hideEndDatePickerCell {
    if([_pickEndDateTextCell.dateLabelView.text isEqualToString:@""]){
        [_pickEndDateCell updateDateLabel];
    }
    _endDatePickerIsShowing = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         _pickEndDateCell.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         _pickEndDateCell.hidden = YES;
                     }];
    _endDate = _pickEndDateCell.date;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _pickCategoryCell.categoryLabelView = _pickCategoryTextCell.categoryLabelView;
    [_pickCategoryTextCell updateLabel:_pickCategoryCell.currentCategory];
    //NSLog(@"%@",_pickCategoryCell.currentCategory);
    //NSLog(@"start date %@",_startDate);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField.tag == COSTFIELDTAG || textField.tag == TIPFIELDTAG){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 6) ? NO : YES;
    }
    else{
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 21) ? NO : YES;
    }
}

- (void)updateCurrentCategoryLabel:(NSString*) category{
    NSString *currentCategory = _pickCategoryCell.currentCategory;
    [_pickCategoryTextCell updateLabel:currentCategory];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)fieldsValid{
    if([_pickCategoryCell.categoryLabelView.text isEqualToString:@""]){
        NSLog(@"No category selected");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"'Category' Missing!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if([_descriptionTextField.text isEqualToString:@""]){
        NSLog(@"No description entered");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"'Description' Missing!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if([_costTextField.text isEqualToString:@""]){
        NSLog(@"No cost entered");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"'Will Cost' Missing!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if([_tipTextField.text isEqualToString:@""]){
        NSLog(@"No tip entered");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"'Will Pay' Missing!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if([_locationTextField.text isEqualToString:@""]){
        NSLog(@"No location entered");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"'Location' Missing!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval startDateTime = [[_pickStartDateCell.pickDatePickerView date] timeIntervalSince1970];
    NSTimeInterval endDateTime = [[_pickEndDateCell.pickDatePickerView date] timeIntervalSince1970];
    
    if(startDateTime < currentTime){
        NSLog(@"Start date is in the past");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"'Start At' is in the Past!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(endDateTime < currentTime){
        NSLog(@"End date is in the past");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"'Done By' is in the Past!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(startDateTime > endDateTime) {
        NSLog(@"Start date occurs after end date");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Start Occurs After End!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    if(startDateTime == endDateTime){
        NSLog(@"Start date is the same as end date");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"End Occurs At Start!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    _pickCategoryCell.categoryLabelView = _pickCategoryTextCell.categoryLabelView;
    [_pickCategoryTextCell updateLabel:_pickCategoryCell.currentCategory];
}

- (void)createTask {
    _pickCategoryCell.categoryLabelView = _pickCategoryTextCell.categoryLabelView;
    _startDate = _pickStartDateCell.date;
    _endDate = _pickEndDateCell.date;
    
    TaskListAppDelegate *appDelegate = (TaskListAppDelegate*)[[UIApplication sharedApplication] delegate];
    _locationCoord = appDelegate.selectedLocation;
    double lat = _locationCoord.coordinate.latitude;
    double longitude = _locationCoord.coordinate.longitude;
    NSString *latString = [NSString stringWithFormat:@"%f",lat];
    NSString *longString = [NSString stringWithFormat:@"%f",longitude];
//    NSLog(@"lat coordinate: %@",latString);
//    NSLog(@"long coordinate: %@",longString);
    
    if([self fieldsValid]){
        NSLog(@"Creating New Task");
        if(_needWillHelpString == nil){
            _needWillHelpString = @"needHelp";
        }
        
        PFObject *task = [PFObject objectWithClassName:@"Task"];
        PFUser *user = [PFUser currentUser];
       
        task[@"needWillHelp"] = _needWillHelpString;
        task[@"category"] = _pickCategoryCell.categoryLabelView.text;
        task[@"description"] = _descriptionTextField.text;
        task[@"cost"] = [@"$" stringByAppendingString:_costTextField.text];
        task[@"tip"] = [@"$" stringByAppendingString:_tipTextField.text];
        task[@"location"] = _locationTextField.text;
        task[@"locationLat"] = latString;
        task[@"locationLong"] = longString;
        task[@"startTime"] = _startDate;
        task[@"endTime"] = _endDate;
        task[@"requested"] = @NO;
        if([_detailsTextView.text isEqualToString:@""]){
            _detailsTextView.text = @"None";
        }
        task[@"details"] =  _detailsTextView.text;
        task[@"accepted"] = @NO;
        task[@"acceptorCompleted"] = @NO;
        task[@"posterCompleted"] = @NO;
        [task setObject:user forKey:@"poster"];
        [task saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded) {
                NSString* channelID = @"posterChannelID_";
                channelID = [channelID stringByAppendingString:[task objectId]];
                NSLog(@"channel ID: %@",channelID);
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation addUniqueObject:channelID forKey:@"channels"];
                [currentInstallation saveInBackground];
            }
            else{
                NSLog(@"%@",error);
            }
        }];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"SearchSegue"]) {
        SearchMapViewController *controller = (SearchMapViewController *)segue.destinationViewController;
        _didSearch = YES;
        
    }
}

@end