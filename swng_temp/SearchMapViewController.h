//
//  SearchMapViewController.h
//  HelpHub
//
//  Created by George Georgaklis on 11/11/14.
//  Copyright (c) 2014 HelpHub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import "AddressAnnotation.h"
#import "TaskListAppDelegate.h"

@interface SearchMapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UITextField *searchField;


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;


@end
