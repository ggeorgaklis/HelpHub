//
//  MapViewController.m
//  HelpHub
//
//  Created by George Georgaklis on 11/6/14.
//  Copyright (c) 2014 HelpHub. All rights reserved.
//

#import "MapViewController.h"
#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    
    _map.delegate = self;
    _map.showsUserLocation = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = _location.coordinate.latitude;
    zoomLocation.longitude = _location.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance (zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    [_map setRegion:viewRegion animated:YES];
    
    //add pin
    CLLocationCoordinate2D coord;
    coord.latitude = _location.coordinate.latitude;
    coord.longitude = _location.coordinate.longitude;
    
    AddressAnnotation *address = [[AddressAnnotation alloc] initWithCoordinate:coord];
    [address setTitle:_locationDesc];
    [_map addAnnotation:address];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"annotation selected");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
