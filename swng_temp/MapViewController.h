//
//  MapViewController.h
//  HelpHub
//
//  Created by George Georgaklis on 11/6/14.
//  Copyright (c) 2014 HelpHub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import "AddressAnnotation.h"

@interface MapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *map;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *locationDesc;

@end
