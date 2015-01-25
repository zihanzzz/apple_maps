//
//  CoordinateViewController.m
//  Maps
//
//  Created by James Zhou on 1/24/15.
//  Copyright (c) 2015 James Zhou. All rights reserved.
//

#import "CoordinateViewController.h"

@interface CoordinateViewController ()

@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UILabel* latitudeLabel;
@property (strong, nonatomic) UILabel* longitudeLabel;
@property (strong, nonatomic) UILabel* addressLabel;

@property (strong, nonatomic) UILabel* latitudeDataLabel;
@property (strong, nonatomic) UILabel* longitudeDataLabel;
@property (strong, nonatomic) UILabel* addressDataLabel;

@property (strong, nonatomic) UIButton* getLocationButton;

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CLGeocoder* geocoder;
@property (strong, nonatomic) CLPlacemark* placemark;

@end

@implementation CoordinateViewController

- (void)viewDidLoad {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.geocoder = [[CLGeocoder alloc] init];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 75, 225, 75)];
    [self.titleLabel setText:@"Coordinate & Address"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.f]];
    
    // latitude
    self.latitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 175, 100, 50)];
    [self.latitudeLabel setText:@"Latitude:"];
    [self.latitudeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.f]];
    self.latitudeLabel.textAlignment = NSTextAlignmentLeft;
    
    self.latitudeDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 175, 150, 50)];
    [self.latitudeDataLabel setText:@"latitude value"];
    self.latitudeDataLabel.textAlignment = NSTextAlignmentLeft;
    
    
    // longitude
    self.longitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 250, 100, 50)];
    [self.longitudeLabel setText:@"Longitude:"];
    [self.longitudeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.f]];
    self.longitudeLabel.textAlignment = NSTextAlignmentLeft;
    
    self.longitudeDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 250, 150, 50)];
    [self.longitudeDataLabel setText:@"longitude value"];
    self.longitudeDataLabel.textAlignment = NSTextAlignmentLeft;
    
    // address
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 325, 100, 50)];
    [self.addressLabel setText:@"Address:"];
    [self.addressLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.f]];
    self.addressLabel.textAlignment = NSTextAlignmentLeft;
    
    self.addressDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 275, 200, 200)];
    [self.addressDataLabel setText:@"address"];
    self.addressDataLabel.textAlignment = NSTextAlignmentLeft;
//    self.addressDataLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.addressDataLabel.numberOfLines = 4;
    
    
    // getLocationButton
    self.getLocationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.getLocationButton.frame = CGRectMake(50, 450, 275, 50);
    [self.getLocationButton setBackgroundColor:[UIColor purpleColor]];
    [self.getLocationButton setTitle:@"Get Location" forState:UIControlStateNormal];
    [self.getLocationButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.f]];
    [self.getLocationButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.getLocationButton.layer setCornerRadius:10.f];
    [self.getLocationButton addTarget:self action:@selector(getLocation) forControlEvents:UIControlEventTouchDown];
    
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.latitudeLabel];
    [self.view addSubview:self.latitudeDataLabel];
    [self.view addSubview:self.longitudeLabel];
    [self.view addSubview:self.longitudeDataLabel];
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.addressDataLabel];
    
    [self.view addSubview:self.getLocationButton];
    
}

-(void)getLocation
{
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Failed to get your location"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSUInteger arraySize = [locations count];
    CLLocation *currentLocation = [locations objectAtIndex:arraySize-1];
    
    NSLog(@"didUpdateToLocation: %@", currentLocation);
    
    if (currentLocation != nil) {
        self.latitudeDataLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        self.longitudeDataLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    }
    
    // Reverse GeoCoding
    NSLog(@"Resolving the Address");
    [self.geocoder reverseGeocodeLocation:currentLocation
completionHandler:^(NSArray *placemarks, NSError *error) {
    NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
    
    if (error == nil && [placemarks count] > 0) {
        self.placemark = [placemarks lastObject];
        self.addressDataLabel.text = [NSString stringWithFormat:@"%@ %@\n%@, %@\n%@\n%@",
                             self.placemark.subThoroughfare, self.placemark.thoroughfare,
                             self.placemark.locality, self.placemark.administrativeArea,
                             self.placemark.postalCode,
                             self.placemark.country];
    } else {
        NSLog(@"%@", error.debugDescription);
    }
    
    
    }];
    
    
    
}






























@end
