//
//  SearchViewController.m
//  Maps
//
//  Created by James Zhou on 1/24/15.
//  Copyright (c) 2015 James Zhou. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@property (strong, nonatomic) UITextField* addressField;
@property (strong, nonatomic) MKMapView* mapView;
@property (strong, nonatomic) UIButton* goButton;

@property (strong, nonatomic) CLGeocoder* geocoder;
@property (strong, nonatomic) CLPlacemark* placemark;

@property (strong, nonatomic) MKPointAnnotation* point;

@property (strong, nonatomic) MKRoute* route;
@property (strong, nonatomic) MKPolylineRenderer* routeLineRenderer;
@property (strong, nonatomic) MKPolyline* line;


@property (strong, nonatomic) UILabel* distanceLabel;
@property (strong, nonatomic) UILabel* distanceDataLabel;

@property (strong, nonatomic) UILabel* travelTimeLabel;
@property (strong, nonatomic) UILabel* travelTimeDataLabel;

@property (strong, nonatomic) UILabel* stepsLabel;
@property (strong, nonatomic) UILabel* firstStepDataLabel;
@property (strong, nonatomic) UILabel* dotsLabel;
@property (strong, nonatomic) UILabel* lastStepDataLabel;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 44, 375, 375)];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    self.addressField = [[UITextField alloc] initWithFrame:CGRectMake(15, 30, 280, 44)];
    self.addressField.placeholder = @"   Enter Address...";
    self.addressField.backgroundColor = [UIColor whiteColor];
    self.addressField.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.addressField.layer setCornerRadius:10.f];
    [self.addressField.layer setBorderWidth:2.f];
    self.addressField.delegate = self;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.addressField.leftView = paddingView;
    self.addressField.leftViewMode = UITextFieldViewModeAlways;
    self.addressField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.goButton = [[UIButton alloc] initWithFrame:CGRectMake(310, 30, 50, 44)];
    self.goButton.backgroundColor = [UIColor whiteColor];
    self.goButton.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.goButton.layer setCornerRadius:10.f];
    [self.goButton.layer setBorderWidth:2.f];
    [self.goButton setTitle:@"GO" forState:UIControlStateNormal];
    [self.goButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.f]];
    [self.goButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.goButton addTarget:self action:@selector(clickGoButton) forControlEvents:UIControlEventTouchDown];
    [self.goButton setHidden:YES];
    
    // distance label
    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 420, 100, 44)];
    self.distanceLabel.text = @"Distance:";
    self.distanceLabel.textAlignment = NSTextAlignmentRight;
    
    self.distanceDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 420, 200, 44)];
    
    // travel time label
    self.travelTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 460, 100, 44)];
    self.travelTimeLabel.text = @"ETA:";
    self.travelTimeLabel.textAlignment = NSTextAlignmentRight;
    
    self.travelTimeDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 460, 200, 44)];
    
    // steps label
    self.stepsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 500, 100, 44)];
    self.stepsLabel.text = @"Steps:";
    self.stepsLabel.textAlignment = NSTextAlignmentRight;
    
    self.firstStepDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 500, 300, 44)];
    self.dotsLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 530, 300, 44)];
    self.lastStepDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 560, 300, 44)];

    
    [self.mapView addSubview:self.addressField];
    [self.mapView addSubview:self.goButton];
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.distanceLabel];
    [self.view addSubview:self.distanceDataLabel];
    [self.view addSubview:self.travelTimeLabel];
    [self.view addSubview:self.travelTimeDataLabel];
    [self.view addSubview:self.stepsLabel];
    
    [self.view addSubview:self.firstStepDataLabel];
    [self.view addSubview:self.dotsLabel];
    [self.view addSubview:self.lastStepDataLabel];

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.addressField) {
        [textField resignFirstResponder];
        [self searchAddress:textField];
    }
    return YES;
}

- (void)searchAddress:(UITextField *)sender
{
    if (self.geocoder == nil) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    if (self.point == nil) {
        self.point = [[MKPointAnnotation alloc] init];
    }
    
    [self.geocoder geocodeAddressString:sender.text
                    completionHandler:^(NSArray *placemarks, NSError *error) {
                        if (error) {
                            NSLog(@"%@", error);
                        } else {
                            [self.goButton setHidden:NO];
                            self.placemark = [placemarks lastObject];
                            float spanX = 1.00725;
                            float spanY = 1.00725;
                            MKCoordinateRegion region;
                            region.center.latitude = self.placemark.location.coordinate.latitude;
                            region.center.longitude = self.placemark.location.coordinate.longitude;
                            region.span = MKCoordinateSpanMake(spanX, spanY);
                            [self.mapView setRegion:region animated:YES];
                            
                            self.point.coordinate = self.placemark.location.coordinate;
                        
                            self.point.title = [self.placemark.addressDictionary objectForKey:@"Street"];
                            NSString* city = [self.placemark.addressDictionary objectForKey:@"City"];
                            NSString* state = [self.placemark.addressDictionary objectForKey:@"State"];
                            self.point.subtitle = [NSString stringWithFormat:@"%@, %@", city, state];
                            
                            [self.mapView addAnnotation:self.point];
                            [self.mapView selectAnnotation:self.point animated:YES];
                            
                        }
                    }];
}

- (void)clickGoButton
{
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:self.placemark];
    [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    MKDirections* directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error.description);
        } else {
            if (self.line) {
                [self.mapView removeOverlay:self.line];
            }
            self.route = response.routes.lastObject;
            self.line = self.route.polyline;
            [self.mapView addOverlay:self.route.polyline];
            self.distanceDataLabel.text = [NSString stringWithFormat:@"%0.02f Miles", self.route.distance/1609.344];
            long seconds = lroundf(self.route.expectedTravelTime);
            int hour = seconds / 3600;
            int mins = (seconds % 3600) / 60;
            if (hour == 0) {
            self.travelTimeDataLabel.text = [NSString stringWithFormat:@"%d mins", mins];
            } else {
                self.travelTimeDataLabel.text = [NSString stringWithFormat:@"%d hours %d mins", hour, mins];
            }
            MKRouteStep* firstStep = [self.route.steps firstObject];
            MKRouteStep* lastStep = [self.route.steps lastObject];
            self.firstStepDataLabel.text = firstStep.instructions;
            int stepCount = [self.route.steps count] - 2;
            self.dotsLabel.text = [NSString stringWithFormat:@"%d more steps...", stepCount];
            self.lastStepDataLabel.text = lastStep.instructions;
            
        }
    }];
    
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    self.routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:self.route.polyline];
    self.routeLineRenderer.strokeColor = [UIColor blueColor];
    self.routeLineRenderer.lineWidth = 6;
    return self.routeLineRenderer;
}



@end
