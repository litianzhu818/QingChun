//
//  BaseTabBarController.h
//  QingChunApp
//
//  Created by Peter Lee on 14/10/22.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

//IOS7_OR_LATER
#define IOS7_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

@interface BaseTabBarController : UITabBarController

- (void)setBagroundColor:(UIColor *)color;

@end
