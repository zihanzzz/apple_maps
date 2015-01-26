//
//  MapsViewController.m
//  Maps
//
//  Created by James Zhou on 1/24/15.
//  Copyright (c) 2015 James Zhou. All rights reserved.
//

#import "MapsViewController.h"

@interface MapsViewController ()

@property (strong, nonatomic) MKMapView* mapView;
@property (strong, nonatomic) MKPointAnnotation* point;

@property (strong, nonatomic) CLGeocoder* geocoder;
@property (strong, nonatomic) CLPlacemark* placemark;

@end


@implementation MapsViewController

- (void) viewDidLoad
{
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 44, 375, 375)];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    self.geocoder = [[CLGeocoder alloc] init];
    
    [self.view addSubview:self.mapView];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    if (self.point == nil) {
        self.point = [[MKPointAnnotation alloc] init];
    }
    self.point.coordinate = userLocation.coordinate;
    self.point.title = @"Which city is it here?";
    
    [self.geocoder reverseGeocodeLocation:userLocation.location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
                            
                            if (error == nil && [placemarks count] > 0) {
                                self.placemark = [placemarks lastObject];
                                self.point.subtitle = [NSString stringWithFormat:@"It's %@, %@!", self.placemark.locality, self.placemark.administrativeArea];
                                
                            } else {
                                NSLog(@"%@", error.debugDescription);
                            }
                            
                            
                        }];
    
    
    
    [self.mapView addAnnotation:self.point];
    
    
}







@end
