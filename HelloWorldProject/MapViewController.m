//
//  MapTabViewController.m
//  HelloWorldProject
//
//  Created by Peachey, Joseph on 5/26/15.
//  Copyright (c) 2015 That Peachey Thing, LLC. All rights reserved.
//

#define JSON_URL @"http://www.helloworld.com/helloworld_locations.json"

#import "MapViewController.h"
#import "LocationInformation.h"
#import "LocationDetailsViewController.h"
#import "AnnotationInformation.h"
#import "TableViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    
    // Check for user location
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
        self.mapView.showsUserLocation = YES;
        
    }
    
    //Load JSON Data
    NSURL *contactURL = [NSURL URLWithString:JSON_URL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:contactURL];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [self.activityIndicator startAnimating];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         if (!error && data!=nil){
            [defaults setObject:data forKey:@"JSON_Data"];
            [self loadJsonData:data];
         }
         else {
            NSData *jsonData = [defaults objectForKey:@"JSON_Data"];
             if(jsonData){
                 [self loadJsonData:jsonData];
             }
             else {
                 UIAlertView *alert = [[UIAlertView alloc] initWithFrame:CGRectMake(50, 150, 250, 150)];
                 alert.title = @"Please check your connection and try again.";
                 [alert show];
             }
         }
     }];
    
    // Change the Navigation Bar item to a list image using Font Awesome
    self.flipMap.title = @"\uf0ca";
    UIFont *font = [UIFont fontWithName:@"FontAwesome" size:26.0];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    [self.flipMap setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
}

-(void)loadJsonData:(NSData *)jsonData {
    NSError *error = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization
                                    JSONObjectWithData:jsonData options:0 error:&error];
    
    //Temporary Array to hold the locations
    NSMutableArray *tempLocationArray = [[NSMutableArray alloc] initWithArray:[dataDictionary objectForKey:@"locations"]];
    
    for(int x = 0; x<[tempLocationArray count]; x++) {
        
        //Calculate the users location and distance from pin
        CLLocation *pinLocation = [[CLLocation alloc] initWithLatitude:[[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"latitude"] doubleValue]
                                                             longitude:[[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"latitude"] doubleValue]];
        
        CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:self.locationManager.location.coordinate.latitude
                                                              longitude:self.locationManager.location.coordinate.longitude];
        
        CLLocationDistance distance = [pinLocation distanceFromLocation:userLocation];
        
        NSString *tempDistance = [NSString stringWithFormat:@"%.1fmi",(distance/1609.344)];
        
        
        // Load location data into object
        AnnotationInformation *currentLocation = [[AnnotationInformation alloc] initWithTitle:[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"name"]
                                                                                         Name:[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"name"]
                                                                                      Address:[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"address"]
                                                                                     Address2:[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"address2"]
                                                                                         City:[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"city"]
                                                                                        State:[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"state"]
                                                                                          Zip:[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"zip_postal_code"]
                                                                                        Phone:[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"phone"]
                                                                                          Fax:[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"fax"]
                                                                                     Latitude:[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"latitude"]
                                                                                    Longitude:[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"longitude"]
                                                                                  OfficeImage:[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"office_image"]
                                                                                     Distance:tempDistance];
        
        
        [self.locationArray addObject:currentLocation];
    }
    
    [self showOfficeLocation];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        [self.mapView setCenterCoordinate:self.mapView.region.center animated:NO];
    });
}

//Add the location marker and annotations to the map
- (void)showOfficeLocation {
    for(int x = 0; x < [self.locationArray count]; x++){
        [self.mapView addAnnotation:self.locationArray[x]];
    }
}

-(NSMutableArray *)locationArray{
    if(!_locationArray) _locationArray = [[NSMutableArray alloc]init];
    return _locationArray;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation){
        return nil; //default to blue dot
    }
    else {
        MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
        
        annotationView.image = [UIImage imageNamed:@"logo-nav.png"];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.frame = CGRectMake(0, 0, 60, 60);
        
        return annotationView;
    }
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"mapDetails" sender:view];
}

//Pass location details to the LocationDetailsViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MKAnnotationView *annotateView = sender;
    if ([[segue identifier] isEqualToString:@"mapDetails"])
    {
        LocationDetailsViewController *detailViewController = [segue destinationViewController];
        
        AnnotationInformation *currentLocation = annotateView.annotation;
        
        //Array to pass on to LocationDetailsViewController
        detailViewController.locationDetails = [[NSArray alloc] initWithObjects:currentLocation.name, currentLocation.address, currentLocation.address2, currentLocation.city, currentLocation.state, currentLocation.zip,currentLocation.officeImage, currentLocation.latitude, currentLocation.longitude, currentLocation.phone, currentLocation.distance, nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
