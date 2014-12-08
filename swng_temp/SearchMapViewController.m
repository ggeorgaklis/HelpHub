//
//  SearchMapViewController.m
//  HelpHub
//
//  Created by George Georgaklis on 11/11/14.
//  Copyright (c) 2014 HelpHub. All rights reserved.
//

#import "SearchMapViewController.h"
#define METERS_PER_MILE 1609.344

@interface SearchMapViewController ()

@end

@implementation SearchMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_searchField setDelegate:self];
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    
    _map.delegate = self;
    _map.showsUserLocation = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    TaskListAppDelegate *appDelegate = (TaskListAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.location = _searchField.text;
    
}

- (void)viewWillAppear:(BOOL)animated {
    _currentLocation = _locationManager.location;
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = _currentLocation.coordinate.latitude;
    zoomLocation.longitude = _currentLocation.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance (zoomLocation, 0.8*METERS_PER_MILE, 0.8*METERS_PER_MILE);
    
    [_map setRegion:viewRegion animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"annotation selected");
    _currentLocation = [[CLLocation alloc] initWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
    
    TaskListAppDelegate *appDelegate = (TaskListAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.selectedLocation = _currentLocation;
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Choose this location?" message: @"Are you sure you want to choose this location?" delegate: self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"pressed Yes");
        NSLog(@"selected lat: %f", _currentLocation.coordinate.latitude);
        NSLog(@"selected long: %f", _currentLocation.coordinate.longitude);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"pressed No");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"searching for %@", _searchField.text);
    [textField resignFirstResponder];
    
    // Create and initialize a search request object.
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = _searchField.text;
    request.region = self.map.region;
    
    // Create and initialize a search object.
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    // Start the search and display the results as annotations on the map.
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSMutableArray *placemarks = [NSMutableArray array];
        for (MKMapItem *item in response.mapItems) {
            [placemarks addObject:item.placemark];
        }
        [_map removeAnnotations:[self.map annotations]];
        [_map showAnnotations:placemarks animated:NO];
    }];
    return NO;
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
