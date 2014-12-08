//
//  TaskMapViewController.h
//  HelpHub
//
//  Created by George Georgaklis on 11/25/14.
//  Copyright (c) 2014 HelpHub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import "AddressAnnotation.h"
#import "TaskController.h"

@interface TaskMapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *map;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) NSMutableArray *locationArray;
@property (strong, nonatomic) NSMutableArray *taskIDArray;

@property (strong, nonatomic) NSString *currentTaskID;

@end
