//
//  AddressAnnotation.m
//  HelpHub
//
//  Created by George Georgaklis on 11/10/14.
//  Copyright (c) 2014 HelpHub. All rights reserved.
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation

- (NSString *)subtitle{
    return nil;
}

- (NSString *)title{
    return _title;
}

-(NSString *)taskID{
    return _taskID;
}

- (CLLocationCoordinate2D)coordinate{
    return _coordinate;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)c{
    _coordinate = c;
    return self;
}

@end