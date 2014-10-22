//
//  CheckNetStatus.h
//  FindLocationDemo
//
//  Created by Peter Lee on 14-4-16.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonManager.h"
#import "Reachability.h"

#define NO_NETWORK @"no_network"
#define DISCONNECT_NET @"disconnect_net"
#define CONNECT_NET @"connect_net"


@protocol NetStatusManagerDelegate <NSObject>

@required

@optional

-(void)NoNetWork;
-(void)DisconnectNetWork;
-(void)ConnectNetWork;

@end



@interface NetStatusManager : NSObject

@property (strong, nonatomic) id<NetStatusManagerDelegate> delegate;

Single_interface(NetStatusManager);
//验证是否可以联网
-(BOOL)getInitNetworkStatus;
//获取前当前的网络状态
-(NetworkStatus)getNowNetWorkStatus;
@end
