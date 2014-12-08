//
//  PickDateCell.m
//  HelpHub
//
//  Created by George Georgaklis on 2/14/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "PickDateCell.h"

@implementation PickDateCell

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
    
    //[self updateDateLabel];
    // Configure the view for the selected state
    
}

-(void)awakeFromNib{
    NSDate *Date=[NSDate date];
    _pickDatePickerView.minimumDate=Date;
}

- (IBAction) getSelection {
    [self updateDateLabel];
}

- (void)updateDateLabel{
    _date = [_pickDatePickerView date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d - h:mm a"];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:_date];
   // NSLog(@"formattedDateString: %@", formattedDateString);
    _dateLabelView.text = formattedDateString;
}

@end
