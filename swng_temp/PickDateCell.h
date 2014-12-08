//
//  PickDateCell.h
//  HelpHub
//
//  Created by George Georgaklis on 2/14/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickDateCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIDatePicker *pickDatePickerView;
@property (strong, nonatomic) NSString *currentDate;
@property (strong, nonatomic) IBOutlet UILabel *dateLabelView;
@property (strong, nonatomic) NSDate *date;

-(IBAction) getSelection;

-(void)updateDateLabel;

@end
