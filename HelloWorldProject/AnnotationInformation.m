//
//  AnnotationInformation.m
//  HelloWorldProject
//
//  Created by Peachey, Joseph on 5/26/15.
//  Copyright (c) 2015 That Peachey Thing, LLC. All rights reserved.
//

#import "AnnotationInformation.h"

@implementation AnnotationInformation

-(instancetype)initWithTitle:(NSString *)title
                        Name:(NSString *)name
                             Address:(NSString *)address
                          Address2:(NSString *)address2
                          City:(NSString *)city
                            State:(NSString *)state
                         Zip:(NSString *)zip
                        Phone:(NSString *)phone
                        Fax:(NSString *)fax
                      Latitude:(NSString *)latitude
                       Longitude:(NSString *)longitude
                OfficeImage:(NSString *)officeImage
                    Distance:(NSString *)distance
{
    
    self = [super init];
    if(self){
        self.title = name;
        self.name = name;
        self.address = address;
        self.address2 = address2;
        self.city = city;
        self.state = state;
        self.zip = zip;
        self.phone = phone;
        self.fax = fax;
        self.latitude = latitude;
        self.longitude = longitude;
        self.officeImage = officeImage;
        self.distance = distance;
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"title: %@",self.title];
}


- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [self.latitude doubleValue];
    theCoordinate.longitude = [self.longitude doubleValue];
    return theCoordinate;
}



@end
