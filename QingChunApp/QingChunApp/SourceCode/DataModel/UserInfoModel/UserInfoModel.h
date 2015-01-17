//
//  UserInfoModel.h
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userDefaultImgURLStr;
@property (strong, nonatomic) NSString *userHighImgURLStr;
@property (strong, nonatomic) NSString *userKey;

@property (strong, nonatomic) NSString *introduce;
@property (strong, nonatomic) NSString *birthday;

@property (assign, nonatomic) BOOL userSex;
@property (assign, nonatomic) NSUInteger userBean;
@property (assign, nonatomic) NSUInteger userGrade;

- (instancetype)initWithDictionary:(NSDictionary *)userInfoDictionary;

@end
