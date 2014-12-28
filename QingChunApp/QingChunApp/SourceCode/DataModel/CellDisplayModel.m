//
//  CellDisplayModel.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/28.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "CellDisplayModel.h"
#import "NSObject+AutoProperties.h"

#import "CellContentModel.h"
#import "CellDisplayUserModel.h"
#import "CellButtonViewModel.h"
#import "CellDisplayImageModel.h"

@implementation CellDisplayModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        
    }
    
    return self;
}

+ (instancetype)cellDisplayModelWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

@end
