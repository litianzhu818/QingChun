//
//  CellContentModel.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/28.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "CellContentModel.h"
#import "NSObject+AutoProperties.h"

@implementation CellContentModel

+ (id)cellContentModelWithID:(NSString *)ID time:(NSString *)time text:(NSString *)text
{
    return [[self alloc] initWithID:ID time:time text:text];
}

- (id)initWithID:(NSString *)ID time:(NSString *)time text:(NSString *)text
{
    self = [super init];
    if (self) {
        self.ID = ID;
        self.time = time;
        self.text = text;
    }
    
    return self;
}

@end
