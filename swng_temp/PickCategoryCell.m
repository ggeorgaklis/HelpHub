//
//  PickCategoryCell.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/10/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "PickCategoryCell.h"

@implementation PickCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) awakeFromNib {
    // Initialization code
    _pickCategoryPickerView.delegate = self;
    _pickCategoryPickerView.dataSource = self;
    _categoryArray = [[NSArray alloc] initWithObjects:@"Food Delivery", @"Grocery Shopping", @"Cleaning Service", @"Tutoring", @"Carpool", @"Other", nil];
}


#pragma mark - UIPickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_categoryArray count];
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_categoryArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Chosen item: %@", [_categoryArray objectAtIndex:row]);
    _currentCategory = (NSString *)[_categoryArray objectAtIndex:row];
    //_categoryLabelView.text = _currentCategory;
    [_categoryLabelView setText:_currentCategory];
    
   // NSLog(@"Current Category Label: %@",_categoryLabelView.text);
    
}

-(void)updateCurrentCategory{
    [_categoryLabelView setText:_currentCategory];
}
/*
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [_categoryArray objectAtIndex:row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xE05920)}];
    return attString;
    
}*/

@end
