//
//  CellContentModel.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/28.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "CellContentModel.h"
#import "NSObject+AutoProperties.h"
#import "NSDate+TimeAgo.h"

@interface CellContentModel ()
{
    NSUInteger timeSeconds;
}

@end

@implementation CellContentModel

+ (id)cellContentModelWithID:(NSString *)ID time:(NSString *)time text:(NSString *)text
{
    return [[self alloc] initWithID:ID time:time text:text];
}

- (id)initWithID:(NSString *)ID time:(NSString *)time text:(NSString *)text
{
    self = [super init];
    if (self) {
        self.ID = ID;
        self.text = text;
        timeSeconds = [time integerValue];
    }
    
    return self;
}

- (NSString *)time
{
    /*
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
     
    return [dateFormatter stringFromDate:[self timeFormatted:timeSeconds]];
     */
    return [[self timeFormatted:timeSeconds] timeAgo];
}

- (NSDate *)timeFormatted:(int)totalSeconds
{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //NSLog(@"enddate=%@",localeDate);
    return localeDate;
}

@end
