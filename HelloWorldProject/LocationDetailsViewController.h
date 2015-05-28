//
//  LocationDetailsViewController.h
//  HelloWorldProject
//
//  Created by Peachey, Joseph on 5/26/15.
//  Copyright (c) 2015 That Peachey Thing, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface LocationDetailsViewController : UITableViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) NSArray *locationDetails;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet MKMapView *officeMap;

@property (strong, nonatomic) IBOutlet UIImageView *officeImageView;

@property (strong, nonatomic) IBOutlet UIButton *callButton;
@property (strong, nonatomic) IBOutlet UIButton *directionButton;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel2;
@property (strong, nonatomic) IBOutlet UILabel *cityStateZipLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@property (strong, nonatomic) NSString *imageURLString;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

-(IBAction)callButtonPressed:(id)sender;
-(IBAction)directionsButtonPressed:(id)sender;

@end