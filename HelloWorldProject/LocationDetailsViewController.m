//
//  LocationDetailsViewController.m
//  HelloWorldProject
//
//  Created by Peachey, Joseph on 5/26/15.
//  Copyright (c) 2015 That Peachey Thing, LLC. All rights reserved.
//

#import "LocationDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LocationDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.officeMap.delegate = self;
    self.officeMap.mapType = MKMapTypeStandard;\
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else {
        [self.locationManager startUpdatingLocation];
    }
    
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    [self.locationManager startUpdatingLocation];
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.locationManager startUpdatingLocation];
        self.officeMap.showsUserLocation = YES;
        
    }

    
    // Load labels using JSON data from the TableView
    self.nameLabel.text = [self.locationDetails objectAtIndex:0];
    self.addressLabel.text = [self.locationDetails objectAtIndex:1];
    self.addressLabel2.text = [self.locationDetails objectAtIndex:2];
    self.cityStateZipLabel.text = [NSString stringWithFormat:@"%@, %@ %@", [self.locationDetails objectAtIndex:3], [self.locationDetails objectAtIndex:4], [self.locationDetails objectAtIndex:5]] ;
    self.imageURLString = [self.locationDetails objectAtIndex:6];
    self.latitude = [self.locationDetails objectAtIndex:7];
    self.longitude = [self.locationDetails objectAtIndex:8];
    self.phoneNumber = [self.locationDetails objectAtIndex:9];
    self.distanceLabel.text = [self.locationDetails objectAtIndex:10];


    [self.officeImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLString]
                                placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1] CGColor],(id)[[UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:1] CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
    
    [self.view addSubview:view];
    [self.view insertSubview:view atIndex:0];
    
    self.view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:1];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self showOfficeLocation];
}


- (void)showOfficeLocation {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
    
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = location.coordinate.latitude;
    region.center.longitude = location.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    
    [self.officeMap setRegion:region animated:YES];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = location.coordinate;
    annotation.title = self.nameLabel.text;
    
    [self.officeMap addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation){
        return nil; //default to blue dot
    }
    else {
        MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
        
        annotationView.image = [UIImage imageNamed:@"logo-nav.png"];
        annotationView.frame = CGRectMake(0, 0, 75, 75);
        
        return annotationView;
    }
    
}

-(IBAction)callButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phoneNumber]]];
}


-(IBAction)directionsButtonPressed:(id)sender
{
    
    NSDictionary *address = @{
                              (NSString *)kABPersonAddressStreetKey: self.addressLabel.text,
                              (NSString *)kABPersonAddressCityKey: [self.locationDetails objectAtIndex:3],
                              (NSString *)kABPersonAddressStateKey: [self.locationDetails objectAtIndex:4],
                              (NSString *)kABPersonAddressZIPKey: [self.locationDetails objectAtIndex:5]
                              };
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
    
    
    CLLocationCoordinate2D coords = location.coordinate;
    
    
    MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:coords addressDictionary:address];
    
    MKMapItem *mapItem =[[MKMapItem alloc]initWithPlacemark:place];
    
    NSDictionary *options = @{
                              MKLaunchOptionsDirectionsModeKey:
                                  MKLaunchOptionsDirectionsModeDriving
                              };
    
    [mapItem openInMapsWithLaunchOptions:options];
}


@end
