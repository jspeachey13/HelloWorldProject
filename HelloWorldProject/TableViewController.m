//
//  TableTabViewController.m
//  HelloWorldProject
//
//  Created by Peachey, Joseph on 5/26/15.
//  Copyright (c) 2015 That Peachey Thing, LLC. All rights reserved.
//

#define JSON_URL @"http://www.helloworld.com/helloworld_locations.json"

#import "TableViewController.h"
#import "LocationTableViewCell.h"
#import "LocationDetailsViewController.h"
#import "LocationInformation.h"

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Check for user location
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
        
    }
    
    //Load JSON Data
    NSURL *contactURL = [NSURL URLWithString:JSON_URL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:contactURL];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    self.activityIndicator.frame = self.tableView.bounds;
    
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
    
    // Change the Navigation Bar item to a map marker image using Font Awesome
    self.flipToMap.title = @"\uf041";
    UIFont *font = [UIFont fontWithName:@"FontAwesome" size:26.0];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    [self.flipToMap setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
}


-(NSMutableArray *)locationArray{
    if(!_locationArray) _locationArray = [[NSMutableArray alloc]init];
    return _locationArray;
}

-(NSMutableArray *)sortedArray{
    if(!_sortedArray) _sortedArray = [[NSMutableArray alloc]init];
    return _sortedArray;
}

-(void)loadJsonData:(NSData *)jsonData  {
    
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
        LocationInformation *currentContact = [[LocationInformation alloc] initWithName:[[dataDictionary objectForKey:@"locations"][x] objectForKey:@"name"]
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
        
        
        [self.locationArray addObject:currentContact];
    }
    
    // Sort the table cells according to distance from user
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]];
    NSArray *tempSortedArray = [self.locationArray sortedArrayUsingDescriptors:sortDescriptors];
    
    self.sortedArray = [tempSortedArray mutableCopy];
    
    // Reload Table View
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        [self.tableView reloadData];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    });
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sortedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"locationTableCell";
    
    LocationTableViewCell *cell = [tableView
                                  dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[LocationTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    LocationInformation *currentContact = [self.sortedArray objectAtIndex:indexPath.row];
    
    cell.locationName.text = currentContact.name;
    cell.locationAddress.text = currentContact.address;
    cell.locationAddressTwo.text = currentContact.address2;
    cell.locationCityStateZip.text = [NSString stringWithFormat:@"%@, %@ %@", currentContact.city, currentContact.state, currentContact.zip];
    cell.locationDistance.text = currentContact.distance;
    
    if(indexPath.row % 2 == 0){
        cell.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:.30];
    }
    else {
        cell.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:.10];
    }
    
    return cell;
}


// Pass location details to the LocationDetailsViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showLocationDetails"])
    {
        LocationDetailsViewController *detailViewController =
        [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView
                                    indexPathForSelectedRow];
        
        LocationInformation *currentLocation = [self.sortedArray objectAtIndex:myIndexPath.row];
        
        //Array to pass on to LocationDetailsViewController
        detailViewController.locationDetails = [[NSArray alloc] initWithObjects:currentLocation.name, currentLocation.address, currentLocation.address2, currentLocation.city, currentLocation.state, currentLocation.zip,currentLocation.officeImage, currentLocation.latitude, currentLocation.longitude, currentLocation.phone, currentLocation.distance, nil];
    }
}

//Flip back to map view
-(IBAction)flipToMap:(id)sender
{
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
    [self.navigationController popViewControllerAnimated:NO];
}

@end