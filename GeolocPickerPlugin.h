//
//  GeolocPickerPlugin.h
//  Forms
//
//  Created by Vincent Rifa on 01/04/2019.
//  Copyright © 2019 Kristal. All rights reserved.
//

#import <Cobalt/CobaltAbstractPlugin.h>
#import "MapViewController.h"


@interface GeolocPickerPlugin : CobaltAbstractPlugin <SelectLocationDelegate> {
    CobaltViewController * _viewController;
    NSString *_callback;
}


@end

