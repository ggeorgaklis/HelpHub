//
//  TaskDetailsViewController.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 3/9/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "TaskDetailsViewController.h"

@interface TaskDetailsViewController ()

@end

@implementation TaskDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"%@",_detailsString);
    [_detailsTextView setText: _detailsString];
    [_detailsText setText:_detailsString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
