//
//  DisplayImage.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/27.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "CellDisplayImageModel.h"
#import "NSObject+AutoProperties.h"

@implementation CellDisplayImageModel

+ (instancetype)cellDisplayImageModelWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithUrlStrSuffix:(NSString *)urlStrSuffix width:(CGFloat)width height:(CGFloat)height
{
    self = [super init];
    if (self) {
        self.urlStrSuffix = urlStrSuffix;
        self.width = width;
        self.height = height;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return [self initWithUrlStrSuffix:[dictionary objectForKey:@"dir"]
                                width:[[dictionary objectForKey:@"width"] floatValue]
                               height:[[dictionary objectForKey:@"height"] floatValue]];
}

@end
