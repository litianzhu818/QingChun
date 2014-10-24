//
//  BaseNavigationBar.h
//  QingChunApp
//
//  Created by Peter Lee on 14/10/23.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseNavigationBarDelegate <NSObject>

@optional

@end

@interface BaseNavigationBar : UINavigationBar

@property (strong, nonatomic) NSArray *items;

@property (weak, nonatomic) id<BaseNavigationBarDelegate> delegate;

@end
