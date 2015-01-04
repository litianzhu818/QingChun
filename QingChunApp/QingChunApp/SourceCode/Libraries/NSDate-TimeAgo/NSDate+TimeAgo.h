//
//  NSDate+TimeAgo.h
//  QingChunApp
//
//  Created by  李天柱 on 14/12/28.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//
@import Foundation;

@interface NSDate (TimeAgo)


- (NSString *) timeAgo;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormatter:(NSDateFormatter *)formatter;


// this method only returns "{value} {unit} ago" strings and no "yesterday"/"last month" strings
- (NSString *)dateTimeAgo;

// this method gives when possible the date compared to the current calendar date: "this morning"/"yesterday"/"last week"/..
// when more precision is needed (= less than 6 hours ago) it returns the same output as dateTimeAgo
- (NSString *)dateTimeUntilNow;

@end

