//
//  FormsUtils.h
//  Forms
//
//  Created by Sébastien Vitard - Pro on 19/04/2018.
//  Copyright © 2018 Kristal. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface FormsUtils : NSObject

+ (CLLocationCoordinate2D)parseCoordinates:(nonnull NSString *)string;

+ (NSString*)formatAddress:(nonnull CLPlacemark *)placemark;

@end
