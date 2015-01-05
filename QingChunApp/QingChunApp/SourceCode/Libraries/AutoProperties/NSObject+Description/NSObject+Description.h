//
//  NSObject+Description.h
//  QingChunApp
//
//  Created by  李天柱 on 15/1/1.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Description)

/**
 @brief Returns a description of the object including its class name and a list of its properties (name = value).
 @return A description of the object including its class name and a list of its properties (name = value).
 */
- (NSString *)autoDescription;

@end
