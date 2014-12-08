//
//  MessageCell2.h
//  HelpHub
//
//  Created by George Georgaklis on 4/24/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell2 : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UITextView *textString;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
