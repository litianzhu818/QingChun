//
//  CellCommentModel.m
//  QingChunApp
//
//  Created by Peter Lee on 15/3/18.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "CellCommentModel.h"
#import "NSObject+AutoProperties.h"

@implementation CellCommentModel

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
    self.ID = [dic objectForKey:@"id"];
    self.userID = [dic objectForKey:@"userid"];
    self.message = [dic objectForKey:@"message"];
    
    self.userName = [dic objectForKey:@"username"];
    self.headImageUrl = [dic objectForKey:@"userimg"];
    self.floors = [dic objectForKey:@"floors"];
    
    self.status = [dic objectForKey:@"status"];
    self.uid = [dic objectForKey:@"uid"];
}


@end
