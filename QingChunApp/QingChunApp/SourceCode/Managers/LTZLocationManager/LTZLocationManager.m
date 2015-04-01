//
//  LTZLocationManager.m
//  LTZLocationManager
//
//  Created by Peter Lee on 13-12-24.
//  Copyright (c) 2013年 Peter Lee. All rights reserved.
//

#import "LTZLocationManager.h"

@interface LTZLocationManager ()<CLLocationManagerDelegate, UIAlertViewDelegate>
{
    CLLocationManager   *_locationManager;
    CLGeocoder          *_geocoder;
    
    double              _latitude;
    double              _longitude;
    
    UIAlertView         *_locationAlert;
}

@property (nonatomic, strong) LocationBlock locationBlock;

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

+ (void)locationWithBlock:(LocationBlock)locaiontBlock
{
    [[LTZLocationManager shareLocation] locationWithBlock:locaiontBlock];
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
    _locationAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位不可用，您可以在\"设置\"->\"隐私\"->\"定位服务\"中打开设置" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
    
    if (![CLLocationManager locationServicesEnabled]){
        [_locationAlert show];
    }else{

        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            //_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = 1000.0f;
            
            if (CURRENT_IOS_SYSTEM_VERSION >= 8.0) {
                
                self.locationManager.distanceFilter = kCLDistanceFilterNone;
                [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
            }
        }

    }
}

- (void)locationWithBlock:(LocationBlock)locaiontBlock
{
    self.locationBlock = [locaiontBlock copy];
    [self startLocation];
}

- (void)startLocation
{
    if (![CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
        [_locationAlert show];
    }else{
    
        //重新初始化，防止关闭服务后重开导致的CLLocationManager不能用
        _locationManager = nil;
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        //_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1000.0f;
        _locationManager.delegate = self;
        
        if (CURRENT_IOS_SYSTEM_VERSION >= 8.0) {
            
            self.locationManager.distanceFilter = kCLDistanceFilterNone;
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        }
        
        [self.locationManager startUpdatingLocation];
    }
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
    
    [_geocoder reverseGeocodeLocation:[locations firstObject] completionHandler:^(NSArray *array, NSError *error) {@autoreleasepool {
            
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
                
                if (_locationBlock) {
                    _locationBlock(state,city,[NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street],coordinate,nil);
                    _locationBlock = NULL;
                }
                
            }else if (error == nil && [array count] == 0){
                
                NSLog(@"No results were returned.");
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No results were returned."                                                                      forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:CustomLocationErrorDomain code:LocationErrorCodeFailed userInfo:userInfo];
                
                if (self.locationBlock) {
                    self.locationBlock(nil,nil,nil,CLLocationCoordinate2DMake(0.0, 0.0),error);
                }
                
            }else if (error != nil){
                
                NSLog(@"An error occurred = %@", error);
                
                if (self.locationBlock) {
                    self.locationBlock(nil,nil,nil,CLLocationCoordinate2DMake(0.0, 0.0),error);
                }
            }
        }}];
    
    [self stopLocation];

}
        
- (void)locationManager:(CLLocationManager *)manager
    didFailWithError:(NSError *)error
{
    [self stopLocation];
    
    if (self.locationBlock) {
        self.locationBlock(nil,nil,nil,CLLocationCoordinate2DMake(0.0, 0.0),error);
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            
            if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
                
                [_locationManager requestWhenInUseAuthorization];
                
            }
            
            break;
            
        case kCLAuthorizationStatusDenied:
            
            NSLog(@"请在设置-隐私-定位服务中开启定位功能！");
            [_locationAlert show];
            
            break;
            
        case kCLAuthorizationStatusRestricted:
            
            NSLog(@"定位服务无法使用！");
            [_locationAlert show];
            
        default:
            
            break;
            
    }
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
        
    }
}

@end
