//
//  QingChunBellModel.h
//  QingChunApp
//
//  Created by  李天柱 on 15/1/27.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QingChunBellModel : NSObject

@property (assign, nonatomic, readonly) NSUInteger atNumber;//@我的数量
@property (assign, nonatomic, readonly) NSUInteger likeNumber;//赞的数量
@property (assign, nonatomic, readonly) NSUInteger msgNumber;//私信我的数量
@property (assign, nonatomic, readonly) NSUInteger commentNumber;//评论数量

+ (id)qingChunBellModel;

+ (id)qingChunBellModelWithAtNumber:(NSUInteger)atNumber
                         likeNumber:(NSUInteger)likeNumber
                          msgNumber:(NSUInteger)msgNumber
                      commentNumber:(NSUInteger)commentNumber;

- (id)initWithAtNumber:(NSUInteger)atNumber
            likeNumber:(NSUInteger)likeNumber
             msgNumber:(NSUInteger)msgNumber
         commentNumber:(NSUInteger)commentNumber;

- (id)initWithDictionary:(NSDictionary *)dic;
- (void)updateWithDictionary:(NSDictionary *)dic;

- (void)updateWithAtNumber:(NSUInteger)atNumber
                likeNumber:(NSUInteger)likeNumber
                 msgNumber:(NSUInteger)msgNumber
             commentNumber:(NSUInteger)commentNumber;

@end
