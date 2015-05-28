//
//  LocationInformation.h
//  HelloWorldProject
//
//  Created by Peachey, Joseph on 5/26/15.
//  Copyright (c) 2015 That Peachey Thing, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationInformation : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zip;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *fax;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *officeImage;
@property (strong, nonatomic) NSString *distance;


-(instancetype)initWithName:(NSString *)name
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
                   Distance:(NSString *)distance;


@end
