//
//  WXMLocationManager.m
//  WXMComponentization
//
//  Created by wxm on 2019/12/31.
//  Copyright © 2019 wxm. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import "WXMLocationManager.h"

@interface WXMLocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) NSDictionary *geocodingDictionary;
@property (nonatomic, copy) void (^resultsCallback)(WXMLocation *location);
@end

@implementation WXMLocation @end
@implementation WXMLocationManager

+ (instancetype)sharedInstance {
    static WXMLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

#pragma mark - 定位代理
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    /**  地址的编码通过经纬度得到具体的地址 */
    CLLocation *location = manager.location;
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    [gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        
        WXMLocation *location = [[WXMLocation alloc] init];
        location.state = [placemark.addressDictionary objectForKey:@"State"];
        location.city = placemark.locality ?: placemark.administrativeArea;
        location.subLocality = [placemark.addressDictionary objectForKey:@"SubLocality"];
        location.thoroughfare = placemark.thoroughfare ?: @"";
        location.subThoroughfare = placemark.subThoroughfare ?: @"";
        
        if (self.resultsCallback && location.state && location.city && location.subLocality) {
            self.resultsCallback(location);
        } else if (self.resultsCallback) {
            self.resultsCallback(nil);
        }
    }];
    
    [self.manager stopUpdatingLocation];
}

/* 定位权限 */
- (BOOL)location {
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        /** [self.manager requestAlwaysAuthorization]; */
        /** [self.manager startUpdatingLocation]; */
        return YES;
        
    } else if ([CLLocationManager locationServicesEnabled] &&
               ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
                [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        
        /** [self.manager requestAlwaysAuthorization]; */
        /** [self.manager startUpdatingLocation]; */
        return YES;
        
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self showAlertViewController];
        return NO;
    }
    return NO;
}

- (void)setCallback:(void (^)(WXMLocation *location))callback {
    self.resultsCallback = callback;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.manager requestWhenInUseAuthorization];
    }
    [self.manager startUpdatingLocation];
}

- (void)showAlertViewController {
}

- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}


@end
