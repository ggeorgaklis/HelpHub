//
//  TaskMapViewController.m
//  HelpHub
//
//  Created by George Georgaklis on 11/25/14.
//  Copyright (c) 2014 HelpHub. All rights reserved.
//

#import "TaskMapViewController.h"
#define METERS_PER_MILE 1609.344

@interface TaskMapViewController ()

@end

@implementation TaskMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    
    _map.delegate = self;
    _map.showsUserLocation = YES;
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [_map removeAnnotations:_map.annotations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [_map removeAnnotations:_map.annotations];
    _currentLocation = _locationManager.location;
    CLLocationCoordinate2D zoomLocation;
    //zoomLocation.latitude = _currentLocation.coordinate.latitude;
    //zoomLocation.longitude = _currentLocation.coordinate.longitude;
    zoomLocation.latitude = 41.698108;
    zoomLocation.longitude = -86.222513;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance (zoomLocation, 2.8*METERS_PER_MILE, 2.8*METERS_PER_MILE);
    
    [_map setRegion:viewRegion animated:YES];
    
    NSLog(@"array count %d",_locationArray.count);
    //use for loop to add pin for each task
    for(int i=0; i<_locationArray.count; i++) {
        CLLocation *location = [_locationArray objectAtIndex:i];
        NSString *taskID = [_taskIDArray objectAtIndex:i];
        
        //add pin
        CLLocationCoordinate2D coord;
        coord.latitude = location.coordinate.latitude;
        coord.longitude = location.coordinate.longitude;
        
        AddressAnnotation *address = [[AddressAnnotation alloc] initWithCoordinate:coord];
        [address setTaskID:taskID];
        NSLog(@"add %@",taskID);
        
        [_map addAnnotation:address];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"annotation selected");
    AddressAnnotation *address = (AddressAnnotation *)view.annotation;
    _currentTaskID = [address taskID];
    [self performSegueWithIdentifier:@"TaskSegue" sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TaskSegue"]) {
        TaskController *controller = (TaskController *)segue.destinationViewController;
        controller.taskID = _currentTaskID;
        controller.taskDisplayButtonType = TASK_REQUEST;
        controller.fromYourTasksPage = NO;
        controller.taskIDArray = _taskIDArray;
        controller.locationArray = _locationArray;
    }
}

@end
