//
//  AddressAnnotation.h
//  HelpHub
//
//  Created by George Georgaklis on 11/10/14.
//  Copyright (c) 2014 HelpHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AddressAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D _coordinate;
    NSString *_title;
}

@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSString *taskID;

-(id)initWithCoordinate:(CLLocationCoordinate2D)c;

@end