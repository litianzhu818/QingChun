//
//  UserHeaderView.h
//  QingChunApp
//
//  Created by  李天柱 on 14/11/6.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfoModel;
@protocol UserHeaderViewDelegate;

@interface UserHeaderView : UIView

@property (strong, nonatomic, readonly) UserInfoModel *userInfo;
@property (assign, nonatomic) id<UserHeaderViewDelegate> delegate;

+ (instancetype)instanceFromNib;

- (void)updateWithUserInfoModel:(UserInfoModel *)userInfo;

@end

@protocol UserHeaderViewDelegate <NSObject>

@optional

- (void)userHeaderView:(UserHeaderView *)userHeaderView didClikedOnButton:(UIButton *)button hasUserInfo:(BOOL)hasUserInfo;

@end