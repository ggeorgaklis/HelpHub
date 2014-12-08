//
//  PickCategoryTextCell.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/12/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickCategoryTextCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *categoryLabelView;

-(void)updateLabel: (NSString*)selectedCategory;
@end
