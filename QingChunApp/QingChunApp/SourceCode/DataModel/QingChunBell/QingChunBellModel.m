//
//  QingChunBellModel.m
//  QingChunApp
//
//  Created by  李天柱 on 15/1/27.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "QingChunBellModel.h"
#import "NSObject+AutoProperties.h"

@interface QingChunBellModel ()
{
    NSUInteger _atNumber;//@我的数量
    NSUInteger _msgNumber;//私信我的数量
    NSUInteger _likeNumber;//赞的数量
    NSUInteger _commentNumber;//评论数量
}
@end

@implementation QingChunBellModel

+ (id)qingChunBellModel
{
    return [[self alloc] init];
}
+ (id)qingChunBellModelWithAtNumber:(NSUInteger)atNumber
                         likeNumber:(NSUInteger)likeNumber
                          msgNumber:(NSUInteger)msgNumber
                      commentNumber:(NSUInteger)commentNumber
{
    return [[self alloc] initWithAtNumber:atNumber
                               likeNumber:likeNumber
                                msgNumber:msgNumber
                            commentNumber:commentNumber];
}

- (id)initWithAtNumber:(NSUInteger)atNumber
            likeNumber:(NSUInteger)likeNumber
             msgNumber:(NSUInteger)msgNumber
         commentNumber:(NSUInteger)commentNumber
{
    self = [super init];
    if (self) {
        [self updateWithAtNumber:atNumber
                      likeNumber:likeNumber
                       msgNumber:msgNumber
                   commentNumber:commentNumber];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self updateWithDictionary:dic];
    }
    return self;
}
- (void)updateWithDictionary:(NSDictionary *)dic
{
    _atNumber = [[dic objectForKey:@"at"] unsignedIntegerValue];
    _likeNumber = [[dic objectForKey:@"praise"] unsignedIntegerValue];
    _msgNumber = [[dic objectForKey:@"secret"] unsignedIntegerValue];
    _commentNumber = [[dic objectForKey:@"msg"] unsignedIntegerValue];
}

- (void)updateWithAtNumber:(NSUInteger)atNumber
                likeNumber:(NSUInteger)likeNumber
                 msgNumber:(NSUInteger)msgNumber
             commentNumber:(NSUInteger)commentNumber
{
    _atNumber = atNumber;
    _likeNumber = likeNumber;
    _msgNumber = msgNumber;
    _commentNumber = commentNumber;
}

@end
