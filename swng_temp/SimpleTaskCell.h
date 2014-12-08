//
//  SimpleTaskCell.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/9/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTaskCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *taskCategoryView;
@property (strong, nonatomic) IBOutlet UILabel *taskDescriptionView;
@property (strong, nonatomic) IBOutlet UILabel *taskLocationView;
@property (strong, nonatomic) IBOutlet UILabel *taskCostView;
@property (strong, nonatomic) IBOutlet UILabel *taskTimeStartView;
@property (strong, nonatomic) IBOutlet UILabel *taskTimeEndView;
@property (strong, nonatomic) NSString *taskID;
@property BOOL taskAccepted;

@end
