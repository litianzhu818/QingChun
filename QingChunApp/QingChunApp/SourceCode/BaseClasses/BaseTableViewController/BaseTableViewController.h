//
//  BaseTableViewController.h
//  QingChunApp
//
//  Created by  李天柱 on 15/1/25.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusBar.h"
#import "NetStatusManager.h"
#import "NotificationView.h"
#import "UICustomAlertView.h"

@interface BaseTableViewController : UITableViewController<NotificationViewDelegate>
@property (strong, nonatomic) NotificationView *netWorkStatusNotice;
@property (strong, nonatomic) UIImageView *defaultImageView;

-(void)showMessage:(NSString *)message
             title:(NSString *)title
 cancelButtonTitle:(NSString *)cancelTitle
       cancleBlock:(void (^)(void))cancleBlock;
-(void)showMessage:(NSString *)message
             title:(NSString *)title
 cancelButtonTitle:(NSString *)cancelTitle
       cancleBlock:(void (^)(void))cancleBlock
  otherButtonTitle:(NSString *)otherButtonTitle
        otherBlock:(void (^)(void))otherBlock;

@end
