//
//  LocationTableViewCell.h
//  HelloWorldProject
//
//  Created by Peachey, Joseph on 5/26/15.
//  Copyright (c) 2015 That Peachey Thing, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *locationName;
@property (nonatomic, strong) IBOutlet UILabel *locationAddress;
@property (nonatomic, strong) IBOutlet UILabel *locationAddressTwo;
@property (nonatomic, strong) IBOutlet UILabel *locationCityStateZip;
@property (nonatomic, strong) IBOutlet UILabel *locationDistance;

@end
