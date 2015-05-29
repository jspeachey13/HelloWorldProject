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
    
    // Overlay Office Image
    UIImage *overlayImage = [self tintedImageWithColor:[UIColor colorWithRed:0/255.0f green:136/255.0f blue:199/255.0f alpha:1] image:self.officeImageView.image];
    [self.overlayImageView setImage:overlayImage];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0f green:136/255.0f blue:199/255.0f alpha:1];
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
    NSString *newString = [[self.phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",newString]]];
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

// Create overlay image
- (UIImage *)tintedImageWithColor:(UIColor *)tintColor image:(UIImage *)officeImage
{
    return [self tintedImageWithColor:tintColor blendingMode:kCGBlendModeDestinationIn image:officeImage];
}

- (UIImage *)tintedImageWithColor:(UIColor *)tintColor blendingMode:(CGBlendMode)blendMode image:(UIImage *)officeImage
{
    UIGraphicsBeginImageContextWithOptions(officeImage.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, officeImage.size.width, officeImage.size.height);
    UIRectFill(bounds);
    [officeImage drawInRect:bounds blendMode:blendMode alpha:.75];
    
    if (blendMode != kCGBlendModeDestinationIn)
        [officeImage drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:.75];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

@end
