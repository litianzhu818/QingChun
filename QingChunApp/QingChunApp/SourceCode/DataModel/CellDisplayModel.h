//
//  CellDisplayModel.h
//  QingChunApp
//
//  Created by  李天柱 on 14/12/28.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CellDisplayUserModel;
@class CellDisplayImageModel;
@class CellButtonViewModel;
@class CellContentModel;

@interface CellDisplayModel : NSObject

//该条信息的基本属性，id，发表时间和文本内容
@property (strong, nonatomic) CellContentModel *cellContentModel;
//信息发表人的属性：id、name、头像下载url
@property (strong, nonatomic) CellDisplayUserModel *cellDisplayUserModel;
//信息中图片的属性：长、宽、下载连接地址
@property (strong, nonatomic) NSArray *cellDisplayImageModels;
//信息中喜欢、不喜欢、收藏、评论数量
@property (strong, nonatomic) CellButtonViewModel *cellButtonViewModel;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (instancetype)cellDisplayModelWithDictionary:(NSDictionary *)dictionary;

@end
