//
//  CellButtonViewModel.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/20.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "CellButtonViewModel.h"
#import "NSObject+AutoProperties.h"

@implementation CellButtonViewModel

+ (id)cellButtonViewModelWithDictionary:(NSDictionary *)dictionary;
{
    return [[self alloc] initWithDictionary:dictionary];
}

+ (id)cellButtonViewModelWithLikeCount:(NSInteger)likeCount
                           unlikeCount:(NSInteger)unlikeCount
                            shareCount:(NSInteger)shareCount
                          commentCount:(NSInteger)commentCount
{
    return [[self alloc] initWithLikeCount:likeCount
                               unlikeCount:unlikeCount
                                shareCount:shareCount
                              commentCount:commentCount];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithLikeCount:[dictionary[@"praise"] integerValue]
                       unlikeCount:[dictionary[@"step"] integerValue]
                        shareCount:[dictionary[@"collection"] integerValue]
                      commentCount:[dictionary[@"msgnum" ] integerValue]];
}

- (id)initWithLikeCount:(NSInteger)likeCount unlikeCount:(NSInteger)unlikeCount shareCount:(NSInteger)shareCount commentCount:(NSInteger)commentCount
{
    if (self = [super init]) {
        
        self.likeCount      =   likeCount;          // 点赞数
        self.unlikeCount    =   unlikeCount;        // 讨厌数
        self.shareCount     =   shareCount;         // 转发数
        self.commentCount   =   commentCount;       // 评论数
    }
    return self;
}

/*
#pragma mark - NSCopying method

- (id)copyWithZone:(NSZone *)zone
{
    CellButtonViewModel *newInfo = [[[self class] allocWithZone:zone] init];
    
    [newInfo setLikeCount:self.likeCount];
    [newInfo setUnlikeCount:self.unlikeCount];
    [newInfo setShareCount:self.shareCount];
    [newInfo setCommentCount:self.commentCount];
    
    return newInfo;
}

#pragma mark - NSCoding Methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInteger:self.likeCount] forKey:@"likeCount"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.unlikeCount] forKey:@"unlikeCount"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.shareCount] forKey:@"shareCount"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.commentCount] forKey:@"commentCount"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.likeCount = [[aDecoder decodeObjectForKey:@"likeCount"] integerValue];
        self.unlikeCount = [[aDecoder decodeObjectForKey:@"unlikeCount"] integerValue];
        self.shareCount = [[aDecoder decodeObjectForKey:@"shareCount"] integerValue];
        self.commentCount = [[aDecoder decodeObjectForKey:@"commentCount"] integerValue];
        
    }
    return  self;
    
}
*/

@end
