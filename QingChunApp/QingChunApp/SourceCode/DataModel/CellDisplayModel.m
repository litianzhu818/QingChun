//
//  CellDisplayModel.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/28.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "CellDisplayModel.h"
#import "NSObject+AutoProperties.h"


@implementation CellDisplayModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self setupWithDictionary:dictionary];
    }
    
    return self;
}

- (void)setupWithDictionary:(NSDictionary *)dictionary
{
    self.cellContentModel = [[CellContentModel alloc] initWithID:[dictionary objectForKey:@"id"] time:[dictionary objectForKey:@"create_date"] text:[dictionary objectForKey:@"content"]];
    self.cellDisplayUserModel = [[CellDisplayUserModel alloc] initWithID:[dictionary objectForKey:@"userid"] name:[dictionary objectForKey:@"username"] imgUrlStrSufix:[dictionary objectForKey:@"userimg"]];
    self.cellButtonViewModel = [[CellButtonViewModel alloc] initWithLikeCount:[[dictionary objectForKey:@"praise"] integerValue] unlikeCount:[[dictionary objectForKey:@"step"] integerValue] shareCount:[[dictionary objectForKey:@"collection"] integerValue] commentCount:[[dictionary objectForKey:@"msgnum"] integerValue]];
    
    //Images
    id tempImages = [dictionary objectForKey:@"images"];
    
    if ([tempImages isKindOfClass:[NSArray class]] && [tempImages count] >= 1) {
        
        self.cellDisplayImageModels = [NSMutableArray array];
        
        [tempImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *tempImageDic = obj;
            CellDisplayImageModel *cellDisplayImageModel = [[CellDisplayImageModel alloc] initWithDictionary:tempImageDic];
            [self.cellDisplayImageModels addObject:cellDisplayImageModel];
        }];
        
    }
}

+ (instancetype)cellDisplayModelWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

@end
