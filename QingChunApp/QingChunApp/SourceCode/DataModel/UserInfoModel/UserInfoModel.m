//
//  UserInfoModel.m
//  QingChunApp
//
//  Created by Peter Lee on 15/1/17.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "UserInfoModel.h"
#import "NSObject+AutoProperties.h"

@implementation UserInfoModel

#pragma mark - class public methods
+ (UserInfoModel *)userInfoModel
{
    return [UserInfoModel userInfoModelWithDictionary:nil];
}

+ (UserInfoModel *)userInfoModelWithDictionary:(NSDictionary *)userInfoDictionary
{
    return [[self alloc] initWithDictionary:userInfoDictionary];
}

#pragma mark - object public methods

- (instancetype)initWithDictionary:(NSDictionary *)userInfoDictionary
{
    self = [super init];
    if (self) {
        [self setupWithDictionary:userInfoDictionary];
    }
    return self;
}

- (void)setupWithDictionary:(NSDictionary *)userInfoDictionary
{
    self.userID = [userInfoDictionary objectForKey:@"id"];
    self.userName = [userInfoDictionary objectForKey:@"userName"];
    self.userKey = [userInfoDictionary objectForKey:@"userKey"];
    self.userBean = [[userInfoDictionary objectForKey:@"bean"] integerValue];
    self.userGrade = [[userInfoDictionary objectForKey:@"grade"] integerValue];
    self.userSex = [[userInfoDictionary objectForKey:@"sex"] boolValue];
    self.birthday = [userInfoDictionary objectForKey:@"birthday"];
    self.introduce = [userInfoDictionary objectForKey:@"introduce"];
    self.userName = [userInfoDictionary objectForKey:@"userName"];
    self.userDefaultImgURLStr = [NSString stringWithFormat:@"%@%@",[[UserConfig sharedInstance] GetHeadURLPrefix],[userInfoDictionary objectForKey:@"head"]];
}



@end
