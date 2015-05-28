//
//  TableTabViewController.h
//  HelloWorldProject
//
//  Created by Peachey, Joseph on 5/26/15.
//  Copyright (c) 2015 That Peachey Thing, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TableViewController : UITableViewController <CLLocationManagerDelegate>

@property (nonatomic,strong) NSMutableArray *locationArray;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *sortedArray;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *flipToMap;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

-(IBAction)flipToMap:(id)sender;

@end
