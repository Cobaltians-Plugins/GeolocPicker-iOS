//
//  FormsUtils.m
//  Forms
//
//  Created by Sébastien Vitard - Pro on 19/04/2018.
//  Copyright © 2018 Kristal. All rights reserved.
//

#import "FormsUtils.h"

@implementation FormsUtils

+ (CLLocationCoordinate2D)parseCoordinates:(nonnull NSString *)string {
    NSArray<NSString *> *coordinates = [string componentsSeparatedByString:@","];
    if (coordinates.count == 2) {
        return CLLocationCoordinate2DMake(coordinates[0].doubleValue, coordinates[1].doubleValue);
    }
    else {
        NSLog(@"FormsUtils - parseCoordinates: wrong coordinate format %@.", string);
    }
    
    return kCLLocationCoordinate2DInvalid;
}

+ (NSString*)formatAddress:(nonnull CLPlacemark *)placemark {
    NSMutableString *newAddress = [NSMutableString stringWithCapacity:1000];
    
    //Building address string
    if(placemark.subThoroughfare!=nil){
        [newAddress appendFormat:@"%@ ", placemark.subThoroughfare];
    }
    if(placemark.thoroughfare!=nil){
        [newAddress appendFormat:@"%@,\n", placemark.thoroughfare];
    }
    if(placemark.postalCode!=nil){
        [newAddress appendFormat:@"%@ ", placemark.postalCode];
    }
    if(placemark.locality!=nil){
        [newAddress appendFormat:@"%@ ", placemark.locality];
    }
    if([newAddress isEqualToString:@""]){
        [newAddress appendFormat:@"%@ ", NSLocalizedString(@"unknownAddress", @"unknown address")];
    }
    
    return newAddress;
    
}

@end
