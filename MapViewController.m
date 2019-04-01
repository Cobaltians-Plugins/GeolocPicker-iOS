//
//  MapViewController.m
//  Forms
//
//  Created by Sébastien Vitard - Pro on 19/04/2018.
//  Copyright © 2018 Forms. All rights reserved.
//

#import "MapViewController.h"

#import "FormsUtils.h"
#import "PlaceAnnotation.h"
#import <Cobalt/Cobalt.h>

@interface MapViewController() {
    PlaceAnnotation *_annotation;
}

@end

@implementation MapViewController

////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark METHODS

////////////////////////////////////////////////////////////////////////////////////////////////

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        _coordinate = kCLLocationCoordinate2DInvalid;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Center map on pin
    if (CLLocationCoordinate2DIsValid(_coordinate)) {
        NSLog(@"MapViewController - viewDidLoad: init map with pin.");
        
        [self updateMap];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_coordinate, 2000, 2000);
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion
                   animated:YES];
        [_lblAddress setHidden:NO];
        _lblAddress.text=_address;
        [_btnClear setHidden:NO];
    }
    // Center map on France
    else {
        NSLog(@"MapViewController - viewDidLoad: init map without pin.");
        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(46.3432433, 2.5907915); // Montlucon
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(center, 1100000, 1100000); // approximately width and height of France
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion
                   animated:YES];
        [_lblInstructions setHidden:NO];
    }
    NSLog(@"MapViewController - viewDidLoad: Opening Map on received address: %@",_address);
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                             action:@selector(onMapLongPress:)];
    [_mapView addGestureRecognizer:longPressGestureRecognizer];
}

////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark METHODS

////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateMap {
    [_mapView removeAnnotations:_mapView.annotations];
    
    if (_annotation == nil) {
        _annotation = [[PlaceAnnotation alloc] init];
    }
    _annotation.coordinate = _coordinate;
    [_mapView addAnnotation:_annotation];
}

- (void)refreshInfo {
    //If location selected
    if (CLLocationCoordinate2DIsValid(_coordinate)) {
        //Hide instructions
        [_lblInstructions setHidden:YES];
        //Display address and clear button
        _lblAddress.text=_address;
        [_lblAddress setHidden:NO];
        [_btnClear setHidden:NO];
    }
    //If no location selected
    else {
        //Hide address and clear button
        [_lblAddress setHidden:YES];
        [_btnClear setHidden:YES];
        //Display instructions
        [_lblInstructions setHidden:NO];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark MAP DELEGATE

////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onMapLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint locationInMap = [sender locationInView:_mapView];
        _coordinate = [_mapView convertPoint:locationInMap
                        toCoordinateFromView:_mapView];
        
        CLGeocoder *geocoder = [CLGeocoder new];
        CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:_coordinate.latitude
                                                            longitude:_coordinate.longitude];
        
        [geocoder reverseGeocodeLocation:newLocation
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           
                           if (error) {
                               NSLog(@"Geocode failed with error: %@", error);
                               return; // Request failed, log error
                           }
                           
                           // Check if any placemarks were found
                           if (placemarks && placemarks.count > 0)
                           {
                               CLPlacemark *placemark = placemarks[0];
                               _address = [NSString alloc];
                               _address = [_address initWithString: [FormsUtils formatAddress:placemark]];
                               NSLog(@"address generated: %@", _address);
                               [self refreshInfo];
                           }
                       }];
        
        
        [self updateMap];
        
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark BUTTONS DELEGATE

////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)onCancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

- (IBAction)onOK:(id)sender {
    if (_delegate != nil) {
        [_delegate didSelectLocation:_coordinate address:_address];
    }
}

- (IBAction)btnClear:(id)sender {
    _coordinate = kCLLocationCoordinate2DInvalid;
    _address = nil;
    [self refreshInfo];
    [self updateMap];
}
@end

