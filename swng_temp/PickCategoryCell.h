//
//  PickCategoryCell.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/10/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface PickCategoryCell : UITableViewCell<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIPickerView *pickCategoryPickerView;
@property (strong, nonatomic) NSArray *categoryArray;
@property (strong, nonatomic) NSString *currentCategory;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabelView;

-(void)updateCurrentCategory;

@end
