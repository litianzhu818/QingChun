//
//  CellButtonViewModel.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/20.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "CellButtonViewModel.h"

@implementation CellButtonViewModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict]) {
        
        self.likeCount      =   [dict[@"likeCount"] integerValue];          // 点赞数
        self.unlikeCount    =   [dict[@"unlikeCount"] integerValue];        // 讨厌数
        self.shareCount     =   [dict[@"shareCount"] integerValue];         // 转发数
        self.commentCount   =   [dict[@"commentCount" ] integerValue];      // 评论数
    }
    return self;
}

+ (id)cellButtonViewModelWithDict:(NSDictionary *)dict;
{
    return [[self alloc] initWithDict:dict];
}

@end
