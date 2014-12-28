//
//  DisplayImage.m
//  QingChunApp
//
//  Created by  李天柱 on 14/12/27.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "CellDisplayImageModel.h"
#import "NSObject+AutoProperties.h"

@interface CellDisplayImageModel ()
{
    NSString *_urlStr;
}
@end

@implementation CellDisplayImageModel
@synthesize urlStr = _urlStr;

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
        _urlStr = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"image_url_string_prefix"],self.urlStrSuffix];
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
