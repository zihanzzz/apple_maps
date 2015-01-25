//
//  ViewController.m
//  Maps
//
//  Created by James Zhou on 1/24/15.
//  Copyright (c) 2015 James Zhou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIButton* viewCoordinateButton;
@property (strong, nonatomic) UIButton* viewMapButton;
@property (strong, nonatomic) UIButton* searchButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // viewCooridinateButton
    self.viewCoordinateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.viewCoordinateButton.frame = CGRectMake(50, 150, 275, 100);
    [self.viewCoordinateButton setBackgroundColor:[UIColor brownColor]];
    [self.viewCoordinateButton setTitle:@"Coordinate & Address" forState:UIControlStateNormal];
    [self.viewCoordinateButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]];
    [self.viewCoordinateButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.viewCoordinateButton.layer setCornerRadius:10.0f];
    [self.viewCoordinateButton addTarget:self action:@selector(clickViewCoordinate) forControlEvents:UIControlEventTouchDown];
    
    // viewMapButton
    self.viewMapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.viewMapButton.frame = CGRectMake(50, 300, 275, 100);
    [self.viewMapButton setBackgroundColor:[UIColor brownColor]];
    [self.viewMapButton setTitle:@"View Map" forState:UIControlStateNormal];
    [self.viewMapButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]];
    [self.viewMapButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.viewMapButton.layer setCornerRadius:10.0f];
    [self.viewMapButton addTarget:self action:@selector(clickViewMap) forControlEvents:UIControlEventTouchDown];
    
    // searchButton
    self.searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.searchButton.frame = CGRectMake(50, 450, 275, 100);
    [self.searchButton setBackgroundColor:[UIColor brownColor]];
    [self.searchButton setTitle:@"Search Location" forState:UIControlStateNormal];
    [self.searchButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]];
    [self.searchButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.searchButton.layer setCornerRadius:10.0f];
    [self.searchButton addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:self.viewCoordinateButton];
    [self.view addSubview:self.viewMapButton];
    [self.view addSubview:self.searchButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickViewCoordinate
{
//    CoordinateViewController *cvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"coordinate"];
//    [self presentViewController:cvc animated:NO completion:nil];
    
    [self performSegueWithIdentifier:@"showCoordinate" sender:self];
}

- (void)clickViewMap
{
//    MapsViewController *mvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"maps"];
//    [self presentViewController:mvc animated:NO completion:nil];
    [self performSegueWithIdentifier:@"showMaps" sender:self];
}

- (void)clickSearch
{
    [self performSegueWithIdentifier:@"showSearch" sender:self];
}

@end
