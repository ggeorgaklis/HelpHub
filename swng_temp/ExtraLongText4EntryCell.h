//
//  ExtraLongText4EntryCell.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 4/8/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ExtraLongText4EntryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabelView;
@property (strong, nonatomic) IBOutlet UITextView *entryTextView;

@end

