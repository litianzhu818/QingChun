//
//  SystemConfig.h
//  QingChunApp
//
//  Created by  李天柱 on 14-10-22.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonManager.h"

#define FIRST_LOADING @"first_laoding"

@interface SystemConfig : NSObject
Single_interface(SystemConfig);

//存取FistLoading的值
-(void)SetFistLoading:(BOOL)value;
-(BOOL)GetFistLoading;

@end
