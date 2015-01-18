//
//  NSObject+AutoProperties.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/27.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "NSObject+AutoProperties.h"
#import "DescriptionBuilder.h"
#import "AutoCoding.h"

@implementation NSObject (AutoProperties)

/**
 *  Auto descript the object for debug
 *
 *  @return The description string
 */
- (NSString *)autoDescription
{
    return [DescriptionBuilder reflectDescription:self];
}

@end
