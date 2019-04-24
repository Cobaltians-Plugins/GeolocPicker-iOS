//
//  GolocPickerPlugin.m
//  Forms
//
//  Created by Vincent Rifa on 01/04/2019.
//  Copyright © 2019 Kristal. All rights reserved.
//

#import "GeolocPickerPlugin.h"
#import "MapViewController.h"
#import "FormsUtils.h"
#import <Cobalt/PubSub.h>

@implementation GeolocPickerPlugin  

- (void)onMessageFromWebView:(WebViewType)webView
          inCobaltController:(nonnull CobaltViewController *)viewController
                  withAction:(nonnull NSString *)action
                        data:(nullable NSDictionary *)data
          andCallbackChannel:(nullable NSString *)callbackChannel
{
    _viewController = viewController;
    _callback = callbackChannel;
    
    UIStoryboard *mapStoryboard = [UIStoryboard storyboardWithName:@"MapStoryboard" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationController = [mapStoryboard instantiateInitialViewController];
    MapViewController *mapviewController = navigationController.viewControllers[0];
    mapviewController.delegate = self;
    
    if (action != nil && [action isEqualToString:@"selectLocation"]) {
        if (data != nil) {
            id location = data[@"location"];
            if (location != nil && [location isKindOfClass:[NSString class]]) {
                CLLocationCoordinate2D coordinate = [FormsUtils parseCoordinates:location];
                if (CLLocationCoordinate2DIsValid(coordinate)) {
                    mapviewController.coordinate = coordinate;
                }
            }
            id address = data[@"address"];
            if (address != nil && [location isKindOfClass:[NSString class]]) {
                mapviewController.address = address;
            }
        }
        [_viewController.navigationController presentViewController:navigationController animated:YES completion:nil];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Location
////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didSelectLocation:(CLLocationCoordinate2D)coordinate address:(NSString *)address {
    NSLog(@"DefaultViewController - didSelectLocation: Back from Map with address: %@",address);
    NSDictionary *data = CLLocationCoordinate2DIsValid(coordinate) ? @{@"location": [NSString stringWithFormat:@"%f,%f",
                                                                                     coordinate.latitude,
                                                                                     coordinate.longitude],
                                                                       @"address": address} : @{};
    [[PubSub sharedInstance] publishMessage:data
                                  toChannel:_callback];
    
    [_viewController.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

@end
