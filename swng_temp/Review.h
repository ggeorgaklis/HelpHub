//
//  Review.h
//  HelpHub
//
//  Created by Nikita Amelchenko on 3/13/14.
//  Copyright (c) 2014 SWNG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Review : NSObject
@property (strong, nonatomic) NSString *review;
@property (strong, nonatomic) NSString *reviewer;
@property int rating;
@end
