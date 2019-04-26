//
//  PlaceAnnotation.h
//  Forms
//
//  Created by Sébastien Vitard - Pro on 19/04/2018.
//  Copyright © 2018 Kristal. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PlaceAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
