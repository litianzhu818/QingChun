//
//  CellButtonViewModel.h
//  QingChunApp
//
//  Created by  李天柱 on 14/12/20.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellButtonViewModel : NSObject

@property (nonatomic, assign)   NSInteger       shareCount;         // 转发数
@property (nonatomic, assign)   NSInteger       commentCount;       // 评论数
@property (nonatomic, assign)   NSInteger       likeCount;          // 点赞数
@property (assign, nonatomic)   NSInteger       unlikeCount;        //讨厌数量

+ (id)cellButtonViewModelWithDict:(NSDictionary *)dict;

- (id)initWithDict:(NSDictionary *)dict;
- (id)initWithLikeCount:(NSInteger)likeCount unlikeCount:(NSInteger)unlikeCount shareCount:(NSInteger)shareCount commentCount:(NSInteger)commentCount;

@end