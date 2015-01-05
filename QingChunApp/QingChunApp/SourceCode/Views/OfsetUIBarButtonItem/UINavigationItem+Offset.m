//
//  UINavigationItem+Offset.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/14.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "UINavigationItem+Offset.h"

#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ?YES:NO)

@implementation UINavigationItem (Offset)

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if (IOS7_OR_LATER) {
        // Add a spacer on when running lower than iOS 7.0
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil action:nil];
        negativeSpacer.width = -10;
        [self setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem,nil]];
    } else {
        // Just set the UIBarButtonItem as you would normally
        [self setLeftBarButtonItem:leftBarButtonItem];
    } 
}
- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    if (IOS7_OR_LATER) {
        // Add a spacer on when running lower than iOS 7.0
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = 10;
        [self setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem,nil]];
    } else {
        // Just set the UIBarButtonItem as you would normally
        [self setRightBarButtonItem:rightBarButtonItem];
    }
}

@end
