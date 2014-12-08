//
//  SettingsViewController.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/18/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _signOutButton.layer.cornerRadius = 4.0f;
    _signOutButton.layer.borderWidth = 1.0f;
    _signOutButton.layer.borderColor = UIColorFromRGB(0x5FC9D3).CGColor;
    
    _profileButton.layer.cornerRadius = 4.0f;
    _profileButton.layer.borderWidth = 1.0f;
    _profileButton.layer.borderColor = UIColorFromRGB(0x5FC9D3).CGColor;
    
    _user = [PFUser currentUser];
    //[_user refresh];
}
- (IBAction)signOut:(id)sender {
    [PFUser logOut];
}

- (IBAction)viewProfile:(id)sender {
    [self performSegueWithIdentifier:@"ProfileSegue" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:nil action:nil];
    if([segue.identifier isEqualToString:@"ProfileSegue"]){
        ProfileViewController *controller = (ProfileViewController *)segue.destinationViewController;
        controller.user = _user;
    }
    [[self navigationItem] setBackBarButtonItem:backButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
