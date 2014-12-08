//
//  NegotiateViewController.m
//  HelpHub
//
//  Created by George Georgaklis on 10/15/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "NegotiateViewController.h"

@interface NegotiateViewController ()

@end

@implementation NegotiateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Negotiate task with ID: %@",_taskID);
    
    [_tipTextField setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedSubmit{
    _tipTextField.text =[@"$" stringByAppendingString:_tipTextField.text];
    NSLog(@"pressed submit with tip: %@",_tipTextField.text);
    
    NSLog(@"Requsting Task");
    if([_currentTask[@"requested"] boolValue] == NO){
        _currentTask[@"requested"] = @YES;
        [_currentTask saveInBackground];
        
        NSString *potentialUserID = [[PFUser currentUser] objectId];
        NSDictionary *data = @{
                               @"alert": @"Your task has been requested!",
                               @"taskID": _taskID, @"potentialUserID":potentialUserID, @"newtip":_tipTextField.text
                               };
        NSLog(@"pushing");
        NSString* channelID = @"posterChannelID_";
        channelID = [channelID stringByAppendingString:[_currentTask objectId]];
        PFPush *push = [[PFPush alloc] init];
        [push setData:data];
        [push setChannel:channelID];
        [push sendPushInBackground];
        
        //acceptor register for push
        channelID = @"acceptorChannelID_";
        channelID = [channelID stringByAppendingString:[_currentTask objectId]];
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addObject:channelID forKey:@"channels"];
        [currentInstallation saveInBackground];
        
        if(![_tipTextField.text isEqualToString:@""]){
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
