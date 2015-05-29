//
//  MapTabViewController.h
//  HelloWorldProject
//
//  Created by Peachey, Joseph on 5/26/15.
//  Copyright (c) 2015 That Peachey Thing, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic,strong) NSMutableArray *locationArray;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *flipMap;

@property (nonatomic, strong) IBOutlet UIButton *locateUserButton;

-(IBAction)locateUserButtonPressed:(id)sender;

@end

