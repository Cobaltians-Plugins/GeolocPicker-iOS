//
//  MapViewController.h
//  Forms
//
//  Created by Sébastien Vitard - Pro on 19/04/2018.
//  Copyright © 2018 Forms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol SelectLocationDelegate

- (void)didSelectLocation:(CLLocationCoordinate2D)coordinate address:(NSString *)address;

@end

@interface MapViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblInstructions;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnClear;
- (IBAction)btnClear:(id)sender;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *address;
@property (weak, nonatomic) id<SelectLocationDelegate> delegate;

@end
