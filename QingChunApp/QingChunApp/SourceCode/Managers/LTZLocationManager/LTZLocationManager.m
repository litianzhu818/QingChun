//
//  LTZLocationManager.m
//  LTZLocationManager
//
//  Created by Peter Lee on 13-12-24.
//  Copyright (c) 2013年 Peter Lee. All rights reserved.
//

#import "LTZLocationManager.h"

@interface LTZLocationManager ()<CLLocationManagerDelegate>
{
    CLLocationManager   *_locationManager;
    CLGeocoder          *_geocoder;
    
    double              _latitude;
    double              _longitude;
}

@property (nonatomic, strong) LocationBlock locationBlock;
@property (nonatomic, strong) LocationErrorBlock errorBlock;
@property (nonatomic, strong) NSStringBlock cityBlock;
@property (nonatomic, strong) NSStringBlock addressBlock;

@end

@implementation LTZLocationManager
@synthesize locationManager = _locationManager;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

+ (LTZLocationManager *)shareLocation;
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initLocationInfo];
    }
    return self;
}

-(void)initLocationInfo
{
    if (![CLLocationManager locationServicesEnabled]){
        UIAlertView *locationServiceAlert = [[UIAlertView alloc] initWithTitle:nil message:@"定位不可用" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [locationServiceAlert show];
    }else{
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = 1000.0f;
        }
    }
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock
{
    self.locationBlock = [locaiontBlock copy];
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = [locaiontBlock copy];
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock
{
    self.addressBlock = [addressBlock copy];
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = [cityBlock copy];
    [self startLocation];
}

- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock
{
    self.cityBlock = [cityBlock copy];
    self.errorBlock = [errorBlock copy];
    [self startLocation];
}

- (void)startLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void)stopLocation
{
    [self.locationManager stopUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    [_geocoder reverseGeocodeLocation:[locations firstObject] completionHandler:^(NSArray *array, NSError *error) {
        
        if (array.count > 0) {
            
            NSString *countryCode = nil;
            NSString *country = nil;
            NSString *state = nil;
            NSString *city = nil;
            NSString *subLocality = nil;
            NSString *street = nil;
            CLLocationCoordinate2D coordinate = [(CLLocation *)[locations firstObject] coordinate];
            
            CLPlacemark *placeMark = [array firstObject];
            
            if (placeMark){
                
                NSDictionary *addressDic = placeMark.addressDictionary;
                country     =   placeMark.country;//国家名称
                countryCode =   placeMark.ISOcountryCode;//国家代码
                state       =   [addressDic objectForKey:@"State"];
                city        =   [addressDic objectForKey:@"City"];
                subLocality =   [addressDic objectForKey:@"SubLocality"];
                street      =   [addressDic objectForKey:@"Street"];
                
                [self stopLocation];
            }
            
            if (_cityBlock) {
                _cityBlock(city);
                _cityBlock = nil;
            }
            
            if (_locationBlock) {
                _locationBlock(coordinate);
                _locationBlock = nil;
            }
            
            if (_addressBlock) {
                _addressBlock([NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street]);
                _addressBlock = nil;
            }
            
        }else if (error == nil && [array count] == 0){
            
            NSLog(@"No results were returned.");
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No results were returned."                                                                      forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:@"com.qcd.me" code:100 userInfo:userInfo];
            self.errorBlock(error);
            
        }else if (error != nil){
            
            NSLog(@"An error occurred = %@", error);
            
            self.errorBlock(error);
        }
    }];
    
    [self stopLocation];

}
        
- (void)locationManager:(CLLocationManager *)manager
    didFailWithError:(NSError *)error
{
    self.errorBlock(error);
}

@end
