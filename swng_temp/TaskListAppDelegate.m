//
//  TaskListAppDelegate.m
//  HelpHub
//
//  Created by Nikita Amelchenko on 2/23/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import "TaskListAppDelegate.h"
#import <Parse/Parse.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation TaskListAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xE05920)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [Parse setApplicationId:@"qQ4xCN3sfDS8X5BAgxIIbB3j5ghq8akH3ZLHO7Mq"
                  clientKey:@"aMmcDY6K8AxYPW58AyQGWeMVczKKcrmN5hMk2qLc"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    // Register for push notifications
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }
    else{
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
         UIUserNotificationTypeBadge |
         UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    
    _currentlyMessaging = NO;
    
    if (launchOptions != nil) {
        NSLog(@"opened from push notification");
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil) {
            if([[userInfo objectForKey:@"potentialUserID"] isEqualToString:@"message"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message!" message:[userInfo objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else if([[userInfo objectForKey:@"potentialUserID"] isEqualToString:@"taskCompleted"]){
                //push sent to other user needing to complete task
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Task Completed!" message:@"Please complete the task to finish the transaction." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                _taskID = [userInfo objectForKey:@"taskID"];
                _potentialUserID = [userInfo objectForKey:@"potentialUserID"];
                _didRecieveNotificationWhileClosed = YES;
            }
            else if([[userInfo objectForKey:@"potentialUserID"] isEqualToString:@"rejected"]){
                //acceptor has been rejected
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Task Rejected" message:@"We are sorry but your request has been rejected." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                _taskID = [userInfo objectForKey:@"taskID"];
                
                PFQuery *query = [PFQuery queryWithClassName:@"Task"];
                [query getObjectInBackgroundWithId:_taskID block:^(PFObject *object, NSError *error) {
                    if(!error) {
                        PFObject *task = object;
                        NSString* channelID = @"acceptorChannelID_";
                        channelID = [channelID stringByAppendingString:[task objectId]];
                        NSLog(@"channelID: %@",channelID);
                        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                        [currentInstallation removeObject:channelID forKey:@"channels"];
                        [currentInstallation saveInBackground];
                    }
                    else{
                        NSLog(@"%@",error);
                    }
                }];
            }
            else if(![[userInfo objectForKey:@"potentialUserID"] isEqualToString:@"none"]){
                //if push is sent to poster
                NSLog(@"Task ID: %@",_taskID);
                NSLog(@"new tip?: %@",[userInfo objectForKey:@"newtip"]);
                if([userInfo objectForKey:@"newtip"] != NULL){
                    _taskID = [userInfo objectForKey:@"taskID"];
                    _potentialUserID = [userInfo objectForKey:@"potentialUserID"];
                    _newtip = [userInfo objectForKey:@"newtip"];
                    _didRecieveNotificationWhileClosed = YES;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Task Requested with New Tip!" message:@"Check your Task List for the requested task." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Task Requested!" message:@"Check your Task List for the requested task." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    _taskID = [userInfo objectForKey:@"taskID"];
                    _potentialUserID = [userInfo objectForKey:@"potentialUserID"];
                    _didRecieveNotificationWhileClosed = YES;
                    //NSLog(@"Task ID: %@",_taskID);
                }
            }
            else{
                //if push is sent to accepted acceptor
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Task Accepted!" message:@"Check your Task List for the accepted task." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                _taskID = [userInfo objectForKey:@"taskID"];
                _potentialUserID = [userInfo objectForKey:@"potentialUserID"];
                _didRecieveNotificationWhileClosed = YES;
                //NSLog(@"Task ID: %@",_taskID);
            }
        }
    }
    else{
        _didRecieveNotificationWhileClosed = NO;
        _taskID = @"did not get taskID";
        _potentialUserID = @"did not get potentialUserID";
    }
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"did receive remote notification");
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    if([[userInfo objectForKey:@"potentialUserID"] isEqualToString:@"message"]){
        //message
        if(!_currentlyMessaging){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message!" message:[userInfo objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        NSLog(@"reloading data");
        [(ChatViewController*)_chatController loadLocalChat];
        
    }
    else if([[userInfo objectForKey:@"potentialUserID"] isEqualToString:@"taskCompleted"]){
        //task has been completed
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Task Completed!" message:@"Please complete the task to finish the transaction." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        _taskID = [userInfo objectForKey:@"taskID"];
        _potentialUserID = [userInfo objectForKey:@"potentialUserID"];
        _didRecieveNotificationWhileInBackground = YES;
    }
    else if([[userInfo objectForKey:@"potentialUserID"] isEqualToString:@"rejected"]){
        //acceptor has been rejected
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Task Rejected" message:@"We are sorry but your request has been rejected." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        _taskID = [userInfo objectForKey:@"taskID"];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Task"];
        [query includeKey:@"poster"];
        [query includeKey:@"acceptor"];
        [query getObjectInBackgroundWithId:_taskID block:^(PFObject *object, NSError *error) {
            if(!error) {
                //remove channel
                PFObject *task = object;
                NSString* channelID = @"acceptorChannelID_";
                channelID = [channelID stringByAppendingString:[task objectId]];
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation removeObject:channelID forKey:@"channels"];
                [currentInstallation saveInBackground];
            }
            else{
                NSLog(@"%@",error);
            }
        }];
    }
    else if(![[userInfo objectForKey:@"potentialUserID"] isEqualToString:@"none"]){
        //if push is sent to poster
        _taskID = [userInfo objectForKey:@"taskID"];
        _potentialUserID = [userInfo objectForKey:@"potentialUserID"];
        _newtip = [userInfo objectForKey:@"newtip"];
        _didRecieveNotificationWhileInBackground = YES;
        
        NSLog(@"Task ID: %@",_taskID);
        
        if(_newtip != NULL) {
            NSLog(@"new tip: %@",_newtip);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Task Requested with New Tip!" message:@"Check your Task List for the requested task." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Task Requested!" message:@"Check your Task List for the requested task." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        }
    }
    else{
        //if push is sent to accepted acceptor
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Task Accepted!" message:@"Check your Task List for the accepted task." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        _taskID = [userInfo objectForKey:@"taskID"];
        _potentialUserID = [userInfo objectForKey:@"potentialUserID"];
        _didRecieveNotificationWhileInBackground = YES;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
