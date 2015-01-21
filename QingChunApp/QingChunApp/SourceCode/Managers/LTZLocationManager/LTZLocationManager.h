//
//  LTZLocationManager.h
//  LTZLocationManager
//
//  Created by Peter Lee on 13-12-24.
//  Copyright (c) 2013年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, LocationErrorCode) {
    LocationErrorCodeFailed = -1000
};

#define CustomLocationErrorDomain @"com.qcd.location.error"

typedef void (^LocationBlock)(NSString *state, NSString *city, NSString *address, CLLocationCoordinate2D locationCorrrdinate, NSError *error);

@interface LTZLocationManager : NSObject

@property(nonatomic, strong, readonly) CLLocationManager *locationManager;

@property(nonatomic, assign, readonly) double latitude;
@property(nonatomic, assign, readonly) double longitude;


+ (LTZLocationManager *)shareLocation;

/**
 *  获取坐标
 *
 *  @param locaiontBlock locaiontBlock description
 */
+ (void)locationWithBlock:(LocationBlock)locaiontBlock;

/**
 *  获取坐标
 *
 *  @param locaiontBlock locaiontBlock description
 */
- (void)locationWithBlock:(LocationBlock)locaiontBlock;

@end
